# LottoZ - 로또 번호 추천 및 관리 애플리케이션

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FF6F00?style=for-the-badge&logo=firebase&logoColor=white)
<br>
![Riverpod](https://img.shields.io/badge/Riverpod-6D41FF?style=for-the-badge&logo=dropbox&logoColor=white)
![GoRouter](https://img.shields.io/badge/GoRouter-448AFF?style=for-the-badge&logo=route&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
<br>
![Google Drive](https://img.shields.io/badge/Google%20Drive-34A853?style=for-the-badge&logo=googledrive&logoColor=white)
![iCloud](https://img.shields.io/badge/iCloud-0C7BEF?style=for-the-badge&logo=icloud&logoColor=white)
![AdMob](https://img.shields.io/badge/AdMob-EA4335?style=for-the-badge&logo=googleads&logoColor=white)
<br><br>

LottoZ는 Flutter로 개발된 로또 번호 추천 및 관리 애플리케이션입니다. 사용자에게 통계 기반의 번호 추천, 번호 생성 및 저장, QR 코드 당첨 확인 등 다양한 기능을
제공하여 로또 경험을 향상시킵니다.

<br>

## 🏛️ 아키텍처 및 기술 스택

이 프로젝트는 클린 아키텍처(Clean Architecture)를 기반으로 한 **모듈형 구조**를 채택하여 코드의 재사용성, 유지보수성, 확장성을 높였습니다.

### 🛠️ 기술 스택

- **Framework**: Flutter
- **Language**: Dart
- **Backend & DB**: Firebase (Firestore, Authentication)
- **State Management**: Provider
- **Dependency Injection**: get_it
- **Font**: Pretendard

### ⚙️ 모듈 구조

각 기능과 역할에 따라 프로젝트를 여러 개의 독립적인 패키지(모듈)로 분리했습니다.

- `core`: 앱 전반에서 사용되는 확장 함수, 유틸리티 등 핵심 코드
- `data`: **데이터 소스(로컬, 원격)**, **리포지토리 구현** 등 데이터 입출력 관리
- `domain`: 앱의 핵심 **비즈니스 로직**, **모델**, **리포지토리 인터페이스** 정의
- `designsystem`: 앱의 통일된 UI를 위한 **테마(색상, 폰트)**, **공용 위젯**, **아이콘** 등
- `lib` (main): 각 모듈을 결합하여 실제 앱을 구성하고 실행하는 **메인 모듈**
- `local`: **로컬 데이터베이스**(e.g., **SharedPreferences**, **Sqflite**) 관련 처리
- `remote`: Firebase 등 **외부 API 연동** 관련 처리
- `locator`: Service Locator 패턴을 사용한 의존성 주입 관리

<br>

## 📁 프로젝트 구조

```
lottoz/
├── core/            # 코어 모듈
├── data/            # 데이터 모듈
├── designsystem/    # 디자인 시스템 모듈
├── domain/          # 도메인(비즈니스 로직) 모듈
├── lib/             # 메인 애플리케이션 모듈
│   ├── main.dart    # 앱 시작점
│   ├── model/       # UI에서 사용하는 모델
│   ├── provider/    # 상태 관리
│   ├── router/      # 화면 라우팅
│   └── ui/          # UI 화면
├── local/           # 로컬 데이터 소스 모듈
├── locator/         # 의존성 주입 모듈
├── remote/          # 원격 데이터 소스 모듈
├── assets/          # 폰트, 아이콘 등 리소스
├── pubspec.yaml     # 프로젝트 의존성 관리
└── README.md        # 프로젝트 소개
```
<br>

## 📸 스크린샷

|                     홈                      |                     회차 분석                      |                           통계                           | 추천 번호                                                |
|:------------------------------------------:|:----------------------------------------------:|:------------------------------------------------------:|------------------------------------------------------|
| <img width="1179" height="2556" alt="IMG_6688" src="https://github.com/user-attachments/assets/6e754098-26f1-4a3c-bd6e-602c736e644e" /> | <img width="1179" height="2556" alt="IMG_6689" src="https://github.com/user-attachments/assets/164503af-f773-4695-a264-d7288713680d" /> | <img width="1179" height="2556" alt="IMG_6690" src="https://github.com/user-attachments/assets/5a89e08b-8573-4b93-8d8f-59ccf757d8e9" /> | <img width="1179" height="2556" alt="IMG_6693" src="https://github.com/user-attachments/assets/f398c43f-0948-4c2c-b154-fa194f3f84eb" /> |

<br>

## ✨ 주요 기능 상세

### **🤖 지능형 번호 추천**
- 과거 당첨 통계와 데이터를 심층 분석하여 최적의 번호 조합을 추천합니다.
- 다양한 필터와 알고리즘을 통해 과학적으로 당첨 확률이 높은 번호를 만나보세요.
<br>

### **⚙️ 나만의 맞춤 번호 생성**
- 완전 자동, 반자동, 수동 등 원하는 방식으로 자유롭게 번호를 생성할 수 있습니다.
- 고정수, 제외수 등 고급 옵션을 설정하여 나만의 전략으로 번호를 조합해보세요.
<br>

###  **📱 SCAN & GO! QR 당첨 확인 및 번호 관리**
- 로또 용지의 QR 코드를 스캔하여 빠르고 정확하게 당첨 여부를 확인할 수 있습니다.
- 생성하거나 스캔한 모든 번호는 '내 번호' 목록에 자동으로 저장되어 편리하게 관리할 수 있습니다.
<br>

### **📊 한눈에 보는 당첨 통계**
- 회차별 당첨 번호, 1등 당첨금, 당첨자 수 등 상세한 정보를 제공합니다.
- 번호별 출현 횟수, 색상 통계 등 다양한 시각 자료를 통해 로또 패턴을 분석해 보세요.
<br>

### **☁️ 안전한 데이터 백업 및 복원**
- 소중한 '내 번호' 데이터를 Google Drive와 iCloud에 연동하여 안전하게 클라우드에 백업합니다.
- 기기를 변경하거나 앱을 재설치해도 언제든지 데이터를 간편하게 복원할 수 있습니다.
