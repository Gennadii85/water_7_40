// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../../../core/var_manager.dart';

class ReportCardManager extends StatelessWidget {
  const ReportCardManager({
    Key? key,
    required this.docID,
    required this.address,
    required this.summa,
    required this.phoneClient,
    required this.goodsList,
    required this.payManager,
    required this.payCar,
    required this.carID,
    required this.created,
    required this.delivered,
  }) : super(key: key);
  final String docID;
  final String address;
  final int summa;
  final String phoneClient;
  final Map goodsList;
  final int payManager;
  final int payCar;
  final int carID;
  final int created;
  final int delivered;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Row(
          children: [Expanded(child: Text(address))],
          // value: address,
          // name: 'Адрес:',
        ),
        children: [
          RowEntity(
            value: phoneClient,
            name: 'Телефон',
          ),
          RowEntity(
            value: summa.toString(),
            name: 'Сумма',
            grn: ' грн.',
          ),
          RowEntity(
            value: payManager.toString(),
            name: 'Заработок менеджера',
            grn: ' грн.',
          ),
          RowEntity(
            value: payCar.toString(),
            name: 'Заработок водителя',
            grn: ' грн.',
          ),
          RowEntity(
            value: carID.toString(),
            name: 'ID водителя',
          ),
          RowEntity(
            value: created.toString(),
            name: 'Создан',
          ),
          RowEntity(
            value: delivered.toString(),
            name: 'Отгружен',
          ),
          _listGoods(),
        ],
      ),
    );
  }

  ListView _listGoods() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: goodsList.entries
          .map(
            (e) => ListTile(
              shape: const Border(top: BorderSide()),
              title: Text(
                e.key.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              trailing: Text(
                '${e.value.toString()} шт.',
                style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 20,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class RowEntity extends StatelessWidget {
  const RowEntity({
    Key? key,
    required this.value,
    required this.name,
    this.grn,
  }) : super(key: key);

  final String value;
  final String name;
  final String? grn;

  @override
  Widget build(BuildContext context) {
    String text = '';
    if (grn == null) {
      text = value;
    } else {
      text = value + grn!;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: VarManager.cardSize,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              softWrap: true,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                text,
                style: VarManager.cardOrderStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 50,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
