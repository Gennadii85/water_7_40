import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_7_40/data/repositories/admin/create_user_repo.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import 'package:water_7_40/presentation/pages/admin/admin_drawer.dart';
import 'package:water_7_40/presentation/pages/admin/widgets_managers/managers_card.dart';

class AddManagers extends StatefulWidget {
  const AddManagers({super.key});

  @override
  State<AddManagers> createState() => _AddManagersState();
}

class _AddManagersState extends State<AddManagers> {
  final db = FirebaseFirestore.instance;

  final TextEditingController passwordControl = TextEditingController();
  final TextEditingController nameControl = TextEditingController();
  final TextEditingController idControl = TextEditingController();
  final TextEditingController percentControl = TextEditingController();
  final TextEditingController phoneControl = TextEditingController();
  final TextEditingController nicknameControl = TextEditingController();
  final TextEditingController notesControl = TextEditingController();

  @override
  void dispose() {
    passwordControl.dispose();
    nameControl.dispose();
    idControl.dispose();
    percentControl.dispose();
    phoneControl.dispose();
    nicknameControl.dispose();
    notesControl.dispose();
    super.dispose();
  }

  void clearTextController() {
    passwordControl.clear();
    nameControl.clear();
    idControl.clear();
    percentControl.clear();
    phoneControl.clear();
    nicknameControl.clear();
    notesControl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Managers list'),
          centerTitle: true,
          actions: [
            AdminButtons(
              text: 'Добавить',
              function: () => createUser(context),
            ),
          ],
        ),
        drawer: const AdminDrawer(),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('managers').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docs = snapshot.data!.docs;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) => ManagersCard(
                        name: docs[index]['name'],
                        password: docs[index]['password'],
                        phone: docs[index]['phone'],
                        managerID: docs[index]['id'].toString(),
                        percent: docs[index]['percent'].toString(),
                        docID: docs[index].id,
                        function: (docID) => deleteUser(context, docID),
                        nickname: docs[index]['nickname'],
                        notes: docs[index]['notes'],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Что-то пошло не по плану'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> createUser(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 50),
              textField(nicknameControl, 'Имя (видно только вам)'),
              const SizedBox(height: 30),
              textField(nameControl, 'Логин для входа *'),
              const SizedBox(height: 30),
              textField(passwordControl, 'Пароль для входа *'),
              const SizedBox(height: 30),
              textField(idControl, 'ID * (только цифры)'),
              const SizedBox(height: 30),
              textField(phoneControl, 'Телефон'),
              const SizedBox(height: 30),
              textField(percentControl, 'Процент'),
              const SizedBox(height: 30),
              textField(notesControl, 'Заметки'),
              const SizedBox(height: 50),
            ],
          ),
        ),
        actions: [
          AdminButtons(
            text: 'Создать',
            function: () {
              RepoCreateUser().createManager(
                context,
                nicknameControl.text,
                nameControl.text,
                passwordControl.text,
                idControl.text,
                phoneControl.text,
                percentControl.text,
                notesControl.text,
              );
              clearTextController();
              Navigator.of(context).pop();
            },
          ),
          AdminButtons(
            text: 'Отмена',
            function: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<dynamic> deleteUser(BuildContext context, docID) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Удалить ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              RepoCreateUser().deleteManager(docID);
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
