import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/var_core.dart';
import '../../data/model/order_model.dart';
import '../../data/model/users_registration_model.dart';
import '../../data/repositories/admin/admin_page_manager_repo.dart';
import '../../data/repositories/cars_page_repo.dart';
import 'car/cars_drawer.dart';
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
          title: Text('Cars panel  ID: ${carsID.toString()}'),
          centerTitle: true,
        ),
        drawer: const CarsDrawer(),
        body: StreamBuilder<List<OrderModel>>(
          stream: RepoCarPage().getTodayOrders(carsID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final orders = snapshot.data!;
              final List<OrderModel> noDeliveredList =
                  orders.where((element) => element.delivered == null).toList();
              final List<OrderModel> deliveredTodayList = orders
                  .where(
                    (element) =>
                        element.delivered != null && element.delivered! > today,
                  )
                  .toList();
              int casa = 0;
              List<int> listSumma = [];
              if (deliveredTodayList.isNotEmpty) {
                for (var element in deliveredTodayList) {
                  if (element.takeMoney) {
                    listSumma.add(element.summa.toInt());
                  } else {
                    listSumma.add(0);
                  }
                  casa = listSumma.reduce((value, element) => value + element);
                }
              }
              return FutureBuilder<List<UsersRegistrationModel>>(
                future: RepoAdminGetPost().getAllManagers(),
                builder: (context, snapshotManager) {
                  if (snapshotManager.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text('Ожидают доставки'),
                          const SizedBox(height: 15),
                          listOrders(
                            noDeliveredList,
                            snapshotManager.data!,
                            true,
                          ),
                          const SizedBox(height: 15),
                          const Text('За текущий день'),
                          const SizedBox(height: 15),
                          Text('Касса за день :   $casa  грн.'),
                          const SizedBox(height: 15),
                          listOrders(
                            deliveredTodayList,
                            snapshotManager.data!,
                            false,
                          ),
                          const SizedBox(height: 30),
                        ],
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

  ListView listOrders(
    List<OrderModel> list,
    List<UsersRegistrationModel> snapshotManager,
    bool buttonUI,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) => OrderCardCar(
        managersList: snapshotManager,
        createDate: DateTime.fromMillisecondsSinceEpoch(list[index].created),
        docID: list[index].docID ?? '',
        managerID: list[index].managerID ?? 0,
        address: list[index].address,
        summa: list[index].summa.toInt(),
        phoneClient: list[index].phoneClient,
        takeMoney: list[index].takeMoney,
        goodsList: list[index].goodsList,
        payCar: list[index].carProfit ?? 0,
        time: list[index].time ?? '',
        name: list[index].name ?? '',
        notes: list[index].notes ?? '',
        buttonUI: buttonUI,
      ),
    );
  }
}
