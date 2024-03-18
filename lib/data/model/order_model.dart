// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderModel {
  final DateTime created;
  final DateTime? delivered;
  final num summa;
  final int? managerID;
  final num? managerProfit;
  final int? carID;
  final num? carProfit;
  final Map goodsList;
  final String address;
  final String phoneClient;
  final bool isDone;
  final bool takeMoney;
  final String? notes;

  OrderModel({
    required this.created,
    this.delivered,
    required this.summa,
    this.managerID,
    this.managerProfit,
    this.carID,
    this.carProfit,
    required this.goodsList,
    required this.address,
    required this.phoneClient,
    required this.isDone,
    required this.takeMoney,
    this.notes,
  });

  static OrderModel fromFirebase(Map<String, dynamic> json) => OrderModel(
        created: (json['created']).toDate(),
        delivered: json['delivered'],
        summa: json['summa'],
        managerID: json['managerID'],
        managerProfit: json['managerProfit'],
        carID: json['carID'],
        carProfit: json['carProfit'],
        goodsList: json['goodsList'],
        address: json['address'],
        phoneClient: json['phoneClient'],
        isDone: json['isDone'],
        takeMoney: json['takeMoney'],
        notes: json['notes'],
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
        'address': address,
        'phoneClient': phoneClient,
        'isDone': isDone,
        'takeMoney': takeMoney,
        'notes': notes,
      };
}
