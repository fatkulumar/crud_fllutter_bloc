part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class LoadUser extends UserEvent {}

class AddUser extends UserEvent {
  final String name;
  final String email;
  final String password;

  AddUser({required this.name, required this.email, required this.password});
}

class UpdateUser extends UserEvent {
  final int id;
  final String name;
  final String email;
  final String password;

  UpdateUser({required this.id, required this.name, required this.email, required this.password});
}

class DeleteUser extends UserEvent {
  final int id;

  DeleteUser({required this.id});
}
