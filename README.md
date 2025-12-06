# 🎸 MyGuitar – Supabase 기반 기타 연습 앱

Supabase에 저장된 곡(Song) 과 악보 메타(Score) 정보를 불러와 보여주고,
사용자가 원하는 곡을 직접 추가 / 삭제 / 즐겨찾기 할 수 있도록 제공.
기타 연습 앱으로 확장하기 위한 기반 구현 진행.
악보 그래픽 출력, 마이크 입력 연주 인식 기능은 향후 제공 예정.

## 🎯 앱 목표 / 개요

Supabase에 저장된 곡/악보 메타 정보를 불러와 표시.
사용자가 곡 및 악보 메타를 직접 추가/삭제하도록 제공.
즐겨찾기 기능 제공. 설정 화면 제공.
향후 확장 기능으로는
악보 미리보기 / 프렛보드 기반 출력 / 마이크 입력 및 연주 인식 기능을 제공할 예정.
제공 기능
곡(Song) 목록 조회 / 추가 / 삭제 제공
곡별 Score(악보 버전) 목록 조회 / 추가 / 삭제 제공
즐겨찾기(Favorites) 기능 제공
Settings 화면 제공
향후 확장: Notes 기반 악보 출력 · 마이크 입력 연주 인식 기능 제공

## 📂 프로젝트 구조

MyGuitarApp
├── App
│   ├── MyGuitarAppApp.swift     
│   │   → 앱 진입점. @main. 다크모드 설정 제공.
│   └── MainTabView.swift        
│       → TabView 구성 제공. Songs / Favorites / Settings 탭 제공.
│
├── Core
│   ├── API
│   │   └── SongApiConfig.swift  
│   │       → Supabase REST API URL & API Key 제공.
│   │
│   ├── Model
│   │   ├── Song.swift           
│   │   │   → songs 테이블 모델. 기본 정보(title, artist 등) 제공.
│   │   ├── Score.swift          
│   │   │   → scores 테이블 모델. 악보 버전/악기 정보 제공.
│   │   └── Note.swift           
│   │       → notes 테이블 모델. (샘플 노출용)
│   │
│   └── Repository
│       ├── SongRepository.swift         
│       │   → Song 기능용 Repository 프로토콜 제공.
│       ├── SupabaseSongRepository.swift 
│       │   → Supabase 연동 Song 구현체. URLSession 통한 REST API GET/POST/DELETE 제공.
│       ├── ScoreRepository.swift        
│       │   → Score 기능용 Repository 프로토콜 제공.
│       └── SupabaseScoreRepository.swift
│           → Score 기능 Supabase 구현체 제공.
│
└── Features
    ├── Songs
    │   ├── SongsRootView.swift   
    │   │   → Songs 탭 루트. 곡 목록 로드/삭제/추가 제공.
    │   ├── SongDetailView.swift  
    │   │   → 곡 상세 화면. Score 목록/즐겨찾기/삭제 제공.
    │   ├── SongRowView.swift     
    │   │   → 곡 리스트 카드 UI 제공.
    │   ├── ScoreSectionView.swift
    │   │   → SongDetailView 내 Score 목록/추가/삭제 제공.
    │   ├── NoteListView.swift    
    │   │   → Score의 Note 목록 샘플 노출. 그래픽 악보 기반 준비.
    │   ├── AddSongView.swift     
    │   │   → 사용자 입력 기반 곡 추가 폼 제공.
    │   ├── SongViewModel.swift   
    │   │   → 곡 목록 상태 관리. CRUD 제공.
    │   └── ScoreViewModel.swift  
    │       → Score 목록 상태 관리. CRUD 제공.
    │
    ├── Favorites
    │   ├── FavoriteManager.swift 
    │   │   → UserDefaults 기반 즐겨찾기 ID 저장/조회 제공.
    │   └── FavoritesView.swift   
    │       → 즐겨찾기 Song 필터링 리스트 제공.
    │
    └── Settings
        └── SettingsView.swift    
            → 앱 환경 설정 제공. 다크모드, 기본 정보 제공.

# 🔄 플로우 차트 (Mermaid)
아래는 README에서 그림처럼 렌더링되는 Mermaid 다이어그램 제공.
## 🗂 Data Flow Diagram
flowchart TD

A[사용자] --> B[SwiftUI View 계층<br/>SongsRootView / SongDetailView<br/>ScoreSectionView / NoteListView]

B --> C[ViewModel 계층<br/>SongViewModel / ScoreViewModel / NoteViewModel]

C --> D[Repository 인터페이스<br/>SongRepository / ScoreRepository / NoteRepository]

D --> E[Supabase Repository 구현체<br/>SupabaseSongRepository<br/>SupabaseScoreRepository]

E --> F[URLSession<br/>HTTP REST API]

F --> G[Supabase REST API 서버]

G --> H[Supabase DB<br/>songs / scores / notes]
## 👤 User Flow Diagram
Songs 탭 → Detail → Score → Note 흐름
flowchart TD

A[앱 실행] --> B[MainTabView]
B --> C[Songs 탭 선택]
C --> D[SongsRootView<br/>노래 리스트]
D --> E[곡 선택]
E --> F[SongDetailView<br/>Score 목록]
F --> G[Score 선택]
G --> H[NoteListView<br/>노트 목록]
H --> I[연습 기능 확장 예정]
Practice 기반 (확장 예정)
flowchart TD

A[MainTabView] --> B[Practice 탭]
B --> C[Score 리스트]
C --> D[NoteListView]
D --> E[마이크 입력 기반 연습 제공 예정]
## 🏗 프로젝트 구조(Architectural Diagram)
flowchart TD

A[View (SwiftUI)] --> B[ViewModel]
B --> C[Repository Interface]
C --> D[Supabase Repository 구현체]
D --> E[URLSession]
E --> F[Supabase REST API]
F --> G[Supabase DB]
# ⚙️ 필수 제한 요소 / 기능 구현
URLSession 사용
SupabaseSongRepository, SupabaseScoreRepository에서 REST API 요청 처리.
GET / POST / DELETE 제공.
List 사용
SongsRootView, FavoritesView, SongDetailView, NoteListView 등에서 사용.
NavigationStack / NavigationLink / navigationTitle
SongsRootView → SongDetailView 이동 제공.
FavoritesView → SongDetailView 이동 제공.
TabView
MainTabView에서 Songs / Favorites / Settings 탭 제공.
# 🔧 주요 제공 기능
🎵 Song CRUD
조회: SongViewModel.loadSongs()
추가: AddSongView → SongViewModel.addSong()
삭제: 스와이프 → deleteSong()
🎼 Score CRUD
조회: ScoreViewModel.loadScores()
추가: ScoreSectionView → addScore()
삭제: deleteScore()
⭐ Favorites
FavoriteManager(UserDefaults) 기반
SongDetailView에서 즐겨찾기 토글
FavoritesView에서 즐겨찾기 Song만 필터링
⚙ Settings
@AppStorage 기반 다크모드 저장/적용
앱 환경 제공
# 🚧 향후 제공 예정 기능
1. 악보 출력 페이지 확장
프렛보드 / 타임라인 그래픽 UI 제공 예정.
2. 마이크 입력 처리
AudioKit 또는 CoreAudio 기반 pitch 인식 제공 예정.
3. 악보 자동 진행
사용자 입력 MIDI 번호와 악보의 pitch_midi 비교 후
맞으면 다음 음표로 자동 진행 제공 예정.
