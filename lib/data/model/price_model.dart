class PriceModel {
  final String? id;
  final String goodsName;
  final int goodsPrice;
  final int? piecesPercentValueManager; //какой процент на каждую штуку
  final int? piecesMoneyValueManager; //сколько денег на каждую штуку
  final int?
      existenceMoneyValueManager; // денег за наличие в заказе неважно сколько шт.
  final int? piecesPercentValueCar;
  final int? piecesMoneyValueCar;
  final int? existenceMoneyValueCar;

  PriceModel({
    this.id,
    required this.goodsName,
    required this.goodsPrice,
    this.piecesPercentValueManager,
    this.piecesMoneyValueManager,
    required this.existenceMoneyValueManager,
    this.piecesPercentValueCar,
    this.piecesMoneyValueCar,
    this.existenceMoneyValueCar,
  });

  static PriceModel fromFirebase(Map<String, dynamic> json, String id) =>
      PriceModel(
        id: id,
        goodsName: json['goodsName'],
        goodsPrice: json['goodsPrice'],
        piecesPercentValueManager: json['piecesPercentValueManager'],
        piecesMoneyValueManager: json['piecesMoneyValueManager'],
        existenceMoneyValueManager: json['existenceMoneyValueManager'],
        piecesPercentValueCar: json['piecesPercentValueCar'],
        piecesMoneyValueCar: json['piecesMoneyValueCar'],
        existenceMoneyValueCar: json['existenceMoneyValueCar'],
      );
  Map<String, dynamic> toFirebase() => {
        'goodsName': goodsName,
        'goodsPrice': goodsPrice,
        'piecesPercentValueManager': piecesPercentValueManager,
        'piecesMoneyValueManager': piecesMoneyValueManager,
        'existenceMoneyValueManager': existenceMoneyValueManager,
        'piecesPercentValueCar': piecesPercentValueCar,
        'piecesMoneyValueCar': piecesMoneyValueCar,
        'existenceMoneyValueCar': existenceMoneyValueCar,
      };
}
