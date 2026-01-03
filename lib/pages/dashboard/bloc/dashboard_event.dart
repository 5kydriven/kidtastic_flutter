sealed class DashboardEvent {
  const DashboardEvent();
}

class DashboardScreenCreated extends DashboardEvent {
  const DashboardScreenCreated();
}

class DashboardSfxButtonPressed extends DashboardEvent {
  const DashboardSfxButtonPressed();
}
