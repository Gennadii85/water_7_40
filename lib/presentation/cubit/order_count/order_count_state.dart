// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'order_count_cubit.dart';

class OrderCountState {
  PriceEntity priceEntity;
  int allMoney;
  List<CreateOrderGoodsEntity> goodsList;
  List<CityModel> addressData;
  CreateOrderAddressEntity addressEntity;
  OrderCountState({
    required this.priceEntity,
    required this.allMoney,
    required this.goodsList,
    required this.addressData,
    required this.addressEntity,
  });
}

class OrderCountInitState extends OrderCountState {
  int managerMoney;
  int? percentManager;
  OrderCountInitState({
    required this.managerMoney,
    this.percentManager,
    required super.priceEntity,
    required super.allMoney,
    required super.goodsList,
    required super.addressData,
    required super.addressEntity,
  });
}

class OrderCountValueState extends OrderCountState {
  int managerMoney;
  int? percentManager;
  OrderCountValueState({
    required this.managerMoney,
    this.percentManager,
    required super.priceEntity,
    required super.allMoney,
    required super.goodsList,
    required super.addressData,
    required super.addressEntity,
  });
}
