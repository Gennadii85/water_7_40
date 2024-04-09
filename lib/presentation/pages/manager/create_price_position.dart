import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import '../../../core/var_manager.dart';
import '../../cubit/order_count/order_count_cubit.dart';
import 'create_order.dart';
import 'price_card.dart';

class CreatePricePosition extends StatefulWidget {
  const CreatePricePosition({
    Key? key,
  }) : super(key: key);

  @override
  State<CreatePricePosition> createState() => _CreatePricePositionState();
}

class _CreatePricePositionState extends State<CreatePricePosition> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: BlocBuilder<OrderCountCubit, OrderCountState>(
            builder: (context, state) {
              final cubit = BlocProvider.of<OrderCountCubit>(context);
              return Column(
                children: [
                  const SizedBox(height: 20),
                  const Text('Выберите позиции и количество'),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.priceEntity.categoriesList.length,
                      itemBuilder: (context, indexCategories) {
                        int cou = 0;
                        return ExpansionTile(
                          title: Text(
                            state.priceEntity.categoriesList[indexCategories]
                                .nameCategories,
                          ),
                          childrenPadding: const EdgeInsets.all(8),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(),
                          ),
                          children: state.priceEntity
                              .categoriesList[indexCategories].priceModelList
                              .map((elem) {
                            final card = PriceCard(
                              goods: elem.goodsName,
                              prise: elem.goodsPrice.toString(),
                              count: state
                                  .priceEntity
                                  .categoriesList[indexCategories]
                                  .countList[cou],
                              index: cou,
                              addCount: (index) =>
                                  cubit.addCount(indexCategories, index),
                              delCount: (index) =>
                                  cubit.delCount(indexCategories, index),
                            );
                            cou++;
                            return card;
                          }).toList(),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'Заказ на сумму: ${state.allMoney} грн.',
                    style: VarManager.cardSize,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdminButtons(
                        text: 'Применить',
                        function: () {
                          cubit.saveFinalPrice();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CreateOrder(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
