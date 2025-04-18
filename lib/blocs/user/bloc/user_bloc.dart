import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
      UserBloc(this.userRepository) : super(UserInitial()) {
      on<LoadUser>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await userRepository.getUsers();
        final users = response.data?.data ??
            (response.singleData != null ? [response.singleData!] : []);

        emit(UserLoaded(
          code: response.code,
          message: response.message,
          success: response.success,
          users: users,
        ));
      } catch (e) {
        emit(UserError('Gagal memuat data user: $e'));
      }
    });

    on<AddUser>((event, emit) async {
      try {
        final response = await userRepository.addUser(
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

    on<UpdateUser>((event, emit) async {
      try {
        final response = await userRepository.updateUser(
          event.id,
          event.name,
          event.email,
          event.password,
        );

        if (response.singleData == null) {
          emit(UserError('Data user gagal diupdate.'));
          return;
        }

        final updatedUser = response.singleData!;

        if (state is UserLoaded) {
          final currentState = state as UserLoaded;

          final updatedUsers = currentState.users.map((user) {
            return user.id == updatedUser.id ? updatedUser : user;
          }).toList();

          emit(UserLoaded(
            code: response.code,
            message: response.message,
            success: response.success,
            users: updatedUsers,
          ));
        } else {
          // fallback: jika sebelumnya bukan UserLoaded
          emit(UserLoaded(
            code: response.code,
            message: response.message,
            success: response.success,
            users: [updatedUser],
          ));
        }

      } catch (e) {
        emit(UserError('Gagal update user: $e'));
      }
    });

    on<DeleteUser>((event, emit) async {
      try {
        final response = await userRepository.deleteUser(event.id);

        if (response.success && response.code == 200) {
          if (state is UserLoaded) {
            final currentState = state as UserLoaded;

            final updatedUsers = currentState.users
                .where((user) => user.id != event.id)
                .toList();

            emit(UserDeleted(response.message));
            // Emit hanya 1 state yang sudah diupdate
            emit(UserLoaded(
              code: response.code,
              message: response.message,
              success: true,
              users: updatedUsers,
            ));
            
          }
        } else {
          emit(UserError(response.message));
        }
      } catch (e) {
        emit(UserError('Terjadi kesalahan saat menghapus user: $e'));
      }
    });
  }
}
