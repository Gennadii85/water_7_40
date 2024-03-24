import 'package:flutter/material.dart';
import 'package:water_7_40/presentation/pages/admin/admin_drawer.dart';
import '../../data/model/order_model.dart';
import '../../data/model/users_registration_model.dart';
import '../../data/repositories/admin/admin_page_manager_repo.dart';
import 'admin/order_card_admin.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Admin panel'),
          centerTitle: true,
          // actions: [
          //   AdminButtons(
          //     function: () {},
          // => RepoAdminPage().update(),
          //     text: 'Обновить',
          //   ),
          // ],
        ),
        drawer: const AdminDrawer(),
        body: FutureBuilder(
          future: AdminGetPostRepo().getAllCars(),
          builder: (context, snapshotCar) {
            if (snapshotCar.hasData) {
              List<UsersRegistrationModel> carList = snapshotCar.data!;
              return StreamBuilder<List<OrderModel>>(
                stream: AdminGetPostRepo().getAllOrders(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final orders = snapshot.data!;
                    final List<OrderModel> hoCarList = orders
                        .where((element) => element.carID == null)
                        .toList();
                    final List<OrderModel> waitDeliveredList = orders
                        .where(
                          (element) =>
                              element.delivered == null &&
                              element.carID != null,
                        )
                        .toList();
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text('Ожидают распределения'),
                          const SizedBox(height: 15),
                          chowOrder(hoCarList, carList),
                          const SizedBox(height: 30),
                          const Text('Распределены и ожидают доставки'),
                          const SizedBox(height: 30),
                          chowOrder(waitDeliveredList, carList),
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
              );
            } else if (snapshotCar.hasError) {
              return const Center(
                child: Text('Ошибка загрузки водителей.'),
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

  ListView chowOrder(
    List<OrderModel> createdList,
    List<UsersRegistrationModel> carList,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: createdList.length,
      itemBuilder: (context, index) => OrderCardAdmin(
        carList: carList,
        docID: createdList[index].docID!,
        address: createdList[index].address,
        summa: createdList[index].summa.toInt(),
        phoneClient: createdList[index].phoneClient,
        isDone: createdList[index].isDone,
        takeMoney: createdList[index].takeMoney,
        goodsList: createdList[index].goodsList,
        notes: createdList[index].notes,
        payManager: createdList[index].managerProfit ?? 0,
        payCar: createdList[index].carProfit ?? 0,
      ),
    );
  }
}
