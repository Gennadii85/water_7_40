// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import '../../../core/var_manager.dart';
import '../../../data/model/order_model.dart';
import '../../../data/model/users_registration_model.dart';
import '../../../data/repositories/admin/admin_page_manager_repo.dart';
import 'update_order.dart';

class OrderCardAdmin extends StatelessWidget {
  const OrderCardAdmin({
    Key? key,
    required this.orderModel,
    required this.carList,
    required this.docID,
    this.carID,
    required this.address,
    this.notes,
    required this.summa,
    required this.phoneClient,
    required this.isDone,
    required this.takeMoney,
    required this.goodsList,
    required this.payManager,
    required this.payCar,
  }) : super(key: key);
  final OrderModel orderModel;
  final List<UsersRegistrationModel> carList;
  final String docID;
  final int? carID;
  final String address;
  final String? notes;
  final int summa;
  final String phoneClient;
  final bool isDone;
  final bool takeMoney;
  final Map goodsList;
  final int payManager;
  final int payCar;
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
            title: RowEntity(
              value: address,
              name: 'Адрес:',
            ),
            subtitle: RowEntity(
              value: carID == null ? 'не назначен' : carID.toString(),
              name: 'Водитель',
            ),
            trailing: IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: carList
                          .map(
                            (elem) => TextButton(
                              onPressed: () {
                                RepoAdminGetPost()
                                    .saveCarIDtoOrders(elem.id!, docID);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                '${elem.name}   id:${elem.id}',
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              ),
              icon: const Icon(Icons.car_crash_outlined),
            ),
            children: [
              RowEntity(
                value: phoneClient,
                name: 'Телефон:',
              ),
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
              _listGoods(),
              AdminButtons(
                text: 'Изменить',
                function: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => deleteOrder(context),
                          child: const Text(
                            'Удалить',
                            style: TextStyle(color: Colors.red, fontSize: 22),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UpdateOrder(
                                  model: orderModel,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Изменить',
                            style: TextStyle(color: Colors.blue, fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<dynamic> deleteOrder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text('Удалить ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              RepoAdminPage().deleteOrder(docID);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Удалить'),
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
