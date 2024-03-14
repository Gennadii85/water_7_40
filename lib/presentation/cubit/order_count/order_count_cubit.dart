import 'package:bloc/bloc.dart';
import '../../../data/model/price_model.dart';

part 'order_count_state.dart';

class OrderCountCubit extends Cubit<OrderCountState> {
  final List<int> countList;
  final int percentManager;
  OrderCountCubit(this.countList, this.percentManager)
      : super(
          OrderCountState(
            listCount: countList,
            allMoney: 0,
            managerMoney: 0,
          ),
        );

  void addCount(int index, List<PriceModel> prise) {
    int elem = state.listCount.elementAt(index);
    state.listCount.setAll(index, [elem + 1]);
    emit(
      OrderCountState(
        listCount: state.listCount,
        allMoney: summaOrder(prise),
        managerMoney: managerProfit(prise),
      ),
    );
  }

  void delCount(int index, List<PriceModel> prise) {
    int elem = state.listCount.elementAt(index);
    if (elem == 0) {
      return;
    } else {
      state.listCount.setAll(index, [elem - 1]);
      emit(
        OrderCountState(
          listCount: state.listCount,
          allMoney: summaOrder(prise),
          managerMoney: managerProfit(prise),
        ),
      );
    }
  }

  int summaOrder(List<PriceModel> prise) {
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

  int managerProfit(List<PriceModel> prise) {
    int allProfit = 0;
    List<int> all = [];
    int countIndex = 0;
    for (var elem in prise) {
      if (elem.manager) {
        int moneyPosition =
            elem.goodsPrice.toInt() * state.listCount[countIndex];
        all.add(moneyPosition * percentManager ~/ 100);
      }
      countIndex++;
    }
    allProfit = all.reduce((value, element) => value + element);
    return allProfit;
  }
}
