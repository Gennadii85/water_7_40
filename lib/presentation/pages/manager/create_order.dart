// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/core/var_manager.dart';
import 'package:water_7_40/data/model/price_model.dart';
import 'package:water_7_40/data/repositories/manager_page_repo.dart';
import 'package:water_7_40/presentation/cubit/order_count/order_count_cubit.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import 'package:water_7_40/presentation/pages/manager/address_order_init_page.dart';
import 'package:water_7_40/presentation/pages/manager/address_order_value_page.dart';
import '../../../data/entity/price_entity.dart';
import '../../../data/model/address_model.dart';
import '../../../data/repositories/admin/admin_page_manager_repo.dart';
import '../managers_page.dart';
import 'create_price_position.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  bool takeMoney = true;

  void writeOrder(
    OrderCountCubit cubit,
  ) async {
    if (cubit.state.addressEntity.city.text.isEmpty ||
        cubit.state.addressEntity.street.text.isEmpty ||
        cubit.state.addressEntity.house.text.isEmpty ||
        cubit.state.addressEntity.apartment.text.isEmpty ||
        cubit.state.addressEntity.phone.text.isEmpty ||
        cubit.state.goodsList.isEmpty) {
      return;
    } else {
      String city = cubit.state.addressEntity.city.text;
      String street = cubit.state.addressEntity.street.text;
      String house = cubit.state.addressEntity.house.text;
      String apartment = cubit.state.addressEntity.apartment.text;
      String address = '$city $street дом $house кв $apartment';
      List<String> addressList = [city, street, house, apartment];
      int? id = await RepoManagerPage().checkAddress(address);
      cubit.writeOrder(address, takeMoney, id, addressList);
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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ManagersPage()),
              );
              BlocProvider.of<OrderCountCubit>(context).initState();
            },
          ),
          title: const Text('Создать заказ'),
          centerTitle: true,
        ),
        body: BlocBuilder<OrderCountCubit, OrderCountState>(
          builder: (context, state) {
            if (state is OrderCountInitState) {
              return initPage();
            } else {
              return valuePage(state);
            }
          },
        ),
      ),
    );
  }

  SingleChildScrollView valuePage(
    OrderCountState state,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 15),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: AddressOrderValuePage(),
          ),
          _textFieldRow(
            state.addressEntity.phone,
            'Телефон клиента *',
          ),
          _textFieldRow(
            state.addressEntity.name,
            'Контактное лицо',
          ),
          _textFieldRow(
            state.addressEntity.time,
            'Время доставки',
          ),
          _textFieldRow(
            state.addressEntity.notes,
            'Заметки',
          ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<OrderCountCubit, OrderCountState>(
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
          ListView.builder(
            itemBuilder: (context, index) {
              int money =
                  state.goodsList[index].count * state.goodsList[index].price;
              return Card(
                elevation: 4,
                color: Colors.blue[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          state.goodsList[index].goodsName,
                          style: VarManager.cardSize,
                        ),
                      ),
                      Text(
                        '${state.goodsList[index].count} шт. - ',
                        style: VarManager.cardSize,
                      ),
                      Text('$money грн.', style: VarManager.cardSize),
                    ],
                  ),
                ),
              );
            },
            shrinkWrap: true,
            itemCount: state.goodsList.length,
            physics: const NeverScrollableScrollPhysics(),
          ),
          const SizedBox(height: 15),
          AdminButtons(
            text: 'Добавить позиции',
            function: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreatePricePosition(),
                ),
              );
            },
          ),
          const SizedBox(height: 15),
          AdminButtons(
            text: 'Заказать',
            function: () {
              writeOrder(
                BlocProvider.of<OrderCountCubit>(context),
              );
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  StreamBuilder<List<PriceModel>> initPage() {
    return StreamBuilder<List<PriceModel>>(
      stream: RepoManagerPage().getPrice(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<PriceModel> priceData = snapshot.data!;

          final List<PriceModel> price =
              priceData.where((element) => element.isActive == true).toList();
          PriceEntity priceEntity = RepoManagerPage().setPriceEntity(price);

          return getCityAddress(priceEntity);
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Не удалось получить прайс.'),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  StreamBuilder<List<CityModel>> getCityAddress(PriceEntity priceEntity) {
    return StreamBuilder<List<CityModel>>(
      stream: RepoAdminGetPost().getCityAddress(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<CityModel> addressData = snapshot.data!;
          return SingleChildScrollView(
            child: BlocBuilder<OrderCountCubit, OrderCountState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AddressOrderInitPage(addressData: addressData),
                    ),
                    _textFieldRow(
                      state.addressEntity.phone,
                      'Телефон клиента *',
                    ),
                    _textFieldRow(
                      state.addressEntity.name,
                      'Контактное лицо',
                    ),
                    _textFieldRow(
                      state.addressEntity.time,
                      'Время доставки',
                    ),
                    _textFieldRow(
                      state.addressEntity.notes,
                      'Заметки',
                    ),
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
                      text: 'Добавить позиции',
                      function: () {
                        BlocProvider.of<OrderCountCubit>(context)
                            .getPriceEntity(
                          priceEntity,
                          addressData,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CreatePricePosition(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
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
