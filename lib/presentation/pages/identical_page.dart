import 'package:flutter/material.dart';
import 'package:water_7_40/data/repositories/users_identic_repo.dart';
import 'package:water_7_40/presentation/pages/admins_page.dart';
import 'package:water_7_40/presentation/pages/cars_page.dart';
import 'package:water_7_40/presentation/pages/managers_page.dart';
import '../../core/var_core.dart';
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
              function: () => RepoIdenticUsers().checkUser(
                context,
                VarHive.managers,
                MaterialPageRoute(builder: (context) => const ManagersPage()),
              ),
            ),
            const SizedBox(height: 30),
            AdminButtons(
              text: 'Водитель',
              function: () => RepoIdenticUsers().checkUser(
                context,
                VarHive.cars,
                MaterialPageRoute(builder: (context) => CarsPage()),
              ),
            ),
            const SizedBox(height: 30),
            AdminButtons(
              text: 'Администратор',
              function: () => RepoIdenticUsers().checkUser(
                context,
                VarHive.admins,
                MaterialPageRoute(builder: (context) => const AdminPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
