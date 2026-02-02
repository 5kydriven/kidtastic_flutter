---
id: kidtastic-navigation
name: Kidtastic Context Navigation
description: "Navigation guide for Kidtastic-specific context files and agents"
type: navigation
domain: kidtastic
---

# Kidtastic Context System

**Domain**: Kidtastic E-Learning Platform  
**Purpose**: Educational offline games for daycare students (ages 3-7)  
**Tech Stack**: Flutter, BLoC, Drift ORM, Freezed

---

## Quick Reference

### Kidtastic Agents
- **@kidtastic-game-developer** - Flutter game development specialist
- **@kidtastic-elearning-specialist** - Educational content and analytics
- **@kidtastic-offline-sync** - Offline-first architecture specialist

### Custom Commands
- `/analyze-kidtastic` - Analyze Kidtastic codebase patterns
- `/add-game` - Create new educational game scaffold
- `/sync-offline` - Manage offline synchronization

### Key Context Files
- **Architecture**: `concepts/architecture.md`
- **BLoC Standards**: `guides/bloc-standards.md`
- **Game Patterns**: `guides/game-patterns.md`
- **UI Standards**: `guides/ui-standards.md`
- **Pattern Analysis**: `../project/kidtastic-pattern-analysis.md`

---

## Context Structure

```
context/kidtastic/
├── navigation.md                    # This file
├── concepts/                        # What it is
│   ├── architecture.md             # System architecture
│   ├── entities.md                 # Domain entities
│   └── game-types.md               # Educational game types
├── guides/                          # How to do it
│   ├── bloc-standards.md           # BLoC implementation guide
│   ├── game-patterns.md            # Game development patterns
│   ├── ui-standards.md             # UI/UX standards
│   └── repository-patterns.md      # Repository best practices
├── examples/                        # Working code
│   ├── bloc-example.md             # Complete BLoC example
│   ├── game-example.md             # Complete game example
│   └── repository-example.md       # Repository example
├── lookup/                          # Quick reference
│   ├── file-locations.md           # Where to find files
│   ├── naming-conventions.md       # Naming standards
│   └── status-codes.md             # Result status codes
└── errors/                          # Common issues
    ├── bloc-issues.md              # BLoC troubleshooting
    ├── sync-issues.md              # Offline sync issues
    └── game-issues.md              # Game development issues
```

---

## Getting Started

### New to Kidtastic?
1. Read **Architecture Overview** (`concepts/architecture.md`)
2. Review **Pattern Analysis** (`../project/kidtastic-pattern-analysis.md`)
3. Check **BLoC Standards** (`guides/bloc-standards.md`)
4. See **Game Patterns** (`guides/game-patterns.md`)

### Adding a New Game?
1. Use `/add-game` command
2. Reference **Game Patterns** guide
3. Follow **BLoC Standards**
4. Check **UI Standards** for child-friendly design

### Working on Offline Sync?
1. Read **Offline Sync Agent** documentation
2. Check **Sync Issues** troubleshooting
3. Review existing sync implementations

---

## Domain Overview

### Core Entities
- **Student** - Daycare students using the app
- **Teacher** - Educators managing content
- **Game** - Educational game definitions
- **GameSession** - Student gameplay sessions
- **Question** - Game questions and prompts
- **StudentInsight** - Learning analytics

### Game Types
1. **Counting Game** - Number recognition and counting
2. **Match Game** - Memory and matching
3. **Pronunciation Game** - Speech practice
4. **Shape Game** - Shape recognition
5. **Color Game** - Color identification

### Architecture Layers
```
UI Layer (Pages, Widgets)
    ↓
BLoC Layer (12 BLoCs)
    ↓
Repository Layer (8 Repositories)
    ↓
DAO Layer (8 DAOs)
    ↓
Database Layer (Drift ORM)
```

---

## Standards & Conventions

### Naming Conventions
- **BLoCs**: `{Feature}Bloc` (e.g., `CountingGameBloc`)
- **Events**: `{Feature}{Action}Event` (e.g., `CountingGameStarted`)
- **States**: `{Feature}State` (e.g., `CountingGameState`)
- **Repositories**: `{Entity}Repository` (e.g., `StudentRepository`)
- **DAOs**: `{Entity}Dao` (e.g., `StudentDao`)

### File Organization
```
lib/pages/{feature}/
├── bloc/
│   ├── {feature}_bloc.dart
│   ├── {feature}_event.dart
│   └── state/
│       └── {feature}_state.dart
├── view/
│   ├── {feature}_page.dart
│   ├── {feature}_body.dart
│   └── view.dart
└── widgets/
    └── {widgets}.dart
```

### Code Patterns
- Use **Freezed** for immutable states
- Use **sealed classes** for events
- Use **Result pattern** for error handling
- Use **AudioService** for audio
- Use **Drift** for database

---

## Common Tasks

### Create New BLoC
```bash
# Use Game Developer Agent
@kidtastic-game-developer
Create BLoC for {feature} with states: loading, loaded, error
```

### Add New Game
```bash
# Use custom command
/add-game --type=counting --name="Number Fun"
```

### Analyze Patterns
```bash
# Use custom command
/analyze-kidtastic --pattern=bloc
```

### Fix Sync Issues
```bash
# Use Offline Sync Agent
@kidtastic-offline-sync
Fix sync queue processing for student data
```

---

## Resources

### Documentation
- [Flutter BLoC Pattern](https://bloclibrary.dev/)
- [Drift ORM Documentation](https://drift.simonbinder.eu/)
- [Freezed Package](https://pub.dev/packages/freezed)

### Kidtastic-Specific
- **Pattern Analysis**: See `../project/kidtastic-pattern-analysis.md`
- **Architecture**: See `concepts/architecture.md`
- **Standards**: See `guides/` directory

### Support
- Check **Errors** section for troubleshooting
- Review **Examples** for working code
- Use **Lookup** for quick reference

---

*Last Updated: 2026-02-02*
