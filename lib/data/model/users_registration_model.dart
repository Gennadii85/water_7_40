class UsersRegistrationModel {
  final String name;
  final String password;
  final int? id;
  final int? percent;
  final String? nickname;
  UsersRegistrationModel({
    required this.name,
    required this.password,
    required this.id,
    required this.percent,
    this.nickname,
  });

  static UsersRegistrationModel fromJson(Map<String, dynamic> json) =>
      UsersRegistrationModel(
        name: json['name'],
        password: json['password'],
        id: json['id'],
        percent: json['percent'],
        nickname: json['nickname'],
      );
  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
        'id': id,
        'percent': percent ?? 0,
        'nickname': nickname,
      };
}
