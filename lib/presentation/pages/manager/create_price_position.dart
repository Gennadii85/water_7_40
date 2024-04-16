// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import '../../../core/var_manager.dart';
import '../../cubit/order_count/order_count_cubit.dart';
import 'create_order.dart';
import 'price_card.dart';

class CreatePricePosition extends StatefulWidget {
  final bool? route;
  const CreatePricePosition({Key? key, this.route}) : super(key: key);

  @override
  State<CreatePricePosition> createState() => _CreatePricePositionState();
}

class _CreatePricePositionState extends State<CreatePricePosition> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.goodsList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      int money = state.goodsList[index].count *
                          state.goodsList[index].price;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          elevation: 4,
                          color: Colors.blue[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    state.goodsList[index].goodsName,
                                    style: VarManager.cardSize,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '1 шт. - ${state.goodsList[index].price} грн. ',
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${state.goodsList[index].count} шт. - $money грн.',
                                    style: VarManager.cardSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
                          if (widget.route != null) {
                            cubit.updateFinalPrice();
                            Navigator.of(context).pop();
                          } else {
                            cubit.saveFinalPrice();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CreateOrder(),
                              ),
                            );
                          }
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
