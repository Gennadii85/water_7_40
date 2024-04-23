// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:water_7_40/data/model/order_model.dart';

import '../../../data/model/users_registration_model.dart';

part 'report_manager_state.dart';

class ReportManagerCubit extends Cubit<ReportManagerState> {
  ReportManagerCubit()
      : super(
          ReportManagerState(
            startDate: DateTime.now(),
            finishDate: DateTime.now(),
            listModel: [],
            manager: UsersRegistrationModel(
              nickname: 'Выберите менеджера',
              name: '',
              id: 0,
              password: '',
              percent: 0,
            ),
            isData: false,
          ),
        );

  dynamic getStartFinishOrders() {
    emit(
      ReportManagerLoaded(
        startDate: state.startDate,
        finishDate: state.finishDate,
        listModel: state.listModel,
        manager: state.manager,
        isData: true,
      ),
    );
  }

  dynamic checkManager(UsersRegistrationModel elem) {
    emit(
      ReportManagerState(
        startDate: state.startDate,
        finishDate: state.finishDate,
        listModel: state.listModel,
        manager: elem,
        isData: false,
      ),
    );
  }

  dynamic addStart(DateTime startDate) {
    emit(
      ReportManagerState(
        startDate: startDate,
        finishDate: state.finishDate,
        listModel: state.listModel,
        manager: state.manager,
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
      ReportManagerState(
        startDate: state.startDate,
        finishDate: finishDate,
        listModel: state.listModel,
        manager: state.manager,
        isData: false,
      ),
    );
  }
}
