import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/data/model/order_model.dart';
import '../../../../data/repositories/admin/admin_general_report_repo.dart';
import '../../../cubit/report_all/report_general_cubit.dart';
import '../admin_buttons.dart';
import 'admin_general_house_report.dart';

class AdminGeneralStreetReport extends StatelessWidget {
  const AdminGeneralStreetReport({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<ReportGeneralCubit, ReportGeneralState>(
          builder: (context, state) {
            List<String> allStreet = [];
            if (state.cityStreetListModel.isNotEmpty) {
              for (var element in state.cityStreetListModel) {
                allStreet.add(element.addressList[1].toString());
              }
            }
            List<String> street = allStreet.toSet().toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: street.length,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text(street[index]),
                        onPressed: () {
                          goHouse(state, street, index, context);
                        },
                      ),
                      IconButton(
                        onPressed: () => cityInfo(
                          context,
                          street,
                          index,
                          state.cityStreetListModel,
                        ),
                        icon: const Icon(Icons.info_outline_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<dynamic> cityInfo(
    BuildContext context,
    List<String> street,
    int index,
    List<OrderModel> orderList,
  ) {
    List<OrderModel> list = orderList
        .where((element) => element.addressList[1] == street[index])
        .toList();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(street[index]),
        content: Column(
          children: [
            Text('Всего заказов:   ${list.length}'),
            Text(
              'Общий оборот:   ${RepoAdminGeneralReport().summaAllMoney(list)} грн.',
            ),
            Text(
              'Заплачено водителям:   ${RepoAdminGeneralReport().carProfit(list)} грн.',
            ),
            Text(
              'Заплачено менеджерам:   ${RepoAdminGeneralReport().managerProfit(list)} грн.',
            ),
            ExpansionTile(
              title: const Text('Список продаж:'),
              children: RepoAdminGeneralReport()
                  .allCityGoods(list)
                  .map(
                    (elem) => SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(border: Border.all()),
                          child: Row(
                            children: [
                              Expanded(flex: 5, child: Text(elem.goodsName)),
                              Expanded(
                                child: Text('${elem.count.toString()} шт.'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        actions: [
          AdminButtons(
            text: 'OK',
            function: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void goHouse(
    ReportGeneralState state,
    List<String> street,
    int index,
    BuildContext context,
  ) {
    List<OrderModel> cityStreetHouseListModel = state.cityStreetListModel
        .where((element) => element.addressList[1] == street[index])
        .toList();
    BlocProvider.of<ReportGeneralCubit>(context)
        .setHouseList(cityStreetHouseListModel);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AdminGeneralHouseReport(),
      ),
    );
  }
}
