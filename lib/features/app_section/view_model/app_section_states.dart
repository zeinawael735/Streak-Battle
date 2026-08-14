sealed class AppSectionState {}

final class AppSectionInitial extends AppSectionState {}

final class AppSectionChangeTabState extends AppSectionState {
  final int index;
  AppSectionChangeTabState(this.index);
}