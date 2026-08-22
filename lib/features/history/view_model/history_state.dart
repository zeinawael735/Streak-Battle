abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistorySuccess extends HistoryState {
  final List<Map<String, dynamic>> battles;
  HistorySuccess(this.battles);
}

class HistoryError extends HistoryState {
  final String message;
  HistoryError(this.message);
}