part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final bool success;
  final int code;
  final String message;
  final List<UserModel> users;

  UserLoaded({
    required this.success,
    required this.code,
    required this.message,
    required this.users,
  });
}

final class UserError extends UserState {
  final String error;
  UserError(this.error);
}

final class UserDeleted extends UserState {
  final String message;
  UserDeleted(this.message);
}
