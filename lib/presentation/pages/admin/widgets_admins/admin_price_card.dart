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
  }) : super(key: key);
  final String id;
  final String name;
  final int prise;
  final String managerMethod;
  final String managerMethodValue;
  final String carMethod;
  final String carMethodValue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
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
                              AdminPageRepo().deletePrice(id);
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
