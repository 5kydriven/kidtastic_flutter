---
id: analyze-kidtastic
name: analyze-kidtastic
description: "Analyze Kidtastic Flutter codebase for patterns, consistency, and refactoring opportunities"
type: command
category: analysis
domain: kidtastic
version: 1.0.0
---

# Command: /analyze-kidtastic

## Description

Analyze the Kidtastic Flutter codebase for architectural patterns, consistency issues, and refactoring opportunities. Provides detailed insights into BLoC implementations, repositories, models, and overall code quality.

## Usage

```bash
/analyze-kidtastic [--pattern=<pattern>] [--scope=<scope>] [--output=<format>]
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `--pattern` | string | No | Specific pattern to analyze: bloc, repository, freezed, dao, table, result, all |
| `--scope` | string | No | Analysis scope: quick (summary only), standard (with suggestions), deep (full analysis) |
| `--output` | string | No | Output format: text, json, markdown |

## Examples

### Analyze all patterns (comprehensive)
```bash
/analyze-kidtastic --pattern=all --scope=deep --output=markdown
```

### Quick BLoC consistency check
```bash
/analyze-kidtastic --pattern=bloc --scope=quick
```

### Repository pattern analysis with refactoring suggestions
```bash
/analyze-kidtastic --pattern=repository --scope=standard
```

### Export full analysis as JSON
```bash
/analyze-kidtastic --pattern=all --output=json > analysis_report.json
```

## Behavior

### Analysis Process
1. **Scan** - Find all Dart files in lib/
2. **Pattern Detection** - Identify pattern implementations
3. **Consistency Check** - Compare implementations for similarity
4. **Quality Assessment** - Identify issues and anti-patterns
5. **Suggestion Generation** - Provide refactoring recommendations

### Output Sections

#### Summary
- Total files analyzed
- Pattern occurrences found
- Overall consistency score
- Critical issues count

#### Pattern Details
For each pattern:
- Occurrence count
- File locations
- Implementation examples
- Consistency metrics
- Variations detected

#### Refactoring Suggestions
- Priority-ranked recommendations
- Effort estimates
- Expected benefits
- Implementation guidance

#### Quality Insights
- Code health metrics
- Technical debt indicators
- Maintainability scores
- Best practice compliance

## Predefined Patterns

### BLoC Pattern
- **Files**: 12 BLoC implementations
- **What**: State management with flutter_bloc
- **Checks**: Freezed usage, event naming, state completeness

### Repository Pattern
- **Files**: 8 repository implementations
- **What**: Data access abstraction layer
- **Checks**: Error handling, Result pattern, DAO usage

### Freezed Model
- **Files**: 24 model implementations
- **What**: Immutable data classes
- **Checks**: Proper annotations, fromJson/toJson, sealed classes

### DAO Pattern
- **Files**: 8 DAO implementations
- **What**: Database access objects
- **Checks**: Drift annotations, CRUD operations, table references

### Table Definition
- **Files**: 8 table definitions
- **What**: Drift table schemas
- **Checks**: Column types, constraints, indexes

### Result Pattern
- **Files**: 52 occurrences across repositories
- **What**: Error handling pattern
- **Checks**: Status codes, error messages, consistency

## Implementation

### Delegation
- **Primary**: Delegates to `analyze-patterns.js` command
- **Secondary**: Uses `@kidtastic-game-developer` for game-specific analysis
- **Tertiary**: Uses `@kidtastic-elearning-specialist` for educational content analysis

### Context Requirements
- Kidtastic architecture context
- Pattern analysis standards
- Code quality criteria

### Processing Steps
1. Parse command parameters
2. Validate pattern selection
3. Execute pattern analysis
4. Aggregate results
5. Generate Kidtastic-specific insights
6. Format output
7. Present report

## Output Formats

### Text (Default)
Human-readable report with:
- Clear headers and sections
- Bullet-pointed findings
- ASCII tables for data
- Color-coded priorities (if terminal supports)

### JSON
Structured data for programmatic use:
```json
{
  "analysis_timestamp": "2026-02-02T10:00:00Z",
  "patterns_analyzed": ["bloc", "repository", "freezed"],
  "summary": {
    "total_files": 270,
    "patterns_found": 52,
    "consistency_score": 0.35
  },
  "patterns": [
    {
      "name": "bloc",
      "occurrences": 12,
      "files": [...],
      "consistency": 0.23,
      "issues": [...]
    }
  ],
  "suggestions": [
    {
      "priority": "high",
      "description": "Create BaseBloc class",
      "effort": "medium",
      "benefit": "Improves consistency by 40%"
    }
  ]
}
```

### Markdown
Formatted for documentation:
```markdown
# Kidtastic Codebase Analysis

## Summary
- **Files Analyzed**: 270
- **Patterns Found**: 52
- **Consistency Score**: 35%

## BLoC Pattern Analysis
...
```

## Integration

### Registry Entry
```json
{
  "id": "analyze-kidtastic",
  "name": "analyze-kidtastic",
  "type": "command",
  "category": "analysis",
  "domain": "kidtastic",
  "description": "Analyze Kidtastic Flutter codebase patterns",
  "delegates_to": ["analyze-patterns.js", "kidtastic-game-developer"],
  "parameters": ["pattern", "scope", "output"]
}
```

### Profile Assignment
- **Developer Profile**: ✅ Included
- **Full Profile**: ✅ Included
- **Kidtastic Profile**: ✅ Primary command

## Notes

- Optimized for Kidtastic Flutter/Dart codebase
- Recognizes Kidtastic-specific patterns
- Provides domain-aware refactoring suggestions
- Can be run periodically to track improvements
- Results can be exported for team review

## Related Commands

- `/analyze-patterns` - Generic pattern analysis
- `/add-game` - Add new educational game
- `/sync-offline` - Manage offline synchronization

## Validation Checklist

✅ Command structure defined  
✅ Parameters documented  
✅ Behavior specified  
✅ Examples provided  
✅ Output formats defined  
✅ Integration ready  
✅ Kidtastic-specific logic included  

**Status**: Ready for deployment
