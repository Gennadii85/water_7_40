// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'report_general_cubit.dart';

class ReportGeneralState {
  final DateTime startDate;
  final DateTime finishDate;
  final List<OrderModel> cityStreetListModel;
  final List<OrderModel> cityStreetHouseListModel;
  final List<OrderModel> cityStreetHouseApartmentListModel;
  final bool isData;
  ReportGeneralState({
    required this.startDate,
    required this.finishDate,
    required this.cityStreetListModel,
    required this.cityStreetHouseListModel,
    required this.cityStreetHouseApartmentListModel,
    required this.isData,
  });
}

class ReportGeneralLoaded extends ReportGeneralState {
  ReportGeneralLoaded({
    required super.startDate,
    required super.finishDate,
    required super.cityStreetListModel,
    required super.cityStreetHouseListModel,
    required super.cityStreetHouseApartmentListModel,
    required super.isData,
  });
}
