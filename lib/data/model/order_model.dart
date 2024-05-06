// ignore_for_file: public_member_api_docs, sort_constructors_first
class OrderModel {
  final String? docID;
  final int created;
  final int? delivered;
  final num summa;
  final int? managerID;
  final int? managerProfit; //заработок менеджера
  final int? carID;
  final int? carProfit; //заработок водителя
  final Map goodsList;
  final String address;
  final String phoneClient;
  final bool isDone; //фирма получила деньги за заказ?
  final bool
      takeMoney; //кто забирал деньги водитель - true или менеджер - false
  final bool payMoneyManager; //менеджеру заплатили зарплату?
  final bool payMoneyCar; //водителю заплатили зарплату?
  final String? notes;
  final String? name; //ф.и.о.  клиента
  final String? phoneManager;
  final String? time; //желаемое время доставки
  final List
      addressList; // лист с данными адреса для отчетности и сортировки  [city, street, house, apartment];

  OrderModel({
    this.docID,
    required this.created,
    required this.delivered,
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
    required this.payMoneyManager,
    required this.payMoneyCar,
    this.notes,
    this.name,
    this.phoneManager,
    this.time,
    required this.addressList,
  });

  static OrderModel fromFirebase(Map<String, dynamic> json, String docID) =>
      OrderModel(
        docID: docID,
        created: json['created'],
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
        payMoneyManager: json['payMoneyManager'],
        payMoneyCar: json['payMoneyCar'],
        notes: json['notes'],
        name: json['name'],
        phoneManager: json['phoneManager'],
        time: json['time'],
        addressList: json['addressList'],
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
        'payMoneyManager': payMoneyManager,
        'payMoneyCar': payMoneyCar,
        'notes': notes,
        'name': name,
        'phoneManager': phoneManager,
        'time': time,
        'addressList': addressList,
      };
}
