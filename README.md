# 곱창119 매출 자동 정리 스킬

매일 새벽, **어제 매출**을 배민·쿠팡이츠·요기요·땡겨요·네이버 주문·토스 포스(홀)에서 읽어서
**구글 시트에 자동으로 적어 주는** Claude 스킬입니다. 곱창119 천안두정점에서 실제로 매일 쓰고 있는 방식을 다른 지점도 쓸 수 있게 정리했습니다.

- 사이트에서 **읽기만** 합니다. 설정·광고·주문은 건드리지 않아요.
- **로그인은 절대 대신 하지 않아요.** 로그인이 풀려 있으면 그 칸은 비워 두고 알려 줍니다.
- 이미 적혀 있는 칸은 **덮어쓰지 않아요.**

---

## 준비물

| 준비물 | 설명 |
|---|---|
| Windows PC | 새벽에 자동으로 돌리려면 그 시간에 켜져 있어야 해요 |
| Claude 유료 요금제 | Pro 이상 (Claude Code 사용) |
| Aside 브라우저 | 배달앱 사장님 사이트에 로그인해 둘 브라우저 |
| 구글 계정 | 매출 시트용 |

---

## 1. Claude Code 설치

1. 시작 메뉴에서 **PowerShell**을 엽니다.
2. 아래 한 줄을 붙여 넣고 엔터:
   ```
   irm https://claude.ai/install.ps1 | iex
   ```
3. 설치가 끝나면 PowerShell을 닫았다가 다시 열고 `claude` 라고 입력 → 화면 안내대로 Claude 계정으로 로그인합니다.

## 2. 어사이드(Aside) 설치와 연결

1. Aside 브라우저를 설치하고 실행합니다.
2. Aside 안에서 아래 사이트에 **사장님이 직접** 로그인해 둡니다. (자동 로그인 체크 권장)
   - 배민 사장님사이트, 쿠팡이츠 스토어, 요기요 사장님, 땡겨요 사장님라운지, 네이버 스마트플레이스(주문), 토스플레이스 대시보드, 구글(시트)
3. Aside의 Claude Code 연결 안내에 따라 MCP를 연결합니다. 보통 PowerShell에서:
   ```
   claude mcp add aside --scope user -- "$env:LOCALAPPDATA\Aside\CLI\current\aside.exe" mcp
   ```
4. `claude`를 실행하고 `/mcp`를 입력했을 때 **aside**가 보이면 성공입니다.

## 3. 이 스킬 설치

1. 이 페이지 위쪽 초록색 **Code → Download ZIP**을 눌러 받고, 압축을 풉니다.
2. 압축 푼 폴더 안의 `scripts` 폴더에서 `install.ps1`을 **마우스 오른쪽 → PowerShell에서 실행**합니다.
   (막히면 Claude Code에 "이 폴더의 install.ps1 실행해줘"라고 말해도 됩니다.)

## 4. 처음 설정 (Claude가 물어보며 진행해요)

PowerShell에서 `claude`를 실행하고 이렇게 말하세요:

```
매출 정리 설정해줘
```

Claude가 하나씩 물어봅니다.
1. 매장 이름, 마감 시각
2. 쓰는 배달앱 고르기 → Claude가 어사이드에서 사이트를 열어 매장 번호를 알아서 찾아요
3. 구글 시트 주소 (없으면 `templates/매출시트_양식.csv`로 새로 만드는 법을 알려줘요)
4. 시트의 어느 열이 어느 앱인지 확인
5. 어제 날짜로 **시험 실행** → 숫자가 맞는지 확인

## 5. 매일 자동 실행 (선택)

시험 실행 숫자가 맞으면, `scripts` 폴더에서 PowerShell을 열고:

```
powershell -ExecutionPolicy Bypass -File install_schedule.ps1 -Time 02:30
```

이제 매일 02:30에 어제 매출이 시트에 들어갑니다. 결과 기록은 `내 사용자 폴더\gopchang119-sales\logs`에 남아요.

- 하루 쉬기: `gopchang119-sales` 폴더에 `skip_2026-11-05.flag`처럼 빈 파일을 만들어 두면 그날은 건너뜁니다.
- 끄기: PowerShell에서 `Unregister-ScheduledTask -TaskName 'Gopchang119 Sales'`

## 손으로 돌리고 싶을 때

`claude`를 열고 "어제 매출 정리해줘" 또는 "11월 3일 매출 입력해줘"라고 말하면 됩니다.

---

## 자주 묻는 것

**Q. 값이 비어 있어요.** → 그 앱 로그인이 풀렸던 거예요. 어사이드에서 다시 로그인해 두면 다음 실행 때 지난 10일치 빈 칸을 알아서 채웁니다.

**Q. 홀 매출이 0이에요.** → 휴무였거나, 포스 결제가 토스에 아직 안 올라온 경우예요. 직접 고쳐 적으면 자동 입력은 그 칸을 다시 건드리지 않아요.

**Q. 배달앱 금액 기준은?** → 할인 후 **손님이 실제 결제한 금액**입니다. 홀은 새벽 6시를 기준으로 하루를 나눠요(밤 12시 넘은 결제도 전날 매출).

**Q. 토스 말고 다른 포스를 써요.** → 설정할 때 Claude에게 쓰는 포스 이름을 말하면, 그 포스 결제 화면을 같이 보고 읽는 방법을 정해 줍니다.

**Q. 비밀번호를 Claude에게 알려줘야 하나요?** → **아니요. 절대 알려주지 마세요.** 로그인은 항상 사장님이 어사이드에서 직접 합니다.

---

## 폴더 구성

```
skills/gopchang119-sales/SKILL.md          ← Claude가 읽는 작업 설명서
skills/gopchang119-sales/templates/        ← 설정 예시, 시트 양식
scripts/install.ps1                        ← 스킬 설치
scripts/install_schedule.ps1               ← 매일 자동 실행 등록
scripts/run_daily.ps1, run_daily_hidden.vbs← 자동 실행 본체
```

개인 설정(`config.json`)과 기록(`logs/`)은 각자 PC에만 남고 GitHub에는 올라가지 않습니다.
