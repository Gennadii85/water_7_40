import 'package:flutter/material.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import 'package:water_7_40/presentation/pages/admin/admin_drawer.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Admin panel'),
          centerTitle: true,
          // actions: [
          //   AdminButtons(
          //     function: () {},
          // => RepoAdminPage().update(),
          //     text: 'Обновить',
          //   ),
          // ],
        ),
        drawer: const AdminDrawer(),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Адрес'),
                            Text('Телефон'),
                            Text('Товар'),
                            Text('Статус заказа'),
                          ],
                        ),
                        AdminButtons(
                          function: () {},
                          // => RepoAdminPage().assignDriver(),
                          text: 'Назначить',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.blue[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {},
                      // => RepoAdminPage().freeOrder(),
                      child: const Text('Свободные'),
                    ),
                    TextButton(
                      onPressed: () {},
                      // => RepoAdminPage().assignedOrder(),
                      child: const Text('Назначенные'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
