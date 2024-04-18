// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';

import '../../../core/var_manager.dart';
import '../../../data/model/users_registration_model.dart';
import '../../../data/repositories/cars_page_repo.dart';

class OrderCardCar extends StatelessWidget {
  final List<UsersRegistrationModel> managersList;
  final DateTime createDate;
  final String docID;
  final int managerID;
  final String address;
  final String notes;
  final int summa;
  final String phoneClient;
  final bool takeMoney;
  final Map goodsList;
  final int payCar;
  final String time;
  final String name;
  final bool buttonUI;
  const OrderCardCar({
    Key? key,
    required this.managersList,
    required this.createDate,
    required this.docID,
    required this.managerID,
    required this.address,
    required this.notes,
    required this.summa,
    required this.phoneClient,
    required this.takeMoney,
    required this.goodsList,
    required this.payCar,
    required this.time,
    required this.name,
    required this.buttonUI,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String take = '';
    if (takeMoney) {
      take = 'По доставке';
    } else {
      take = 'У менеджера';
    }
    String manager = '';
    String managerPhone = '';
    if (managersList.where((element) => element.id! == managerID).isNotEmpty) {
      if (managersList
          .where((element) => element.id! == managerID)
          .first
          .nickname!
          .isNotEmpty) {
        manager = managersList
            .where((element) => element.id! == managerID)
            .first
            .nickname!;
      } else {
        manager = managerID.toString();
      }
      if (managersList
          .where((element) => element.id! == managerID)
          .first
          .phone!
          .isNotEmpty) {
        managerPhone = managersList
            .where((element) => element.id! == managerID)
            .first
            .phone!;
      }
    } else {
      manager = managerID.toString();
    }
    return Card(
      elevation: 3,
      child: Column(
        children: [
          ExpansionTile(
            controlAffinity: ListTileControlAffinity.leading,
            title: RowEntity(value: address, name: 'Адрес:'),
            subtitle: RowEntity(value: time, name: 'Время:'),
            children: [
              RowEntity(value: summa.toString(), name: 'Сумма:', grn: ' грн.'),
              RowEntity(value: take, name: 'Инкассация:'),
              RowEntity(value: notes, name: 'Примечания:'),
              RowEntity(
                value:
                    '${createDate.day} - ${createDate.month} - ${createDate.year}  в ${createDate.hour} : ${createDate.minute}',
                name: 'Создан:',
              ),
              RowEntity(
                value: '$manager тел.- $managerPhone',
                name: 'Менеджер:',
              ),
              RowEntity(value: payCar.toString(), name: 'З/П:'),
              RowEntity(value: phoneClient, name: 'Телефон:'),
              RowEntity(value: name, name: 'Ф.И.О.:'),
              _listGoods(),
              buttonUI
                  ? AdminButtons(
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
                    )
                  : const SizedBox(),
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
