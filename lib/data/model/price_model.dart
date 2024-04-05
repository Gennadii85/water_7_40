class PriceModel {
  final String? id;
  final String goodsName;
  final int goodsPrice;
  final int? piecesPercentValueManager; //какой процент на каждую штуку
  final int? piecesMoneyValueManager; //сколько денег на каждую штуку
  final int?
      existenceMoneyValueManager; // денег за наличие в заказе неважно сколько шт.
  final bool managerPercent;
  final int? piecesPercentValueCar;
  final int? piecesMoneyValueCar;
  final int? existenceMoneyValueCar;
  final String categoryName;
  final bool isActive;

  PriceModel({
    this.id,
    required this.goodsName,
    required this.goodsPrice,
    this.piecesPercentValueManager,
    this.piecesMoneyValueManager,
    required this.existenceMoneyValueManager,
    required this.managerPercent,
    this.piecesPercentValueCar,
    this.piecesMoneyValueCar,
    this.existenceMoneyValueCar,
    required this.categoryName,
    required this.isActive,
  });

  static PriceModel fromFirebase(Map<String, dynamic> json, String id) =>
      PriceModel(
        id: id,
        goodsName: json['goodsName'],
        goodsPrice: json['goodsPrice'],
        piecesPercentValueManager: json['piecesPercentValueManager'],
        piecesMoneyValueManager: json['piecesMoneyValueManager'],
        existenceMoneyValueManager: json['existenceMoneyValueManager'],
        managerPercent: json['managerPercent'],
        piecesPercentValueCar: json['piecesPercentValueCar'],
        piecesMoneyValueCar: json['piecesMoneyValueCar'],
        existenceMoneyValueCar: json['existenceMoneyValueCar'],
        categoryName: json['categoryName'],
        isActive: json['isActive'],
      );
  Map<String, dynamic> toFirebase() => {
        'goodsName': goodsName,
        'goodsPrice': goodsPrice,
        'piecesPercentValueManager': piecesPercentValueManager,
        'piecesMoneyValueManager': piecesMoneyValueManager,
        'existenceMoneyValueManager': existenceMoneyValueManager,
        'managerPercent': managerPercent,
        'piecesPercentValueCar': piecesPercentValueCar,
        'piecesMoneyValueCar': piecesMoneyValueCar,
        'existenceMoneyValueCar': existenceMoneyValueCar,
        'categoryName': categoryName,
        'isActive': isActive,
      };
}
