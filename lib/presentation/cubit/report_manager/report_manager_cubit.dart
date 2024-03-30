import 'package:bloc/bloc.dart';
import 'package:water_7_40/data/model/order_model.dart';

import '../../../data/repositories/admin/admin_manager_report_repo.dart';

part 'report_manager_state.dart';

class ReportManagerCubit extends Cubit<ReportManagerState> {
  ReportManagerCubit()
      : super(
          ReportManagerState(
            startDate: DateTime.now(),
            finishDate: DateTime.now(),
            listModel: [],
          ),
        );

  dynamic addStart(DateTime startDate) {
    emit(
      ReportManagerState(
        startDate: startDate,
        finishDate: state.startDate,
        listModel: state.listModel,
      ),
    );
  }

  dynamic addFinish(DateTime finishDate) {
    if (finishDate.millisecondsSinceEpoch <
        state.startDate.millisecondsSinceEpoch) {
      return;
    }
    emit(
      ReportManagerState(
        startDate: state.startDate,
        finishDate: finishDate,
        listModel: state.listModel,
      ),
    );
  }

  // dynamic getListModel(int id) async {
  //   List<OrderModel> modelList = await RepoAdminManagersReport().getAllOrders(
  //     id,
  //     state.startDate,
  //     state.finishDate,
  //   );
  //   emit(
  //     ReportManagerState(
  //       startDate: state.startDate,
  //       finishDate: state.finishDate,
  //       listModel: modelList,
  //     ),
  //   );
  //   // print(modelList);
  // }
}
