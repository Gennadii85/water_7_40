// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/data/model/price_model.dart';
import 'package:water_7_40/presentation/cubit/order_count/order_count_cubit.dart';
import 'package:water_7_40/presentation/pages/manager/price_card.dart';

class PriceBody extends StatelessWidget {
  const PriceBody({
    Key? key,
    required this.price,
  }) : super(key: key);
  final List<PriceModel> price;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCountCubit, OrderCountState>(
      builder: (context, state) {
        final cubit = BlocProvider.of<OrderCountCubit>(context);
        return ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.countList.length,
          itemBuilder: (context, indexModel) {
            int cou = 0;
            List<PriceModel> priceModelList = price
                .where(
                  (elem) =>
                      elem.categoryName ==
                      state.countList[indexModel].entries.first.key,
                )
                .toList();
            return ExpansionTile(
              title: Text(state.countList[indexModel].entries.first.key),
              childrenPadding: const EdgeInsets.all(8),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(),
              ),
              children: priceModelList.map((elem) {
                PriceCard card = PriceCard(
                  goods: elem.goodsName,
                  prise: elem.goodsPrice.toString(),
                  count: state.countList[indexModel].entries.first.value[cou],
                  index: cou,
                  addCount: (index) => cubit.addCount(indexModel, index),
                  delCount: (index) => cubit.delCount(indexModel, index),
                );
                cou++;
                return card;
              }).toList(),
            );
          },
        );
      },
    );
  }
}
