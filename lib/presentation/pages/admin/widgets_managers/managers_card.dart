// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/data/repositories/admin/admin_manager_report_repo.dart';
import 'package:water_7_40/presentation/cubit/report_manager/report_manager_cubit.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import '../../../../core/var_admin.dart';
import '../../../../data/model/order_model.dart';
import 'report_card_manager.dart';

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
                function: () => _getMoney(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  dynamic _getMoney(context) {
    DateTime date = DateTime.now();
    return showDialog(
      context: context,
      builder: (context) => BlocBuilder<ReportManagerCubit, ReportManagerState>(
        builder: (context, state) {
          ReportManagerCubit cubit = BlocProvider.of(context);
          return Padding(
            padding: const EdgeInsets.all(50),
            child: Scaffold(
              body: StreamBuilder<List<OrderModel>>(
                stream: RepoAdminManagersReport().getAllOrders(
                  int.parse(managerID),
                  state.startDate,
                  state.finishDate,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final orderList = data;
                    print(orderList);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Логин: $name     ID: $managerID',
                                style: VarAdmin.adminCardText,
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orderList.length,
                            itemBuilder: (context, index) => ReportCardManager(
                              address: orderList[index].address,
                              summa: orderList[index].summa.toInt(),
                              phoneClient: orderList[index].phoneClient,
                              goodsList: orderList[index].goodsList,
                              payManager: orderList[index].managerProfit ?? 0,
                              payCar: orderList[index].carProfit ?? 0,
                              carID: orderList[index].carID ?? 0,
                              created: orderList[index].created,
                              delivered: orderList[index].delivered ?? 0,
                              docID: orderList[index].docID!,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Ошибка загрузки данных.'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Expanded modelList(List<OrderModel> orderList) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orderList.length,
        itemBuilder: (context, index) => ReportCardManager(
          address: orderList[index].address,
          summa: orderList[index].summa.toInt(),
          phoneClient: orderList[index].phoneClient,
          goodsList: orderList[index].goodsList,
          payManager: orderList[index].managerProfit ?? 0,
          payCar: orderList[index].carProfit ?? 0,
          carID: orderList[index].carID ?? 0,
          created: orderList[index].created,
          delivered: orderList[index].delivered ?? 0,
          docID: orderList[index].docID!,
        ),
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
