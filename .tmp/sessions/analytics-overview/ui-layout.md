# Analytics Overview - UI Layout Specification

## 📐 Page Structure

```
┌─────────────────────────────────────────────────────────────┐
│  [Green Card Background - Existing]                        │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │  [Owl Mascot]    Analytics Overview                 │   │
│  │                  [Dashboard Header Image]           │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │                                                     │   │
│  │  📊 KEY METRICS (4-Card Grid)                       │   │
│  │  ┌──────────┬──────────┬──────────┬──────────┐     │   │
│  │  │ 👥       │ 🎮       │ ⏱️       │ 📈       │     │   │
│  │  │ Students │ Sessions │ Time     │ Avg      │     │   │
│  │  │ 25       │ 1,234    │ 45h      │ 78%      │     │   │
│  │  │ +3 today │ +45 today│ +2.3h    │ +5%      │     │   │
│  │  └──────────┴──────────┴──────────┴──────────┘     │   │
│  │                                                     │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │  🎮 TOP PERFORMING GAMES                            │   │
│  │  ┌───────────────────────────────────────────────┐ │   │
│  │  │ Match the Shapes ████████████████████  85%   │ │   │
│  │  │ Counting         ███████████████░░░░░  72%   │ │   │
│  │  │ Pronunciation    ██████████░░░░░░░░░░  58%   │ │   │
│  │  └───────────────────────────────────────────────┘ │   │
│  │                                                     │   │
│  ├─────────────────────────────────────────────────────┤   │
│  │                                                     │   │
│  │  🕐 RECENT ACTIVITY                                 │   │
│  │  ┌───────────────────────────────────────────────┐ │   │
│  │  │ [👤] John Doe    Match Shapes    95%  2m ago │ │   │
│  │  │ [👤] Jane Smith  Counting        88%  5m ago │ │   │
│  │  │ [👤] Mike Johnson Pronunciation  72%  12m ago│ │   │
│  │  │ [👤] Sarah Lee   Counting        91%  15m ago│ │   │
│  │  │ [👤] Tom Brown   Match Shapes    85%  22m ago│ │   │
│  │  │           ... (more items)                    │ │   │
│  │  └───────────────────────────────────────────────┘ │   │
│  │                                                     │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## 🎨 Detailed Component Specifications

### 1. Page Header (Existing - Keep)
- **Owl mascot**: Top-left positioning
- **Title**: "Analytics Overview" - 24px, Bold, White
- **Dashboard header image**: Top-right, decorative

### 2. Key Metrics Section

#### Layout
- **Container**: White rounded card (16px radius)
- **Padding**: 16px all sides
- **Grid**: 4 columns on tablet/desktop, 2x2 on mobile
- **Gap**: 12px between cards

#### Metric Card Design
```
┌─────────────────────┐
│                     │
│    [Icon]           │  <- 32px icon, centered
│                     │
│    25               │  <- 28px, Bold, Primary color
│                     │
│    Students         │  <- 12px, Grey, Uppercase
│                     │
│    ↑ +3 today       │  <- 11px, Green (positive)
│                     │
└─────────────────────┘
```

#### Metrics to Display
1. **Total Students**
   - Icon: Icons.people_rounded
   - Color: Colors.blue
   - Format: Integer
   - Change: Daily delta

2. **Total Sessions**
   - Icon: Icons.sports_esports_rounded
   - Color: Colors.orange
   - Format: Integer with commas
   - Change: Daily delta

3. **Total Time Played**
   - Icon: Icons.schedule_rounded
   - Color: Colors.green
   - Format: Xh Ym (e.g., "45h 30m")
   - Change: Daily delta

4. **Average Accuracy**
   - Icon: Icons.trending_up_rounded
   - Color: Colors.purple
   - Format: XX%
   - Change: Percentage point delta

### 3. Top Performing Games Section

#### Layout
- **Container**: White rounded card (16px radius)
- **Title**: "Top Performing Games" - 18px, Bold, left-aligned
- **Padding**: 16px
- **Chart type**: Horizontal bar chart

#### Bar Chart Design
```
Match the Shapes
┌────────────────────────────────────────┐
│████████████████████████████████░░░░░░░░│ 85%
└────────────────────────────────────────┘

Counting
┌────────────────────────────────────────┐
│██████████████████████████░░░░░░░░░░░░░░│ 72%
└────────────────────────────────────────┘

