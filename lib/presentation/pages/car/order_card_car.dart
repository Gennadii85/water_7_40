// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';

import '../../../core/var_manager.dart';
import '../../../data/repositories/cars_page_repo.dart';

class OrderCardCar extends StatelessWidget {
  const OrderCardCar({
    Key? key,
    required this.docID,
    required this.address,
    this.notes,
    required this.summa,
    required this.phoneClient,
    required this.isDone,
    required this.takeMoney,
    required this.goodsList,
    this.phoneManager,
  }) : super(key: key);

  final String docID;
  final String address;
  final String? notes;
  final int summa;
  final String phoneClient;
  final bool isDone;
  final bool takeMoney;
  final Map goodsList;
  final String? phoneManager;
  @override
  Widget build(BuildContext context) {
    String take = '';
    if (takeMoney) {
      take = 'По доставке';
    } else {
      take = 'У менеджера';
    }
    return Card(
      elevation: 3,
      child: Column(
        children: [
          ExpansionTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: RowEntity(value: address, name: 'Адрес:'),
            subtitle: RowEntity(value: phoneClient, name: 'Телефон:'),
            children: [
              RowEntity(
                value: summa.toString(),
                name: 'Сумма:',
                grn: ' грн.',
              ),
              RowEntity(
                value: take,
                name: 'Инкассация:',
              ),
              RowEntity(
                value: notes ?? '',
                name: 'Примечания:',
              ),
              _listGoods(),
              AdminButtons(
                text: 'Доставлено',
                function: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text('Заказ доставлен?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            RepoCarPage().markDelivered(docID);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Да',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Нет',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
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
