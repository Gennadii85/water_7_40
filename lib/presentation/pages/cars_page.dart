import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_7_40/presentation/pages/manager/managers_drawer.dart';

import '../../core/var_core.dart';
import '../../data/model/order_model.dart';
import '../../data/repositories/cars_page_repo.dart';
import 'car/order_card_car.dart';

class CarsPage extends StatelessWidget {
  CarsPage({super.key});
  final int carsID = Hive.box(VarHive.nameBox).get(VarHive.carsID);
  final int today =
      DateTime.now().millisecondsSinceEpoch - DateTime.now().hour * 3600000;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cars panel'),
          centerTitle: true,
        ),
        drawer: const ManagersDrawer(),
        body: StreamBuilder<List<OrderModel>>(
          stream: RepoCarPage().getTodayOrders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final orders = snapshot.data!;
              final List<OrderModel> noDeliveredList = orders
                  .where(
                    (element) => element.delivered == null,
                  )
                  .toList();
              final List<OrderModel> deliveredTodayList = orders
                  .where(
                    (element) =>
                        element.delivered != null && element.delivered! > today,
                  )
                  .toList();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Ожидают доставки'),
                    const SizedBox(height: 15),
                    listOrders(noDeliveredList),
                    const SizedBox(height: 15),
                    const Text('За текущий день'),
                    const SizedBox(height: 15),
                    listOrders(deliveredTodayList),
                    const SizedBox(height: 30),
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
  }

  ListView listOrders(List<OrderModel> list) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) => OrderCardCar(
        address: list[index].address,
        summa: list[index].summa.toInt(),
        phoneClient: list[index].phoneClient,
        isDone: list[index].isDone,
        takeMoney: list[index].takeMoney,
        goodsList: list[index].goodsList,
        notes: list[index].notes,
        docID: list[index].docID!,
      ),
    );
  }
}
