import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/var_admin.dart';
import '../../../presentation/pages/widgets/massage.dart';
import '../../model/price_model.dart';

class AdminPageRepo {
  final db = FirebaseFirestore.instance;
  Stream<List<PriceModel>> getPrice() {
    return db.collection('price').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => PriceModel.fromFirebase(doc.data(), doc.id))
              .toList(),
        );
  }

  dynamic deletePrice(String id) {
    db.collection('price').doc(id).delete();
  }

  dynamic writeOrder(
    context,
    String goodsNameControl,
    String goodsPriceControl,
    String piecesPercentValueControlManager,
    String piecesMoneyValueControlManager,
    String existenceMoneyValueControlManager,
    String piecesPercentValueControlCar,
    String piecesMoneyValueControlCar,
    String existenceMoneyValueControlCar,
  ) {
    int trueCountManager = 0;
    if (piecesPercentValueControlManager.isNotEmpty) trueCountManager++;
    if (piecesMoneyValueControlManager.isNotEmpty) trueCountManager++;
    if (existenceMoneyValueControlManager.isNotEmpty) trueCountManager++;
    if (trueCountManager > 1) {
      Massage().massage(
        context,
        'Указанно более одного способа начисления для менеджера',
      );
      return;
    }
    int trueCountCar = 0;
    if (piecesPercentValueControlCar.isNotEmpty) trueCountCar++;
    if (piecesMoneyValueControlCar.isNotEmpty) trueCountCar++;
    if (existenceMoneyValueControlCar.isNotEmpty) trueCountCar++;
    if (trueCountCar > 1) {
      Massage().massage(
        context,
        'Указанно более одного способа начисления для водителя',
      );
      return;
    }
    if (trueCountCar == 0 && trueCountManager == 0) {
      Massage().massage(
        context,
        'Не указанно ни одного способа начисления !!!!',
      );
    }
    final model = PriceModel(
      goodsName: goodsNameControl,
      goodsPrice: int.tryParse(goodsPriceControl) ?? 0,
      piecesPercentValueManager: int.tryParse(piecesPercentValueControlManager),
      piecesMoneyValueManager: int.tryParse(piecesMoneyValueControlManager),
      existenceMoneyValueManager:
          int.tryParse(existenceMoneyValueControlManager),
      piecesPercentValueCar: int.tryParse(piecesPercentValueControlCar),
      piecesMoneyValueCar: int.tryParse(piecesMoneyValueControlCar),
      existenceMoneyValueCar: int.tryParse(existenceMoneyValueControlCar),
    );
    FirebaseFirestore.instance
        .collection(VarAdmin.dbPrice)
        .doc()
        .set(model.toFirebase());
    Massage().massage(
      context,
      'В прайс добавлена новая позиция !!!!',
    );
  }

  String managerMethod(PriceModel prise) {
    final PriceModel model = prise;
    String massage = 'Начислений нет';
    if (model.piecesPercentValueManager != null) {
      massage = '- процентов на каждую штуку товара';
    }
    if (model.piecesMoneyValueManager != null) {
      massage = ' грн. на каждую штуку товара';
    }
    if (model.existenceMoneyValueManager != null) {
      massage = ' грн. за наличие в заказе неважно сколько шт.';
    }
    return massage;
  }

  String carMethod(PriceModel prise) {
    final PriceModel model = prise;
    String massage = 'Начислений нет';
    if (model.piecesPercentValueCar != null) {
      massage = '- процентов на каждую штуку товара';
    }
    if (model.piecesMoneyValueCar != null) {
      massage = ' грн на каждую штуку товара';
    }
    if (model.existenceMoneyValueCar != null) {
      massage = ' грн. за наличие в заказе неважно сколько шт.';
    }
    return massage;
  }

  String managerMethodValue(PriceModel prise) {
    final PriceModel model = prise;
    String value = '';
    if (model.piecesPercentValueManager != null) {
      value = model.piecesPercentValueManager.toString();
    }
    if (model.piecesMoneyValueManager != null) {
      value = model.piecesMoneyValueManager.toString();
    }
    if (model.existenceMoneyValueManager != null) {
      value = model.existenceMoneyValueManager.toString();
    }
    return value;
  }

  String carMethodValue(PriceModel prise) {
    final PriceModel model = prise;
    String value = '';
    if (model.piecesPercentValueCar != null) {
      value = model.piecesPercentValueCar.toString();
    }
    if (model.piecesMoneyValueCar != null) {
      value = model.piecesMoneyValueCar.toString();
    }
    if (model.existenceMoneyValueCar != null) {
      value = model.existenceMoneyValueCar.toString();
    }
    return value;
  }
}
