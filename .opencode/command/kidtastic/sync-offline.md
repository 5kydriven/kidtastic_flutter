---
id: sync-offline
name: sync-offline
description: "Manage offline synchronization, sync queue, and conflict resolution for Kidtastic"
type: command
category: development
domain: kidtastic
version: 1.0.0
---

# Command: /sync-offline

## Description

Manage offline-first synchronization for the Kidtastic platform. View sync queue status, resolve conflicts, force synchronization, and configure sync settings. Essential for maintaining data integrity in offline environments.

## Usage

```bash
/sync-offline [--action=<action>] [--entity=<entity>] [--status=<status>]
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `--action` | string | No | Action: status, sync, resolve, clear, config (default: status) |
| `--entity` | string | No | Filter by entity: student, teacher, game, session, insight, all |
| `--status` | string | No | Filter by status: pending, syncing, synced, error, conflict |
| `--force` | flag | No | Force action even if warnings |

## Examples

### Check sync status
```bash
/sync-offline --action=status
```

### Force sync all pending items
```bash
/sync-offline --action=sync --entity=all
```

### View conflicts
```bash
/sync-offline --action=status --status=conflict
```

### Resolve all conflicts (server wins)
```bash
/sync-offline --action=resolve --status=conflict --strategy=server-wins
```

### Clear error queue
```bash
/sync-offline --action=clear --status=error --force
```

### Configure sync settings
```bash
/sync-offline --action=config --auto-sync=true --frequency=15min
```

## Actions

### status
Display current sync status overview.

**Output**:
```
Sync Status Overview
====================

Pending Items: 23
  • Student: 5
  • GameSession: 12
  • StudentInsight: 6

Syncing: 3
  • GameSession: 3

Synced (today): 156

Errors: 2
  • Student: 1 (Network timeout)
  • GameSession: 1 (Server error)

Conflicts: 1
  • StudentInsight: 1 (data mismatch)

Last Sync: 2026-02-02 14:30:15
Connectivity: Online ✅
Auto-Sync: Enabled (every 15 min)
```

### sync
Process sync queue manually.

**Options**:
- `--entity=all` - Sync all entities
- `--entity=student` - Sync only student data
- `--batch-size=50` - Process in batches

**Output**:
```
Starting Sync...
===============

Processing 23 pending items...
[████████████████████] 100%

Results:
  ✅ Synced: 21
  ❌ Errors: 2
  ⚠️  Conflicts: 0

Next sync scheduled: 2026-02-02 14:45:00
```

### resolve
Resolve sync conflicts.

**Strategies**:
- `server-wins` - Keep server version
- `client-wins` - Keep local version
- `last-write-wins` - Most recent wins
- `merge` - Combine non-conflicting fields
- `manual` - Flag for manual review

**Output**:
```
Resolving Conflicts...
=====================

Found 3 conflicts:
  1. StudentInsight #123 - Resolved (server-wins)
  2. GameSession #45 - Resolved (merge)
  3. Student #8 - Needs manual review

Resolution complete: 2/3 resolved
```

### clear
Clear sync queue items.

**⚠️ Warning**: Destructive operation

**Options**:
- `--status=error` - Clear only error items
- `--older-than=7d` - Clear items older than 7 days
- `--force` - Skip confirmation

### config
Configure sync settings.

**Settings**:
- `auto-sync` - Enable/disable automatic sync
- `frequency` - Sync interval (5min, 15min, 30min, 1hour)
- `batch-size` - Items per sync batch (10-100)
- `retry-attempts` - Max retry attempts (1-10)
- `conflict-strategy` - Default resolution strategy

**Output**:
```
Sync Configuration
==================

Current Settings:
  Auto-Sync: ✅ Enabled
  Frequency: 15 minutes
  Batch Size: 50 items
  Retry Attempts: 3
  Conflict Strategy: last-write-wins

Updated: 2026-02-02 14:30:00
```

## Implementation

### Delegation
- **Primary**: Delegates to `@kidtastic-offline-sync` agent
- **Secondary**: Uses existing SyncService in codebase
- **Tertiary**: Interacts with Drift database directly

### Context Requirements
- Kidtastic offline sync architecture
- Sync queue schema
- Conflict resolution strategies
- Database access patterns

### Processing Steps
1. Parse action and parameters
2. Load sync configuration
3. Connect to database
4. Execute requested action
5. Format and display results
6. Log operation

## Sync Queue Schema

### Database Tables
```dart
// Sync queue table
class SyncQueueTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()(); // 'student', 'game_session', etc.
  IntColumn get entityId => integer()();
  TextColumn get operation => text()(); // 'create', 'update', 'delete'
  TextColumn get data => text()(); // JSON payload
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get lastError => text().nullable()();
}

// Sync log table
class SyncLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  IntColumn get entityId => integer()();
  TextColumn get operation => text()();
  TextColumn get status => text()(); // 'success', 'error', 'conflict'
  DateTimeColumn get syncedAt => dateTime()();
  TextColumn get errorMessage => text().nullable()();
}
```

## Conflict Resolution

### Detection
Conflicts detected when:
- Local modifiedAt > server modifiedAt
- Server version changed since last sync
- Both versions have different data

### Strategies

#### Server-Wins
```dart
// Always accept server version
final resolved = conflict.serverVersion;
```
Use for: Critical data, authoritative server

#### Client-Wins
```dart
// Always keep local version
final resolved = conflict.localVersion;
```
Use for: Offline-first scenarios

#### Last-Write-Wins
```dart
// Compare timestamps
final resolved = conflict.localModifiedAt > conflict.serverModifiedAt
  ? conflict.localVersion
  : conflict.serverVersion;
```
Use for: General data, simple resolution

#### Merge
```dart
// Combine non-conflicting fields
final resolved = mergeFields(
  local: conflict.localVersion,
  server: conflict.serverVersion,
);
```
Use for: Complex objects, preserve all data

## Output Formats

### Interactive (Default)
Real-time progress bars and status updates.

### JSON
```json
{
  "action": "status",
  "timestamp": "2026-02-02T14:30:00Z",
  "summary": {
    "pending": 23,
    "syncing": 3,
    "synced": 156,
    "errors": 2,
    "conflicts": 1
  },
  "entities": {
    "student": { "pending": 5, "synced": 45 },
    "gameSession": { "pending": 12, "synced": 89 },
    "studentInsight": { "pending": 6, "synced": 22 }
  },
  "connectivity": "online",
  "lastSync": "2026-02-02T14:30:15Z"
}
```

## Integration

### Registry Entry
```json
{
  "id": "sync-offline",
  "name": "sync-offline",
  "type": "command",
  "category": "development",
  "domain": "kidtastic",
  "description": "Manage offline synchronization",
  "delegates_to": ["kidtastic-offline-sync"],
  "parameters": ["action", "entity", "status", "force"]
}
```

### Profile Assignment
- **Developer Profile**: ✅ Included
- **Full Profile**: ✅ Included
- **Kidtastic Profile**: ✅ Primary command

## Notes

- Requires database access
- Safe to run anytime (read-only by default)
- Destructive operations require --force
- Logs all operations for audit
- Respects user privacy
- Works offline (local database only)

## Related Commands

- `/analyze-kidtastic` - Check sync implementation
- `/add-game` - Add games with offline support

## Validation Checklist

✅ Command structure defined  
✅ Actions documented  
✅ Parameters specified  
✅ Examples provided  
✅ Output formats defined  
✅ Integration ready  
✅ Kidtastic-specific logic included  

**Status**: Ready for deployment
