Param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet("DB02", "CORE", "MASTERDATA","WH02", "RND","DBCLUS4-2","DBCLUS4-1","DBCLUS4-3")]
    [string]$Pipeline,
   
    [Parameter(Mandatory=$true, Position=1)]
    [string]$TargetServer
)

# Write-Host "Getting Refresh automation from $Pipeline to $TargetServer"
$ErrorActionPreference = "Stop"

trap
{  
   Write-Host "Error found at line $($_.InvocationInfo.ScriptLineNumber):$($_.InvocationInfo.OffsetInLine) $_"
   Exit 1
}

function Execute-Sql {
    Param([string]$server, [string]$path)

    $cmd = "& sqlcmd -b -E -S ${server} -i `"${path}`""

    $output2 = Invoke-Expression $cmd -OutVariable ConsoleOutput # | Tee-Object -Variable out
    $result = $?
    if ($lastexitcode -gt 0) {
        $result = $False
    }
    foreach ($Line in $ConsoleOutput) {
  if ($Line.Trim().length -gt 0) {
   Write-Host $Line
   $global:ExecutionLog = $global:ExecutionLog + "    " + $Line + "`n"
  }
    }
    return $Result
}

Write-Host "Starting refresh for server $TargetServer ($Pipeline). Current user=$($env:username)"
$TargetFolder = "C:\DBA\RefreshAutomation\${TargetServer}"
$RepoFolder   = "$TargetFolder\Repo"


New-Item -ItemType Directory -Force -Path $RepoFolder
Remove-Item –Path $RepoFolder\* -Force -Recurse
$GitHubRepo = "git@git.acadian-asset.com:DO/RefreshAutomation.git"
Write-Host "Cloning git repo"

try {
    # This is a temporary workaround for
    $result  = Invoke-Expression   "& C:\DBA\git\bin\git.exe clone  $GitHubRepo $RepoFolder" -ErrorAction SilentlyContinue  -ErrorVariable errout -OutVariable stdout
} catch {
    if ($LASTEXITCODE -ne -1) {
       Write-Error "Cannot clone git repository"
    } else {
        $errout
        $stdout
    }
}

# Wait up to 10 minutes until databases come online.
$Duration = 10*60
$TimeOut=New-TimeSpan -Seconds $Duration
$Sw=[Diagnostics.Stopwatch]::StartNew()

$SQLConnection = new-object system.data.sqlclient.SqlConnection("Server=$TargetServer;Trusted_Connection=yes")
$SQLConnection.open()
$Query = "select top 1 name from sys.databases where state_desc<>'ONLINE' and not name in ('MasterData')"
$sqlCommand = New-Object system.Data.sqlclient.SqlCommand($Query,$SQLConnection)

While ($Sw.Elapsed -lt $TimeOut)
{
    # Get-Date
    $DBName = $sqlCommand.ExecuteScalar()
    if ($DBName) {
        Write-Host "Database $DBName is not online"
        Sleep -Seconds 5
    } else {
        Write-Host "All databases are online"
        $DBName = "ALL_ONLINE"
        break;
    }
}
$SQLConnection.close()
if ($DBName -ne "ALL_ONLINE") {
    Write-Error "Database $DBName is not online"
    exit 1
}


$Files = Get-ChildItem -Recurse -Include *.sql $RepoFolder\$Pipeline 
if ($Files.Count -eq 0) {
    Write-Error "No files found for refresh"
}
$OverallStatus = "Success"
$Report = "<ul>";

foreach ($File in $Files) {
    Write-Host "Checking file $($File.FullName)"
    $FirstLine = Get-Content $File.FullName -First 1
    Write-Host "First Line: $FirstLine"

    $RunFile = $false
    if ($FirstLine.StartsWith('--SERVERS')) {
        $Servers = $FirstLine.Split(':')[1];
        if ($Servers) {
            $ServerList = $Servers.Split(',');
            foreach ($ServerPattern in $ServerList) {
                $ServerPattern = $ServerPattern.trim();
                if ($TargetServer -Like $ServerPattern) {
                    $RunFile = $true;
                    break;
                }               
            }
        } else {
            # if we didn't find any thing then we run the file
            # $RunFile = $true
        }
    } else {
        Write-Warning "First line doesn't start with --SERVERS"
    }

    if ($RunFile) {     
  $global:ExecutionLog = ""
        $ScriptResult = Execute-SQL -Server $TargetServer -Path $File.FullName
        $RepoURL = "https://git.acadian-asset.com/DO/RefreshAutomation/blob/master$($File.FullName.Substring($RepoFolder.Length).Replace('\','/'))"
        if ($ScriptResult -eq $False) {
            $Report += "<li style=""color:red"">Failed: $RepoURL</li>"
   $Report += "<pre>" + $global:ExecutionLog + "</pre>"
            Write-Host "Deployment failed" -ForegroundColor Red
            $OverallStatus = "Error"
        } else {
            $Report += "<li>$RepoURL</li>"
        }
    } else {
        Write-Host "Skipping file $($File.FullName)"
        $Report += "<li style=""color:gray"">Ignore: $($File.FullName) ($Servers)</li>"
    }
}
$Report = $Report + "<ul>";

$SmtpServer  = "casarray.acadian-asset.com"
$From        = "sqldev@acadian-asset.com"
$To          = "dbOps@Acadian-Asset.com"

if ($OverallStatus -eq "Success") {
    $Subject = "Successful refresh automation for $TargetServer ($Pipeline)"
} else {
    $Subject = "Errors in refresh automation for $TargetServer ($Pipeline)"
}

Send-MailMessage -From $From -To ($To -split ",") -Subject $Subject -BodyAsHtml $Report  -SmtpServer $SmtpServer
Write-Host "Refresh completed"