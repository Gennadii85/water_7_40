part of 'report_general_cubit.dart';

class ReportGeneralState {
  // final UsersRegistrationModel manager;
  final DateTime startDate;
  final DateTime finishDate;
  // final List<OrderModel> listModel;
  final bool isData;
  ReportGeneralState({
    // required this.manager,
    required this.startDate,
    required this.finishDate,
    // required this.listModel,
    required this.isData,
  });
}

class ReportGeneralLoaded extends ReportGeneralState {
  ReportGeneralLoaded({
    // required super.manager,
    required super.startDate,
    required super.finishDate,
    // required super.listModel,
    required super.isData,
  });
}
