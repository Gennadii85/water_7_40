// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/core/var_manager.dart';
import 'package:water_7_40/data/model/price_model.dart';
import 'package:water_7_40/data/repositories/manager_page_repo.dart';
import 'package:water_7_40/presentation/cubit/order_count/order_count_cubit.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import 'package:water_7_40/presentation/pages/admins_page.dart';
import '../../../data/entity/price_entity.dart';
import '../../../data/model/order_model.dart';
import '../manager/create_price_position.dart';

class UpdateOrder extends StatefulWidget {
  final OrderModel model;
  const UpdateOrder({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  State<UpdateOrder> createState() => _UpdateOrderState();
}

class _UpdateOrderState extends State<UpdateOrder> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController manIDControl = TextEditingController();
  final TextEditingController managerProfitControl = TextEditingController();
  final TextEditingController carProfitControl = TextEditingController();
  final TextEditingController phoneManagerControl = TextEditingController();
  bool takeMoney = true;

  @override
  void initState() {
    phoneController.text = widget.model.phoneClient;
    nameController.text = widget.model.name ?? '';
    timeController.text = widget.model.time ?? '';
    notesController.text = widget.model.notes ?? '';
    manIDControl.text = widget.model.managerID.toString();
    managerProfitControl.text = widget.model.managerProfit.toString();
    carProfitControl.text = widget.model.carProfit.toString();
    phoneManagerControl.text = widget.model.phoneManager ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Редактировать заказ'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: StreamBuilder<List<PriceModel>>(
          stream: RepoManagerPage().getPrice(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<PriceModel> priceData = snapshot.data!;
              final List<PriceModel> price = priceData
                  .where((element) => element.isActive == true)
                  .toList();
              PriceEntity priceEntity = RepoManagerPage().setPriceEntity(price);
              return SingleChildScrollView(
                child: BlocBuilder<OrderCountCubit, OrderCountState>(
                  builder: (context, state) {
                    if (state is OrderCountInitState) {
                      return initPage(priceEntity);
                    } else {
                      return valuePage(state, context);
                    }
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Не удалось получить прайс.'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                semanticsValue: 'Загружаю прайс',
              ),
            );
          },
        ),
      ),
    );
  }

  Column valuePage(
    OrderCountState state,
    BuildContext context,
  ) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.model.address,
            style: const TextStyle(fontSize: 18, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 15),
        _textFieldRow(
          manIDControl,
          'ID менеджера',
        ),
        _textFieldRow(
          phoneManagerControl,
          'Телефон менеджера',
        ),
        _textFieldRow(
          managerProfitControl,
          'Зарплата менеджера',
        ),
        _textFieldRow(
          carProfitControl,
          'Зарплата водителя',
        ),
        _textFieldRow(
          timeController,
          'Время доставки',
        ),
        _textFieldRow(
          notesController,
          'Заметки',
        ),
        _textFieldRow(
          phoneController,
          'Телефон клиента *',
        ),
        _textFieldRow(
          nameController,
          'Контактное лицо',
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
              child: Text(
                'Заказ на сумму: ${widget.model.summa.toString()} грн.',
                style: VarManager.cardSize,
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
                builder: (context) => const CreatePricePosition(route: true),
              ),
            );
          },
        ),
        const SizedBox(height: 15),
        AdminButtons(
          text: 'Применить',
          function: () {
            if (phoneController.text.isEmpty ||
                manIDControl.text.isEmpty ||
                managerProfitControl.text.isEmpty ||
                carProfitControl.text.isEmpty ||
                state.allMoney == 0) {
              return;
            } else {
              BlocProvider.of<OrderCountCubit>(context).updateOrder(
                widget.model,
                state.allMoney,
                phoneController.text,
                takeMoney,
                notesController.text,
                int.tryParse(manIDControl.text) ?? widget.model.managerID!,
                int.tryParse(managerProfitControl.text) ??
                    widget.model.managerProfit!,
                int.tryParse(carProfitControl.text) ?? widget.model.carProfit!,
                null,
                timeController.text,
                phoneManagerControl.text,
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AdminPage(),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Column initPage(PriceEntity priceEntity) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.model.address,
            style: const TextStyle(fontSize: 18, color: Colors.blue),
          ),
        ),
        const SizedBox(height: 15),
        _textFieldRow(
          manIDControl,
          'ID менеджера',
        ),
        _textFieldRow(
          phoneManagerControl,
          'Телефон менеджера',
        ),
        _textFieldRow(
          managerProfitControl,
          'Зарплата менеджера',
        ),
        _textFieldRow(
          carProfitControl,
          'Зарплата водителя',
        ),
        _textFieldRow(
          timeController,
          'Время доставки',
        ),
        _textFieldRow(
          notesController,
          'Заметки',
        ),
        _textFieldRow(
          phoneController,
          'Телефон клиента *',
        ),
        _textFieldRow(
          nameController,
          'Контактное лицо',
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
              child: Text(
                'Заказ на сумму: ${widget.model.summa.toString()} грн.',
                style: VarManager.cardSize,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ListView(
          shrinkWrap: true,
          children: widget.model.goodsList.entries
              .map(
                (e) => Card(
                  elevation: 4,
                  color: Colors.blue[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            e.key,
                            style: VarManager.cardSize,
                          ),
                        ),
                        Text(
                          '${e.value} шт.',
                          style: VarManager.cardSize,
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 15),
        AdminButtons(
          text: 'Добавить позиции',
          function: () {
            BlocProvider.of<OrderCountCubit>(context)
                .getPriceEntity(priceEntity, []);
            BlocProvider.of<OrderCountCubit>(context)
                .setUpdateGoodsList(widget.model.goodsList);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CreatePricePosition(route: true),
              ),
            );
          },
        ),
        const SizedBox(height: 15),
        AdminButtons(
          text: 'Применить',
          function: () {
            if (phoneController.text.isEmpty ||
                manIDControl.text.isEmpty ||
                managerProfitControl.text.isEmpty ||
                carProfitControl.text.isEmpty) {
              return;
            } else {
              BlocProvider.of<OrderCountCubit>(context).updateOrder(
                widget.model,
                widget.model.summa.toInt(),
                phoneController.text,
                takeMoney,
                notesController.text,
                int.tryParse(manIDControl.text) ?? widget.model.managerID!,
                int.tryParse(managerProfitControl.text) ??
                    widget.model.managerProfit!,
                int.tryParse(carProfitControl.text) ?? widget.model.carProfit!,
                widget.model.goodsList,
                timeController.text,
                phoneManagerControl.text,
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AdminPage(),
                ),
              );
            }
          },
        ),
        const SizedBox(height: 30),
      ],
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
        minLines: 1,
        maxLines: 50,
      ),
    );
  }
}
