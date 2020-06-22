Param(
    [Parameter(Mandatory=$true)]
    [string]$Environment,
    [switch]$Print = $false,
    [switch]$Rollback = $false,
    [switch]$Local = $false
)
trap
{
    Write-Host "Error found at line $($_.InvocationInfo.ScriptLineNumber):$($_.InvocationInfo.OffsetInLine) $_"
    $_.ScriptStackTrace
    exit 1
}
function List-GitChanges() {
    Param(
        [parameter(Mandatory=$true)]
        [String]
        $From,
        [parameter(Mandatory=$true)]
        [String]
        $To,
        [parameter(Mandatory=$false)]
        [String[]]
        $Filter,
        [parameter(Mandatory=$false)]
        [String]
        $Extension
    )
    $Result = New-Object System.Collections.ArrayList
    $GitChanges = git diff --name-status $From $To
    $GitChanges | ForEach-Object {
        $Change   = $_.Substring(0,1)
        $Parts    = $_.Split("`t")
        $FileName = $Parts[$Parts.length-1]
        if ($Change -eq "R") {
            $SourceFile = $Parts[1]
            Write-Host "Source Files is $SourceFile"
        }
        if (!$Filter) {
            $Result.Add( @{change=$Change; file=$FileName; target = $FileName; source=SourceFile;}) | Out-Null
        }  else {
            $Index = $FileName.IndexOf('/', $FileName.IndexOf('/') + 1)
            if ($Index -gt 0) {
                $FileDBFolder = $FileName.Substring(0,$Index)
                $MatchedFilter = $Filter | Where { ($FileDBFolder -eq $_) -and ($FileName -like ($_ + "*$Extension"))  } | Select -First 1
         } else {
           $MatchedFilter = $Filter | Where { ($FileName -like ($_ + "*$Extension"))  } | Select -First 1
         }
            if ($MatchedFilter) {
                if ($SourceFile -like ($MatchedFilter + "*$Extension")) {
                    $SourceFile = $SourceFile.substring($MatchedFilter.length)
                }
                $Result.Add( @{change=$Change; file=$FileName; target = $FileName.substring($MatchedFilter.length); source=$SourceFile}) | Out-Null
            }
        }
        Write-Verbose -Message "$Change in file $FileName"
    }
    return @(, $Result)
}
function Execute-Sql {
    Param([string]$Server, [string]$Database, [string]$Path)
    $cmd = "& sqlcmd -b -E -d ${Database} -S ${Server} -i `"${path}`""
    $output2 = Invoke-Expression $cmd -OutVariable ConsoleOutput
    $result = $?
    if ($lastexitcode -gt 0) {
        $result = $False
    }
    foreach ($Line in $ConsoleOutput) {
        Write-Host $Line
        if ($Line -match 'Changed database context to ''(.+)''.') {
            if ($Matches[1] -ne $Database) {
                 Write-Warning "Changing database context to $($Matches[1])"
            }
        }
    }
    return $Result
}
function Deploy-SSISPackages($Server, $ChangedFiles) {
    if ($ChangedFiles.Count -eq 0) {
        Write-Host "No SSIS packages to deploy"
    }
    $TargetRootFolder = "\\$Server\SSIS-Packages\"
    $DeployedFiles = New-Object System.Collections.ArrayList
    $ChangedFiles | Foreach {
        $TargetPackageFile = Join-Path $TargetRootFolder $_.target
        $Change = $_.change
        $RepoFile = $_.file
        # for renames
        $SourceFile = $_.source
        <#
            Added (A), Copied (C), Deleted (D), Modified (M), Renamed (R),
            have their type (i.e. regular file, symlink, submodule, ...) changed (T),
            are Unmerged (U), are Unknown (X), or have had their pairing Broken (B).
            Status letters C and R are always followed by a score (denoting the percentage of similarity
            between the source and target of the move or copy). Status letter M may be followed
            by a score (denoting the percentage of dissimilarity) for file rewrites.
        #>
        switch -regex ( $Change )
        {
            "^(A|M)$"
                {
                    Write-Host "Copying $RepoFile to $TargetPackageFile"
                    Write-Host "-"
                    if (!$Print) {
                        Copy-Item -Path $RepoFile -Destination $TargetPackageFile
                    }
                }
            "^R$"
                {
                    $SourcePackageFile = Join-Path $TargetRootFolder $SourceFile
                    Write-Host "Copying $RepoFile to $TargetPackageFile and deleting file $SourcePackageFile"
                    Write-Host "-"                  
                    if (!$Print) {
                        Remove-Item $SourcePackageFile -Force -Verbose -ErrorAction Ignore
                        Copy-Item -Path $RepoFile -Destination $TargetPackageFile
                    }
                }
            "^D$"
                {
                    Write-Host "Deleting file $TargetPackageFile"
                    Write-Host "-"                  
                    if (!$Print) {
                        Remove-Item $TargetPackageFile -Force -Verbose -ErrorAction Ignore
                    }
                }
            default {
                throw "Git change type $Change is not implemented (file $($_.file))"
            }
        }
        $DeployedFiles.Add($RepoFile) | Out-Null
        Write-Host ""       
    }
    return (, $DeployedFiles)
}
<#
    Sets Global Variable LastCommit
#>
function Get-ChangeLog($Server, $Database, $Application) {
    Write-Host "Loading previously deployed scripts for $Server. $Database for application $Application"
    $Query = @"
USE [$Database]
IF OBJECT_ID('dbo.ChangeLog') is null
BEGIN
    PRINT 'Creating ChangeLog table'
    CREATE TABLE [$Database].dbo.ChangeLog(
        AppName     nvarchar(100)  NOT NULL,
        CommitHash  varchar(40)    NOT NULL,
        Branch      nvarchar(200)  NULL,
        ProjectId   int            NOT NULL, -- value 0 means script was executed outside of ci/cd context
        JobId       int            NOT NULL, -- value 0 means script was executed outside of ci/cd context
        Status      varchar(10)    NOT NULL CONSTRAINT CK_ChangeLog_Status CHECK  (([Status]='Error' OR [Status]='Success'  OR [Status]='Ignore')),
        Files       xml            NOT NULL,
        RunServer   sysname        NOT NULL CONSTRAINT DF_ChangeLog_RunServer  DEFAULT (@@servername),
        ExecutedBy  nvarchar(100)  NOT NULL CONSTRAINT DF_ChangeLog_ExecutedBy  DEFAULT (suser_sname()),
        ExecutedAt  datetime2(0)   NOT NULL CONSTRAINT DF_ChangeLog_ExecutedAt  DEFAULT (getdate())
    )
    -- TODO - add PK & indexes
END
IF NOT EXISTS(SELECT * FROM sys.columns WHERE name='Branch' AND object_id=OBJECT_ID('dbo.ChangeLog'))
    ALTER TABLE dbo.ChangeLog ADD Branch nvarchar(200) NULL
"@
    Write-Verbose $Query
    Invoke-Sqlcmd -ServerInstance $Server -Database $Database -Query $Query | Out-Null
    $Query = @"
    SELECT DISTINCT
        F.files.value('.','varchar(1000)') FilePath,
        CommitHash,
        ExecutedAt,
        ISNULL(Branch,'unknown') as Branch
    FROM [$Database].dbo.ChangeLog cl
        CROSS APPLY Files.nodes('/Files/File') as F(files)
    WHERE
        cl.AppName='$Application' and Status in ('Ignore','Success')
    ORDER BY ExecutedAt DESC
"@
    Write-Verbose $Query
    $ResultSet = Invoke-Sqlcmd -ServerInstance $Server -Database $Database -Query $Query
    $Result = New-Object System.Collections.ArrayList
    $global:LastCommit = $null
    $LastCommitDate    = $null
    foreach ($Row in $ResultSet) {
        $Result.Add($Row.FilePath) | Out-Null
        if ($Row.CommitHash -and (!$LastCommitDate -or $LastCommitDate -le $Row.ExecutedAt)) {
            if (($GitBranch -eq $Row.Branch) -or ($GitBranch -eq 'master' -and $Row.Branch -eq 'unknown')) {
            $LastCommitDate = $Row.ExecutedAt
            $global:LastCommit = $Row.CommitHash
        }
    }
    }
    if ($global:LastCommit) {
        Write-Host "Last deployed commit $($global:LastCommit) was on $LastCommitDate" | Out-Null
    } elseif ($GitBranch -eq "master") {
        Write-Host "No last deployed commit found. All changes will be deployed" | Out-Null
        $global:LastCommit = $EMPTY_TREE_SHA
    } else {
        $global:LastCommit = (git merge-base master HEAD)
        Write-Host "Merge-base will be used as a base for the commit $($global:LastCommit) for branch $GitBranch" | Out-Null
    }
    # Write-Host "Loaded $($Result.count) previously deployed files"
    return ,$Result
}
function Save-JobStatus($Server, $Application, $Commit, $Branch) {
    Write-Host "Saving last executed job $Server for application $Application"
    $Query = @"
USE msdb
IF OBJECT_ID('cicd.Jobs') is null
BEGIN
    IF SCHEMA_ID('cicd') is null
       EXEC('create schema cicd')
    PRINT 'Creating cicd.Jobs table'
    CREATE TABLE msdb.cicd.Jobs (
        AppName     nvarchar(100)  NOT NULL,
        Branch      nvarchar(200)  NOT NULL CONSTRAINT DF_Jobs_Branch DEFAULT N'undefined',
        CommitHash  varchar(40)    NOT NULL,
        ProjectId   int            NOT NULL, -- value 0 means script was executed outside of ci/cd context
        JobId       int            NOT NULL, -- value 0 means script was executed outside of ci/cd context
        Disabled    bit            NOT NULL CONSTRAINT DF_Jobs_Disabled    DEFAULT (0),
        RunServer   sysname        NOT NULL CONSTRAINT DF_Jobs_RunServer   DEFAULT (@@servername),
        ExecutedBy  nvarchar(100)  NOT NULL CONSTRAINT DF_Jobs_ExecutedBy  DEFAULT (suser_sname()),
        ExecutedAt  datetime2(0)   NOT NULL CONSTRAINT DF_Jobs_ExecutedAt  DEFAULT (getdate()),
        CONSTRAINT [PK_Jobs] PRIMARY KEY CLUSTERED (AppName,Branch)
    )
    
    IF NOT EXISTS(SELECT * FROM sys.columns WHERE name='Branch' AND object_id=OBJECT_ID('cicd.Jobs'))
        ALTER TABLE msdb.cicd.Jobs ADD Branch nvarchar(200) NULL
    -- TODO - add PK & indexes
END
"@
    Invoke-Sqlcmd -ServerInstance $Server -Database "msdb" -Query $Query | Out-Null
    $ProjectId = if ($env:CI_PROJECT_ID) { $env:CI_PROJECT_ID } else { 0 }
    $JobId     = if ($env:CI_JOB_ID) { $env:CI_JOB_ID } else { 0 }
    
    $Query = @"
    IF NOT EXISTS(SELECT * FROM cicd.Jobs WHERE AppName='$Application' AND (Branch='$Branch' OR ('$Branch'='master' AND Branch='undefined')))
       INSERT INTO cicd.Jobs(AppName, CommitHash, Branch, ProjectId, JobId) VALUES ('$Application', '$Commit', '$Branch', $ProjectId, $JobId)
    ELSE 
       UPDATE cicd.Jobs 
       SET CommitHash='$Commit', ProjectId=$ProjectId, JobId=$JobId, ExecutedBy=suser_sname(), ExecutedAt=GetDate(), Branch='$Branch',Disabled=0
       WHERE AppName='$Application' AND (Branch='$Branch' OR ('$Branch'='master' AND Branch='undefined'))
"@
    Invoke-Sqlcmd -ServerInstance $Server -Database "msdb" -Query $Query
}
function Save-ChangeLog($Server, $Database, $Application, $Branch, $Commit, $Status, $Files, $Print) {
    if ($Commit -eq '.') {
        $Commit = git rev-parse --short=8 HEAD
    }
    $sqlCommand = New-Object System.Data.SqlClient.SqlCommand
    $sqlCommand.CommandText = "SET NOCOUNT ON; " +
        "insert into [$Database].dbo.ChangeLog(AppName, Status, CommitHash, Files, JobId, ProjectId, Branch) values "+
        "(@Application, @Status, @CommitHash, @Files, @JobId, @ProjectId, @Branch)"
    $FilesStr = "<Files>"
    $Files | ForEach-Object { $FilesStr += "<File>$_</File>" }
    $FilesStr += "</Files>"
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Application", [Data.SQLDBType]::VarChar,  100)))    | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Status",      [Data.SQLDBType]::VarChar,  10)))     | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@CommitHash",  [Data.SQLDBType]::VarChar,  40)))     | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Files",       [Data.SQLDBType]::NVarChar, 100000))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@JobId",       [Data.SQLDBType]::Int))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@ProjectId",   [Data.SQLDBType]::Int))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Branch",      [Data.SQLDBType]::NVarChar, 200))) | Out-Null
    $sqlCommand.Parameters[0].Value = $Application
    $sqlCommand.Parameters[1].Value = $Status
    $sqlCommand.Parameters[2].Value = $Commit
    $sqlCommand.Parameters[3].Value = $FilesStr
    $sqlCommand.Parameters[4].Value = if ($env:CI_JOB_ID) { $env:CI_JOB_ID } else { 0 }
    $sqlCommand.Parameters[5].Value = if ($env:CI_PROJECT_ID) { $env:CI_PROJECT_ID } else { 0 }
    $sqlCommand.Parameters[6].Value = $Branch
    if (!$Print) {
        $sqlConnection = New-Object System.Data.SqlClient.SqlConnection
        $sqlConnection.ConnectionString = "Server=$Server;Database=$Database;Integrated Security=True;"
        $sqlConnection.Open()
        if ($sqlConnection.State -ne [Data.ConnectionState]::Open) {
            LogErrorAndStop "Connection to DB is not open."
        }
        $sqlCommand.Connection = $sqlConnection
        $sqlCommand.ExecuteNonQuery() | Out-Null
        if ($sqlConnection.State -eq [Data.ConnectionState]::Open) {
            $sqlConnection.Close()
        }
    } else {
        $Query = $sqlCommand.CommandText;
        foreach ($p in $sqlCommand.Parameters) {
            $Type  = $p.DbType
            $Value = $p.Value.ToString()
            if ($Type -eq [System.Data.DbType]'String' -or $Type -eq [System.Data.DbType]'AnsiString') {
                $Value = '''' + $Value + ''''
            }             
            $Query = $Query.Replace($p.ParameterName, $Value);
        }
        Write-Host $Query
    }
}
function Deploy-SSRSReports($Server, $ChangedFiles) {
    if ($ChangedFiles.Count -eq 0) {
        Write-Host "No SSRS reports to deploy"
        return
    }
    $ReportServerUri = "http://$($Server)/AAMReportingServer/ReportService2010.asmx?wsdl" # .acadian-asset.com
    $rs = New-WebServiceProxy -Uri $ReportServerUri -UseDefaultCredential
    $ConfigDataSources = $map.Environments.($Environment).DataSources
    $DataSourceMapping = $map.Application.SSRS.DataSourceMapping
    $DeployedFiles = New-Object System.Collections.ArrayList
    $ChangedFiles | Foreach {
        # $TargetPackageFile = Join-Path $TargetRootFolder $_.target
        $Change = $_.change
        $RepoFile = $_.file
        $SourceFile = $_.source
        $ReportName = [System.IO.Path]::GetFileNameWithoutExtension($RepoFile)
        $TargetFolderPath = (Split-Path $_.target).Replace('\','/')
        if ($Change -eq "D" -or $Change -eq "R") {
            if ($Change -eq "D") {
                $TargetReportName = (Join-Path $TargetFolderPath $ReportName).Replace('\','/')
            }
            if ($Change -eq "R") {
                $PreviousReportName = [System.IO.Path]::GetFileNameWithoutExtension($SourceFile)
                $TargetReportName = (Join-Path $TargetFolderPath $PreviousReportName).Replace('\','/')
            }
            Write-Host "Deleting report $TargetReportName"
            if (!$Print) {
                try {
                    $rs.DeleteItem($TargetReportName)
                } catch {
                    Write-Warning "Cannot delete report $TargetReportName $($_.Exception.Message)"
                }
            }
        }
        if ($Change -match "^(A|M|R)$") {
            Write-Host "Deploying $ReportName.rdl to directory $TargetFolderPath"
            Write-Host ""
            if (!$Print) {
                # upload report content
                $ReportFileBytes = [System.IO.File]::ReadAllBytes((Join-Path $wd $RepoFile))
                $warnings = $null
                $report = $rs.CreateCatalogItem(
                    "Report",         # Catalog item type
                    $ReportName,      # Report name
                    $TargetFolderPath,# Destination folder
                    $true,            # Overwrite report if it exists?
                    $ReportFileBytes, # .rdl file contents
                    $null,            # Properties to set.
                    [ref]$warnings)   # Warnings that occured while uploading.
                $warnings | ForEach-Object {
                    Write-Warning "$($_.Message)"
                }
                # Remapping data sources
                $dataSources = $rs.GetItemDataSources($report.Path)
                $dataSources | ForEach-Object {
                    $DataSourceName = $_.Name
                    $Mapping = $DataSourceMapping.psobject.Properties | Where { $_.Value -contains $DataSourceName } | Select -First 1
                    if (!$Mapping) {
                        throw "Mapping is not defined for data source $DataSourceName in report $ReportName"
                    } else {
                        $TargetDataSource = $ConfigDataSources.$($Mapping.Name)
                        Write-Host "Remapping $DataSourceName to $TargetDataSource in report $ReportName"
                    }
                    $proxyNamespace = $_.GetType().Namespace
                    $myDataSource = New-Object ("$proxyNamespace.DataSource")
                    $myDataSource.Name = $DataSourceName
                    $myDataSource.Item = New-Object ("$proxyNamespace.DataSourceReference")
                    $myDataSource.Item.Reference = $TargetDataSource
                    $_.item = $myDataSource.Item
                }
                    $rs.SetItemDataSources($report.Path, $dataSources )
            }
            $DeployedFiles.Add($RepoFile) | Out-Null
        }
        Write-Host ""
    }
    return (, $DeployedFiles)
}
function Run-SQLFiles([string]$Server, [string]$Database, $FileSet,[string]$Prefix, [switch]$Rollback=$false, $DeployedInPast, [switch]$Print) {
    $Order = $map.Application.Deployment.Order
    $ReRunnable = $map.Application.Deployment.ReRunnable
    $Ignore     = $map.Application.Deployment.Exclude
    if ($Rollback) {
        $Order = $Order | ForEach-Object { $_ -replace "/Scripts", "/Rollback"}
    }
    $DeployedFiles = New-Object System.Collections.ArrayList
    $Files = $FileSet | Where-Object { $_.target.StartsWith($Prefix) }
    $FileNames = @( $Files | ForEach-Object { $_.target } | Sort @{Expression={$_}; Ascending=!$Rollback} )
    foreach ($file in $Files) {
        $path = $file.target
        $name = Split-Path $path -leaf
        if ($DeployedInPast -contains $file.file) {
            $rerun = $false
            foreach ($Pattern in $ReRunnable) {
                if ($path -like $pattern) {
                    $rerun = $true;
                    break
                }
            }
            if (!$rerun) {
                # file was deployed previously and not re-runnable
                $file.priority = -2
                continue
            }
        }
        $idx = -1
        for ($i=0; $i -lt $Order.length; $i++) {
            if ($Order[$i].EndsWith($name)) {
                $idx = $i * 10000
                break;
            }
        }
        if ($idx -eq -1) {
            for ($i=0; $i -lt $Order.length; $i++) {
                if ($path -like $Order[$i]) {
                    $idx = $i * 10000
                    break;
                }
            }
            if ($idx -ge 0) {
                # Taking additional order from name
                for ($i=0; $i -lt $FileNames.length; $i++) {
                    if ($path -eq $FileNames[$i]) {
                        $idx = $idx + $i
                        break;
                    }
                }
            }
        }
        if ($idx -eq -1) {
            if (($Rollback -and !$path.StartsWith("/Scripts")) -or (!$Rollback -and !$path.StartsWith("/Rollback"))) {
                $IgnoreFile = $false
                foreach ($IgnorePattern in $Ignore) {
                    if ($path -like $IgnorePattern) {
                        $IgnoreFile = $true
                        break
                    }
                }
                if (!$IgnoreFile) {
                    Write-Error "Cannot determine priority for file $path"
                }
            } else {
                Write-Verbose "Ignoring script/rollback file $path"
            }
        }
        $file.priority = $idx
    }
    $Files  = $Files | Sort @{Expression={$_.priority}}
    foreach ($file in $Files) {
        if ($file.priority -ge 0 -and $file.change -ne 'D') {
            Write-Host "Processing file $($file.file) ( git-change: $($file.change) priority $($file.priority) ) "
            if (!$Print) {
                $FileStatus = Execute-Sql -Server $Server -Database $Database -Path $file.file
                if (!$FileStatus) {
                    Write-Verbose "Setting global status to error"
                    $DeployedFiles.Add($file.file) | Out-Null
                    $global:Status = "Error"
                    break;
                }
            }
            $DeployedFiles.Add($file.file) | Out-Null
        }
    }
    return (, $DeployedFiles)
}
$ErrorActionPreference = "Stop"
#check if sqlserver module is available if it is use that. if not use sqlps
if (Get-Module -ListAvailable sqlserver) {
    Import-Module -Name sqlserver -DisableNameChecking
} else { 
Import-Module -Name sqlps -DisableNameChecking
} 
# TODO: Set-StrictMode -Version 2.0
# $VerbosePreference="Continue"
$wd = $MyInvocation.MyCommand.Path -replace $MyInvocation.MyCommand.Name,''
Set-Location $wd
$map = (Get-Content .\manifest.json) -join "`n" | ConvertFrom-Json
$EMPTY_TREE_SHA = "4b825dc642cb6eb9a060e54bf8d69288fbee4904"
if ($Local) {
    $HeadSHA  = "."
} else {
    $HeadSHA = git rev-parse --short=8 HEAD
}
if ($env:CI_COMMIT_REF_NAME) {
    $GitBranch = $env:CI_COMMIT_REF_NAME 
}
if (!$GitBranch -or ($GitBranch  -match '^v\d+\.\d+\.\d+$')) {
    Write-Host "Calculating branch name"
    
    $RefNameList = git log -n 1 --pretty=%d HEAD
    Write-Host "All references $RefNameList"
    $GitBranch = "master"
    # Test Cases 
    ##  (HEAD, tag: v1.1.1)
    ##  (HEAD, tag: v0.3.0, origin/hotfix/jira-2)
    ##  (HEAD, tag: v0.2.0, origin/master, origin/HEAD, master)
    ForEach ($RefName in $RefNameList.trim().substring(1,$RefNameList.trim().length-2).split(",")) {
        $RefName = $RefName.trim().replace("origin/","").replace("HEAD -> ","")
        if (!($RefName.StartsWith("tag")) -and $RefName -ne "HEAD") {
            $GitBranch = $RefName
            break
        }
    }
}
$Application = $map.Application.Name
Write-Host ""
Write-Host "--------Deploying of $Application into $Environment. Print:$Print Rollback:$Rollback--------"
if (!$map.Environments.($Environment)) {
    Write-Error "Environment $Environment is not defined in manifest file"
}
if (!$Application) {
    Write-Error "Application is not defined in manifest file"
}
# --------------- SSIS Package Deployment --------------------------------
$SsisHost = $map.Environments.($Environment).Hosts.SSIS
if ($SsisHost) {
    $SsisFileFolders = $map.Application.SSIS.RootFolders | % { $_.Trim("/").Trim("\") }
    Write-Host ""
    Write-Host "Deploying available ssis packages to $SsisHost"
    Write-Host "---------------"
    $global:Status = 'Success'
    $DeploymentHistory = Get-ChangeLog -Server $SsisHost -Database "msdb" -Application $Application
    $ChangedFiles = List-GitChanges -From $LastCommit -To $HeadSHA -Filter $SsisFileFolders -Extension "dtsx"
    $DeployedFiles = Deploy-SSISPackages -Server $SsisHost -ChangedFiles $ChangedFiles
    if ($DeployedFiles.count -gt 0) {
        Save-ChangeLog -Server $SsisHost -Database "msdb" -Application $Application `
                       -Commit $HeadSHA -Status $global:Status -Files $DeployedFiles -Print:$Print -Branch $GitBranch
    }
}
# --------------- SSRS Report Deployment ----------------------------------
$SsrsHost = $map.Environments.($Environment).Hosts.SSRS
if ($SsrsHost) {
    $SsrsFileFolders = $map.Application.SSRS.RootFolders | % { $_.Trim("/").Trim("\") }
    Write-Host ""
    Write-Host "Deploying available ssrs reports to $SsrsHost"
    Write-Host "---------------"
    $global:Status = 'Success'
    $DeploymentHistory =  Get-ChangeLog -Server $SsrsHost -Database "msdb" -Application $Application
    $ChangedFiles = List-GitChanges -From $LastCommit -To $HeadSHA -Filter $SsrsFileFolders -Extension "rdl"
    $DeployedFiles = Deploy-SSRSReports -Server $SsrsHost -ChangedFiles $ChangedFiles
    if ($DeployedFiles.count -gt 0) {
        Save-ChangeLog -Server $SsrsHost -Database "msdb" -Application $Application `
                       -Commit $HeadSHA -Status $global:Status -Files $DeployedFiles -Print:$Print -Branch $GitBranch
    }
}
# -------------- Database Deployment --------------------------------------
Write-Host ""
Write-Host "Deploying other Database components"
Write-Host "-----------------------------------"
Get-ChildItem -Directory -Exclude SSIS,SSRS | ForEach-Object {
    $HostAlias = $_.Name
    Get-ChildItem -Path $HostAlias | ForEach-Object {
        $TargetDb = $_.Name
        $TargetHost =  $map.Environments.($Environment).Hosts.($HostAlias)
        if (!$TargetHost) {
            Write-Warning "Host not specified for folder $HostAlias. Ignoring folder"
            return
        }  
        $global:Status = 'Success'        
        Write-Host "Processing $HostAlias($TargetHost).$TargetDb"
        Write-Host "-"
        $DeploymentHistory =  Get-ChangeLog -Server $TargetHost -Database $TargetDb -Application $Application
        $ChangedFiles = List-GitChanges -From $LastCommit -To $HeadSHA -Filter "$HostAlias/$TargetDb" -Extension "sql" # -Local
        $DeployedFiles = Run-SQLFiles -Server $TargetHost -Database $TargetDb -FileSet $ChangedFiles `
                                     -DeployedInPast $DeploymentHistory -Rollback:$Rollback -Print:$Print
        if ($DeployedFiles.count -eq 0) {
            Write-Host "No files exist for this deployment"
        }
        if ($DeployedFiles.count -gt 0) {
            Save-ChangeLog -Server $TargetHost -Database $TargetDb -Application $Application `
                           -Commit $HeadSHA -Status $Status -Files $DeployedFiles -Print:$Print -Branch $GitBranch
        }
        if ($Status -eq 'Error') {
            Write-Error "Deployment failed"
        }
        Write-Host ""
    }
    if (!$Print) {
        Save-JobStatus -Server $TargetHost -Application $Application -Commit $HeadSHA -Branch $GitBranch
    }
}
Write-Host "--------Deployed completed ---------"