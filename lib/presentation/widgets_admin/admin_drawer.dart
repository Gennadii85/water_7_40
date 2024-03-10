import 'package:flutter/material.dart';
import 'package:water_7_40/presentation/widgets_admin/add_admin.dart';
import 'package:water_7_40/presentation/pages/widgets_car/add_cars.dart';

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
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddCars()),
                ),
                child: const Text('Водители'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Менеджеры'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddAdmin()),
                ),
                child: const Text('Админы'),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
