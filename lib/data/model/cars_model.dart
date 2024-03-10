// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class CarsModel {
  final String docID;
  final String carID;
  final String name;
  final String password;
  CarsModel({
    required this.docID,
    required this.carID,
    required this.name,
    required this.password,
  });
  Map<String, String> toFirebase() {
    return {'carID': carID, 'name': name, 'password': password};
  }

  factory CarsModel.fomSnap(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CarsModel(
      docID: document.id,
      carID: data['carID'],
      name: data['name'],
      password: data['password'],
    );
  }
}
