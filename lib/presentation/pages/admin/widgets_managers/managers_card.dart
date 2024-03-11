// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../core/var_admin.dart';

class ManagersCard extends StatelessWidget {
  final String name;
  final String password;
  final String phone;
  final String docID;
  final String managerID;
  final String percent;
  final Function function;
  const ManagersCard({
    Key? key,
    required this.name,
    required this.password,
    required this.phone,
    required this.docID,
    required this.managerID,
    required this.percent,
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
                  ),
                  Text(
                    ' Пароль:    $password',
                    style: VarAdmin.adminCardText,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    maxLines: 5,
                  ),
                  Text(
                    ' Телефон:    $phone',
                    style: VarAdmin.adminCardText,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    maxLines: 5,
                  ),
                  Text(
                    ' ID:    $managerID',
                    style: VarAdmin.adminCardText,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    maxLines: 5,
                  ),
                  Text(
                    ' %:    $percent',
                    style: VarAdmin.adminCardText,
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => function(docID),
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
