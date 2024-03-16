// ignore_for_file: public_member_api_docs, sort_constructors_first
class PriceModel {
  final String goodsName;
  final num goodsPrice;
  final bool manager;
  final int driver;
  PriceModel({
    required this.goodsName,
    required this.goodsPrice,
    required this.manager,
    required this.driver,
  });

  static PriceModel fromFirebase(Map<String, dynamic> json) => PriceModel(
        goodsName: json['name'],
        goodsPrice: json['money'],
        manager: json['manager'],
        driver: json['driver'],
      );
  Map<String, dynamic> toFirebase() => {
        'name': goodsName,
        'money': goodsPrice,
        'manager': manager,
        'driver': driver,
      };
}
