import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/var_admin.dart';
import '../../../../data/model/order_model.dart';
import '../../../../data/repositories/admin/admin_general_report_repo.dart';
import '../../../cubit/report_all/report_general_cubit.dart';
import '../admin_buttons.dart';
import 'admin_general_street_report.dart';

class AdminGeneralReport extends StatelessWidget {
  const AdminGeneralReport({super.key});

  @override
  Widget build(BuildContext context) {
    ReportGeneralCubit cubit = BlocProvider.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<ReportGeneralCubit, ReportGeneralState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    startDate(state, context, cubit),
                    const SizedBox(height: 10),
                    finishDate(state, context, cubit),
                    const SizedBox(height: 20),
                    AdminButtons(
                      text: 'Показать',
                      function: () => cubit.getStartFinishOrders(),
                    ),
                    const SizedBox(height: 20),
                    cubit.state.isData ? getCity(state) : const SizedBox(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  StreamBuilder<List<OrderModel>> getCity(
    ReportGeneralState state,
  ) {
    return StreamBuilder<List<OrderModel>>(
      stream: RepoAdminGeneralReport().getStartFinishOrders(
        state.startDate,
        state.finishDate.add(const Duration(days: 1)),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<OrderModel> orderList = snapshot.data!;
          List<String> allCity = [];
          if (orderList.isNotEmpty) {
            for (var element in orderList) {
              allCity.add(element.addressList[0].toString());
            }
          }
          List<String> city = allCity.toSet().toList();
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: city.length,
            itemBuilder: (context, index) => Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: BlocBuilder<ReportGeneralCubit, ReportGeneralState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text(city[index]),
                        onPressed: () {
                          goStreet(orderList, city, index, context);
                        },
                      ),
                      IconButton(
                        onPressed: () =>
                            cityInfo(context, city, index, orderList),
                        icon: const Icon(Icons.info_outline_rounded),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Ошибка загрузки данных заказов.'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<dynamic> cityInfo(
    BuildContext context,
    List<String> city,
    int index,
    List<OrderModel> orderList,
  ) {
    List<OrderModel> list = orderList
        .where((element) => element.addressList[0] == city[index])
        .toList();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(city[index]),
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

  void goStreet(
    List<OrderModel> orderList,
    List<String> city,
    int index,
    BuildContext context,
  ) {
    List<OrderModel> cityStreetListModel = orderList
        .where((element) => element.addressList[0] == city[index])
        .toList();
    BlocProvider.of<ReportGeneralCubit>(context)
        .setCityList(cityStreetListModel);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AdminGeneralStreetReport()),
    );
  }

  Container finishDate(
    ReportGeneralState state,
    BuildContext context,
    ReportGeneralCubit cubit,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'По',
                  style: VarAdmin.adminCardText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '${state.finishDate.day} - ${state.finishDate.month} - ${state.finishDate.year}',
                  style: VarAdmin.adminCardText,
                ),
              ),
              IconButton(
                onPressed: () async {
                  final selectedDate = await calendar(context, DateTime.now());
                  if (selectedDate != null) {
                    cubit.addFinish(selectedDate);
                  }
                },
                icon: const Icon(Icons.calendar_month),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container startDate(
    ReportGeneralState state,
    BuildContext context,
    ReportGeneralCubit cubit,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              'От',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              '${state.startDate.day} - ${state.startDate.month} - ${state.startDate.year}',
              style: VarAdmin.adminCardText,
            ),
          ),
          IconButton(
            onPressed: () async {
              final selectedDate = await calendar(context, DateTime.now());
              if (selectedDate != null) {
                cubit.addStart(selectedDate);
              }
            },
            icon: const Icon(Icons.calendar_month),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> calendar(BuildContext context, DateTime date) {
    return showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2024),
      lastDate: DateTime(2050),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
  }
}
