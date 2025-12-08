# clone_project – Chapter 08 ~ 12 정리

## 1. 프로젝트 개요

이 프로젝트는 Flutter와 Firebase를 활용하여  
중고 거래 서비스인 **당근마켓**의 핵심 기능을 단계적으로 구현하는 클론 앱입니다.

이 문서는 **Chapter 08 ~ 12** 동안
이전 챕터와 비교했을 때 **어떤 기능이 새로 추가·변경되었는지**를 중심으로 정리했습니다.

---

## 2. 사용 기술

- **언어**: Dart
- **프레임워크**: Flutter
- **상태관리 & 라우팅**: GetX
- **백엔드(BaaS)**: Firebase (Auth, Firestore 등)
- **로컬 저장소**: SharedPreferences

---

## 3. 챕터별 기능 요약

### Chapter 08 – 기본 프로젝트 구조 및 라우팅 설정

**추가/변경 내용**

- `GetMaterialApp` 기반 전역 라우팅 구조 설정
- `/` 라우트에 루트 위젯(`App`) 연결
- 다크 톤 기반 `ThemeData` 설정  
  → `AppBarTheme`, `scaffoldBackgroundColor` 등 공통 디자인 지정

**의미**

- 이전까지 UI 위젯만 존재하던 상태에서  
  **실제 앱처럼 동작하는 뼈대(라우팅 + 테마)** 를 갖추게 된 단계

---

### Chapter 09 – Firebase 기본 연동 및 앱 초기화

**Chapter 08 대비 추가된 내용**

- Firebase 프로젝트 연동 (`firebase_core`, `firebase_options.dart`)
- `main()` 함수 비동기 처리
  - `WidgetsFlutterBinding.ensureInitialized()` 호출
  - `Firebase.initializeApp()` 완료 후에만 `runApp()` 실행

**의미**

- 회원 인증, 데이터 저장, 파일 업로드 등  
  이후 모든 기능의 기반이 되는 **Firebase 연결**이 완료됨
- “UI만 있는 앱”에서 **백엔드와 실제로 연결된 앱**으로 한 단계 진화

---

### Chapter 10 – SharedPreferences 도입 및 로컬 상태 저장 준비

**Chapter 09 대비 추가된 내용**

- `shared_preferences` 패키지 추가
- 앱 시작 시 `SharedPreferences` 인스턴스 생성  
  → 예: `prefs = await SharedPreferences.getInstance();`
- 전역에서 사용할 수 있도록 `prefs` 참조를 준비

**의미**

- **자동 로그인 여부, 온보딩 여부, 간단한 설정** 등을  
  로컬에 저장할 수 있는 기반이 마련됨
- Firebase(서버) + SharedPreferences(로컬)이라는  
  **혼합 구조**를 사용하는 출발점

---

### Chapter 11 – 스플래시 & 초기 라우팅 구조

**Chapter 10 대비 추가된 내용**

- 스플래시 페이지 UI 및 라우트 추가
- 컨트롤러 도입
  - `SplashController`
  - `DataLoadController`
  - 기본 구조의 `AuthenticationController`
- `initialBinding` 사용
  - 앱 시작 시 위 컨트롤러들을 한 번에 `Get.put()`으로 등록
- `/home`, `/login` 라우트 설정

**의미**

- 앱 실행 시
  1. 스플래시 화면 표시  
  2. 초기 데이터/인증 상태 확인  
  3. 홈 또는 로그인 페이지로 분기  
  하는 기본 흐름을 만들었다는 점에서 중요

---

### Chapter 12 – Firebase 인증 & 회원가입/로그인 구현

**Chapter 11 대비 추가된 내용**

- Firebase Auth 연동
  - 이메일/비밀번호 로그인
  - 계정 생성(회원가입)
- Repository / Controller 계층 도입
  - `AuthenticationRepository`
  - `UserRepository`
  - `LoginController`
  - `SignupController`
- 라우트 확장
  - `/signup/:uid` → 회원가입 페이지
- `initialBinding` 확장
  - 인증 관련 Repository와 Controller를 함께 주입

**의미**

- 앱이 단순히 화면만 있는 수준을 넘어서  
  **실제 계정을 생성하고 로그인할 수 있는 서비스** 단계로 진입
- 이후의 홈 화면, 상품 등록, 채팅 기능 등은  
  모두 “로그인한 사용자”를 전제로 동작할 수 있게 됨

---

## 4. 구조 요약

- `lib/main.dart`
  - Firebase 초기화
  - SharedPreferences 초기화
  - GetX `initialBinding` 설정 및 라우팅 정의
- `lib/src/...`
  - 스플래시, 로그인, 회원가입, 홈 등 화면 및 관련 컨트롤러 정의
  - 인증/유저 정보를 관리하는 Repository 계층 추가

---

## 5. 학습/발전 포인트

- 앱의 **뼈대(라우팅/테마) → 백엔드 연동 → 로컬 저장소 → 인증 흐름**까지  
  실제 서비스 앱의 기반 기능을 단계적으로 완성한 구간
- MVC/MVVM에 가까운
  **View(페이지) – Controller – Repository – Firebase** 구조를 연습할 수 있었음
