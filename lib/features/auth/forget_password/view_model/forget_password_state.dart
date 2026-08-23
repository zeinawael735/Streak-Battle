import 'package:equatable/equatable.dart';

abstract class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgetPasswordIdle extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class ForgetPasswordSuccess extends ForgetPasswordState {
  final int remainingSeconds;
  const ForgetPasswordSuccess({this.remainingSeconds = 30});

  @override
  List<Object?> get props => [remainingSeconds];
}

class ForgetPasswordError extends ForgetPasswordState {
  final String message;
  const ForgetPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}