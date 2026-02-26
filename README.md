# CoinPriceProject

<br>

> Upbit API를 활용한 실시간 코인 시세 모니터링 앱

MVVM + Combine 패턴을 통한 반응형 UI 구현에 초점을 맞춘 실시간 코인 시세확인 프로젝트입니다. 

<br>

----

<br>

## 📺 Preview

| 실시간 시세 (WebSocket) | 즐겨찾기 (UserDefaults) | 검색 및 필터링 |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/8f7c6dc2-5027-49bf-b178-896a64fdcd5d" width="240"> | <img src="https://github.com/user-attachments/assets/a7f3401d-bbdb-4c7f-a729-aa7fb2f6fe9c" width="240"> | <img src="https://github.com/user-attachments/assets/8c355bd8-d552-4aeb-b62b-3631384893e1" width="240"> |



<br>

---

<br>

## 🛠 Tech Stack
* Language: Swift
* UI Framework: UIKit (Programmatic UI)
* Architecture: MVVM
* Reactive: Combine
* Network: URLSession (REST API & WebSocket)
* Local Storage: UserDefaults
* Dependency: Kingfisher

<br>

----

<br>

## File Tree -프로젝트 구조

```text

CoinPriceProject
├── Models          # SocketTickerModel, CoinModel, UpbitMarketCode
├── Network         # NetworkService, UpbitRawData(DTO)
├── Service         # CoinDataManager, FavoriteManager, SocketManager
├── ViewModels      # CoinViewModel, FavoriteViewModel
├── Views           # CoinListVC, FavoriteListVC, TabbarControllerVC, Cells(CoinlistTableViewCell)
└── Resources       # Assets, LaunchScreen, Info.plist, AppDelegate, SceneDelegate
'''
```

<br>

----

<br>

## 🧠 Key Architecture: MVVM + Combine
### 본 프로젝트는 데이터의 흐름을 단방향으로 관리하고, 상태 변경에 따른 UI 업데이트를 자동화하기 위해 Combine을 적극 활용했습니다.

### 1. Reactive Data Binding
* ViewModel의 @Published 속성(filteredCoins)을 ViewController에서 구독하여, 데이터 변경 시 combine으로 데이터가 연결 반응하도록 구현했습니다.
* UISearchController의 입력 이벤트를 Combine으로 바인딩하여 실시간 필터링을 구현했습니다.

### 2. Logic Separation
* ViewController: UI 배치 및 사용자 이벤트 전달에만 집중
* ViewModel: 데이터 가공, 실시간 시세 업데이트 로직, 검색 필터링 로직 담당
* DataManager: 서버 데이터(REST/Socket)를 Fetch하고 가공하는 Repository 역할

<br>

----

<br>


## :fire: Technical Challenges & 트러블슈팅

### 개발 과정에서 직면한 성능 문제를 해결하기 위해 다음과 같은 최적화를 진행했습니다.

####  WebSocket 리소스 최적화 (Critical Hit)
* 과부하 문제: 업비트의 200여 개 코인을 동시에 구독할 경우, 초당 수백 건의 데이터가 유입되어 UI 스레드 과부하 및 앱 강제 종료(Killed) 현상 발생.

* ✅해결: prefix(20) 메서드를 활용하여, 사용자경험UX를 해치지않는 선에서 상위 거래량 코인 20개에 대해서만 실시간 구독을 활성화. 과부하를 최적화하고 안정성 확보


* 비동기 이미지처리: Kingfisher를 활용해 수백 개의 코인 로고 이미지를 캐싱 처리하여 스크롤 성능을 개선함


#### cell favoriteButton 셀 재사용 버그

* ✅해결: 셀 재사용시 재사용셀을 리셋해주지않아 중복클릭되는 오류가 있어 prepareForReuse()코드를 cell 안에 넣어줌으로써 해결.


#### CoinDataManager로 데이터 흐름정리 - 단일 신뢰 원칙


* CoinManager(시세), FavoriteManager(즐겨찾기) 등 여러 객체가 파편화되어 있어, 특정 데이터 변경 시 모든 화면의 상태를 동일하게 유지하기 어렵고 디버깅 시 데이터 추적이 복잡해지는 문제 발생.

* ✅해결: CoinDataManager를 설정하여 모든 코인 데이터(시세+즐겨찾기 상태)를 통합 관리.   CoinDataManager가 다른 Manager에게 데이터를 뿌려주고 필요한상태로 가공해서 각 ViewModel에 쓰이도록 단방향식 구현. 유지보수 효율성 향상



