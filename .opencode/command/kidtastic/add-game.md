---
id: add-game
name: add-game
description: "Create a new educational game scaffold for Kidtastic with BLoC, UI, and repository components"
type: command
category: development
domain: kidtastic
version: 1.0.0
---

# Command: /add-game

## Description

Create a complete educational game scaffold for the Kidtastic platform. Generates all necessary files following Kidtastic architectural patterns: BLoC state management, child-friendly UI, repository layer, and database integration.

## Usage

```bash
/add-game --name=<name> --type=<type> [--difficulty=<level>] [--skills=<skills>]
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `--name` | string | Yes | Game name (e.g., "Number Fun", "Shape Match") |
| `--type` | string | Yes | Game type: counting, matching, pronunciation, shapes, colors, memory, puzzle |
| `--difficulty` | string | No | Default difficulty: easy, medium, hard (default: medium) |
| `--skills` | string | No | Comma-separated skills (e.g., "counting,sequencing,recognition") |
| `--target-age` | string | No | Target age range: 3-4, 5-6, 6-7 (default: 5-6) |

## Examples

### Create a counting game
```bash
/add-game --name="Number Adventure" --type=counting --skills="counting,sequencing" --target-age=5-6
```

### Create a shape matching game
```bash
/add-game --name="Shape Detective" --type=matching --difficulty=easy --skills="shape-recognition,matching"
```

### Create a pronunciation game
```bash
/add-game --name="Word Wizard" --type=pronunciation --target-age=6-7 --skills="pronunciation,vocabulary"
```

## Behavior

### Game Generation Process
1. **Validate** - Check parameters and existing games
2. **Design** - Create game specification based on type
3. **Generate BLoC** - Events, states, and BLoC class
4. **Generate UI** - Page, body, and game widgets
5. **Generate Repository** - If data persistence needed
6. **Generate DAO** - Database access (if needed)
7. **Update Navigation** - Add to game list
8. **Validate** - Check generated code

### Generated Files

#### BLoC Layer
```
lib/pages/{game_name}/
├── bloc/
│   ├── {game_name}_bloc.dart      # Game logic and state management
│   ├── {game_name}_event.dart     # Game events
│   └── state/
│       └── {game_name}_state.dart # Game states (Freezed)
```

#### UI Layer
```
lib/pages/{game_name}/
├── view/
│   ├── {game_name}_page.dart      # Main page widget
│   ├── {game_name}_body.dart      # Page body content
│   └── view.dart                  # Barrel export
└── widgets/
    ├── game_board.dart            # Main game board
    ├── game_item.dart             # Interactive game items
    └── widgets.dart               # Barrel export
```

#### Data Layer (if needed)
```
lib/repositories/
├── {game_name}_repository.dart    # Data access (optional)

lib/daos/
├── {game_name}_dao/
│   └── {game_name}_dao.dart       # Database access (optional)
```

### Game Types

#### Counting Game
**Skills**: Number recognition, counting, sequencing  
**Mechanics**: Tap numbers in order, count objects  
**States**: initial, playing, correct, incorrect, completed  
**Example**: Tap 1, 2, 3... in sequence

#### Matching Game
**Skills**: Memory, visual matching, concentration  
**Mechanics**: Flip cards, find matching pairs  
**States**: initial, playing, flipped, matched, completed  
**Example**: Memory card matching

#### Pronunciation Game
**Skills**: Speech, phonics, listening  
**Mechanics**: Listen, repeat, get feedback  
**States**: initial, listening, recording, analyzing, feedback  
**Example**: Repeat words, get pronunciation score

#### Shapes Game
**Skills**: Shape recognition, sorting  
**Mechanics**: Identify shapes, drag to match  
**States**: initial, playing, correct, incorrect, completed  
**Example**: Drag circle to circle outline

#### Colors Game
**Skills**: Color identification, matching  
**Mechanics**: Tap colors, match objects  
**States**: initial, playing, correct, incorrect, completed  
**Example**: Match red apple to red color

## Implementation

### Delegation
- **Primary**: Delegates to `@kidtastic-game-developer` agent
- **Secondary**: Uses `@kidtastic-elearning-specialist` for educational design
- **Tertiary**: Consults existing game implementations for patterns

### Context Requirements
- Kidtastic BLoC standards
- Game pattern templates
- UI/UX standards for children
- Repository patterns

### Processing Steps
1. Parse and validate parameters
2. Load game type template
3. Generate BLoC (events, states, bloc)
4. Generate UI components
5. Generate data layer (if needed)
6. Create barrel exports
7. Update game list
8. Validate generated code
9. Present results

## Game Templates

### BLoC Template
```dart
// {game_name}_bloc.dart
class {GameName}Bloc extends Bloc<{GameName}Event, {GameName}State> {
  final AudioService _audioService = AudioService.instance;
  
