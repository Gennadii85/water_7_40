import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const Spacer(),
          ListView(
            shrinkWrap: true,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('Водители'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Менеджеры'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Клиенты'),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
