import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_7_40/core/var_core.dart';
import 'package:water_7_40/data/repositories/core_rpo.dart';
import 'package:water_7_40/presentation/pages/managers_page.dart';
import 'firebase_options.dart';
import 'presentation/pages/admins_page.dart';
import 'presentation/pages/identical_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IdenticalPage(),
    );
  }
}
