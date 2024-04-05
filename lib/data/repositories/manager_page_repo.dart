import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/cubit/add_address/add_address_cubit.dart';
import '../model/order_model.dart';
import '../model/price_model.dart';

class RepoManagerPage {
  final db = FirebaseFirestore.instance;
  final int today =
      DateTime.now().millisecondsSinceEpoch - DateTime.now().hour * 3600000;

  Stream<List<PriceModel>> getPrice() {
    return db
        .collection('price')
        .orderBy('goodsName', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PriceModel.fromFirebase(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<List<OrderModel>> getTodayOrders() {
    return db
        .collection('orders')
        .orderBy('created', descending: true)
        .where('created', isGreaterThan: today)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirebase(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<int?> checkAddress(String address) async {
    int? id;
    await db.collection('managerAddress').doc(address).get().then(
      (doc) {
        Map? data = doc.data() ?? {};
        String? idData = data['managerID'] ?? '';
        id = int.tryParse(idData!);
      },
      onError: (e) => id = null,
    );
    return id;
  }

  List<Map<String, List<int>>> setCount(List<PriceModel> price) {
    List<String> categoriesList =
        price.map((e) => e.categoryName).toSet().toList();
    List<Map<String, List<int>>> finish = categoriesList.map((elem) {
      List<PriceModel> getList(elem) =>
          price.where((element) => element.categoryName == elem).toList();
      return {elem: List.generate(getList(elem).length, (index) => 0)};
    }).toList();
    return finish;
  }

  Padding addressAuto(
    TextEditingController houseControl,
    TextEditingController apartmentControl,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text('Населенный пункт *'),
          autocompleteCity(),
          const SizedBox(height: 20),
          const Text('Улица *'),
          autocompleteStreet(),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: houseControl,
                  decoration: InputDecoration(
                    labelText: '№ дома',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: apartmentControl,
                  decoration: InputDecoration(
                    labelText: '№ квартиры',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container autocompleteCity() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<AddAddressCubit, AddAddressState>(
          builder: (context, state) {
            final cubit = BlocProvider.of<AddAddressCubit>(context);
            return Row(
              children: [
                Expanded(
                  child: Autocomplete<String>(
                    optionsMaxHeight: 600,
                    optionsBuilder: (textEditingValue) {
                      state.city = textEditingValue.text;
                      return state.cityList
                          .map((e) => e.toLowerCase())
                          .toList()
                          .where((option) {
                        return option
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (selection) {
                      state.city = selection;
                      cubit.addCity();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Container autocompleteStreet() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<AddAddressCubit, AddAddressState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: Autocomplete<String>(
                    optionsMaxHeight: 600,
                    optionsBuilder: (textEditingValue) {
                      state.street = textEditingValue.text;
                      return state.streetList
                          .map((e) => e.toLowerCase())
                          .toList()
                          .where((option) {
                        return option
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (selection) {
                      state.street = selection;
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
