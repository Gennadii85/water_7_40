import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_7_40/data/model/price_model.dart';
import 'package:water_7_40/presentation/cubit/order_count/order_count_cubit.dart';
import 'package:water_7_40/presentation/pages/manager/goods_card.dart';
import '../../core/var_core.dart';
import '../../core/var_manager.dart';
import '../../data/repositories/manager_page_repo.dart';
import 'admin/admin_buttons.dart';

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
          actions: [
            AdminButtons(
              function: () => setState(() {}),
              text: 'Обновить',
            ),
          ],
        ),
        body: StreamBuilder<List<PriceModel>>(
          stream: RepoManagerPage().getPrice(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final prise = snapshot.data!;
              final List<int> countList =
                  List<int>.generate(prise.length, (index) => 0);
              final int percentManager = int.parse(
                Hive.box(VarHive.nameBox).get(VarHive.managersPercent),
              );
              return BlocProvider(
                create: (context) => OrderCountCubit(countList, percentManager),
                child: BlocBuilder<OrderCountCubit, OrderCountState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: prise.length,
                            itemBuilder: (context, index) => GoodsCard(
                              goods: prise[index].goodsName,
                              prise: prise[index].goodsPrice.toString(),
                              count: state.listCount[index],
                              addCount: () =>
                                  BlocProvider.of<OrderCountCubit>(context)
                                      .addCount(index, prise),
                              delCount: () =>
                                  BlocProvider.of<OrderCountCubit>(context)
                                      .delCount(index, prise),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Заказ на сумму: ${state.allMoney.toString()} грн.',
                                  style: VarManager.cardSize,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Прибыль менеджера: ${state.managerMoney.toString()} грн.',
                                  style: VarManager.cardSize,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
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
}
