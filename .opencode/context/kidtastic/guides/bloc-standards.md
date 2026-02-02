---
id: kidtastic-bloc-standards
name: Kidtastic BLoC Standards
description: "Standards and best practices for BLoC implementation in Kidtastic"
type: guide
domain: kidtastic
---

# Kidtastic BLoC Standards

**Pattern**: BLoC (Business Logic Component)  
**Library**: flutter_bloc  
**State Management**: Freezed for immutable states  

---

## BLoC Structure

### File Organization

```
lib/pages/{feature}/bloc/
├── {feature}_bloc.dart          # BLoC class with event handlers
├── {feature}_event.dart         # Event definitions (sealed class)
└── state/
    └── {feature}_state.dart     # State definitions (Freezed)
```

### Naming Conventions

| Component | Naming Pattern | Example |
|-----------|---------------|---------|
| BLoC | `{Feature}Bloc` | `CountingGameBloc` |
| Event File | `{feature}_event.dart` | `counting_game_event.dart` |
| State File | `{feature}_state.dart` | `counting_game_state.dart` |
| Events | `{Action}Event` or `{Feature}{Action}Event` | `NumberTapped`, `CountingGameStarted` |
| States | `{Feature}State` with variants | `CountingGameState.initial()` |

---

## Event Standards

### Use Sealed Classes

```dart
// counting_game_event.dart

sealed class CountingGameEvent {
  const CountingGameEvent();
}

// Lifecycle events
class CountingGameStarted extends CountingGameEvent {
  const CountingGameStarted();
}

class CountingGamePaused extends CountingGameEvent {
  const CountingGamePaused();
}

// User interaction events
class NumberTapped extends CountingGameEvent {
  final int number;
  const NumberTapped(this.number);
}

class CountingGameSubmitted extends CountingGameEvent {
  final List<int> sequence;
  const CountingGameSubmitted(this.sequence);
}

// System events
class CountingGameTimerTicked extends CountingGameEvent {
  final int remainingSeconds;
  const CountingGameTimerTicked(this.remainingSeconds);
}
```

### Event Guidelines

✅ **DO**:
- Use sealed classes for type safety
- Keep events immutable (const constructors)
- Name events as past tense actions
- Include all necessary data in event
- Group related events logically

❌ **DON'T**:
- Use dynamic or generic events
- Pass BuildContext to events
- Include business logic in events
- Create events for UI-only changes

---

## State Standards

### Use Freezed

```dart
// counting_game_state.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'counting_game_state.freezed.dart';

@freezed
sealed class CountingGameState with _$CountingGameState {
  const factory CountingGameState.initial() = CountingGameInitial;
  
  const factory CountingGameState.loading() = CountingGameLoading;
  
  const factory CountingGameState.playing({
    required List<int> numbers,
    required List<int> tappedNumbers,
    required int currentTarget,
    @Default(0) int score,
  }) = CountingGamePlaying;
  
  const factory CountingGameState.correct({
    required int pointsEarned,
    required int newScore,
  }) = CountingGameCorrect;
  
  const factory CountingGameState.incorrect({
    required int correctAnswer,
    required String feedback,
  }) = CountingGameIncorrect;
  
  const factory CountingGameState.completed({
    required int finalScore,
    required int starsEarned,
    required Duration timeTaken,
  }) = CountingGameCompleted;
  
  const factory CountingGameState.error({
    required String message,
  }) = CountingGameError;
}
```

### State Guidelines

✅ **DO**:
- Use Freezed for immutability
- Create specific states for each UI scenario
- Include all data needed for UI rendering
- Use @Default for optional fields
- Keep states pure (no side effects)

❌ **DON'T**:
- Use mutable state classes
- Include methods in state classes
- Mix UI logic with state
- Create overly generic states

---

## BLoC Implementation

### Basic Structure

