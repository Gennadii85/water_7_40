import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_7_40/core/var_core.dart';
import 'package:water_7_40/presentation/pages/managers_page.dart';
import 'firebase_options.dart';
import 'presentation/cubit/start_page/start_page_cubit.dart';
import 'presentation/pages/admins_page.dart';
import 'presentation/pages/cars_page.dart';
import 'presentation/pages/identical_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox(VarHive.nameBox);
  runApp(
    BlocProvider(
      create: (context) => StartPageCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    BlocProvider.of<StartPageCubit>(context).getStarted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StartPageCubit, StartPageState>(
      builder: (context, state) {
        if (state is StartPageInitial) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: IdenticalPage(),
          );
        }
        if (state is StartPageAdmin) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: AdminPage(),
          );
        }
        if (state is StartPageCar) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: CarsPage(),
          );
        }
        if (state is StartPageManager) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: ManagersPage(),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
