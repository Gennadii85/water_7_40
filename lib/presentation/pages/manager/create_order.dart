import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/core/var_manager.dart';
import 'package:water_7_40/data/model/price_model.dart';
import 'package:water_7_40/data/repositories/manager_page_repo.dart';
import 'package:water_7_40/presentation/cubit/order_count/order_count_cubit.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import 'package:water_7_40/presentation/pages/manager/price_card.dart';
import '../../../data/model/address_model.dart';
import '../../../data/repositories/admin/admin_page_manager_repo.dart';
import '../../cubit/add_address/add_address_cubit.dart';
import '../managers_page.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final TextEditingController phoneClient = TextEditingController();
  final TextEditingController notes = TextEditingController();
  final TextEditingController houseControl = TextEditingController();
  final TextEditingController apartmentControl = TextEditingController();
  bool takeMoney = true;

  void writeOrder(
    AddAddressState addAddress,
    OrderCountCubit cubit,
  ) async {
    if (houseControl.text.isEmpty ||
        apartmentControl.text.isEmpty ||
        phoneClient.text.isEmpty ||
        cubit.state.allMoney == 0) {
      return;
    } else {
      String address =
          '${addAddress.city} ${addAddress.street} дом ${houseControl.text} кв ${apartmentControl.text}';
      int? id = await RepoManagerPage().checkAddress(address);
      cubit.writeOrder(address, phoneClient.text, takeMoney, notes.text, id);
      goManagerPage(id);
    }
  }

  void goManagerPage(int? id) {
    if (id != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            'Этот адрес закреплен за другим менеджером! По-этому он не будет отображаться на вашей панели!',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Я понял'),
            ),
          ],
        ),
      );
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ManagersPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Создать заказ'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<PriceModel>>(
          stream: RepoManagerPage().getPrice(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final prise = snapshot.data!;
              return StreamBuilder<List<CityModel>>(
                stream: RepoAdminGetPost().getCityAddress(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<CityModel> addressData = snapshot.data!;
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => OrderCountCubit(prise),
                        ),
                        BlocProvider(
                          create: (context) => AddAddressCubit(addressData),
                        ),
                      ],
                      child: BlocBuilder<OrderCountCubit, OrderCountState>(
                        builder: (context, state) {
                          final cubit =
                              BlocProvider.of<OrderCountCubit>(context);
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.prise.length,
                                    itemBuilder: (context, index) => PriceCard(
                                      goods: state.prise[index].goodsName,
                                      prise: state.prise[index].goodsPrice
                                          .toString(),
                                      count: state.listCount[index],
                                      addCount: () => cubit.addCount(index),
                                      delCount: () => cubit.delCount(index),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Заказ на сумму: ${state.allMoney.toString()} грн.',
                                        style: VarManager.cardSize,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                addressAuto(addressData),
                                _textFieldRow(phoneClient, 'Телефон клиента *'),
                                _textFieldRow(notes, 'Заметки'),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Text('Расчет с водителем'),
                                      Checkbox(
                                        value: takeMoney,
                                        onChanged: (value) {
                                          setState(() {
                                            takeMoney = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Builder(
                                  builder: (context) {
                                    final addAddress =
                                        context.watch<AddAddressCubit>().state;
                                    return AdminButtons(
                                      text: 'Заказать',
                                      function: () =>
                                          writeOrder(addAddress, cubit),
                                    );
                                  },
                                ),
                                const SizedBox(height: 30),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Не удалось получить список адресов.'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Не удалось получить прайс.'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Padding addressAuto(data) {
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
      // ),
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

  Padding _textFieldRow(TextEditingController controller, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: text,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
