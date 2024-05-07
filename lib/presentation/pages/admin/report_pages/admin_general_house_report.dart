import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/order_model.dart';
import '../../../cubit/report_all/report_general_cubit.dart';
import 'admin_general_house_apartment_report.dart';

class AdminGeneralHouseReport extends StatelessWidget {
  const AdminGeneralHouseReport({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<ReportGeneralCubit, ReportGeneralState>(
          builder: (context, state) {
            List<String> allHouse = [];
            if (state.cityStreetHouseListModel.isNotEmpty) {
              for (var element in state.cityStreetHouseListModel) {
                allHouse.add(element.addressList[2].toString());
              }
            }
            List<String> house = allHouse.toSet().toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: house.length,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text('номер дома:    ${house[index]}'),
                        onPressed: () {
                          goApartment(state, house, index, context);
                        },
                      ),
                      IconButton(
                        onPressed: () {},
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

  void goApartment(
    ReportGeneralState state,
    List<String> house,
    int index,
    BuildContext context,
  ) {
    List<OrderModel> cityStreetHouseApartmentListModel = state
        .cityStreetHouseListModel
        .where((element) => element.addressList[2] == house[index])
        .toList();
    BlocProvider.of<ReportGeneralCubit>(context)
        .setApartmentList(cityStreetHouseApartmentListModel);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AdminGeneralHouseApartmentReport(),
      ),
    );
  }
}
