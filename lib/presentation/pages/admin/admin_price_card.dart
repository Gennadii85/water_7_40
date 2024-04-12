// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:water_7_40/data/repositories/admin/admin_page_manager_repo.dart';

class AdminPriceCard extends StatelessWidget {
  const AdminPriceCard({
    Key? key,
    required this.id,
    required this.name,
    required this.prise,
    required this.managerMethod,
    required this.managerMethodValue,
    required this.carMethod,
    required this.carMethodValue,
    required this.isActive,
  }) : super(key: key);
  final String id;
  final String name;
  final int prise;
  final String managerMethod;
  final String managerMethodValue;
  final String carMethod;
  final String carMethodValue;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ExpansionTile(
        collapsedBackgroundColor:
            isActive ? Colors.blue[200] : Colors.grey[200],
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(name)),
            Text('${prise.toString()} грн'),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text('Начисления менеджеру:'),
                Text('${managerMethodValue.toString()} $managerMethod'),
                const Text('Начисления водителю:'),
                Text('${carMethodValue.toString()} $carMethod'),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.red[200]),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: const Text('Удалить эту позицию ?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () {
                              RepoAdminPage().deletePrice(id);
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text('Удалить'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isActive ? Colors.blue[200] : Colors.grey[200],
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Text(
                          isActive ? 'Убрать из прайса ?' : 'Вернуть в прайс ?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () {
                              isActive
                                  ? RepoAdminPage().deActivatedPrice(id)
                                  : RepoAdminPage().activatedPrice(id);
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    isActive ? 'Убрать из прайса ?' : 'Вернуть в прайс ?',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
