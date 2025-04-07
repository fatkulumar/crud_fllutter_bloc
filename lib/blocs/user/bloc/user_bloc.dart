import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/stores/user_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserApi userApi;
  UserBloc(this.userApi) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userApi.getUsers();

        if (response.data != null) {
          emit(
            UserLoaded(
              code: response.code,
              message: response.message,
              success: response.success,
              users: response.data!.data, // Mengambil list data pengguna
            ),
          );
        } else if (response.singleData != null) {
          // Menghitung jika hanya ada satu objek pengguna (untuk addUser)
          emit(
            UserLoaded(
              code: response.code,
              message: response.message,
              success: response.success,
              users: [
                response.singleData!,
              ], // Menampilkan satu objek sebagai list
            ),
          );
        } else {
          emit(
            UserLoaded(
              code: response.code,
              message: response.message,
              success: response.success,
              users: [],
            ),
          );
        }
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<AddUser>((event, emit) async {
      try {
        final response = await userApi.addUser(
          event.name,
          event.email,
          event.password,
        );

        if (response.singleData != null) {
          if (state is UserLoaded) {
            final currentState = state as UserLoaded;
            final updatedUsers = List<UserModel>.from(currentState.users)
              ..add(response.singleData!); // Tambah user baru ke list

            emit(
              UserLoaded(
                code: response.code,
                message: response.message,
                success: response.success,
                users: updatedUsers,
              ),
            );
          } else {
            // Kalau state sebelumnya bukan UserLoaded, kita anggap baru dan emit list 1 user
            emit(
              UserLoaded(
                code: response.code,
                message: response.message,
                success: response.success,
                users: [response.singleData!],
              ),
            );
          }
        } else {
          emit(UserError('Tidak ada data pengguna yang ditambahkan.'));
        }
      } catch (e) {
        emit(UserError('Gagal menambahkan user: $e'));
      }
    });
  }
}
