import 'package:flutter/material.dart';
import 'package:water_7_40/data/entity/price_entity.dart';
import 'package:water_7_40/presentation/pages/manager/goods_card.dart';
import '../../data/repositories/manager_page_repo.dart';
import 'admin/admin_buttons.dart';

class ManagersPage extends StatefulWidget {
  const ManagersPage({super.key});

  @override
  State<ManagersPage> createState() => _ManagersPageState();
}

class _ManagersPageState extends State<ManagersPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Manager panel'),
          centerTitle: true,
          actions: [
            AdminButtons(
              function: () {},
              text: 'Обновить',
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<List<PriceEntity>>(
                stream: RepoManagerPage().getPrice(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final prise = snapshot.data!;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: prise.length,
                      itemBuilder: (context, index) => GoodsCard(
                        goods: prise[index].goodsName,
                        prise: prise[index].goodsPrice.toString(),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              Row(
                children: [Text('Заказ на сумму'), Text('data')],
              )
            ],
          ),
        ),
      ),
    );
  }
}
