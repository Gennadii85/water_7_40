import 'package:flutter/material.dart';
import 'package:water_7_40/core/var_admin.dart';

class AdminCard extends StatelessWidget {
  final String name;
  final String password;
  final Function function;
  const AdminCard({
    Key? key,
    required this.name,
    required this.password,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Логин:    $name',
                    style: VarAdmin.adminCardText,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    maxLines: 5,
                  ),
                  Text(
                    ' Пароль:    $password',
                    style: VarAdmin.adminCardText,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              onPressed: () => function(name),
              icon: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
