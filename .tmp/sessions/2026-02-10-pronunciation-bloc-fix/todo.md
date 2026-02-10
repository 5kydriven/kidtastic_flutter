# Pronunciation Game Fixes - Session Todo

**Created:** 2026-02-10

## Part 1: Next Question Called Two Times (FIXED)

### Problem
The **silence timer race condition** was causing `_stopRecording` (and thus `QuestionNext`) to be called twice.

### Solution
1. Cancel silence timer **immediately** when `isCorrect` becomes true
2. Add `_isStopping` lock flag to prevent re-entry into `_stopRecording`
3. Add guard to return early if already stopping

### Files Modified
- `lib/pages/pronunciation_game/bloc/pronunciation_game_bloc.dart`

---

## Part 2: Analytics Shows 0% for Pronunciation (FIXED)

### Problem
Analytics was using `session.score` to calculate accuracy, but pronunciation game never updates the score field. It only saves attempts to `pronunciation_attempt_table`.

### Solution
Instead of fixing the pronunciation game to update score (which would make it like other games), we modified analytics to calculate pronunciation accuracy from the detailed attempt data.

### Changes Made

1. **PronunciationAttemptDao** - Added method to get attempts by multiple session question IDs:
   ```dart
   Future<List<PronunciationAttemptTableData>> getAttemptsBySessionQuestionIds({
     required List<int> sessionQuestionIds,
   })
   ```

2. **AnalyticsRepository** - Major updates:
   - Added dependencies: `SessionQuestionDao` and `PronunciationAttemptDao`
   - Added extension `isPronunciationGame` on `GameTableData`
   - Added helper method `_calculatePronunciationSessionAccuracy()` that:
     - Gets all session questions for a session
     - Fetches all pronunciation attempts for those questions
     - Calculates accuracy: `(correct attempts / total attempts) * 100`
   - Modified `getAverageAccuracyByGame()` to use attempts for pronunciation games
   - Modified `getRecentSessions()` to calculate score from attempts for pronunciation games

3. **main.dart** - Updated AnalyticsRepository instantiation to include new DAO dependencies

### Accuracy Calculation Logic

**For regular games:**
```
accuracy = (session.score / session.totalQuestions) * 100
```

**For pronunciation games:**
```
accuracy = (correct attempts / total attempts) * 100
```

This leverages the unique detailed tracking of pronunciation attempts (confidence scores, recognized text) while providing accurate analytics.

### Files Modified
- `lib/daos/pronunciation_attempt_dao/pronunciation_attempt_dao.dart`
- `lib/repositories/analytics_repository.dart`
- `lib/main.dart`

### Methods Updated in AnalyticsRepository
All accuracy-related methods now handle pronunciation games specially:

1. **getAverageAccuracy()** - Overall average accuracy across all games
2. **getAverageAccuracyByGame()** - Per-game accuracy breakdown
3. **getTodayAverageAccuracy()** - Today's average accuracy
4. **getRecentSessions()** - Recent session list with correct scores
5. **getTopStudents()** - Top performing students (was showing 0% for pronunciation)
6. **getLowPerformingStudents()** - Students needing attention (was showing 0% for pronunciation)
7. **getInactiveStudents()** - Inactive students with their accuracy

### How It Works
For each method, when processing a session:
1. Look up the game for that session
2. Check if it's a pronunciation game (`game.isPronunciationGame`)
3. If pronunciation: Calculate accuracy from `pronunciation_attempt_table`
4. If other game: Use `session.score` as before

This ensures pronunciation data is properly calculated while maintaining backward compatibility with other games.

---

## Part 3: Student Profile Pronunciation Fix (FIXED)

### Problem
Student Profile page was showing 0% accuracy for pronunciation games because `StudentProfileBloc` calculated accuracy using `session.score` directly without handling pronunciation games specially.

### Solution
Modified `StudentProfileBloc` to calculate pronunciation accuracy from attempts, similar to the analytics fix.

### Changes Made

1. **StudentProfileBloc** - Major updates:
   - Added dependencies: `SessionQuestionRepository` and `PronunciationAttemptRepository`
   - Modified overall accuracy calculation to handle pronunciation games
   - Added `_calculatePronunciationSessionAccuracy()` helper method
   - Added `sessionAccuracyMap` to state for per-session calculated accuracy
   - Pre-calculates accuracy for recent sessions

2. **StudentProfileState** - Added field:
   ```dart
   @Default({}) Map<int, double> sessionAccuracyMap,
   ```

3. **StudentProfileRecent** - Updated to use `sessionAccuracyMap`:
   - Checks if game is pronunciation
   - Uses calculated accuracy from map instead of `session.score`

4. **StudentProfilePage** - Updated to pass new repositories to bloc

### Files Modified
- `lib/pages/student_profile/bloc/student_profile_bloc.dart`
- `lib/pages/student_profile/bloc/state/student_profile_state.dart`
- `lib/pages/student_profile/view/student_profile_recent.dart`
- `lib/pages/student_profile/view/student_profile_page.dart`

### Complete List of Fixed Components

**Analytics Pages:**
- ✅ Overall accuracy (getAverageAccuracy)
- ✅ Per-game accuracy (getAverageAccuracyByGame)
- ✅ Today's accuracy (getTodayAverageAccuracy)
- ✅ Recent sessions
- ✅ Top students
- ✅ Needs attention / Low performing students
- ✅ Inactive students

**Student Profile Pages:**
- ✅ Overall accuracy
- ✅ Recent sessions list
- ✅ Skill breakdown (pronunciation insights now recalculated from attempts)
- ✅ Areas for improvement (uses corrected pronunciation insight data)
- ✅ Game insights (pronunciation insights recalculated from attempts)
