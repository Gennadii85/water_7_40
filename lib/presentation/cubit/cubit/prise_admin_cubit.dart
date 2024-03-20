// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../../core/var_admin.dart';
// import '../../../data/model/price_model.dart';

// part 'prise_admin_state.dart';

// class PriceAdminCubit extends Cubit<PriceAdminState> {
//   PriceAdminCubit()
//       : super(
//           PriceAdminInitState(
//             goodsName: '',
//             goodsPrice: 0,
//             piecesPercentValue: null, //какой процент на каждую штуку
//             piecesMoneyValue: null, //сколько денег на каждую штуку
//             existenceMoneyValue:
//                 null, // сколько денег за наличие в заказе неважно сколько шт.
//           ),
//         );

//   void writeOrder(
//     String goodsNameControl,
//     String goodsPriceControl,
//     String piecesPercentValueControl,
//     String piecesMoneyValueControl,
//     String existenceMoneyValueControl,
//   ) {
//     final model = PriceModel(
//       goodsName: goodsNameControl,
//       goodsPrice: int.tryParse(goodsPriceControl) ?? 0,
//       piecesPercentValue: int.tryParse(piecesPercentValueControl),
//       piecesMoneyValue: int.tryParse(piecesMoneyValueControl),
//       existenceMoneyValue: int.tryParse(existenceMoneyValueControl),
//     );
//     FirebaseFirestore.instance
//         .collection(VarAdmin.dbPrice)
//         .doc()
//         .set(model.toFirebase());
//   }
// }
