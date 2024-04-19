import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import 'package:water_7_40/presentation/pages/cars_page.dart';
import '../../../core/var_core.dart';
import '../../../core/var_manager.dart';
import '../../../data/entity/car_cargo_entity.dart';
import '../../../data/model/order_model.dart';
import '../../../data/repositories/cars_page_repo.dart';

class CarCargo extends StatelessWidget {
  CarCargo({super.key});
  final int carsID = Hive.box(VarHive.nameBox).get(VarHive.carsID);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Берем на борт .....'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<OrderModel>>(
          stream: RepoCarPage().getTodayOrders(carsID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<OrderModel> noDeliveredList = snapshot.data!
                  .where(
                    (element) => element.delivered == null,
                  )
                  .toList();
              List<String> listName = [];
              List<int> listCount = [];
              for (var element in noDeliveredList) {
                final Map goodsMap = element.goodsList;
                for (var element in goodsMap.entries) {
                  final entity = CarCargoEntity(
                    goodsName: element.key,
                    count: element.value,
                  );
                  if (listName.contains(entity.goodsName)) {
                    int index = listName.indexOf(entity.goodsName);
                    int val = listCount.elementAt(index);
                    listCount.setAll(index, {val + entity.count});
                  } else {
                    listName.add(entity.goodsName);
                    listCount.add(entity.count);
                  }
                }
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Список позиций'),
                    ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      padding: const EdgeInsets.all(10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listName.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(
                                listName[index],
                                style: VarManager.cardOrderStyle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                listCount[index].toString(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    AdminButtons(
                      text: 'Назад',
                      function: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CarsPage(),
                        ),
                      ),
                    ),
                  ],
                ),
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
        ),
      ),
    );
  }
}
