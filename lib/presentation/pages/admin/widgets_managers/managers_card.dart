import 'package:flutter/material.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import '../../../../core/var_manager.dart';
import '../../../../data/repositories/admin/create_user_repo.dart';

class ManagersCard extends StatelessWidget {
  final String name;
  final String password;
  final String phone;
  final String docID;
  final String managerID;
  final String percent;
  final Function function;
  final String nickname;
  final String notes;
  const ManagersCard({
    Key? key,
    required this.name,
    required this.password,
    required this.phone,
    required this.docID,
    required this.managerID,
    required this.percent,
    required this.function,
    required this.nickname,
    required this.notes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 5,
      child: ExpansionTile(
        title: RowEntity(value: nickname, name: 'Имя:'),
        subtitle: RowEntity(value: managerID, name: 'ID:'),
        trailing: IconButton(
          onPressed: () => function(docID),
          icon: const Icon(
            Icons.delete_forever_outlined,
            color: Colors.red,
          ),
        ),
        children: [
          RowEntity(value: name, name: 'Логин:'),
          RowEntity(value: password, name: 'Пароль:'),
          RowEntity(value: phone, name: 'Телефон:'),
          RowEntity(value: percent, name: 'Процент:'),
          RowEntity(value: notes, name: 'Заметки:'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AdminButtons(
              text: 'Редактировать',
              function: () => showDialog(
                context: context,
                builder: (context) {
                  TextEditingController passwordControl =
                      TextEditingController(text: password);
                  TextEditingController percentControl =
                      TextEditingController(text: percent);
                  TextEditingController nicknameControl =
                      TextEditingController(text: nickname);
                  TextEditingController phoneControl =
                      TextEditingController(text: phone);
                  TextEditingController notesControl =
                      TextEditingController(text: notes);

                  return AlertDialog(
                    content: SingleChildScrollView(
                      child: Column(
                        children: [
                          textField(passwordControl, 'Пароль'),
                          textField(percentControl, 'Процент'),
                          textField(nicknameControl, 'Имя'),
                          textField(phoneControl, 'Телефон'),
                          textField(notesControl, 'Заметки'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AdminButtons(
                                text: 'Сохранить',
                                function: () {
                                  RepoCreateUser().redactManager(
                                    context,
                                    nicknameControl.text,
                                    passwordControl.text,
                                    phoneControl.text,
                                    percentControl.text,
                                    notesControl.text,
                                    docID,
                                  );
                                },
                              ),
                              AdminButtons(
                                text: 'Отменить',
                                function: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Padding textField(
  TextEditingController controller,
  String labelText,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
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
    ),
  );
}

class RowEntity extends StatelessWidget {
  const RowEntity({
    Key? key,
    required this.value,
    required this.name,
  }) : super(key: key);

  final String value;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: VarManager.cardSize,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              softWrap: true,
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                value,
                style: VarManager.cardOrderStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 50,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
