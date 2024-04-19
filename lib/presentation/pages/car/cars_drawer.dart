import 'package:flutter/material.dart';
import 'package:water_7_40/core/var_admin.dart';
import 'package:water_7_40/presentation/pages/identical_page.dart';
import 'car_cargo.dart';

class CarsDrawer extends StatelessWidget {
  const CarsDrawer({super.key});

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
                  MaterialPageRoute(
                    builder: (context) => CarCargo(),
                  ),
                ),
                child: const Text(
                  'Посчитать загрузку',
                  style: VarAdmin.adminDrawerText,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const IdenticalPage(),
                  ),
                ),
                child: const Text(
                  'Смена аккаунта',
                  style: VarAdmin.adminDrawerText,
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
