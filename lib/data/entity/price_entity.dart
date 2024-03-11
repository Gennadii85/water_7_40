class PriceEntity {
  final String goodsName;
  final num goodsPrice;
  PriceEntity({
    required this.goodsName,
    required this.goodsPrice,
  });

  static PriceEntity fromJson(Map<String, dynamic> json) => PriceEntity(
        goodsName: json['name'],
        goodsPrice: json['money'],
      );
  Map<String, dynamic> toJson() => {
        'name': goodsName,
        'money': goodsPrice,
      };
}
