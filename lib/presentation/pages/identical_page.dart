import 'package:flutter/material.dart';
import 'package:water_7_40/data/repositories/identic_repo.dart';
import '../../core/var_manager.dart';
import 'admin/admin_buttons.dart';

class IdenticalPage extends StatelessWidget {
  const IdenticalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Страница идентификации',
                  style: VarManager.cardSize,
                ),
              ],
            ),
            const SizedBox(height: 30),
            AdminButtons(
              text: 'Менеджер',
              function: () => RepoIdenticManagers().loginManager(context),
            ),
            const SizedBox(height: 30),
            AdminButtons(text: 'Водитель', function: () {}),
            const SizedBox(height: 30),
            AdminButtons(text: 'Администратор', function: () {}),
          ],
        ),
      ),
    );
  }
}
