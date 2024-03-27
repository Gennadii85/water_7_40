// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_count_cubit.dart';

class OrderCountState {
  List<int> listCount;
  int allMoney;
  int managerMoney;
  List<PriceModel> prise;
  int? percentManager;

  OrderCountState({
    required this.listCount,
    required this.allMoney,
    required this.managerMoney,
    required this.prise,
    required this.percentManager,
  });
}

class OrderCountInitState extends OrderCountState {
  OrderCountInitState({
    required super.listCount,
    required super.allMoney,
    required super.managerMoney,
    required super.prise,
    required super.percentManager,
  });
}
