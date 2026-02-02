---
id: kidtastic-architecture
name: Kidtastic Architecture
description: "Architecture overview of the Kidtastic Flutter e-learning platform"
type: concept
domain: kidtastic
---

# Kidtastic Architecture Overview

**Platform**: Flutter E-Learning Game  
**Target Users**: Daycare students (ages 3-7)  
**Architecture**: Layered with BLoC pattern, offline-first  

---

## System Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                    │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Pages     │  │   Widgets   │  │   Views     │         │
│  │  (12 games) │  │ (reusable)  │  │ (screens)   │         │
│  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘         │
└─────────┼────────────────┼────────────────┼────────────────┘
          │                │                │
          └────────────────┴────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                      STATE MANAGEMENT                        │
│                    (BLoC Pattern)                            │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐        │
│  │  Events      │ │    BLoC      │ │    States    │        │
│  │  (Actions)   │→│ (Business    │→│  (UI Data)   │        │
│  │              │ │   Logic)     │ │              │        │
│  └──────────────┘ └──────────────┘ └──────────────┘        │
│                                                              │
│  BLoCs: Home, Login, Register, Dashboard,                   │
│         StudentList, StudentProfile,                        │
│         CountingGame, MatchGame, ShapeGame,                 │
│         PronunciationGame, ColorGame,                       │
│         Activities, GameList                                │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                      REPOSITORY LAYER                        │
│                   (Data Access Abstraction)                  │
│                                                              │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   Student   │ │   Teacher   │ │    Game     │           │
│  │ Repository  │ │ Repository  │ │ Repository  │           │
│  └──────┬──────┘ └──────┬──────┘ └──────┬──────┘           │
│         │               │               │                   │
│  ┌──────┴──────┐ ┌──────┴──────┐ ┌──────┴──────┐          │
│  │GameSession  │ │  Session    │ │Pronunciation│          │
│  │ Repository  │ │  Question   │ │   Attempt   │          │
│  │             │ │ Repository  │ │ Repository  │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
│                                                              │
│  Additional: GameQuestionRepository,                        │
│              StudentInsightRepository                       │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                         DAO LAYER                            │
│                    (Database Access)                         │
│                                                              │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │  StudentDao │ │  TeacherDao │ │   GameDao   │           │
│  └──────┬──────┘ └──────┬──────┘ └──────┬──────┘           │
│         │               │               │                   │
│  ┌──────┴──────┐ ┌──────┴──────┐ ┌──────┴──────┐          │
│  │ GameSession │ │   Session   │ │Pronunciation│          │
│  │    Dao      │ │  Question   │ │ AttemptDao  │          │
│  │             │ │    Dao      │ │             │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
│                                                              │
│  Additional: GameQuestionDao,                               │
│              StudentInsightDao                              │
└──────────────────────────┬──────────────────────────────────┘
                           │
┌──────────────────────────▼──────────────────────────────────┐
│                     DATABASE LAYER                           │
│                    (Drift ORM / SQLite)                      │
│                                                              │
│  Tables:                                                     │
│  • StudentTable      • TeacherTable      • GameTable        │
│  • GameSessionTable  • SessionQuestionTable                 │
│  • PronunciationAttemptTable                                │
│  • StudentInsightTable       • GameQuestionTable            │
│                                                              │
│  Features:                                                   │
│  • Offline-first storage                                     │
│  • Sync status tracking                                      │
│  • Auto-generated .g.dart files                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Key Architectural Patterns

### 1. BLoC (Business Logic Component)

**Purpose**: Separate business logic from UI  
**Implementation**: flutter_bloc + freezed

```dart
// Event (sealed class)
sealed class CountingGameEvent {}
class CountingGameStarted extends CountingGameEvent {}
class NumberTapped extends CountingGameEvent { final int number; }

// State (Freezed)
@freezed
class CountingGameState with _$CountingGameState {
  const factory CountingGameState.initial() = _Initial;
  const factory CountingGameState.playing({required List<int> numbers}) = _Playing;
  const factory CountingGameState.correct() = _Correct;
  const factory CountingGameState.completed() = _Completed;
}

// BLoC
class CountingGameBloc extends Bloc<CountingGameEvent, CountingGameState> {
  // Event handlers
}
```