```dart
// counting_game_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kidtastic_flutter/service/services.dart';

import 'counting_game_event.dart';
import 'state/counting_game_state.dart';

class CountingGameBloc extends Bloc<CountingGameEvent, CountingGameState> {
  final AudioService _audioService = AudioService.instance;
  
  CountingGameBloc() : super(const CountingGameState.initial()) {
    // Register event handlers
    on<CountingGameStarted>(_onStarted);
    on<NumberTapped>(_onNumberTapped);
    on<CountingGameSubmitted>(_onSubmitted);
  }
  
  // Event handler methods
  Future<void> _onStarted(
    CountingGameStarted event,
    Emitter<CountingGameState> emit,
  ) async {
    emit(const CountingGameState.loading());
    
    try {
      // Initialize game data
      final numbers = List.generate(10, (i) => i + 1)..shuffle();
      
      emit(CountingGameState.playing(
        numbers: numbers,
        tappedNumbers: [],
        currentTarget: 1,
        score: 0,
      ));
      
      // Play start sound
      await _audioService.playSfx(Audios.gameStartWav);
    } catch (e) {
      emit(CountingGameState.error(message: 'Failed to start game'));
    }
  }
  
  Future<void> _onNumberTapped(
    NumberTapped event,
    Emitter<CountingGameState> emit,
  ) async {
    final currentState = state;
    
    // Only handle if in playing state
    if (currentState is! CountingGamePlaying) return;
    
    final isCorrect = event.number == currentState.currentTarget;
    
    if (isCorrect) {
      // Update state
      final newTappedNumbers = [...currentState.tappedNumbers, event.number];
      final newScore = currentState.score + 10;
      
      // Check if game completed
      if (newTappedNumbers.length == currentState.numbers.length) {
        emit(CountingGameState.completed(
          finalScore: newScore,
          starsEarned: _calculateStars(newScore),
          timeTaken: Duration.zero, // Track actual time
        ));
        await _audioService.playSfx(Audios.successWav);
      } else {
        emit(currentState.copyWith(
          tappedNumbers: newTappedNumbers,
          currentTarget: currentState.currentTarget + 1,
          score: newScore,
        ));
        await _audioService.playSfx(Audios.correctWav);
      }
    } else {
      emit(CountingGameState.incorrect(
        correctAnswer: currentState.currentTarget,
        feedback: 'Try again! Look for number ${currentState.currentTarget}',
      ));
      await _audioService.playSfx(Audios.incorrectWav);
      
      // Return to playing state after delay
      await Future.delayed(const Duration(seconds: 2));
      emit(currentState);
    }
  }
  
  Future<void> _onSubmitted(
    CountingGameSubmitted event,
    Emitter<CountingGameState> emit,
  ) async {
    // Handle submission logic
  }
  
  int _calculateStars(int score) {
    if (score >= 90) return 3;
    if (score >= 60) return 2;
    return 1;
  }
}
```

### BLoC Guidelines

✅ **DO**:
- Extend `Bloc<Event, State>`
- Use `on<Event>()` to register handlers
- Keep event handlers private (`_onEventName`)
- Check current state type before processing
- Use `emit()` to emit new states
- Handle errors with try-catch
- Play audio feedback via AudioService
- Keep business logic in BLoC (not UI)

❌ **DON'T**:
- Emit multiple states rapidly
- Perform long operations without loading state
- Access UI elements (BuildContext)
- Use setState or direct state mutation
- Ignore errors (always emit error state)

---

## Common State Patterns

### Loading Pattern

```dart
// Always show loading before async operations
Future<void> _onLoadData(
  LoadDataEvent event,
  Emitter<MyState> emit,
) async {
  emit(const MyState.loading()); // Show loading UI
  
  try {
    final data = await repository.fetchData();
    emit(MyState.loaded(data: data));
  } catch (e) {
    emit(MyState.error(message: e.toString()));
  }
}
```

### Form Validation Pattern

```dart
@freezed
class FormState with _$FormState {
  const factory FormState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isValid,
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _FormState;
}

// In BLoC
void _onEmailChanged(EmailChanged event, Emitter<FormState> emit) {
  emit(state.copyWith(
    email: event.email,
    isValid: _validateForm(event.email, state.password),
  ));
}
```

### Game State Pattern

```dart
@freezed
class GameState with _$GameState {
  const factory GameState.initial() = GameInitial;
  const factory GameState.loading() = GameLoading;
  const factory GameState.playing({
    required GameData data,
    required int score,
    required int level,
  }) = GamePlaying;
  const factory GameState.paused() = GamePaused;
  const factory GameState.correct({required int points}) = GameCorrect;
  const factory GameState.incorrect({required String feedback}) = GameIncorrect;
  const factory GameState.completed({required int finalScore}) = GameCompleted;
  const factory GameState.error({required String message}) = GameError;
}
```

---

## BLoC Provider Setup

### Main.dart Setup

```dart
// Provide BLoC at appropriate level
MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (context) => HomeBloc(),
    ),
    BlocProvider(
      create: (context) => StudentListBloc(
        studentRepository: context.read<StudentRepository>(),
      ),
    ),
  ],
  child: MyApp(),
)
```

### Page-Level Setup

```dart
// For feature-specific BLoCs
BlocProvider(
  create: (context) => CountingGameBloc(),
  child: CountingGamePage(),
)
```

### Accessing BLoC

```dart
// Read (don't listen)
final bloc = context.read<CountingGameBloc>();

// Watch (listen to state changes)
final state = context.watch<CountingGameBloc>().state;

// Select (listen to specific part of state)
final score = context.select<CountingGameBloc, int>((bloc) => bloc.state.score);
```

---

## UI Integration

### BlocBuilder

```dart
BlocBuilder<CountingGameBloc, CountingGameState>(
  builder: (context, state) {
    return state.map(
      initial: (_) => const LoadingWidget(),
      loading: (_) => const LoadingWidget(),
      playing: (state) => GameBoard(
        numbers: state.numbers,
        onNumberTap: (number) {
          context.read<CountingGameBloc>().add(NumberTapped(number));
        },
      ),
      correct: (state) => CorrectAnswerAnimation(points: state.pointsEarned),
      incorrect: (state) => IncorrectAnswerFeedback(
        feedback: state.feedback,
      ),
      completed: (state) => GameCompletedDialog(
        score: state.finalScore,
        stars: state.starsEarned,
      ),
      error: (state) => ErrorWidget(message: state.message),
    );
  },
)
```

