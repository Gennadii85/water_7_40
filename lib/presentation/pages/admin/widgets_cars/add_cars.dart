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

  final TextEditingController nameControl = TextEditingController();
  final TextEditingController passwordControl = TextEditingController();
  final TextEditingController carIDControl = TextEditingController();
  final TextEditingController maxControl = TextEditingController();
  final TextEditingController nicknameControl = TextEditingController();
  final TextEditingController phoneControl = TextEditingController();
  final TextEditingController notesControl = TextEditingController();

  @override
  void dispose() {
    nameControl.dispose();
    passwordControl.dispose();
    carIDControl.dispose();
    maxControl.dispose();
    nicknameControl.dispose();
    phoneControl.dispose();
    notesControl.dispose();
    super.dispose();
  }

  void clearTextController() {
    nameControl.clear();
    passwordControl.clear();
    carIDControl.clear();
    maxControl.clear();
    nicknameControl.clear();
    phoneControl.clear();
    notesControl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cars list'),
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
                        nickname: docs[index]['nickname'],
                        password: docs[index]['password'],
                        carID: docs[index]['id'].toString(),
                        docID: docs[index].id,
                        function: (docID) => deleteUser(context, docID),
                        max: docs[index]['max'],
                        name: docs[index]['name'],
                        phone: docs[index]['phone'],
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
              textField(carIDControl, 'ID * (только цифры)'),
              const SizedBox(height: 30),
              textField(phoneControl, 'Телефон'),
              const SizedBox(height: 30),
              textField(maxControl, 'Maximum'),
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
              RepoCreateUser().createCar(
                context,
                nicknameControl.text,
                nameControl.text,
                passwordControl.text,
                carIDControl.text,
                phoneControl.text,
                maxControl.text,
                notesControl.text,
              );
              clearTextController();
            },
          ),
          AdminButtons(
            text: 'Отмена',
            function: () {
              clearTextController();
              Navigator.of(context).pop();
              return;
            },
          ),
        ],
      ),
    );
  }

  TextField textField(
    TextEditingController controller,
    String labelText,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
      minLines: 1,
      maxLines: 50,
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
              RepoCreateUser().deleteCar(docID);
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
