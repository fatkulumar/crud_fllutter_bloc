import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/models/response_model.dart';
import 'package:flutter_application_1/services/user_api.dart';

class UserRepository {
  final UserApi api;

  UserRepository({required this.api});

  Future<ResponseModel<UserModel>> getUsers() {
    return api.getUsers();
  }

  Future<ResponseModel<UserModel>> addUser(
      String name, String email, String password) {
    return api.addUser(name, email, password);
  }

  Future<ResponseModel<UserModel>> updateUser(
      int id, String name, String email, String password) {
    return api.updateUser(id, name, email, password);
  }

  Future<ResponseModel<UserModel>> deleteUser(int id) {
    return api.deleteUser(id);
  }
}
