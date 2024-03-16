class UsersRegistrationModel {
  final String name;
  final String password;
  final String? id;
  final String? percent;
  UsersRegistrationModel({
    required this.name,
    required this.password,
    required this.id,
    required this.percent,
  });

  static UsersRegistrationModel fromJson(Map<String, dynamic> json) =>
      UsersRegistrationModel(
        name: json['name'],
        password: json['password'],
        id: json['managerID'] ?? '1',
        percent: json['percent'] ?? '',
      );
  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
        'managerID': id ?? '1',
        'percent': percent ?? '',
      };
}
