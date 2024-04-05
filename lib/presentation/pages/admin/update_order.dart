// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:water_7_40/core/var_manager.dart';
// import 'package:water_7_40/data/model/price_model.dart';
// import 'package:water_7_40/data/repositories/manager_page_repo.dart';
// import 'package:water_7_40/presentation/cubit/order_count/order_count_cubit.dart';
// import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
// import 'package:water_7_40/presentation/pages/admins_page.dart';
// import 'package:water_7_40/presentation/pages/manager/price_card.dart';
// import '../../../data/model/order_model.dart';

// class UpdateOrder extends StatefulWidget {
//   final OrderModel model;
//   const UpdateOrder({
//     Key? key,
//     required this.model,
//   }) : super(key: key);

//   @override
//   State<UpdateOrder> createState() => _UpdateOrderState();
// }

// class _UpdateOrderState extends State<UpdateOrder> {
//   final TextEditingController phoneClient = TextEditingController();
//   final TextEditingController notes = TextEditingController();
//   final TextEditingController addressControl = TextEditingController();
//   final TextEditingController manIDControl = TextEditingController();
//   final TextEditingController managerProfitControl = TextEditingController();
//   final TextEditingController carProfitControl = TextEditingController();
//   bool takeMoney = true;

//   @override
//   void initState() {
//     manIDControl.text = widget.model.managerID.toString();
//     managerProfitControl.text = widget.model.managerProfit.toString();
//     carProfitControl.text = widget.model.carProfit.toString();
//     notes.text = widget.model.notes ?? '';
//     phoneClient.text = widget.model.phoneClient;
//     addressControl.text = widget.model.address;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Редактировать заказ'),
//           centerTitle: true,
//           leading: IconButton(
//             onPressed: () => Navigator.of(context).pop(),
//             icon: const Icon(Icons.arrow_back),
//           ),
//         ),
//         body: StreamBuilder<List<PriceModel>>(
//           stream: RepoManagerPage().getPrice(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final prise = snapshot.data!;
//               return SingleChildScrollView(
//                 child: BlocProvider(
//                   create: (context) => OrderCountCubit(prise),
//                   child: BlocBuilder<OrderCountCubit, OrderCountState>(
//                     builder: (context, state) {
//                       final cubit = BlocProvider.of<OrderCountCubit>(context);
//                       if (state is OrderCountInitState) {
//                         cubit.getListCount(widget.model.goodsList);

//                         // тут состояние не то или новое надо создать
//                       }

//                       return Column(
//                         children: [
//                           Text(
//                             widget.model.address,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               color: Colors.blue,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ListView.builder(
//                               physics: const NeverScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                               itemCount: state.prise.length,
//                               itemBuilder: (context, index) => PriceCard(
//                                 goods: state.prise[index].goodsName,
//                                 prise: state.prise[index].goodsPrice.toString(),
//                                 count: state.listCount[index],
//                                 addCount: () => cubit.addCount(index),
//                                 delCount: () => cubit.delCount(index),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Заказ на сумму: ${state.allMoney.toString()} грн.',
//                                   style: VarManager.cardSize,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 15),
//                           _textFieldRow(
//                             manIDControl,
//                             'ID Менеджера *',
//                           ),
//                           _textFieldRow(
//                             managerProfitControl,
//                             'Заработок менеджера',
//                           ),
//                           _textFieldRow(
//                             carProfitControl,
//                             'Заработок водителя',
//                           ),
//                           _textFieldRow(
//                             phoneClient,
//                             'Телефон клиента *',
//                           ),
//                           _textFieldRow(
//                             notes,
//                             'Заметки',
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 const Text('Расчет с водителем'),
//                                 Checkbox(
//                                   value: takeMoney,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       takeMoney = value!;
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                           AdminButtons(
//                             text: 'Применить',
//                             function: () {
//                               if (phoneClient.text.isEmpty ||
//                                   addressControl.text.isEmpty ||
//                                   cubit.state.allMoney == 0) {
//                                 return;
//                               } else {
//                                 cubit.updateOrder(
//                                   widget.model.docID!,
//                                   addressControl.text,
//                                   phoneClient.text,
//                                   takeMoney,
//                                   notes.text,
//                                   int.tryParse(manIDControl.text) ??
//                                       widget.model.managerID!,
//                                   int.tryParse(managerProfitControl.text) ??
//                                       widget.model.managerProfit!,
//                                   int.tryParse(carProfitControl.text) ??
//                                       widget.model.carProfit!,
//                                 );
//                                 Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) => const AdminPage(),
//                                   ),
//                                 );
//                               }
//                             },
//                           ),
//                           const SizedBox(height: 30),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               );
//             } else if (snapshot.hasError) {
//               return const Center(
//                 child: Text('Не удалось получить прайс.'),
//               );
//             }
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Padding _textFieldRow(TextEditingController controller, String text) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: text,
//           border: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(10),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
