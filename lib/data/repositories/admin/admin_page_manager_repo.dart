import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_7_40/data/model/address_model.dart';
import '../../../core/var_admin.dart';
import '../../../presentation/pages/widgets/massage.dart';
import '../../model/order_model.dart';
import '../../model/price_model.dart';
import '../../model/users_registration_model.dart';

class RepoAdminPage {
  final db = FirebaseFirestore.instance;
  Stream<List<PriceModel>> getPrice() {
    return db
        .collection('price')
        .orderBy('goodsName', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PriceModel.fromFirebase(doc.data(), doc.id))
              .toList(),
        );
  }

  dynamic deletePrice(String id) {
    db.collection('price').doc(id).delete();
  }

  dynamic activatedPrice(String docID) {
    db.collection('price').doc(docID).update({'isActive': true});
  }

  dynamic deActivatedPrice(String docID) {
    db.collection('price').doc(docID).update({'isActive': false});
  }

  dynamic writeOrder(
    context,
    String goodsNameControl,
    String goodsPriceControl,
    String piecesPercentValueControlManager,
    String piecesMoneyValueControlManager,
    String existenceMoneyValueControlManager,
    bool managerPercent,
    String piecesPercentValueControlCar,
    String piecesMoneyValueControlCar,
    String existenceMoneyValueControlCar,
    String categoryNameControl,
  ) {
    int trueCountManager = 0;
    if (piecesPercentValueControlManager.isNotEmpty) trueCountManager++;
    if (piecesMoneyValueControlManager.isNotEmpty) trueCountManager++;
    if (existenceMoneyValueControlManager.isNotEmpty) trueCountManager++;
    if (managerPercent) trueCountManager++;
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
      managerPercent: managerPercent,
      piecesPercentValueCar: int.tryParse(piecesPercentValueControlCar),
      piecesMoneyValueCar: int.tryParse(piecesMoneyValueControlCar),
      existenceMoneyValueCar: int.tryParse(existenceMoneyValueControlCar),
      categoryName: categoryNameControl,
      isActive: true,
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
    if (model.managerPercent) {
      massage = ' Каждому менеджеру свой процент';
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

  dynamic deleteOrder(String docID) {
    db.collection('orders').doc(docID).delete();
  }
}

class RepoAdminGetPost {
  final db = FirebaseFirestore.instance;
  final int today =
      DateTime.now().millisecondsSinceEpoch - DateTime.now().hour * 3600000;

  Stream<List<OrderModel>> getAllOrders() {
    return db
        .collection('orders')
        .where('delivered', isNull: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirebase(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<List<UsersRegistrationModel>> getAllCars() async {
    var collection = FirebaseFirestore.instance.collection('cars');
    var querySnapshot = await collection.get();
    List<UsersRegistrationModel> list = [];
    for (var doc in querySnapshot.docs) {
      UsersRegistrationModel data = UsersRegistrationModel.fromJson(doc.data());
      list.add(data);
    }
    return list;
  }

  Future<List<UsersRegistrationModel>> getAllManagers() async {
    var collection = FirebaseFirestore.instance.collection('managers');
    var querySnapshot = await collection.get();
    List<UsersRegistrationModel> list = [];
    for (var doc in querySnapshot.docs) {
      UsersRegistrationModel data = UsersRegistrationModel.fromJson(doc.data());
      list.add(data);
    }
    return list;
  }

  dynamic saveCarIDtoOrders(int carID, String docID) {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(docID)
        .update({'carID': carID}).then((value) => carID);
  }

  Stream<List<CityModel>> getCityAddress() {
    return db.collection('address').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => CityModel.fromFirebase(doc)).toList(),
        );
  }

  dynamic setCityName(String name) =>
      db.collection('address').doc(name).set({'street': []});

  dynamic setStreetName(String cityName, String streetName) =>
      db.collection('address').doc(cityName).update({
        'street': FieldValue.arrayUnion([streetName]),
      });

  dynamic saveAddress(
    String city,
    String street,
  ) =>
      db.collection('address').doc(city).update({
        'street': FieldValue.arrayUnion([street]),
      });

  dynamic saveAddressAndManager(
    String city,
    String street,
    String house,
    String apartment,
    String id,
  ) {
    saveAddress(city, street);
    String save = ('$city $street дом $house кв $apartment').toLowerCase();
    db
        .collection('managerAddress')
        .doc(save)
        .set({'managerID': id, 'phone': null, 'name': null});
  }

  dynamic savePhoneNameAddress(String phone, String name, String address) {
    db
        .collection('managerAddress')
        .doc(address)
        .update({'phone': phone, 'name': name});
  }

  List<OrderModel> sortListToCreated(List<OrderModel> list) {
    list.sort((a, b) => b.created.compareTo(a.created));
    return list;
  }

  dynamic writeAddressToManagers(
    String address,
    String id,
    String phone,
    String? name,
  ) {
    name ??= '';
    db
        .collection('managerAddress')
        .doc(address)
        .set({'managerID': id, 'phone': phone, 'name': name});
  }
}
