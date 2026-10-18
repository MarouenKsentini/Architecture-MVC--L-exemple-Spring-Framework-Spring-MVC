$env:JAVA_HOME = "C:\Program Files\Java\jdk-17.0.18"
$workingDir = "C:\Users\marou\Downloads\productapp"
$logDir = $workingDir
$pwsh = $PSHOME
$mvn = "C:\apache-maven\apache-maven-3.9.14\bin\mvn.cmd"

$start = Get-Date
Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Starting Maven Spring Boot app..." | Out-File -FilePath "$logDir\mvn-stdout.log" -Append
Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Starting Maven Spring Boot app..." | Out-File -FilePath "$logDir\mvn-stderr.log" -Append

$proc = Start-Process -FilePath $mvn `
  -ArgumentList "spring-boot:run", "-f", "$workingDir\pom.xml" `
  -WorkingDirectory $workingDir `
  -RedirectStandardOutput "$logDir\mvn-stdout.log" `
  -RedirectStandardError "$logDir\mvn-stderr.log" `
  -PassThru

Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Maven PID: $($proc.Id)" | Out-File -FilePath "$logDir\mvn-stdout.log" -Append
Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Launched. Waiting for app to be ready..." | Out-File -FilePath "$logDir\mvn-stdout.log" -Append

# Wait up to 120 seconds for the app to start
$timeout = 120
$interval = 2
$elapsed = 0
$ready = $false

while ($elapsed -lt $timeout) {
    Start-Sleep -Seconds $interval
    $elapsed += $interval

    # Check if process still running
    if (-not $proc.HasExited) {
        # Try to detect if Spring Boot has started by looking at the log
        $stdout = Get-Content "$logDir\mvn-stdout.log" -Raw -ErrorAction SilentlyContinue
        if ($stdout -match "Started ProductappApplication") {
            Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Application started successfully after $elapsed seconds" | Out-File -FilePath "$logDir\mvn-stdout.log" -Append
            $ready = $true
            break
        }
        # Also check for port binding
        if ($stdout -match "Tomcat started on port") {
            Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Tomcat detected on port after $elapsed seconds" | Out-File -FilePath "$logDir\mvn-stdout.log" -Append
            $ready = $true
            break
        }
    } else {
        Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Maven process exited prematurely with code $($proc.ExitCode)" | Out-File -FilePath "$logDir\mvn-stderr.log" -Append
        Get-Content "$logDir\mvn-stdout.log" | Select-Object -Last 20 | Out-File -FilePath "$logDir\mvn-stderr.log" -Append
        break
    }
}

if (-not $ready) {
    Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Timeout reached after $timeout seconds. App may not be ready." | Out-File -FilePath "$logDir\mvn-stderr.log" -Append
    # Print last 30 lines of stdout for debugging
    Get-Content "$logDir\mvn-stdout.log" | Select-Object -Last 30 | Out-File -FilePath "$logDir\mvn-stderr.log" -Append
}

# Keep the PowerShell process alive to hold the child process
Write-Output "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Done. App PID: $($proc.Id), Ready: $ready" | Out-File -FilePath "$logDir\mvn-stdout.log" -Append
# Prevent the PowerShell process from exiting (which would kill mvn child)
while ($true) { Start-Sleep -Seconds 60 }
