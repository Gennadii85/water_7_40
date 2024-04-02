// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/presentation/cubit/report_manager/report_manager_cubit.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import '../../../../core/var_admin.dart';
import '../report_page.dart';

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
      child: Column(
        children: [
          Row(
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
          ExpansionTile(
            title: const Text(
              'Отчеты',
              style: TextStyle(color: Colors.blue),
            ),
            tilePadding: const EdgeInsets.only(left: 50),
            children: [
              AdminButtons(
                text: 'Зарплата за период',
                function: () => _getMoney(context, int.tryParse(managerID)),
              ),
            ],
          ),
        ],
      ),
    );
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
