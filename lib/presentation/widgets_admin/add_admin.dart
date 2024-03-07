import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_7_40/data/repositories/admin_page_repo.dart';
import 'package:water_7_40/presentation/widgets_admin/admin_buttons.dart';
import 'package:water_7_40/presentation/widgets_admin/admin_drawer.dart';

class AddAdmin extends StatelessWidget {
  AddAdmin({super.key});

  final db = FirebaseFirestore.instance;
  final TextEditingController passControl = TextEditingController();
  final TextEditingController nameControl = TextEditingController();

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
              final List<Widget> listAdmins = snapshot.data!.docs
                  .map(
                    (e) => Row(
                      children: [Text(e.data()!.toString())],
                    ),
                  )
                  .toList();
              return Column(
                children: [
                  const SizedBox(height: 100),
                  ListView(
                    shrinkWrap: true,
                    children: listAdmins,
                  ),
                  AdminButtons(
                    text: 'Добавить',
                    function: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Column(
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
                        actions: [
                          AdminButtons(
                            text: 'Создать',
                            function: () {
                              RepoAdminPage().createAdmin(
                                nameControl.text,
                                passControl.text,
                              );
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
                  AdminButtons(
                    text: 'Удалить',
                    function: () {},
                  ),
                ],
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
