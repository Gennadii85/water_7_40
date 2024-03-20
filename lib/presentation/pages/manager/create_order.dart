import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/core/var_manager.dart';
import 'package:water_7_40/data/model/price_model.dart';
import 'package:water_7_40/data/repositories/manager_page_repo.dart';
import 'package:water_7_40/presentation/cubit/order_count/order_count_cubit.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import 'package:water_7_40/presentation/pages/manager/price_card.dart';
import 'package:water_7_40/presentation/pages/managers_page.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final TextEditingController address = TextEditingController();
  final TextEditingController phoneClient = TextEditingController();
  final TextEditingController notes = TextEditingController();
  bool takeMoney = true;

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
              return BlocProvider(
                create: (context) => OrderCountCubit(prise),
                child: BlocBuilder<OrderCountCubit, OrderCountState>(
                  builder: (context, state) {
                    final cubit = BlocProvider.of<OrderCountCubit>(context);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.prise.length,
                              itemBuilder: (context, index) => PriceCard(
                                goods: state.prise[index].goodsName,
                                prise: state.prise[index].goodsPrice.toString(),
                                count: state.listCount[index],
                                // id: state.prise[index].id,
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
                          _textFieldRow(address, 'Адрес доставки *'),
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
                          AdminButtons(
                            text: 'Заказать',
                            function: () {
                              if (address.text.isEmpty ||
                                  phoneClient.text.isEmpty ||
                                  state.allMoney == 0) {
                                return null;
                              } else {
                                cubit.writeOrder(
                                  address.text,
                                  phoneClient.text,
                                  takeMoney,
                                  notes.text,
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ManagersPage(),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
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
