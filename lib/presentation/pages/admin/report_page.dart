// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/order_model.dart';
import '../../../data/repositories/admin/admin_manager_report_repo.dart';
import '../../cubit/report_manager/report_manager_cubit.dart';
import 'widgets_managers/report_card_manager.dart';

class ReportPage extends StatelessWidget {
  final int? id;
  final bool
      position; //если менеджер - true  если водитель - false => что считать определяет
  const ReportPage({
    Key? key,
    required this.id,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ReportManagerCubit cubit = BlocProvider.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Отчетность'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Итого за период:'),
              const SizedBox(height: 50),
              StreamBuilder<List<OrderModel>>(
                stream: RepoAdminManagersReport().getAllOrders(
                  cubit.state.startDate,
                  cubit.state.finishDate,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int searchID = id ?? 0;
                    List<OrderModel> orderList = snapshot.data!
                        .where((element) => element.managerID == searchID)
                        .toList();
                    int profit = summa(orderList);
                    return Column(
                      children: [
                        Text(
                          'Всего заказов ${orderList.length}. Начислено $profit грн.',
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
            ],
          ),
        ),
      ),
    );
  }

  int summa(List<OrderModel> orderList) {
    int profit = 0;
    if (position && orderList.isNotEmpty) {
      List list = [];
      for (var element in orderList) {
        list.add(element.managerProfit ?? 0);
      }
      int profitManager =
          list.reduce((value, element) => value + element).toInt();
      profit = profitManager;
    }
    if (position != true && orderList.isNotEmpty) {
      List list = [];
      for (var element in orderList) {
        list.add(element.carProfit ?? 0);
      }
      int profitCar = list.reduce((value, element) => value + element).toInt();
      profit = profitCar;
    }
    return profit;
  }
}
