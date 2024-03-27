import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_7_40/presentation/pages/admin/widgets_cars/cars_card.dart';
import 'package:water_7_40/data/repositories/admin/create_user_repo.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import 'package:water_7_40/presentation/pages/admin/admin_drawer.dart';

class AddCars extends StatefulWidget {
  const AddCars({super.key});

  @override
  State<AddCars> createState() => _AddCarsState();
}

class _AddCarsState extends State<AddCars> {
  final db = FirebaseFirestore.instance;

  final TextEditingController passControl = TextEditingController();
  final TextEditingController nameControl = TextEditingController();
  final TextEditingController idControl = TextEditingController();

  @override
  void dispose() {
    passControl.dispose();
    nameControl.dispose();
    idControl.dispose();
    super.dispose();
  }

  void clearTextController() {
    passControl.clear();
    nameControl.clear();
    idControl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cars list'),
          centerTitle: true,
        ),
        drawer: const AdminDrawer(),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('cars').snapshots(),
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
                      itemBuilder: (context, index) => CarsCard(
                        name: docs[index]['name'],
                        password: docs[index]['password'],
                        carID: docs[index]['id'].toString(),
                        docID: docs[index].id,
                        function: (docID) => showDialog(
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
                                  RepoCreateUser().deleteCar(docID);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
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
                                    labelText: 'Логин для входа *',
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
                                    labelText: 'Пароль для входа *',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                TextField(
                                  controller: idControl,
                                  decoration: const InputDecoration(
                                    labelText: 'ID * (только цифры)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                          actions: [
                            AdminButtons(
                              text: 'Создать',
                              function: () {
                                RepoCreateUser().createCar(
                                  context,
                                  nameControl.text,
                                  passControl.text,
                                  idControl.text,
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