### BlocListener

```dart
BlocListener<CountingGameBloc, CountingGameState>(
  listenWhen: (previous, current) => 
    current is CountingGameCompleted,
  listener: (context, state) {
    // Save progress to repository
    context.read<GameSessionRepository>().saveSession(
      studentId: studentId,
      gameId: gameId,
      score: (state as CountingGameCompleted).finalScore,
    );
  },
  child: GameWidget(),
)
```

### BlocConsumer (Builder + Listener)

```dart
BlocConsumer<CountingGameBloc, CountingGameState>(
  listenWhen: (previous, current) => 
    current is CountingGameCorrect || current is CountingGameIncorrect,
  listener: (context, state) {
    // Handle side effects
    if (state is CountingGameCorrect) {
      context.read<AudioService>().playSfx(Audios.correctWav);
    }
  },
  builder: (context, state) {
    // Build UI
    return state.map(...);
  },
)
```

---

## Testing BLoCs

### Unit Test Example

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountingGameBloc', () {
    late CountingGameBloc bloc;
    
    setUp(() {
      bloc = CountingGameBloc();
    });
    
    tearDown(() {
      bloc.close();
    });
    
    test('initial state is initial', () {
      expect(bloc.state, const CountingGameState.initial());
    });
    
    blocTest<CountingGameBloc, CountingGameState>(
      'emits [loading, playing] when started',
      build: () => CountingGameBloc(),
      act: (bloc) => bloc.add(const CountingGameStarted()),
      expect: () => [
        const CountingGameState.loading(),
        isA<CountingGamePlaying>(),
      ],
    );
    
    blocTest<CountingGameBloc, CountingGameState>(
      'emits correct state when right number tapped',
      build: () => CountingGameBloc(),
      seed: () => const CountingGameState.playing(
        numbers: [1, 2, 3],
        tappedNumbers: [],
        currentTarget: 1,
        score: 0,
      ),
      act: (bloc) => bloc.add(const NumberTapped(1)),
      expect: () => [
        isA<CountingGamePlaying>().having(
          (s) => s.currentTarget, 'target', 2,
        ),
      ],
    );
  });
}
```

---

## Best Practices

### 1. Keep BLoCs Focused
- One BLoC per feature
- Single responsibility
- Don't share BLoCs across unrelated features

### 2. State Immutability
- Always create new state instances
- Use copyWith for updates
- Never mutate existing state

### 3. Error Handling
- Always catch exceptions
- Emit error states
- Provide meaningful error messages
- Recover gracefully

### 4. Performance
- Use const constructors
- Minimize state objects
- Use Equatable (built into Freezed)
- Debounce rapid events if needed

### 5. Testing
- Test all event handlers
- Test state transitions
- Mock dependencies
- Test error scenarios

---

## Common Mistakes

### ❌ Emitting Multiple States Rapidly

```dart
// BAD
emit(State.loading());
emit(State.loaded(data));
emit(State.success());

// GOOD - Combine into single state
emit(State.loaded(data: data, isSuccess: true));
```

### ❌ Checking State by Equality

```dart
// BAD
if (state == LoadingState()) { ... }

// GOOD
if (state is LoadingState) { ... }
```

### ❌ Passing BuildContext to BLoC

```dart
// BAD
class MyBloc extends Bloc {
  final BuildContext context; // DON'T DO THIS
}

// GOOD - Use dependency injection
class MyBloc extends Bloc {
  final Repository repository;
  MyBloc({required this.repository});
}
```

### ❌ Business Logic in UI

```dart
// BAD - In Widget
onPressed: () {
  if (isValid) {
    bloc.add(SubmitEvent());
  }
}

// GOOD - In BLoC
onPressed: () => bloc.add(SubmitEvent()),

// BLoC handles validation
void _onSubmit(SubmitEvent event, Emitter emit) {
  if (!_isValid()) {
    emit(State.error('Invalid input'));
    return;
  }
  // Process...
}
```

---

## Migration Guide

### Converting to Freezed

1. Add dependencies:
```yaml
dependencies:
  freezed_annotation: ^2.4.1
  
dev_dependencies:
  freezed: ^2.4.5
  build_runner: ^2.4.7
```

2. Run code generation:
```bash
flutter pub run build_runner build
```

3. Update imports and part statements

---

## Related Documentation

- **Architecture**: `../concepts/architecture.md`
- **Game Patterns**: `game-patterns.md`
- **UI Standards**: `ui-standards.md`
- **Pattern Analysis**: `../../project/kidtastic-pattern-analysis.md`

---

*Last Updated: 2026-02-02*
