import 'package:flutter/material.dart';
import 'package:water_7_40/core/var_admin.dart';
import 'package:water_7_40/presentation/pages/admin/report_pages/admin_general_report.dart';
import 'package:water_7_40/presentation/pages/admin/widgets_admins/add_admin.dart';
import 'package:water_7_40/presentation/pages/admin/widgets_cars/add_cars.dart';
import 'package:water_7_40/presentation/pages/admin/widgets_managers/add_managers.dart';
import 'package:water_7_40/presentation/pages/admins_page.dart';

import '../identical_page.dart';
import 'admin_add_address.dart';
import 'report_pages/admin_car_report.dart';
import 'report_pages/admin_manager_report.dart';
import 'create_price_page.dart';

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
                  MaterialPageRoute(builder: (context) => const AdminPage()),
                ),
                child: const Text(
                  'Админ панель',
                  style: VarAdmin.adminDrawerText,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddCars()),
                ),
                child: const Text(
                  'Водители',
                  style: VarAdmin.adminDrawerText,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddManagers()),
                ),
                child: const Text(
                  'Менеджеры',
                  style: VarAdmin.adminDrawerText,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddAdmin()),
                ),
                child: const Text(
                  'Админы',
                  style: VarAdmin.adminDrawerText,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CreatePricePage(),
                  ),
                ),
                child: const Text(
                  'Прайс лист',
                  style: VarAdmin.adminDrawerText,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminAddAddress(),
                  ),
                ),
                child: const Text(
                  'Добавить адрес',
                  style: VarAdmin.adminDrawerText,
                ),
              ),
              const SizedBox(height: 40),
              ExpansionTile(
                expandedCrossAxisAlignment: CrossAxisAlignment.center,
                title: const Text(
                  'Отчеты',
                  style: VarAdmin.adminDrawerText,
                ),
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AdminManagerReport(),
                      ),
                    ),
                    child: const Text(
                      'Отчеты менеджера',
                      style: VarAdmin.adminDrawerText,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AdminCarReport(),
                      ),
                    ),
                    child: const Text(
                      'Отчеты водителя',
                      style: VarAdmin.adminDrawerText,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AdminGeneralReport(),
                      ),
                    ),
                    child: const Text(
                      'Общий по фирме',
                      style: VarAdmin.adminDrawerText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const IdenticalPage(),
                  ),
                ),
                child: const Text(
                  'Смена аккаунта',
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
