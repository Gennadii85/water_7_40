import 'package:cloud_firestore/cloud_firestore.dart';

class CityModel {
  String cityName;
  List<String> street;
  CityModel({required this.cityName, required this.street});

  factory CityModel.fromFirebase(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return CityModel(
      cityName: snapshot.id,
      street: List<String>.from(data?['street'] ?? []),
    );
  }
  Map<String, dynamic> toFirebase() => {
        'street': street,
      };
}
