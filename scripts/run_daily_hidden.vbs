' Runs run_daily.ps1 with no visible window (so nobody closes it by accident).
Set sh = CreateObject("WScript.Shell")
p = sh.ExpandEnvironmentStrings("%USERPROFILE%") & "\gopchang119-sales\run_daily.ps1"
sh.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -File """ & p & """", 0, True
