// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'report_manager_cubit.dart';

class ReportManagerState {
  final UsersRegistrationModel manager;
  final DateTime startDate;
  final DateTime finishDate;
  final List<OrderModel> listModel;
  final bool isData;
  ReportManagerState({
    required this.manager,
    required this.startDate,
    required this.finishDate,
    required this.listModel,
    required this.isData,
  });
}

// class ReportManagerInitial extends ReportManagerState {
//   final DateTime startDate;
//   final DateTime finishDate;
//   final List<OrderModel> listModel;
//   ReportManagerInitial({
//     required this.startDate,
//     required this.finishDate,
//     required this.listModel,
//   });
// }

class ReportManagerLoaded extends ReportManagerState {
  ReportManagerLoaded({
    required super.manager,
    required super.startDate,
    required super.finishDate,
    required super.listModel,
    required super.isData,
  });
}
