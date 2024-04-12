import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/presentation/cubit/report_manager/report_manager_cubit.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import '../../../../core/var_admin.dart';
import '../../../../core/var_manager.dart';
import '../../../../data/repositories/admin/create_user_repo.dart';
import '../report_page.dart';

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
          // AdminButtons(
          //   text: 'Зарплата за период',
          //   function: () => _getMoney(context, int.tryParse(managerID)),
          // ),
        ],
      ),
    );

    // Card(
    //   margin: const EdgeInsets.all(8),
    //   elevation: 5,
    //   child: Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Expanded(
    //             flex: 7,
    //             child: Padding(
    //               padding: const EdgeInsets.only(left: 15),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   Text(
    //                     'Логин:    $name',
    //                     style: VarAdmin.adminCardText,
    //                   ),
    //                   Text(
    //                     ' Пароль:    $password',
    //                     style: VarAdmin.adminCardText,
    //                     softWrap: true,
    //                     overflow: TextOverflow.clip,
    //                     maxLines: 5,
    //                   ),
    //                   Text(
    //                     ' Телефон:    $phone',
    //                     style: VarAdmin.adminCardText,
    //                     softWrap: true,
    //                     overflow: TextOverflow.clip,
    //                     maxLines: 5,
    //                   ),
    //                   Text(
    //                     ' ID:    $managerID',
    //                     style: VarAdmin.adminCardText,
    //                     softWrap: true,
    //                     overflow: TextOverflow.clip,
    //                     maxLines: 5,
    //                   ),
    //                   Text(
    //                     ' %:    $percent',
    //                     style: VarAdmin.adminCardText,
    //                     softWrap: true,
    //                     overflow: TextOverflow.clip,
    //                     maxLines: 5,
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           IconButton(
    //             onPressed: () => function(docID),
    //             icon: const Icon(
    //               Icons.delete_forever_outlined,
    //               color: Colors.red,
    //             ),
    //           ),
    //         ],
    //       ),
    //       ExpansionTile(
    //         title: const Text(
    //           'Отчеты',
    //           style: TextStyle(color: Colors.blue),
    //         ),
    //         tilePadding: const EdgeInsets.only(left: 50),
    //         children: [
    //           AdminButtons(
    //             text: 'Зарплата за период',
    //             function: () => _getMoney(context, int.tryParse(managerID)),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }

  dynamic _getMoney(context, int? id) {
    DateTime date = DateTime.now();
    return showDialog(
      context: context,
      builder: (context) => BlocBuilder<ReportManagerCubit, ReportManagerState>(
        builder: (context, state) {
          ReportManagerCubit cubit = BlocProvider.of(context);
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        'Логин: $name     ID: $managerID',
                        style:
                            const TextStyle(fontSize: 22, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'От',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          '${state.startDate.day} - ${state.startDate.month} - ${state.startDate.year}',
                          style: VarAdmin.adminCardText,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final selectedDate = await calendar(context, date);
                          if (selectedDate != null) {
                            cubit.addStart(selectedDate);
                          }
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'До',
                          style: VarAdmin.adminCardText,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          '${state.finishDate.day} - ${state.finishDate.month} - ${state.finishDate.year}',
                          style: VarAdmin.adminCardText,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final selectedDate = await calendar(context, date);
                          if (selectedDate != null) {
                            cubit.addFinish(selectedDate);
                          }
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                AdminButtons(
                  text: 'Показать',
                  function: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ReportPage(
                          id: id,
                          position: true,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<DateTime?> calendar(BuildContext context, DateTime date) {
    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
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
