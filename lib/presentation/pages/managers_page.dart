import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/data/model/price_model.dart';
import 'package:water_7_40/presentation/cubit/order_count/order_count_cubit.dart';
import 'package:water_7_40/presentation/pages/manager/goods_card.dart';
import '../../core/var_manager.dart';
import '../../data/repositories/manager_page_repo.dart';
import 'admin/admin_buttons.dart';
import 'manager/widgets/managers_drawer.dart';

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
        body: StreamBuilder<List<PriceModel>>(
          stream: RepoManagerPage().getPrice(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final prise = snapshot.data!;
              return BlocProvider(
                create: (context) => OrderCountCubit(prise),
                child: BlocBuilder<OrderCountCubit, OrderCountState>(
                  builder: (context, state) {
                    final cubit = BlocProvider.of<OrderCountCubit>(context);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.prise.length,
                            itemBuilder: (context, index) => GoodsCard(
                              goods: state.prise[index].goodsName,
                              prise: state.prise[index].goodsPrice.toString(),
                              count: state.listCount[index],
                              id: state.prise[index].id,
                              addCount: () => cubit.addCount(index),
                              delCount: () => cubit.delCount(index),
                            ),
                          ),
                          const SizedBox(height: 15),
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
                          const SizedBox(height: 15),
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
                          const SizedBox(height: 15),
                          AdminButtons(
                            text: 'Заказать',
                            function: () => cubit.writeOrder(),
                          ),
                          const SizedBox(height: 15),
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
