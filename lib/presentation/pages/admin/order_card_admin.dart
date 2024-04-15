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
  final OrderModel orderModel;
  final List<UsersRegistrationModel> carList;
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
            title: RowEntity(
              value: address,
              name: 'Адрес:',
            ),
            subtitle: RowEntity(
              value: carID == null
                  ? 'не назначен'
                  : carList
                          .where((element) => element.id == carID)
                          .first
                          .nickname ??
                      carID.toString(),
              name: 'Водитель',
            ),
            trailing: IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return showCarList(context);
                },
              ),
              icon: const Icon(Icons.car_crash_outlined),
            ),
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

  AlertDialog showCarList(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: MediaQuery.sizeOf(context).width - 20,
        height: MediaQuery.sizeOf(context).height / 3,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: carList.length,
          itemBuilder: (context, index) => Row(
            children: [
              Expanded(
                flex: 4,
                child: TextButton(
                  onPressed: () {
                    RepoAdminGetPost()
                        .saveCarIDtoOrders(carList[index].id!, docID);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    carList[index].nickname ?? carList[index].id.toString(),
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: SizedBox(
                        width: MediaQuery.sizeOf(context).width - 20,
                        height: MediaQuery.sizeOf(context).height / 3,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              infoRow('Логин', carList[index].name),
                              infoRow('Пароль', carList[index].password),
                              infoRow('ID', carList[index].id.toString()),
                              infoRow('Max', carList[index].max.toString()),
                              infoRow('Имя', carList[index].nickname ?? ''),
                              infoRow('Телефон', carList[index].phone ?? ''),
                              infoRow('Заметки', carList[index].notes ?? ''),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.info_outline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row infoRow(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(fontSize: 18, color: Colors.blue[500]),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const SizedBox(height: 10),
      ],
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
