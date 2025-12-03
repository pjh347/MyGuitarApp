# 앱 목표 / 개요

Supabase에 저장된 곡/악보 메타 정보를 불러와서 보여주고,
사용자가 직접 곡 및 악보 메타를 추가/삭제,
기타 연습을 위한 앱

- 곡(Song) 목록 조회 / 추가 / 삭제
- 곡별 악보 메타(Score: 버전, 악기 등) 조회 / 추가 / 삭제
- 즐겨찾기(Favorites) 기능
- Settings 화면에서 앱 환경 일부 설정
- 향후 확장: 악보(Notes) 그래픽 출력, 마이크 입력을 통한 연주 인식 및 자동 진행

- 목표 예시
  
https://www.google.com/imgres?q=기타%20앱&imgurl=https%3A%2F%2Fplay-lh.googleusercontent.com%2FBsyYU7ruOVD35cj9S5MpFfci5JQgp7CrMW8uCLFvVL_PuZ5hRQxSyPGQpPR2m2sEa0o%3Dw526-h296-rw&imgrefurl=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.gismart.guitar%26hl%3Dko&docid=s-Cehy1fsIKxuM&tbnid=X_rG18XjwRuc1M&vet=12ahUKEwiIwMeR0aCRAxXYr1YBHUeFErYQM3oECCgQAA..i&w=526&h=296&hcb=2&ved=2ahUKEwiIwMeR0aCRAxXYr1YBHUeFErYQM3oECCgQAA

<img width="299" height="168" alt="image" src="https://github.com/user-attachments/assets/a8040997-9a3c-40cc-8f56-13b2d6fd58aa" />


## 프로젝트 구조

```
MyGuitarApp
├── App
│   ├── MyGuitarAppApp.swift     // @main, 앱 진입점
│   └── MainTabView.swift        // TabView (Songs / Favorites / Settings)
│
├── Core
│   ├── API
│   │   └── SongApiConfig.swift  // Supabase REST API URL & API Key
│   │
│   ├── Model
│   │   ├── Song.swift           // 곡 정보 모델
│   │   ├── Score.swift          // 악보 메타 정보 모델
│   │   └── Note.swift           // 음표 정보 모델 (샘플 읽기용)
│   │
│   └── Repository
│       ├── SongRepository.swift         // Song용 Repository 프로토콜
│       ├── SupabaseSongRepository.swift // Supabase Song 구현체
│       ├── ScoreRepository.swift        // Score용 Repository 프로토콜
│       └── SupabaseScoreRepository.swift// Supabase Score 구현체
│
└── Features
    ├── Songs
    │   ├── SongsRootView.swift   // Songs 탭의 메인 화면 (리스트 + 추가/삭제)
    │   ├── SongDetailView.swift  // 곡 상세 + Score 섹션 + 즐겨찾기 버튼
    │   ├── SongRowView.swift     // 곡 리스트의 카드 UI
    │   ├── ScoreSectionView.swift// 곡 상세 화면 내 Score 섹션 (목록 + 추가/삭제)
    │   ├── NoteListView.swift    // 선택된 Score의 음표 리스트 (샘플 노출용)
    │   ├── AddSongView.swift     // 새 곡 추가를 위한 입력 폼
    │   ├── SongViewModel.swift   // 곡 목록/추가/삭제 상태 관리
    │   └── ScoreViewModel.swift  // 특정 Song의 Score 목록/추가/삭제 관리
    │
    ├── Favorites
    │   ├── FavoriteManager.swift // UserDefaults 기반 즐겨찾기 관리 (ObservableObject)
    │   └── FavoritesView.swift   // 즐겨찾기 탭 화면 (즐겨찾기 Song만 리스트)
    │
    └── Settings
        └── SettingsView.swift    // 설정 탭 화면
```

## 플로우 차트

