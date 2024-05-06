import 'package:bloc/bloc.dart';
import '../../../data/model/order_model.dart';

part 'report_general_state.dart';

class ReportGeneralCubit extends Cubit<ReportGeneralState> {
  ReportGeneralCubit()
      : super(
          ReportGeneralState(
            startDate: DateTime.now(),
            finishDate: DateTime.now(),
            listModel: [],
            isData: false,
          ),
        );

  dynamic getStartFinishOrders() {
    emit(
      ReportGeneralLoaded(
        startDate: state.startDate,
        finishDate: state.finishDate,
        listModel: state.listModel,
        isData: true,
      ),
    );
  }

  dynamic addStart(DateTime startDate) {
    emit(
      ReportGeneralState(
        startDate: startDate,
        finishDate: state.finishDate,
        listModel: state.listModel,
        isData: false,
      ),
    );
  }

  dynamic addFinish(DateTime finishDate) {
    if (finishDate.millisecondsSinceEpoch <
        state.startDate.millisecondsSinceEpoch) {
      return;
    }
    emit(
      ReportGeneralState(
        startDate: state.startDate,
        finishDate: finishDate,
        listModel: state.listModel,
        isData: false,
      ),
    );
  }
}