Pronunciation
┌────────────────────────────────────────┐
│████████████████░░░░░░░░░░░░░░░░░░░░░░░░│ 58%
└────────────────────────────────────────┘
```

#### Styling
- **Bar height**: 24px
- **Bar colors**: 
  - Match Shapes: Colors.green[600]
  - Counting: Colors.orange[600]
  - Pronunciation: Colors.blue[600]
- **Percentage text**: 14px, Bold, right-aligned
- **Game name**: 14px, Regular, left-aligned
- **Spacing**: 8px between bars

### 4. Recent Activity Section

#### Layout
- **Container**: White rounded card (16px radius)
- **Title**: "Recent Activity" - 18px, Bold, left-aligned
- **Max height**: 300px (scrollable)
- **Item count**: Show last 10 sessions

#### Activity Item Design
```
┌───────────────────────────────────────────────────────────┐
│ ┌──────┐                                                  │
│ │ 👤   │  John Doe              Match Shapes    95%      │
│ │Avatar│  ─────────────────────────────────────────────   │
│ └──────┘  2 minutes ago                                │
└───────────────────────────────────────────────────────────┘
```

#### Activity Item Components
1. **Avatar**: Circle, 40px, shows student image or placeholder
2. **Student Name**: 14px, Bold, max 1 line
3. **Game Name**: 12px, Grey, with game icon
4. **Score**: 14px, Bold, color-coded:
   - ≥80%: Green
   - 50-79%: Orange
   - <50%: Red
5. **Timestamp**: 11px, Grey (e.g., "2m ago", "1h ago", "Yesterday")

#### Divider
- Light grey line between items
- 1px height
- Full width

## 📱 Responsive Behavior

### Desktop (> 1200px)
- Metrics: 4 columns
- Charts side-by-side with Recent Activity
- Max width: 1200px centered

### Tablet (768px - 1200px)
- Metrics: 2x2 grid
- Sections stack vertically
- Full width with padding

### Mobile (< 768px)
- Metrics: 2x2 grid (smaller cards)
- Single column layout
- Reduced padding (12px)
- Scrollable sections

## 🎯 Interactions

### Loading State
- Show shimmer effect on cards
- Animated skeleton placeholders

### Error State
- Show error icon with retry button
- "Unable to load analytics" message

### Empty State
- Friendly message: "No activity yet! Students will appear here once they start playing."
- Show placeholder illustration

### Pull-to-Refresh
- Implement on ScrollView
- Reload all analytics data

## 🧩 Widget Tree Structure

```dart
AnalyticsPage
├── GreenBackground (existing)
├── SafeArea
└── SingleChildScrollView
    └── Padding (16px)
        ├── PageHeader (existing style)
        ├── SizedBox (16px)
        ├── AnalyticsMetricsGrid
        │   └── GridView (4 items)
        │       └── MetricCard (x4)
        ├── SizedBox (16px)
        ├── TopGamesChart
        │   └── Card
        │       └── Column
        │           ├── SectionTitle
        │           └── BarChart
        ├── SizedBox (16px)
        └── RecentActivityList
            └── Card
                └── Column
                    ├── SectionTitle
                    └── ListView (10 items)
                        └── ActivityItem (x10)
```

## 📦 Required Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  fl_chart: ^0.66.0  # For bar charts
  intl: ^0.19.0      # For date formatting
  shimmer: ^3.0.0    # For loading states (optional)
```

## 🎨 Color Palette Reference

```dart
// Primary Colors
const Color kPrimaryGreen = Color(0xFF4CAF50);
const Color kPrimaryGreenLight = Color(0xFF81C784);

// Metric Card Colors
const Color kMetricStudents = Colors.blue;
const Color kMetricSessions = Colors.orange;
const Color kMetricTime = Colors.green;
const Color kMetricAccuracy = Colors.purple;

// Score Colors
const Color kScoreHigh = Colors.green;
const Color kScoreMedium = Colors.orange;
const Color kScoreLow = Colors.red;

// Background Colors
const Color kCardBackground = Colors.white;
const Color kBackgroundGreen = Color(0xFFE8F5E9);

// Text Colors
const Color kTextPrimary = Color(0xFF212121);
const Color kTextSecondary = Color(0xFF757575);
const Color kTextMuted = Color(0xFFBDBDBD);
```

---

**Ready for review!** Please check this layout and let me know if you'd like any changes before I start implementation. 🎨
