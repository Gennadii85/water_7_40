import 'package:flutter/material.dart';
import 'package:water_7_40/core/var_manager.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import 'package:water_7_40/presentation/pages/identical_page.dart';

import '../../data/repositories/managers_identic_repo.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController passControl = TextEditingController();
  final TextEditingController nameControl = TextEditingController();

  @override
  void dispose() {
    passControl.dispose();
    nameControl.dispose();
    super.dispose();
  }

  void clearTextController() {
    passControl.clear();
    nameControl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Введите свой логин и пароль предоставленный администратором',
                style: VarManager.cardSize,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: nameControl,
                decoration: const InputDecoration(
                  labelText: 'Логин для входа',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: passControl,
                decoration: const InputDecoration(
                  labelText: 'Пароль для входа',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              AdminButtons(
                text: 'Войти',
                function: () => RepoIdenticManagers().registrationManager(
                  context,
                  nameControl.text,
                  passControl.text,
                ),
              ),
              AdminButtons(
                text: 'Назад',
                function: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const IdenticalPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
