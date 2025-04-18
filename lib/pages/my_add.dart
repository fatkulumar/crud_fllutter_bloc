import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/user/bloc/user_bloc.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAdd extends StatefulWidget {
   final UserModel? user; 
  const MyAdd({super.key, this.user});

  @override
  State<MyAdd> createState() => _MyAddState();
}

class _MyAddState extends State<MyAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _nameController.text = widget.user!.name;
      _emailController.text = widget.user!.email;
      _passwordController.text = widget.user!.password; // opsional
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  ).hasMatch(value)) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              BlocListener<UserBloc, UserState>(
                listener: (context, state) {
                  if (state is UserLoaded) {
                    final message = state.message;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(message)));
                    Navigator.pop(context); // Kembali ke halaman utama
                  } else if (state is UserError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.error)));
                  }
                },
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final name = _nameController.text;
                      final email = _emailController.text;
                      final password = _passwordController.text;

                      if (widget.user == null) {
                        context.read<UserBloc>().add(
                          AddUser(name: name, email: email, password: password),
                        );
                      } else {
                        // mode edit
                        context.read<UserBloc>().add(
                          UpdateUser(
                            id: widget.user!.id!,
                            name: name,
                            email: email,
                            password: password,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(widget.user == null ? 'Tambah User' : 'Update User'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}