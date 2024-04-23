part of 'report_car_cubit.dart';

class ReportCarState {
  final UsersRegistrationModel car;
  final DateTime startDate;
  final DateTime finishDate;
  final List<OrderModel> listModel;
  final bool isData;
  ReportCarState({
    required this.car,
    required this.startDate,
    required this.finishDate,
    required this.listModel,
    required this.isData,
  });
}

class ReportCarLoaded extends ReportCarState {
  ReportCarLoaded({
    required super.car,
    required super.startDate,
    required super.finishDate,
    required super.listModel,
    required super.isData,
  });
}
