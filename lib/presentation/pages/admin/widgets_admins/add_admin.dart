import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_7_40/presentation/pages/admin/widgets_admins/admin_card.dart';
import 'package:water_7_40/data/repositories/admin_page_repo.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import 'package:water_7_40/presentation/pages/admin/admin_drawer.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final db = FirebaseFirestore.instance;

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
        appBar: AppBar(
          title: const Text('Admins list'),
          centerTitle: true,
        ),
        drawer: const AdminDrawer(),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('admins').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docs = snapshot.data!.docs;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) => AdminCard(
                        name: docs[index]['name'],
                        password: docs[index]['password'].toString(),
                        function: (name) => RepoAdminPage().deleteAdmin(name),
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
                                const SizedBox(height: 50),
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
                              ],
                            ),
                          ),
                          actions: [
                            AdminButtons(
                              text: 'Создать',
                              function: () {
                                RepoAdminPage().createAdmin(
                                  nameControl.text,
                                  passControl.text,
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
