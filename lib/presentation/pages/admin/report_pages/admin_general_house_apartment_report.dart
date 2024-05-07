import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/report_all/report_general_cubit.dart';

class AdminGeneralHouseApartmentReport extends StatelessWidget {
  const AdminGeneralHouseApartmentReport({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: BlocBuilder<ReportGeneralCubit, ReportGeneralState>(
          builder: (context, state) {
            List<String> allApartment = [];
            if (state.cityStreetHouseApartmentListModel.isNotEmpty) {
              for (var element in state.cityStreetHouseApartmentListModel) {
                allApartment.add(element.addressList[3].toString());
              }
            }
            List<String> apartment = allApartment.toSet().toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: apartment.length,
                itemBuilder: (context, index) => Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text('квартира:   ${apartment[index]}'),
                        onPressed: () {},
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
}
