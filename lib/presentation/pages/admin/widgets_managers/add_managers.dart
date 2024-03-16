import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_7_40/data/repositories/admin_page_repo.dart';
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

  final TextEditingController passControl = TextEditingController();
  final TextEditingController nameControl = TextEditingController();
  final TextEditingController idControl = TextEditingController();
  final TextEditingController percentControl = TextEditingController();
  final TextEditingController phoneControl = TextEditingController();

  @override
  void dispose() {
    passControl.dispose();
    nameControl.dispose();
    idControl.dispose();
    percentControl.dispose();
    phoneControl.dispose();
    super.dispose();
  }

  void clearTextController() {
    passControl.clear();
    nameControl.clear();
    idControl.clear();
    percentControl.clear();
    phoneControl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Managers list'),
          centerTitle: true,
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Все заказы без указания менеджера будут иметь ID = 0',
                      ),
                    ),
                    const SizedBox(height: 30),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) => ManagersCard(
                        name: docs[index]['name'],
                        password: docs[index]['password'],
                        phone: docs[index]['phone'],
                        managerID: docs[index]['managerID'].toString(),
                        percent: docs[index]['percent'].toString(),
                        docID: docs[index].id,
                        function: (docID) =>
                            RepoAdminPage().deleteManager(docID),
                      ),
                    ),
                    const SizedBox(height: 50),
                    AdminButtons(
                      text: 'Добавить',
                      function: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
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
                                const SizedBox(height: 15),
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
                                const SizedBox(height: 15),
                                TextField(
                                  controller: phoneControl,
                                  decoration: const InputDecoration(
                                    labelText: 'Телефон',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: idControl,
                                  decoration: const InputDecoration(
                                    labelText: 'ID (только цифры)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: percentControl,
                                  decoration: const InputDecoration(
                                    labelText: 'Процент (только цифры)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          actions: [
                            AdminButtons(
                              text: 'Создать',
                              function: () {
                                RepoAdminPage().createManager(
                                  context,
                                  nameControl.text,
                                  passControl.text,
                                  phoneControl.text,
                                  idControl.text,
                                  percentControl.text,
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
}
