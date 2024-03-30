// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'report_manager_cubit.dart';

class ReportManagerState {
  final DateTime startDate;
  final DateTime finishDate;
  final List<OrderModel> listModel;
  ReportManagerState({
    required this.startDate,
    required this.finishDate,
    required this.listModel,
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

// class ReportManagerLoaded extends ReportManagerState {
//   final DateTime startDate;
//   final DateTime finishDate;
//   final List<OrderModel> listModel;
//   ReportManagerLoaded({
//     required this.startDate,
//     required this.finishDate,
//     required this.listModel,
//   });
// }
