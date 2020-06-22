Param(
    [Parameter(Mandatory=$true)]
    [string]$Server,
    [string[]]$IncludeApps = "*",
    [string[]]$ExcludeApps = @("system-dbs","/accounting/positions/operational-master/database-mssql"),
    [switch]$DeleteObsoleteJobs = $true,
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"
$HasErrors = $false

trap
{   
   Write-Host "Error found at line $($_.InvocationInfo.ScriptLineNumber):$($_.InvocationInfo.OffsetInLine) $_"
   Exit 1
}

# Reset branch cache - useful for debugging
$Global:BranchCache = $null
function Get-Branches($ProjectId, $GitLabToken) {
    $Branches = $null
    if (!$Global:BranchCache) {
        $Global:BranchCache = @{}
    }
    if ($ProjectId -gt 0) {
        $Branches = $Global:BranchCache[$ProjectId] 
        if ($Branches) {
            Write-Verbose "Using cached list of branches for project $ProjectId" 
        } else {
            $Branches = @()
            $Uri       = "https://git.acadian-asset.com/api/v4/projects/$ProjectId/repository/branches"
            $Response  = Invoke-RestMethod -Method Get -Headers @{'PRIVATE-TOKEN'= $GitLabToken} -Uri $Uri

            foreach ($Branch in $Response) {
                $Branches += $Branch.name
            }
            $Global:BranchCache[$ProjectId] = $Branches
            Write-Verbose "Loaded list of branches for project $ProjectId $($Branches -Join ",")" 
        }
    }
    return $Branches
}


# $Token     = "TcHFAN4uHx8pP32y47hV"
$GitLabToken = "iszs2ESYGceWnnzYDMVD"
Write-Host "Rerunning CD/CD jobs for server $Server Include:$($IncludeApps -join ',') Exclude:$($ExcludeApps -join ',')"

$Query = "exec msdb.cicd.GetJobsToRerun"

$QueryResult = Invoke-Sqlcmd -ServerInstance $Server -Database "msdb" -Query $Query

$JobToRerun = $QueryResult | Sort-Object -Property @{Expression={$_.AppName}}, @{Expression={if ($_.Branch -eq "master"){1}else{2}}}

$JobToRerun | Format-Table -AutoSize | Out-String -Width 200 -Stream

ForEach ($Row in $JobToRerun) {
    $ProjectId = $Row.ProjectId
    $JobId     = $Row.JobId
    $AppName   = $Row.AppName
    $Branch    = $Row.Branch
    $Uri       = "https://git.acadian-asset.com/api/v4/projects/$ProjectId/jobs/$JobId/retry"
    $RunJob    = $true
    if (($ExcludeApps | Where { $AppName -like $_ } | Select-Object -First 1) -eq $null -and `
        ($IncludeApps | Where { $AppName -like $_ } | Select-Object -First 1) -ne $null)
    {
        if (!$Branch -or ($Branch -eq [System.DBNull]::Value)) {
            $Branch = "undefined"
        }
        $ReRunJob = $true
        if ($Branch -ne "undefined") {
            $ActiveProjectBranches = Get-Branches -ProjectId $ProjectId -GitLabToken $GitLabToken
            if ($ActiveProjectBranches -contains $Branch) {
              #  Write-Host $Branch -ForegroundColor Green
            } else {
                Write-Host "Ignoring $AppName JobId: $($Row.JobId) Branch: $Branch - Branch doesn't exist in gitlab"
    
    if ($DeleteObsoleteJobs) {
     Write-Host "    Deleting obsolete app/branch record"
     $Query = "delete from msdb.cicd.Jobs where AppName='$AppName' and Branch='$Branch'"
     Invoke-Sqlcmd -ServerInstance $Server -Database "msdb" -Query $Query
    }
                # Write-Host "    Branch $Branch will be ignored" -ForegroundColor Red
                $ReRunJob = $false
            }
        } else {
            # This is from previous single-branch version of the script
            # Write-Host $Branch -ForegroundColor Gray
        }

        if ($ReRunJob) {
   if ($DryRun) {
    Write-Host "DryRun $AppName JobId: $($Row.JobId) Branch: $Branch"
   } else {
    Write-Host "ReRunning $AppName JobId: $($Row.JobId) Branch: $Branch"
    try {
        $Response  = Invoke-RestMethod -Method Post -Headers @{'PRIVATE-TOKEN'= $GitLabToken} -Uri $Uri
    } catch {
     $HasErrors = $true
     # Dig into the exception to get the Response details.
     # Note that value__ is not a typo.
     Write-Host "    Error Code:" $_.Exception.Response.StatusCode.value__ 
     Write-Host "    Error Description:" $_.Exception.Response.StatusDescription
    } 
    Write-Host "   New JobId=$($Response.Id) created at $($Response.created_at) Pipeline: $($Response.pipeline.id)"
   }
        }
    } else {
        Write-Host "Excluding $AppName"
    }
}
if ($HasErrors) {
    Write-Error "At least one pipeline failed"
} else {
    Write-Host "ReRuning CI/CD Jobs is completed"
}