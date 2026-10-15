# 스킬 설치 - 이 파일을 한 번 실행하면 Claude가 "gopchang119-sales" 스킬을 쓸 수 있게 됩니다.
$repo = Split-Path $PSScriptRoot -Parent
$skillDst = Join-Path $env:USERPROFILE '.claude\skills\gopchang119-sales'
New-Item -ItemType Directory -Force $skillDst | Out-Null
Copy-Item (Join-Path $repo 'skills\gopchang119-sales\*') $skillDst -Recurse -Force
$work = Join-Path $env:USERPROFILE 'gopchang119-sales'
New-Item -ItemType Directory -Force "$work\logs" | Out-Null
Write-Host "설치 완료!"
Write-Host "이제 Claude Code를 열고 이렇게 말해 보세요:  매출 정리 설정해줘"
