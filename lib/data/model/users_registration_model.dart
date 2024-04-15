class UsersRegistrationModel {
  final String name;
  final String password;
  final String? phone;
  final int? id;
  final int? percent;
  final String? nickname;
  final String? notes;
  final String? max;
  UsersRegistrationModel({
    required this.name,
    required this.password,
    this.phone,
    required this.id,
    required this.percent,
    this.notes,
    this.max,
    this.nickname,
  });

  static UsersRegistrationModel fromJson(Map<String, dynamic> json) =>
      UsersRegistrationModel(
        name: json['name'],
        password: json['password'],
        phone: json['phone'],
        id: json['id'],
        percent: json['percent'],
        nickname: json['nickname'],
        notes: json['notes'],
        max: json['max'],
      );
  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
        'phone': phone,
        'id': id,
        'percent': percent ?? 0,
        'nickname': nickname,
        'notes': notes,
        'max': max,
      };
}
