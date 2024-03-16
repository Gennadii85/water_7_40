class PriceModel {
  final String goodsName;
  final num goodsPrice;
  final bool manager;
  // final int driver;
  final int id;

  PriceModel({
    required this.goodsName,
    required this.goodsPrice,
    required this.manager,
    // required this.driver,
    required this.id,
  });

  static PriceModel fromFirebase(Map<String, dynamic> json) => PriceModel(
        goodsName: json['name'],
        goodsPrice: json['money'],
        manager: json['manager'],
        // driver: json['driver'],
        id: json['id'],
      );
  Map<String, dynamic> toFirebase() => {
        'name': goodsName,
        'money': goodsPrice,
        'manager': manager,
        // 'driver': driver,
        'id': id,
      };
}
