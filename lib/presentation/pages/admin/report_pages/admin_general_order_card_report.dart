// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import '../../../../core/var_manager.dart';

class OrderCardAdminGeneralReport extends StatelessWidget {
  const OrderCardAdminGeneralReport({
    Key? key,
    required this.createDate,
    required this.docID,
    this.carID,
    required this.managerID,
    required this.address,
    this.notes,
    required this.summa,
    required this.phoneClient,
    required this.isDone,
    required this.takeMoney,
    required this.goodsList,
    required this.payManager,
    required this.payCar,
    required this.time,
    required this.name,
  }) : super(key: key);

  final DateTime createDate;
  final String docID;
  final int? carID;
  final int managerID;
  final String address;
  final String? notes;
  final int summa;
  final String phoneClient;
  final bool isDone;
  final bool takeMoney;
  final Map goodsList;
  final int payManager;
  final int payCar;
  final String time;
  final String name;
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
            title: Text(createDate.millisecondsSinceEpoch.toString()),
            children: [
              RowEntity(
                value:
                    '${createDate.day} - ${createDate.month} - ${createDate.year}  в ${createDate.hour} : ${createDate.minute}',
                name: 'Создан:',
              ),
              RowEntity(
                value: summa.toString(),
                name: 'Сумма:',
                grn: ' грн.',
              ),
              RowEntity(
                value: time,
                name: 'Время:',
              ),
              RowEntity(
                value: managerID.toString(),
                name: 'Менеджер:',
              ),
              RowEntity(
                value: payManager.toString(),
                name: 'Заработок менеджера:',
                grn: ' грн.',
              ),
              RowEntity(
                value: payCar.toString(),
                name: 'Заработок водителя:',
                grn: ' грн.',
              ),
              RowEntity(
                value: notes ?? '',
                name: 'Примечания:',
              ),
              RowEntity(
                value: phoneClient,
                name: 'Телефон:',
              ),
              RowEntity(
                value: name,
                name: 'Ф.И.О.:',
              ),
              RowEntity(
                value: take,
                name: 'Инкассация:',
              ),
              ...goodsList.entries
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
            ],
          ),
        ],
      ),
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
