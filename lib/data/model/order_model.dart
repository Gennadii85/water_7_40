class OrderModel {
  final DateTime created;
  final DateTime? delivered;
  final num summa;
  final int? managerID;
  final num? managerProfit;
  final int? carID;
  final num? carProfit;
  final Map goodsList;
  OrderModel({
    required this.created,
    this.delivered,
    required this.summa,
    this.managerID,
    this.managerProfit,
    this.carID,
    this.carProfit,
    required this.goodsList,
  });

  static OrderModel fromFirebase(Map<String, dynamic> json) => OrderModel(
        created: json['created'],
        delivered: json['delivered'] ?? '',
        summa: json['summa'],
        managerID: json['managerID'] ?? '0',
        managerProfit: json['managerProfit'] ?? '0',
        carID: json['carID'] ?? '0',
        carProfit: json['carProfit'] ?? '0',
        goodsList: json['goodsList'],
      );
  Map<String, dynamic> toFirebase() => {
        'created': created,
        'delivered': delivered,
        'summa': summa,
        'managerID': managerID,
        'managerProfit': managerProfit,
        'carID': carID,
        'carProfit': carProfit,
        'goodsList': goodsList,
      };
}
