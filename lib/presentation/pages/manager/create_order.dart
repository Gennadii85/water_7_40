// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:water_7_40/core/var_manager.dart';
import 'package:water_7_40/data/model/price_model.dart';
import 'package:water_7_40/data/repositories/manager_page_repo.dart';
import 'package:water_7_40/presentation/cubit/order_count/order_count_cubit.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import 'package:water_7_40/presentation/pages/manager/price_body.dart';
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
      // cubit.writeOrder(address, phoneClient.text, takeMoney, notes.text, id);
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
              final List<PriceModel> priceData = snapshot.data!;

              final List<PriceModel> price = priceData
                  .where((element) => element.isActive == true)
                  .toList();

              return StreamBuilder<List<CityModel>>(
                stream: RepoAdminGetPost().getCityAddress(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<CityModel> addressData = snapshot.data!;
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) => OrderCountCubit(
                            price,
                            RepoManagerPage().setCount(price),
                          ),
                        ),
                        BlocProvider(
                          create: (context) => AddAddressCubit(addressData),
                        ),
                      ],
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PriceBody(price: price),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: BlocBuilder<OrderCountCubit,
                                      OrderCountState>(
                                    builder: (context, state) {
                                      return Text(
                                        'Заказ на сумму: ${state.allMoney.toString()} грн.',
                                        style: VarManager.cardSize,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            RepoManagerPage()
                                .addressAuto(houseControl, apartmentControl),
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
                                  function: () => writeOrder(
                                    addAddress,
                                    BlocProvider.of<OrderCountCubit>(
                                      context,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
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
