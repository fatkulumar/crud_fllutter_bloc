import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_1/models/response_model.dart';
import 'package:flutter_application_1/models/user_model.dart';

class UserApi {
  final String _baseUrl;

  UserApi() : _baseUrl = dotenv.get('API_URL', fallback: 'http://localhost:8000/api');

  Uri _buildUrl(String path) {
    return Uri.parse('$_baseUrl$path');
  }

  Future<ResponseModel<UserModel>> getUsers() async {
    final url = _buildUrl('/item');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ResponseModel<UserModel>.fromJsonForDataModel(
          jsonData,
          (json) => UserModel.fromJson(json),
        );
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ResponseModel<UserModel>> addUser(
    String name,
    String email,
    String password,
  ) async {
    final url = _buildUrl('/item');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ResponseModel<UserModel>.fromJsonForSingle(
          jsonData,
          (json) => UserModel.fromJson(json),
        );
      } else {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ResponseModel<UserModel>> updateUser(
    int id,
    String name,
    String email,
    String password,
  ) async {
    final url = _buildUrl('/item/$id');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id,
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ResponseModel<UserModel>.fromJsonForSingle(
          jsonData,
          (json) => UserModel.fromJson(json),
        );
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<ResponseModel<UserModel>> deleteUser(
    int id,
  ) async {
    final url = _buildUrl('/item/$id');
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ResponseModel<UserModel>.fromJsonForSingle(
          jsonData,
          (json) => UserModel.fromJson(json),
        );
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
