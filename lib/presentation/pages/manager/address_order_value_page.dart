// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/presentation/cubit/order_count/order_count_cubit.dart';

class AddressOrderValuePage extends StatelessWidget {
  const AddressOrderValuePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Населенный пункт *'),
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<OrderCountCubit, OrderCountState>(
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: Autocomplete<String>(
                        optionsMaxHeight: 600,
                        initialValue: TextEditingValue(
                          text: state.addressEntity.city.text,
                        ),
                        optionsBuilder: (textEditingValue) {
                          state.addressEntity.city.text = textEditingValue.text;
                          return state.addressData
                              .map((e) => e.cityName)
                              .toList()
                              .map((e) => e.toLowerCase())
                              .toList()
                              .where((option) {
                            return option
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (selection) {
                          state.addressEntity.city.text = selection;
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Улица *'),
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<OrderCountCubit, OrderCountState>(
              builder: (context, state) {
                return Row(
                  children: [
                    Expanded(
                      child: Autocomplete<String>(
                        optionsMaxHeight: 600,
                        initialValue: TextEditingValue(
                          text: state.addressEntity.street.text,
                        ),
                        optionsBuilder: (textEditingValue) {
                          state.addressEntity.street.text =
                              textEditingValue.text;
                          return state.addressData
                              .where(
                                (element) =>
                                    element.cityName ==
                                    state.addressEntity.city.text,
                              )
                              .first
                              .street
                              .map((e) => e.toLowerCase())
                              .toList()
                              .where((option) {
                            return option
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (selection) {
                          state.addressEntity.street.text = selection;
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<OrderCountCubit, OrderCountState>(
          builder: (context, state) {
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: state.addressEntity.house,
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
                    controller: state.addressEntity.apartment,
                    decoration: InputDecoration(
                      labelText: '№ квартиры',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
