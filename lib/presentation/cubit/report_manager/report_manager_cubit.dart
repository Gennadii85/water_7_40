import 'package:bloc/bloc.dart';
import 'package:water_7_40/data/model/order_model.dart';

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
}
