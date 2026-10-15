# 매일 자동 실행 등록 - 사장님이 직접 한 번만 실행하세요.
# 실행: 시작 메뉴에서 PowerShell 열기 → 이 폴더로 이동 → powershell -ExecutionPolicy Bypass -File install_schedule.ps1
param([string]$Time = '02:30')
$dir = Join-Path $env:USERPROFILE 'gopchang119-sales'
New-Item -ItemType Directory -Force $dir | Out-Null
Copy-Item (Join-Path $PSScriptRoot 'run_daily.ps1') $dir -Force
Copy-Item (Join-Path $PSScriptRoot 'run_daily_hidden.vbs') $dir -Force

$action  = New-ScheduledTaskAction -Execute 'wscript.exe' -Argument "`"$dir\run_daily_hidden.vbs`""
$trigger = New-ScheduledTaskTrigger -Daily -At $Time
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Hours 2)
Register-ScheduledTask -TaskName 'Gopchang119 Sales' -Action $action -Trigger $trigger -Settings $settings -Force | Out-Null
Write-Host "등록 완료: 매일 $Time 에 어제 매출을 시트에 입력합니다. (PC가 켜져 있어야 해요)"
Write-Host "끄고 싶으면: Unregister-ScheduledTask -TaskName 'Gopchang119 Sales'"
