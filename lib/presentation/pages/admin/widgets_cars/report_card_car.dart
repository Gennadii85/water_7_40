// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import '../../../../core/var_manager.dart';
import '../../../../data/repositories/admin/admin_car_report_repo.dart';

class ReportCardCar extends StatelessWidget {
  const ReportCardCar({
    Key? key,
    required this.docID,
    required this.address,
    required this.summa,
    required this.goodsList,
    required this.payCar,
    required this.managerID,
    required this.created,
    required this.delivered,
    required this.payMoneyCar,
    required this.isDone,
    required this.takeMoney,
  }) : super(key: key);
  final String docID;
  final String address;
  final int summa;
  final Map goodsList;
  final int payCar;
  final int? managerID;
  final int created;
  final int? delivered;
  final bool payMoneyCar;
  final bool isDone;
  final bool takeMoney;
  @override
  Widget build(BuildContext context) {
    String createdData =
        '${DateTime.fromMillisecondsSinceEpoch(created).day} - ${DateTime.fromMillisecondsSinceEpoch(created).month} - ${DateTime.fromMillisecondsSinceEpoch(created).year}';
    String deliveredData = 'Не отгружен';
    if (delivered != null) {
      deliveredData =
          '${DateTime.fromMillisecondsSinceEpoch(delivered!).day} - ${DateTime.fromMillisecondsSinceEpoch(delivered!).month} - ${DateTime.fromMillisecondsSinceEpoch(delivered!).year}';
    }
    return Card(
      elevation: 5,
      child: ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        collapsedBackgroundColor: isDone ? Colors.grey[300] : Colors.red[100],
        title: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(address),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => payMoneyCar
                    ? RepoAdminCarsReport().checkPayMoneyCarFalse(docID)
                    : RepoAdminCarsReport().checkPayMoneyCarTrue(docID),
                style: IconButton.styleFrom(
                  backgroundColor: payMoneyCar ? null : Colors.blue[100],
                ),
                child: const Text('З/П'),
              ),
            ),
            Expanded(
              child: takeMoney == false
                  ? const SizedBox()
                  : TextButton(
                      onPressed: () => isDone
                          ? RepoAdminCarsReport().checkPayFalse(docID)
                          : RepoAdminCarsReport().checkPayTrue(docID),
                      style: IconButton.styleFrom(
                        backgroundColor: isDone ? null : Colors.blue[100],
                      ),
                      child: const Text('Касса'),
                    ),
            ),
          ],
        ),
        children: [
          RowEntity(
            value: summa.toString(),
            name: 'Сумма',
            grn: ' грн.',
          ),
          RowEntity(
            value:
                '${payCar.toString()} грн.   ${payMoneyCar ? 'Оплачен' : 'Не оплачен'}',
            name: 'Заработок водителя',
          ),
          RowEntity(
            value: isDone ? 'Оплачено' : 'Не оплачено',
            name: 'Расчет по заказу',
          ),
          RowEntity(
            value: takeMoney ? 'Водитель' : 'Менеджер',
            name: 'Кто инкассировал',
          ),
          RowEntity(
            value: managerID.toString(),
            name: 'ID менеджера',
          ),
          RowEntity(
            value: createdData,
            name: 'Создан',
          ),
          RowEntity(
            value: deliveredData,
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
