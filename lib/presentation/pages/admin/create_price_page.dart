import 'package:flutter/material.dart';
import 'package:water_7_40/presentation/pages/admin/admin_drawer.dart';
import 'package:water_7_40/presentation/pages/admin/admin_price_card.dart';
import '../../../core/var_admin.dart';
import '../../../data/model/price_model.dart';
import '../../../data/repositories/admin/admin_page_manager_repo.dart';

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
  TextEditingController categoryNameControl = TextEditingController();
  bool managerPercent = false;
  List<PriceModel> priseList = [];
  List<String> categoriesList = [];

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
    categoryNameControl.dispose();

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
    categoryNameControl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Создать прайс'),
          centerTitle: true,
        ),
        drawer: const AdminDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Text('Текущий прайс'),
              const SizedBox(height: 25),
              StreamBuilder<List<PriceModel>>(
                stream: RepoAdminPage().getPrice(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Widget> widgetList = [];
                    final prise = snapshot.data!;
                    priseList = prise;
                    categoriesList =
                        prise.map((e) => e.categoryName).toSet().toList();
                    for (var element in categoriesList) {
                      List<PriceModel> list = prise
                          .where((elem) => elem.categoryName == element)
                          .toList();
                      Widget widget = ExpansionTile(
                        title: Text(element),
                        childrenPadding: const EdgeInsets.all(8),
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(),
                        ),
                        children: list
                            .map(
                              (elem) => AdminPriceCard(
                                id: elem.id!,
                                name: elem.goodsName,
                                prise: elem.goodsPrice,
                                managerMethod:
                                    RepoAdminPage().managerMethod(elem),
                                managerMethodValue:
                                    RepoAdminPage().managerMethodValue(elem),
                                carMethod: RepoAdminPage().carMethod(elem),
                                carMethodValue:
                                    RepoAdminPage().carMethodValue(elem),
                                isActive: elem.isActive,
                              ),
                            )
                            .toList(),
                      );
                      widgetList.add(widget);
                      widgetList.add(const SizedBox(height: 15));
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        shrinkWrap: true,
                        children: widgetList,
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
                      'Выберите категорию или оставьте позицию без категории!',
                      style: VarAdmin.adminPriceText,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Autocomplete<String>(
                        optionsMaxHeight: 600,
                        optionsBuilder: (textEditingValue) {
                          categoryNameControl.text = textEditingValue.text;

                          final Set<String> list =
                              priseList.map((e) => e.categoryName).toSet();

                          return list
                              .map((e) => e.toLowerCase())
                              .toList()
                              .where((option) {
                            return option
                                .contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        onSelected: (selection) {
                          categoryNameControl.text = selection;
                          selection = '';
                        },
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
                      RepoAdminPage().writeOrder(
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
                        categoryNameControl.text,
                      );
                      clearTextController();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreatePricePage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
              const SizedBox(height: 50),
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