**Benefits**:
- Testable business logic
- Predictable state changes
- Separation of concerns
- Reusable across platforms

### 2. Repository Pattern

**Purpose**: Abstract data access  
**Implementation**: Repository classes with DAO injection

```dart
class StudentRepository {
  final StudentDao _studentDao;
  
  Future<Result<List<Student>>> getStudents() async {
    try {
      final students = await _studentDao.getAllStudents();
      return Result(data: students, statusCode: 200);
    } catch (e) {
      return Result(statusCode: 400);
    }
  }
}
```

**Benefits**:
- Data source abstraction
- Easy to test with mocks
- Consistent error handling
- Swappable implementations

### 3. DAO (Data Access Object)

**Purpose**: Database operations  
**Implementation**: Drift ORM with @DriftAccessor

```dart
@DriftAccessor(tables: [StudentTable])
class StudentDao extends DatabaseAccessor<KidtasticDatabase> {
  Future<List<StudentTableData>> getAllStudents() {
    return select(studentTable).get();
  }
  
  Future<int> insertStudent(StudentTableCompanion student) {
    return into(studentTable).insert(student);
  }
}
```

**Benefits**:
- Type-safe SQL
- Auto-generated code
- Migration support
- Reactive queries (Streams)

### 4. Result Pattern

**Purpose**: Consistent error handling  
**Implementation**: Generic Result<T> class

```dart
class Result<T> {
  final T? data;
  final int statusCode;
  
  ResultStatus get resultStatus {
    switch (statusCode) {
      case 200: case 201: return ResultStatus.success;
      case 400: case 401: case 404: case 500: return ResultStatus.error;
      default: return ResultStatus.none;
    }
  }
}
```

**Benefits**:
- Explicit error handling
- Consistent API responses
- Type safety
- Easy to extend

---

## Data Flow

### Typical User Action Flow

```
1. User taps button
   ↓
2. UI dispatches Event to BLoC
   ↓
3. BLoC processes business logic
   ↓
4. BLoC calls Repository (if needed)
   ↓
5. Repository calls DAO
   ↓
6. DAO performs database operation
   ↓
7. Result flows back up the chain
   ↓
8. BLoC emits new State
   ↓
9. UI rebuilds with new State
```

### Example: Student Taps Number in Counting Game

```
User taps "3"
   ↓
UI: context.read<CountingGameBloc>().add(NumberTapped(3))
   ↓
BLoC: on<NumberTapped>(_onNumberTapped)
   ↓
BLoC: Check if 3 is correct
   ↓
BLoC: If correct → emit(CorrectState())
       If wrong → emit(TryAgainState())
   ↓
UI: Rebuilds with animation/sound feedback
```

---

## Domain Entities

### Core Domain

**Student**
- id, name, firstName, lastName
- gender, image
- isSynced, lastPlayedAt, createdAt

**Teacher**
- id, name, username, password (hashed)
- Authentication and management

**Game**
- id, name, description, type
- Configuration and metadata

**GameSession**
- id, studentId, gameId
- startTime, endTime, score, isCompleted

### Learning Data

**Question**
- id, gameId, prompt, answer
- difficulty, type, media (image/audio)

**SessionQuestion**
- id, sessionId, questionId
- studentAnswer, isCorrect, timeTaken

**PronunciationAttempt**
- id, studentId, word, audioPath
- accuracyScore, feedback

**StudentInsight**
- id, studentId, metricType, value
- timestamp, context

---

## Game Types

### 1. Counting Game
**Skills**: Number recognition, sequencing, counting  
**Mechanics**: Tap numbers in order, count objects  
**BLoC**: CountingGameBloc

### 2. Match Game
**Skills**: Memory, visual matching, concentration  
**Mechanics**: Flip cards, find pairs  
**BLoC**: MatchGameBloc

### 3. Pronunciation Game
**Skills**: Speech, phonics, listening  
**Mechanics**: Listen and repeat, speech recognition  
**BLoC**: PronunciationGameBloc  
**Special**: Uses SherpaWorker for offline speech recognition

### 4. Shape Game
**Skills**: Shape recognition, sorting, matching  
**Mechanics**: Identify shapes, drag to match  
**BLoC**: ShapeGameBloc

