// ignore_for_file: public_member_api_docs, sort_constructors_first
class WriteAddressModel {
  String address;
  String id;
  String? name;
  String? phone;

  WriteAddressModel({
    required this.address,
    required this.id,
    required this.name,
    required this.phone,
  });

  static WriteAddressModel fromFirebase(
    Map<String, dynamic> json,
    String docID,
  ) =>
      WriteAddressModel(
        address: docID,
        id: json['managerID'],
        name: json['name'],
        phone: json['phone'],
      );
}