  {GameName}Bloc() : super(const {GameName}State.initial()) {
    on<{GameName}Started>(_onStarted);
    on<{GameName}ItemTapped>(_onItemTapped);
  }
  
  Future<void> _onStarted(
    {GameName}Started event,
    Emitter<{GameName}State> emit,
  ) async {
    emit(const {GameName}State.loading());
    // Initialize game...
    emit({GameName}State.playing(...));
  }
}
```

### State Template
```dart
// {game_name}_state.dart
@freezed
sealed class {GameName}State with _${GameName}State {
  const factory {GameName}State.initial() = _Initial;
  const factory {GameName}State.loading() = _Loading;
  const factory {GameName}State.playing({...}) = _Playing;
  const factory {GameName}State.correct({...}) = _Correct;
  const factory {GameName}State.incorrect({...}) = _Incorrect;
  const factory {GameName}State.completed({...}) = _Completed;
  const factory {GameName}State.error({required String message}) = _Error;
}
```

### UI Template
```dart
// {game_name}_page.dart
class {GameName}Page extends StatelessWidget {
  const {GameName}Page({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => {GameName}Bloc(),
      child: const {GameName}View(),
    );
  }
}
```

## Output

### Success Response
```
✅ Game "{name}" created successfully!

📁 Generated Files:
  • BLoC: lib/pages/{name}/bloc/ (3 files)
  • UI: lib/pages/{name}/view/ (3 files)
  • Widgets: lib/pages/{name}/widgets/ (2 files)
  • Repository: lib/repositories/{name}_repository.dart (optional)
  • DAO: lib/daos/{name}_dao/ (optional)

🎮 Game Configuration:
  • Type: {type}
  • Difficulty: {difficulty}
  • Target Age: {target_age}
  • Skills: {skills}

📝 Next Steps:
  1. Customize game logic in {name}_bloc.dart
  2. Design game board in game_board.dart
  3. Add game content (questions, items)
  4. Test with flutter run
  5. Add to game list in database
```

### Validation
- Check game name is unique
- Verify game type is supported
- Ensure no file conflicts
- Validate generated code compiles

## Integration

### Registry Entry
```json
{
  "id": "add-game",
  "name": "add-game",
  "type": "command",
  "category": "development",
  "domain": "kidtastic",
  "description": "Create new educational game scaffold",
  "delegates_to": ["kidtastic-game-developer"],
  "parameters": ["name", "type", "difficulty", "skills", "target-age"]
}
```

### Profile Assignment
- **Developer Profile**: ✅ Included
- **Full Profile**: ✅ Included
- **Kidtastic Profile**: ✅ Primary command

## Notes

- Follows Kidtastic BLoC standards
- Generates child-friendly UI by default
- Includes audio feedback integration
- Creates offline-first architecture
- Supports all existing game types
- Extensible for custom game types

## Related Commands

- `/analyze-kidtastic` - Analyze existing games
- `/sync-offline` - Configure offline sync for game data

## Validation Checklist

✅ Command structure defined  
✅ Parameters documented  
✅ Game types specified  
✅ File generation documented  
✅ Examples provided  
✅ Integration ready  
✅ Kidtastic-specific logic included  

**Status**: Ready for deployment