### 5. Color Game
**Skills**: Color identification, matching, naming  
**Mechanics**: Tap colors, match objects  
**BLoC**: ColorGameBloc

---

## Offline-First Architecture

### Sync Strategy
- **Local-first**: All data stored locally in SQLite
- **Sync when online**: Queue changes, sync when connected
- **Conflict resolution**: Last-write-wins or manual

### Sync Status Tracking
```dart
// Added to entities
BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
DateTimeColumn get syncedAt => dateTime().nullable()();
DateTimeColumn get modifiedAt => dateTime().clientDefault(() => DateTime.now())();
```

### Sync Queue
- Pending operations stored in queue
- Processed when connectivity available
- Retry with exponential backoff

---

## File Organization

```
lib/
├── main.dart                      # App entry point
├── app.dart                       # App widget
├── constants/                     # App constants
│   ├── assets.dart               # Image/audio paths
│   ├── audios.dart               # Audio file constants
│   ├── game_type.dart            # Game type enum
│   └── ...
├── models/                        # Data models (Freezed)
│   ├── student/
│   ├── teacher/
│   ├── game/
│   └── ...
├── pages/                         # Feature modules
│   ├── home/                     # Home dashboard
│   ├── login/                    # Teacher login
│   ├── student_list/             # Student management
│   ├── counting_game/            # Counting game
│   ├── match_game/               # Match game
│   └── ... (12 features)
├── repositories/                  # Data access
│   ├── student_repository.dart
│   ├── game_repository.dart
│   └── ...
├── daos/                          # Database access
│   ├── student_dao/
│   ├── game_dao/
│   └── ...
├── tables/                        # Drift table definitions
│   ├── student_table.dart
│   ├── game_table.dart
│   └── ...
├── database/                      # Database setup
│   ├── kidtastic_database.dart
│   └── seeder/                   # Database seeding
├── service/                       # Services
│   └── audio_service.dart        # Audio playback
├── workers/                       # Background workers
│   └── sherpa_worker.dart        # Speech recognition
├── utils/                         # Utilities
│   ├── calculate_similarity.dart
│   └── ...
└── widgets/                       # Reusable widgets
    ├── game/                     # Game-specific widgets
    └── ...
```

---

## Technology Stack

### Core
- **Flutter**: UI framework
- **Dart**: Programming language
- **BLoC**: State management

### Database
- **Drift**: ORM for SQLite
- **SQLite**: Local database

### Code Generation
- **Freezed**: Immutable classes
- **json_serializable**: JSON parsing
- **drift_dev**: Database code generation

### Audio
- **flutter_tts**: Text-to-speech
- **AudioService**: Custom audio service
- **Sherpa**: Offline speech recognition

### State Management
- **flutter_bloc**: BLoC pattern
- **provider**: Dependency injection

### UI
- **Material Design**: Base design system
- **Custom widgets**: Kid-friendly components

---

## Key Design Principles

### 1. Child-Friendly
- Large touch targets (48x48dp minimum)
- Bright, high-contrast colors
- Simple, clear visuals
- Audio feedback for all actions
- No text-heavy instructions

### 2. Offline-First
- Works completely without internet
- Local data persistence
- Sync when online
- Graceful degradation

### 3. Educational
- Clear learning objectives
- Progressive difficulty
- Immediate feedback
- Positive reinforcement
- Progress tracking

### 4. Maintainable
- Consistent patterns
- Clear separation of concerns
- Testable code
- Documentation
- Type safety

---

## Performance Considerations

### Optimizations
- Use `const` constructors
- Minimize widget rebuilds
- Lazy load game data
- Cache images and audio
- Use database indexes

### Targets
- 60fps animations
- < 2 second load times
- Smooth transitions
- Responsive UI

---

## Security & Privacy

### Data Protection
- Local-only storage (no cloud required)
- Hashed passwords (bcrypt)
- No PII collection
- Secure audio storage

### Child Safety
- COPPA compliant
- No external ads
- No in-app purchases
- Offline operation

---

## Related Documentation

- **Pattern Analysis**: `../project/kidtastic-pattern-analysis.md`
- **BLoC Standards**: `../guides/bloc-standards.md`
- **Game Patterns**: `../guides/game-patterns.md`
- **UI Standards**: `../guides/ui-standards.md`

---

*Last Updated: 2026-02-02*
