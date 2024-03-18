import 'package:flutter/material.dart';
import 'package:water_7_40/data/model/order_model.dart';
import 'package:water_7_40/presentation/pages/manager/create_order.dart';
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Manager panel'),
          centerTitle: true,
        ),
        drawer: const ManagersDrawer(),
        body: StreamBuilder<List<OrderModel>>(
          stream: RepoManagerPage().getOrders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final orders = snapshot.data!;
              final List<OrderModel> noDeliveredList =
                  orders.where((element) => element.delivered == null).toList();
              final List<OrderModel> createdList = orders;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Ожидают доставки'),
                    const SizedBox(height: 15),
                    _noDelivered(noDeliveredList),
                    const SizedBox(height: 15),
                    const Text('За текущий месяц'),
                    const SizedBox(height: 15),
                    _created(createdList),
                    const SizedBox(height: 30),
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
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  ListView _created(List<OrderModel> createdList) {
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
      itemBuilder: (context, index) => Column(
        children: [
          Text(noDeliveredList[index].created.toString()),
        ],
      ),
    );
  }
}
