import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/user/bloc/user_bloc.dart';
import 'package:flutter_application_1/pages/my_add.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Home'), actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: IconButton(onPressed: () {
            context.read<UserBloc>().add(LoadUser());
          }, icon: Icon(Icons.refresh)),
        )
      ],),
      body: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),  // Menampilkan pesan delete user
            );
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),  // Menampilkan pesan error jika terjadi
            );
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserLoaded) {
              final users = state.users;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users[index].name),
                    subtitle: Text(
                      users[index].email,
                    ), // misalnya ada email juga
                    leading: Icon(Icons.person),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        // Konfirmasi atau langsung delete
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (dialogContext) => AlertDialog(
                                title: Text('Konfirmasi'),
                                content: Text('Hapus data user ini?'),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () =>
                                            Navigator.pop(dialogContext, false),
                                    child: Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () =>
                                            Navigator.pop(dialogContext, true),
                                    child: Text('Hapus'),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true && context.mounted) {
                          context.read<UserBloc>().add(
                            DeleteUser(id: users[index].id!),
                          );
                        }
                      },
                    ), // optional icon
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyAdd(user: users[index]),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (state is UserError) {
              return Center(child: Text(state.error));
            } else if (state is UserDeleted) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyAdd()),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
