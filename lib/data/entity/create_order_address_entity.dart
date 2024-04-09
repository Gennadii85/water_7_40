// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CreateOrderAddressEntity {
  TextEditingController street;
  TextEditingController house;
  TextEditingController apartment;
  TextEditingController phone;
  TextEditingController city;
  TextEditingController name;
  TextEditingController notes;
  CreateOrderAddressEntity({
    required this.city,
    required this.street,
    required this.house,
    required this.apartment,
    required this.phone,
    required this.name,
    required this.notes,
  });
}
