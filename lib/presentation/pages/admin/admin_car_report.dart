// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/var_admin.dart';
import '../../../data/model/order_model.dart';
import '../../../data/model/users_registration_model.dart';
import '../../../data/repositories/admin/admin_car_report_repo.dart';
import '../../../data/repositories/admin/admin_page_manager_repo.dart';
import '../../cubit/report_car/report_car_cubit.dart';
import 'admin_buttons.dart';
import 'widgets_cars/report_card_car.dart';

class AdminCarReport extends StatelessWidget {
  const AdminCarReport({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReportCarCubit cubit = BlocProvider.of(context);
    ExpansionTileController controller = ExpansionTileController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Отчетность'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<List<UsersRegistrationModel>>(
            future: RepoAdminGetPost().getAllCars(),
            builder: (context, snapshotCars) {
              if (snapshotCars.hasData) {
                List<UsersRegistrationModel> carsData = snapshotCars.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<ReportCarCubit, ReportCarState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          checkCar(
                            state,
                            controller,
                            carsData,
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
              } else if (snapshotCars.hasError) {
                return const Center(
                  child: Text('Не удалось получить список водителей.'),
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

  StreamBuilder<List<OrderModel>> getStartFinishOrders(ReportCarState state) {
    return StreamBuilder<List<OrderModel>>(
      stream: RepoAdminCarsReport().getStartFinishOrders(
        state.startDate,
        state.finishDate,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<OrderModel> orderList = snapshot.data!
              .where(
                (element) => element.carID == state.car.id!,
              )
              .toList();
          int profit = summaProfit(orderList);
          int salary = salaryProfit(orderList);
          int moneyPaid = profit - salary;
          int cash = cashCar(orderList);
          return Column(
            children: [
              Text(
                'Касса у водителя: $cash грн.',
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
                  'Красный цвет - долг по кассе.    Кнопка светиться - не заплачена З/П',
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderList.length,
                itemBuilder: (context, index) => ReportCardCar(
                  address: orderList[index].address,
                  summa: orderList[index].summa.toInt(),
                  goodsList: orderList[index].goodsList,
                  payCar: orderList[index].carProfit ?? 0,
                  managerID: orderList[index].managerID,
                  created: orderList[index].created,
                  delivered: orderList[index].delivered,
                  docID: orderList[index].docID!,
                  payMoneyCar: orderList[index].payMoneyCar,
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
    ReportCarState state,
    BuildContext context,
    ReportCarCubit cubit,
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
    ReportCarState state,
    BuildContext context,
    ReportCarCubit cubit,
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

  ExpansionTile checkCar(
    ReportCarState state,
    ExpansionTileController controller,
    List<UsersRegistrationModel> carsData,
    ReportCarCubit cubit,
  ) {
    return ExpansionTile(
      collapsedBackgroundColor: Colors.blue[200],
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        state.car.nickname ?? state.car.name,
      ),
      controller: controller,
      children: carsData
          .map(
            (elem) => TextButton(
              onPressed: () {
                cubit.checkCar(elem);
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

  int cashCar(List<OrderModel> orderList) {
    //касса у водителя на руках
    int profit = 0;
    if (orderList.isNotEmpty) {
      List list = [];
      for (var element in orderList) {
        if (element.takeMoney == false) {
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
        list.add(element.carProfit ?? 0);
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
        if (element.payMoneyCar) {
        } else {
          list.add(element.carProfit ?? 0);
        }
      }
      if (list.isNotEmpty) {
        int salaryCar =
            list.reduce((value, element) => value + element).toInt();
        profit = salaryCar;
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
