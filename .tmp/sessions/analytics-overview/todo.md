# Analytics Overview - Phase 1 Implementation Plan

## 📋 Todo List

### 1. Data Layer Updates
- [ ] Update `AnalyticsState` with aggregate metrics fields
  - `totalStudents: int`
  - `totalSessions: int`
  - `totalMinutesPlayed: int`
  - `averageAccuracy: double`
  - `sessionsByGame: Map<String, int>`
  - `recentSessions: List<RecentSession>`
  - `topStudents: List<StudentRank>`
  
- [ ] Create `AnalyticsRepository` for aggregate queries
  - `getTotalStudents()`
  - `getTotalSessions()`
  - `getTotalPlayTime()`
  - `getAverageAccuracy()`
  - `getSessionsByGame()`
  - `getRecentSessions(limit: 10)`
  - `getTopStudents(by: RankCriteria, limit: 5)`

### 2. UI Components

#### 2.1 Key Metrics Section
- [ ] Create `AnalyticsMetricsGrid` widget
  - 4 metric cards in a responsive grid
  - Icons: Icons.people, Icons.sports_esports, Icons.schedule, Icons.trending_up
  - Shows value + change indicator (today vs yesterday)

#### 2.2 Top Games Section
- [ ] Create `TopGamesChart` widget
  - Horizontal bar chart showing average accuracy per game
  - 3 bars for: Counting, Pronunciation, Match the Shapes
  - Color-coded bars with percentages

#### 2.3 Recent Activity Section
- [ ] Create `RecentActivityList` widget
  - List of last 10 sessions
  - Shows: Student avatar, name, game icon, score, time ago
  - Scrollable with max height

### 3. Analytics Page Integration
- [ ] Update `AnalyticsPage` layout
  - Replace Placeholder with actual content
  - Add ScrollView for overflow
  - Organize sections vertically with proper spacing
  - Maintain existing UI theme (green card, owl mascot, header)

### 4. BLoC Updates
- [ ] Update `AnalyticsEvent`
  - Add `LoadAnalyticsOverview()` event
  
- [ ] Update `AnalyticsBloc`
  - Handle `LoadAnalyticsOverview` event
  - Call repository methods
  - Emit state with loaded data

### 5. Testing
- [ ] Write widget tests for new components
- [ ] Test repository methods with mock data
- [ ] Verify responsive layout on different screen sizes

## 🎨 Design System

### Colors (from existing app)
- Primary Green: `Colors.green` (or specific shade from theme)
- Background: Green gradient card
- Card Background: White with slight transparency
- Text Primary: Dark (on white cards)
- Text Secondary: Grey
- Accent: Orange/Yellow for highlights

### Typography
- Section Title: 20px, Bold
- Metric Value: 24px, Bold
- Metric Label: 12px, Regular
- List Item: 14px, Regular

### Spacing
- Section padding: 16px
- Card margin: 8px
- Internal padding: 12px
- Grid gap: 12px

## 📁 Files to Create/Modify

### New Files
```
lib/pages/analytics/view/widgets/
  ├── analytics_metrics_grid.dart
  ├── metric_card.dart
  ├── top_games_chart.dart
  └── recent_activity_list.dart

lib/repositories/analytics_repository.dart
```

### Modified Files
```
lib/pages/analytics/view/analytics_page.dart
lib/pages/analytics/bloc/analytics_bloc.dart
lib/pages/analytics/bloc/event/analytics_event.dart
lib/pages/analytics/bloc/state/analytics_state.dart
```

## ⏱️ Estimated Time
- Data Layer: 1 hour
- UI Components: 2 hours
- Integration: 1 hour
- Testing: 1 hour
**Total: ~5 hours**

## 🔄 Dependencies
- fl_chart (if not already installed) - for charts
- intl - for date/time formatting
- Existing BLoC pattern
- Existing repository pattern
