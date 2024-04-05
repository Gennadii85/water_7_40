// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_count_cubit.dart';

class OrderCountState {
  int allMoney;
  int managerMoney;
  // List<ExpansionTile> modelList;
  List<PriceModel> price;
  List<Map<String, List<int>>> countList;
  int? percentManager;

  OrderCountState({
    required this.allMoney,
    required this.managerMoney,
    required this.price,
    required this.countList,
    required this.percentManager,
  });
}

class OrderCountInitState extends OrderCountState {
  OrderCountInitState({
    required super.allMoney,
    required super.managerMoney,
    // required super.modelList,
    required super.price,
    required super.percentManager,
    required super.countList,
  });
}

// class OrderCountUpdateInitState extends OrderCountState {
//   OrderCountUpdateInitState({
//     required super.allMoney,
//     required super.managerMoney,
//     required super.modelList,
//     // required super.priceModelList,
//     required super.percentManager,
//   });
// }
