import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_7_40/core/var_manager.dart';
import '../../../core/var_core.dart';
import '../../../data/model/order_model.dart';
import '../../../data/model/price_model.dart';

part 'order_count_state.dart';

class OrderCountCubit extends Cubit<OrderCountState> {
  List<PriceModel> prise;
  final int managerID = Hive.box(VarHive.nameBox).get(VarHive.managersID);
  OrderCountCubit(this.prise)
      : super(
          OrderCountState(
            listCount: List<int>.generate(prise.length, (index) => 0),
            allMoney: 0,
            managerMoney: 0,
            prise: prise,
            percentManager:
                Hive.box(VarHive.nameBox).get(VarHive.managersPercent),
          ),
        );

  void initState() {
    emit(
      OrderCountInitState(
        listCount: List<int>.generate(prise.length, (index) => 0),
        allMoney: 0,
        managerMoney: 0,
        prise: prise,
        percentManager: state.percentManager,
      ),
    );
  }

  void addCount(int index) {
    int elem = state.listCount.elementAt(index);
    state.listCount.setAll(index, [elem + 1]);
    emit(
      OrderCountState(
        listCount: state.listCount,
        allMoney: summaOrder(),
        managerMoney: managerProfit(),
        prise: state.prise,
        percentManager: state.percentManager,
      ),
    );
  }

  void delCount(int index) {
    int elem = state.listCount.elementAt(index);
    if (elem == 0) {
      return;
    } else {
      state.listCount.setAll(index, [elem - 1]);
      emit(
        OrderCountState(
          listCount: state.listCount,
          allMoney: summaOrder(),
          managerMoney: managerProfit(),
          prise: state.prise,
          percentManager: state.percentManager,
        ),
      );
    }
  }

  int summaOrder() {
    int allMoney = 0;
    List<int> all = [];
    int countIndex = 0;
    for (var elem in prise) {
      all.add(elem.goodsPrice.toInt() * state.listCount[countIndex]);
      countIndex++;
    }
    allMoney = all.reduce((value, element) => value + element);
    return allMoney;
  }

  int managerProfit() {
    int allProfit = 0;
    List<int> all = [];
    int countIndex = 0;
    for (var elem in prise) {
      if (elem.manager) {
        int moneyPosition =
            elem.goodsPrice.toInt() * state.listCount[countIndex];
        all.add(moneyPosition * state.percentManager ~/ 100);
      }
      countIndex++;
    }
    allProfit = all.reduce((value, element) => value + element);
    return allProfit;
  }

  void writeOrder(
    String address,
    String phoneClient,
    bool takeMoney,
    String? notes,
  ) {
    Map map = {};
    int countIndex = 0;
    for (var elem in prise) {
      map.addAll({elem.id.toString(): state.listCount[countIndex]});
      countIndex++;
    }
    final model = OrderModel(
      created: DateTime.now(),
      delivered: null,
      summa: state.allMoney,
      managerID: managerID,
      managerProfit: managerProfit(),
      carID: null,
      carProfit: null,
      goodsList: map,
      address: address,
      phoneClient: phoneClient,
      isDone: false,
      takeMoney: takeMoney,
      notes: notes,
    );
    FirebaseFirestore.instance
        .collection(VarManager.orders)
        .doc()
        .set(model.toFirebase());

    initState();
  }
}
