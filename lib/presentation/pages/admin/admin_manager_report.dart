// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/var_admin.dart';
import '../../../data/model/order_model.dart';
import '../../../data/model/users_registration_model.dart';
import '../../../data/repositories/admin/admin_manager_report_repo.dart';
import '../../../data/repositories/admin/admin_page_manager_repo.dart';
import '../../cubit/report_manager/report_manager_cubit.dart';
import 'admin_buttons.dart';
import 'widgets_managers/report_card_manager.dart';

class AdminManagerReport extends StatelessWidget {
  const AdminManagerReport({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReportManagerCubit cubit = BlocProvider.of(context);
    ExpansionTileController controller = ExpansionTileController();
    return SafeArea(
      // debugShowCheckedModeBanner: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Отчетность'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<List<UsersRegistrationModel>>(
            future: RepoAdminGetPost().getAllManagers(),
            builder: (context, snapshotManager) {
              if (snapshotManager.hasData) {
                List<UsersRegistrationModel> managersData =
                    snapshotManager.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<ReportManagerCubit, ReportManagerState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          checkManager(
                            state,
                            controller,
                            managersData,
                            cubit,
                          ),
                          const SizedBox(height: 10),
                          startDate(state, context, cubit),
                          const SizedBox(height: 10),
                          finishDate(state, context, cubit),
                          const SizedBox(height: 10),
                          AdminButtons(
                            text: 'Показать',
                            function: () => cubit.getStartFinishOrders(),
                          ),
                          cubit.state.isData
                              ? getStartFinishOrders(state)
                              : const SizedBox(),
                        ],
                      );
                    },
                  ),
                );
              } else if (snapshotManager.hasError) {
                return const Center(
                  child: Text('Не удалось получить список менеджеров.'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<OrderModel>> getStartFinishOrders(
    ReportManagerState state,
  ) {
    return StreamBuilder<List<OrderModel>>(
      stream: RepoAdminManagersReport().getStartFinishOrders(
        state.startDate,
        state.finishDate,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<OrderModel> orderList = snapshot.data!
              .where(
                (element) => element.managerID == state.manager.id!,
              )
              .toList();
          int profit = summaProfit(orderList);
          int salary = salaryProfit(orderList);
          int moneyPaid = profit - salary;
          int cash = cashManager(orderList);
          return Column(
            children: [
              Text(
                'Касса у менеджера: $cash грн.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                'Всего заказов: ${orderList.length}. Начислено З/П: $profit грн.',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Оплачено З/П: $moneyPaid грн.',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Задолженность по З/П: $salary грн.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Красный цвет - долг по кассе.    Кнопка зеленая - не заплачена З/П',
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderList.length,
                itemBuilder: (context, index) => ReportCardManager(
                  address: orderList[index].address,
                  summa: orderList[index].summa.toInt(),
                  goodsList: orderList[index].goodsList,
                  payManager: orderList[index].managerProfit ?? 0,
                  carID: orderList[index].carID,
                  created: orderList[index].created,
                  delivered: orderList[index].delivered,
                  docID: orderList[index].docID!,
                  payMoneyManager: orderList[index].payMoneyManager,
                  isDone: orderList[index].isDone,
                  takeMoney: orderList[index].takeMoney,
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Ошибка загрузки данных заказов.'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Container finishDate(
    ReportManagerState state,
    BuildContext context,
    ReportManagerCubit cubit,
  ) {
    return Container(
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
              final selectedDate = await calendar(context, DateTime.now());
              if (selectedDate != null) {
                cubit.addFinish(selectedDate);
              }
            },
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
    );
  }

  Container startDate(
    ReportManagerState state,
    BuildContext context,
    ReportManagerCubit cubit,
  ) {
    return Container(
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
              final selectedDate = await calendar(context, DateTime.now());
              if (selectedDate != null) {
                cubit.addStart(selectedDate);
              }
            },
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
    );
  }

  ExpansionTile checkManager(
    ReportManagerState state,
    ExpansionTileController controller,
    List<UsersRegistrationModel> managersData,
    ReportManagerCubit cubit,
  ) {
    return ExpansionTile(
      collapsedBackgroundColor: Colors.blue[200],
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        state.manager.nickname ?? state.manager.name,
      ),
      controller: controller,
      children: managersData
          .map(
            (elem) => TextButton(
              onPressed: () {
                cubit.checkManager(elem);
                controller.collapse();
              },
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(elem.nickname ?? ''),
                  ),
                  Expanded(
                    child: Text('ID ${elem.id!}'),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  int cashManager(List<OrderModel> orderList) {
    //касса у менеджера на руках
    int profit = 0;
    if (orderList.isNotEmpty) {
      List list = [];
      for (var element in orderList) {
        if (element.takeMoney) {
        } else if (element.isDone != true) {
          list.add(element.summa);
        }
      }
      if (list.isNotEmpty) {
        int summa = list.reduce((value, element) => value + element).toInt();
        profit = summa;
      }
    }
    return profit;
  }

  int summaProfit(List<OrderModel> orderList) {
    //весь заработок с заказов
    int profit = 0;
    if (orderList.isNotEmpty) {
      List list = [];
      for (var element in orderList) {
        list.add(element.managerProfit ?? 0);
      }
      int profitManager =
          list.reduce((value, element) => value + element).toInt();
      profit = profitManager;
    }
    return profit;
  }

  int salaryProfit(List<OrderModel> orderList) {
    //не выплаченный заработок
    int profit = 0;
    if (orderList.isNotEmpty) {
      List list = [];
      for (var element in orderList) {
        if (element.payMoneyManager) {
        } else {
          list.add(element.managerProfit ?? 0);
        }
      }
      if (list.isNotEmpty) {
        int salaryManager =
            list.reduce((value, element) => value + element).toInt();
        profit = salaryManager;
      }
    }
    return profit;
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