```
flowchart TD

%% ====== MAIN TAB STRUCTURE ======
A[MyGuitarAppApp (App Entry)] --> B[MainTabView]

B --> T1[Songs 탭]
B --> T2[Favorites 탭]
B --> T3[Settings 탭]


%% ===== SONGS TAB =====
T1 --> S1[SongsRootView<br/>곡 리스트 화면]

S1 -->|NavigationLink| S2[SongDetailView<br/>곡 상세 화면]

S1 -->|+ 버튼| S3[AddSongView<br/>곡 추가 입력 폼]

S1 -->|Delete (스와이프)| SR2[SongViewModel.deleteSong]
S1 -->|onAppear / refresh| SR1[SongViewModel.loadSongs]

%% AddSongView
S3 -->|저장 onSave| SR3[SongViewModel.addSong → Supabase POST]
S3 -->|저장 후| S1


%% ===== SONG DETAIL (SCORES) =====
S2 --> SS1[ScoreViewModel.loadScores<br/>→ Supabase GET]

S2 -->|악보 추가| SS2[ScoreSectionView - AddScore]
SS2 -->|버전/악기 입력| SS3[ScoreViewModel.addScore<br/>→ Supabase POST]

S2 -->|악보 삭제| SS4[ScoreViewModel.deleteScore<br/>→ Supabase DELETE]

%% ===== NOTES =====
S2 -->|Score 선택(향후)| N1[NoteListView<br/>샘플 음표 리스트]
N1 --> N2[Supabase GET /notes]

%% ===== FAVORITES TAB =====
T2 --> F1[FavoritesView<br/>즐겨찾기 목록]

F1 -->|onAppear| SR1F[SongViewModel.loadSongs + FavoriteManager.load]

S2 -->|⭐ 버튼| F2[FavoriteManager.toggle(songId)]
F2 --> F1

%% ===== SETTINGS TAB =====
T3 --> ST1[SettingsView<br/>다크모드 등 설정]

ST1 --> ST2[@AppStorage(dark_mode) 변경]
ST2 --> A


%% ===== SUPABASE =====
SR1 --> DB1[(Supabase<br/>songs)]
SR2 --> DB1
SR3 --> DB1

SS1 --> DB2[(Supabase<br/>scores)]
SS3 --> DB2
SS4 --> DB2

N2 --> DB3[(Supabase<br/>notes)]


%% VISUAL STYLE
classDef view fill:#1E90FF,stroke:#0b4b8c,stroke-width:1,color:#fff;
classDef model fill:#F39C12,stroke:#c27a0e,stroke-width:1,color:#fff;
classDef repo fill:#27AE60,stroke:#1c8044,stroke-width:1,color:#fff;
classDef db fill:#8e44ad,stroke:#5e2d7d,stroke-width:1,color:#fff;

class A,B,T1,T2,T3,S1,S2,S3,N1,F1 ST1 view;
class SR1,SR2,SR3,SR1F,SS1,SS2,SS3,SS4 model;
class DB1,DB2,DB3 db;
```

## 필수 제한 요소 / 주요 기능

> 필수 제한 요소 사용

- URLSession

SupabaseSongRepository, SupabaseScoreRepository, NoteListView 등에서
Supabase REST API 호출에 사용

- List
1. SongsRootView : 곡 리스트
2. FavoritesView : 즐겨찾기 리스트
3. SongDetailView : 곡 정보 + Score 목록
4. NoteListView : 샘플 악보 음표 목록

- NavigationStack / NavigationLink / navigationTitle

1. SongsRootView → SongDetailView 로 이동
2. FavoritesView → SongDetailView 로 이동
3. 각 화면 상단 제목에 .navigationTitle() 사용

- TabView

MainTabView 에서
1. SongsRootView (Songs 탭)
2. FavoritesView (즐겨찾기 탭)
3. SettingsView (설정 탭)

> 주요 기능

- Supabase 연동

songs, scores, notes 테이블과 REST API로 통신
곡/악보 메타 데이터 로드 및 반영

- Song CRUD

1. 목록 조회: SongViewModel.loadSongs()
2. 추가: AddSongView + SongViewModel.addSong(...)
3. 삭제: 리스트 스와이프 → SongViewModel.deleteSong(...)

- Score 메타 CRUD
1. 조회: ScoreViewModel.loadScores()
2. 추가: ScoreSectionView의 입력 폼 → ScoreViewModel.addScore(...)
3. 삭제: Score 리스트 스와이프 → ScoreViewModel.deleteScore(...)

- 즐겨찾기(Favorites)

1. FavoriteManager에서 UserDefaults로 즐겨찾기 Song ID 목록 관리
2. SongDetailView 우상단 ⭐ 버튼으로 토글
3. FavoritesView에서 즐겨찾기된 곡만 필터링해서 표시

- Settings

SettingsView에서 앱 정보 및 간단한 설정 관리
(원하면 다크모드, 색맹 모드 같은 옵션도 추가 가능)


## 향후 구현 예정 기능

1. 악보 출력 페이지

notes 테이블의 데이터를 기반으로
기타 프렛보드 / 타임라인 형태의 그래픽 악보 화면

2. 마이크 입력 처리

마이크로부터 현재 음(pitch)을 실시간 인식
MIDI 번호(pitch_midi) 로 변환

3. 마이크 입력과 악보 진행 연동

현재 재생해야 할 음표의 pitch_midi와 비교
사용자의 입력이 맞으면 다음 음표로 진행
틀리면 피드백 제공

