// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:water_7_40/presentation/pages/admin/widgets_admins/admin_price_card.dart';

import '../../../../core/var_admin.dart';
import '../../../../data/model/price_model.dart';
import '../../../../data/repositories/admin/admin_page_manager_repo.dart';

class CreatePricePage extends StatefulWidget {
  const CreatePricePage({super.key});

  @override
  State<CreatePricePage> createState() => _CreatePricePageState();
}

class _CreatePricePageState extends State<CreatePricePage> {
  TextEditingController goodsNameControl = TextEditingController();
  TextEditingController goodsPriceControl = TextEditingController();
  TextEditingController piecesPercentValueControlManager =
      TextEditingController();
  TextEditingController piecesMoneyValueControlManager =
      TextEditingController();
  TextEditingController existenceMoneyValueControlManager =
      TextEditingController();
  TextEditingController piecesPercentValueControlCar = TextEditingController();
  TextEditingController piecesMoneyValueControlCar = TextEditingController();
  TextEditingController existenceMoneyValueControlCar = TextEditingController();
  bool managerPercent = false;

  @override
  void dispose() {
    goodsNameControl.dispose();
    goodsPriceControl.dispose();
    piecesPercentValueControlManager.dispose();
    piecesMoneyValueControlManager.dispose();
    existenceMoneyValueControlManager.dispose();
    piecesPercentValueControlCar.dispose();
    piecesMoneyValueControlCar.dispose();
    existenceMoneyValueControlCar.dispose();

    super.dispose();
  }

  void clearTextController() {
    goodsNameControl.clear();
    goodsPriceControl.clear();
    piecesPercentValueControlManager.clear();
    piecesMoneyValueControlManager.clear();
    existenceMoneyValueControlManager.clear();
    piecesPercentValueControlCar.clear();
    piecesMoneyValueControlCar.clear();
    existenceMoneyValueControlCar.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Создать прайс'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Текущий прайс'),
              const SizedBox(height: 25),
              StreamBuilder<List<PriceModel>>(
                stream: AdminPageRepo().getPrice(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final prise = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: prise.length,
                        itemBuilder: (context, index) => AdminPriceCard(
                          id: prise[index].id!,
                          name: prise[index].goodsName,
                          prise: prise[index].goodsPrice,
                          managerMethod:
                              AdminPageRepo().managerMethod(prise[index]),
                          managerMethodValue:
                              AdminPageRepo().managerMethodValue(prise[index]),
                          carMethod: AdminPageRepo().carMethod(prise[index]),
                          carMethodValue:
                              AdminPageRepo().carMethodValue(prise[index]),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(height: 15),
              ExpansionTile(
                title: const Text('Добавить позицию в прайс'),
                childrenPadding: const EdgeInsets.all(8),
                collapsedShape: Border.all(),
                children: [
                  TextField(
                    controller: goodsNameControl,
                    decoration: const InputDecoration(
                      labelText: 'Название услуги *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: goodsPriceControl,
                    decoration: const InputDecoration(
                      labelText: 'Стоимость за 1 шт. услуги *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      'Определите только один метод расчета менеджера и водителя. Если оставить все поля пустыми - менеджер и водитель не будут получать отчисления с этой позиции !!!',
                      style: VarAdmin.adminPriceText,
                    ),
                  ),
                  const SizedBox(height: 15),
                  managerSalary(),
                  const SizedBox(height: 15),
                  CarSalary(
                    piecesPercentValueControlCar: piecesPercentValueControlCar,
                    piecesMoneyValueControlCar: piecesMoneyValueControlCar,
                    existenceMoneyValueControlCar:
                        existenceMoneyValueControlCar,
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    child: const Text('Сохранить позицию в прайс'),
                    onPressed: () {
                      AdminPageRepo().writeOrder(
                        context,
                        goodsNameControl.text,
                        goodsPriceControl.text,
                        piecesPercentValueControlManager.text,
                        piecesMoneyValueControlManager.text,
                        existenceMoneyValueControlManager.text,
                        managerPercent,
                        piecesPercentValueControlCar.text,
                        piecesMoneyValueControlCar.text,
                        existenceMoneyValueControlCar.text,
                      );
                      clearTextController();
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ExpansionTile managerSalary() {
    return ExpansionTile(
      title: const Text('Начисления менеджеру'),
      childrenPadding: const EdgeInsets.all(8),
      collapsedShape: Border.all(),
      children: [
        TextField(
          controller: piecesPercentValueControlManager,
          decoration: const InputDecoration(
            labelText: 'Процент на каждую штуку',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: piecesMoneyValueControlManager,
          decoration: const InputDecoration(
            labelText: 'Сколько денег на каждую штуку',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: existenceMoneyValueControlManager,
          decoration: const InputDecoration(
            labelText: 'сколько денег за наличие в заказе неважно сколько шт.',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Начислять индивидуальный процент.'),
                Checkbox(
                  value: managerPercent,
                  onChanged: (value) {
                    setState(() {
                      managerPercent = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CarSalary extends StatelessWidget {
  const CarSalary({
    super.key,
    required this.piecesPercentValueControlCar,
    required this.piecesMoneyValueControlCar,
    required this.existenceMoneyValueControlCar,
  });

  final TextEditingController piecesPercentValueControlCar;
  final TextEditingController piecesMoneyValueControlCar;
  final TextEditingController existenceMoneyValueControlCar;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Начисления водителю'),
      childrenPadding: const EdgeInsets.all(8),
      collapsedShape: Border.all(),
      children: [
        TextField(
          controller: piecesPercentValueControlCar,
          decoration: const InputDecoration(
            labelText: 'Процент на каждую штуку',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: piecesMoneyValueControlCar,
          decoration: const InputDecoration(
            labelText: 'Сколько денег на каждую штуку',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: existenceMoneyValueControlCar,
          decoration: const InputDecoration(
            labelText: 'сколько денег за наличие в заказе неважно сколько шт.',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
