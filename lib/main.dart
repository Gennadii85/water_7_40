import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'presentation/pages/admin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized;
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminPage(),
    );
  }
}
