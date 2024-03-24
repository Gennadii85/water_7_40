import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_7_40/data/model/order_model.dart';
import 'package:water_7_40/presentation/pages/manager/create_order.dart';
import '../../core/var_core.dart';
import '../../data/repositories/manager_page_repo.dart';
import 'admin/admin_buttons.dart';
import 'manager/managers_drawer.dart';
import 'manager/order_card.dart';

class ManagersPage extends StatefulWidget {
  const ManagersPage({super.key});

  @override
  State<ManagersPage> createState() => _ManagersPageState();
}

class _ManagersPageState extends State<ManagersPage> {
  final int managerID = Hive.box(VarHive.nameBox).get(VarHive.managersID);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Manager panel'),
          centerTitle: true,
          actions: [
            AdminButtons(
              text: 'Создать заказ',
              function: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateOrder(),
                ),
              ),
            ),
          ],
        ),
        drawer: const ManagersDrawer(),
        body: StreamBuilder<List<OrderModel>>(
          stream: RepoManagerPage().getTodayOrders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final orders = snapshot.data!;
              final List<OrderModel> noDeliveredList = orders
                  .where(
                    (element) =>
                        element.delivered == null &&
                        element.managerID == managerID,
                  )
                  .toList();
              final List<OrderModel> allOrdersList = orders
                  .where(
                    (element) =>
                        element.delivered != null &&
                        element.managerID == managerID,
                  )
                  .toList();
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Ожидают доставки'),
                    const SizedBox(height: 15),
                    _noDelivered(noDeliveredList),
                    const SizedBox(height: 15),
                    const Text('За текущий день'),
                    const SizedBox(height: 15),
                    _createdToday(allOrdersList),
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

  ListView _createdToday(List<OrderModel> createdList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: createdList.length,
      itemBuilder: (context, index) => OrderCard(
        address: createdList[index].address,
        summa: createdList[index].summa.toInt(),
        phoneClient: createdList[index].phoneClient,
        isDone: createdList[index].isDone,
        takeMoney: createdList[index].takeMoney,
        goodsList: createdList[index].goodsList,
        notes: createdList[index].notes,
      ),
    );
  }

  ListView _noDelivered(List<OrderModel> noDeliveredList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: noDeliveredList.length,
      itemBuilder: (context, index) => OrderCard(
        address: noDeliveredList[index].address,
        summa: noDeliveredList[index].summa.toInt(),
        phoneClient: noDeliveredList[index].phoneClient,
        isDone: noDeliveredList[index].isDone,
        takeMoney: noDeliveredList[index].takeMoney,
        goodsList: noDeliveredList[index].goodsList,
        notes: noDeliveredList[index].notes,
      ),
    );
  }
}
