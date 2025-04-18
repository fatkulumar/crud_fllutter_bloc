import 'package:flutter/material.dart';
import 'package:flutter_application_1/blocs/user/bloc/user_bloc.dart';
import 'package:flutter_application_1/pages/my_home.dart';
import 'package:flutter_application_1/repositories/user_repository.dart';
import 'package:flutter_application_1/services/user_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
    Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserBloc(UserRepository(api: UserApi()))..add(LoadUser()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHome(),
      ),
    );
  }
}
