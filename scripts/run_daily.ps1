# 곱창119 매출 자동 정리 - 작업 스케줄러가 매일 새벽 실행합니다.
# 사용법(수동): powershell -ExecutionPolicy Bypass -File run_daily.ps1 [-TargetDate 2026-11-05]
param([string]$TargetDate = '')
$ErrorActionPreference = 'Continue'
$dir = Join-Path $env:USERPROFILE 'gopchang119-sales'
New-Item -ItemType Directory -Force "$dir\logs" | Out-Null
$stamp = Get-Date -Format 'yyyy-MM-dd_HHmm'

# 하루 쉬고 싶으면 skip_<오늘날짜>.flag 파일을 만들어 두세요 (예: skip_2026-11-05.flag)
$skipFlag = "$dir\skip_$(Get-Date -Format 'yyyy-MM-dd').flag"
if ((Test-Path $skipFlag) -and -not $TargetDate) {
    "SKIPPED" | Out-File -FilePath "$dir\logs\run_${stamp}_skipped.txt" -Encoding utf8
    Remove-Item $skipFlag -Force
    exit 0
}

# Windows PowerShell 5.1에서 한글이 깨지지 않도록 영어로만 지시하고, 한글 규칙은 스킬 파일에서 읽게 합니다.
$prompt = "Use the gopchang119-sales skill in RUN mode (config: $dir\config.json). Today is $(Get-Date -Format 'yyyy-MM-dd') (Korea time); D = yesterday."
$prompt += " Headless run: never end your turn to wait; when you must wait, wait inside mcp__aside__repl with await new Promise(r=>setTimeout(r,110000)) and continue. Write the log before your final reply."
if ($TargetDate) { $prompt += " OVERRIDE: D is $TargetDate." }

$claude = (Get-Command claude -ErrorAction SilentlyContinue).Source
if (-not $claude) { $claude = Join-Path $env:USERPROFILE '.local\bin\claude.exe' }

Set-Location $dir
$OutputEncoding = New-Object System.Text.UTF8Encoding $false
[Console]::OutputEncoding = New-Object System.Text.UTF8Encoding $false
$prompt | & $claude -p --allowedTools 'Skill' 'mcp__aside__repl' 'Read' 'Write' 'Edit' 2>&1 |
    Out-File -FilePath "$dir\logs\run_$stamp.txt" -Encoding utf8

# 가끔 빈 로그로 끝나는 경우가 있어 5분 뒤 한 번 더 시도합니다.
if ((Get-Item "$dir\logs\run_$stamp.txt").Length -lt 10) {
    Start-Sleep -Seconds 300
    $prompt | & $claude -p --allowedTools 'Skill' 'mcp__aside__repl' 'Read' 'Write' 'Edit' 2>&1 |
        Out-File -FilePath "$dir\logs\run_${stamp}_retry.txt" -Encoding utf8
}
