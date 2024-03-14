class ManagersModel {
  final String name;
  final String password;
  final String id;
  final String percent;
  ManagersModel({
    required this.name,
    required this.password,
    required this.id,
    required this.percent,
  });

  static ManagersModel fromJson(Map<String, dynamic> json) => ManagersModel(
        name: json['name'],
        password: json['password'],
        id: json['managerID'],
        percent: json['percent'],
      );
  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
        'managerID': id,
        'percent': percent,
      };
}
