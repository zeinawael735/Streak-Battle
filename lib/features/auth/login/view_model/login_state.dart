sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}

class UserNameLoaded extends LoginState {}

class LogoutLoading extends LoginState {}

class LogoutSuccess extends LoginState {}

class LogoutError extends LoginState {
  final String message;
  LogoutError(this.message);
}

class DeleteAccountLoading extends LoginState {}

class DeleteAccountSuccess extends LoginState {}

class DeleteAccountError extends LoginState {
  final String message;
  DeleteAccountError(this.message);
}
