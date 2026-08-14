import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_section_states.dart';

class AppSectionCubit extends Cubit<AppSectionState> {
  AppSectionCubit() : super(AppSectionInitial());

  int currentIndex = 0;

  void changeTab(int navIndex) {
    if (navIndex == 2) return;

    final Map<int, int> navToScreen = {
      0: 0,
      1: 1,
      3: 2,
      4: 3,
    };

    final screenIndex = navToScreen[navIndex] ?? currentIndex;

    if (currentIndex == screenIndex) return;

    currentIndex = screenIndex;
    emit(AppSectionChangeTabState(currentIndex));
  }

  int getNavIndex(int screenIndex) {
    const Map<int, int> screenToNav = {
      0: 0,
      1: 1,
      2: 3,
      3: 4,
    };
    return screenToNav[screenIndex] ?? 0;
  }
}