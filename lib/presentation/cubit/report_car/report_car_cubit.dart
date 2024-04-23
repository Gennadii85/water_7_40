import 'package:bloc/bloc.dart';
import '../../../data/model/order_model.dart';
import '../../../data/model/users_registration_model.dart';

part 'report_car_state.dart';

class ReportCarCubit extends Cubit<ReportCarState> {
  ReportCarCubit()
      : super(
          ReportCarState(
            startDate: DateTime.now(),
            finishDate: DateTime.now(),
            listModel: [],
            car: UsersRegistrationModel(
              nickname: 'Выберите водителя',
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
      ReportCarLoaded(
        startDate: state.startDate,
        finishDate: state.finishDate,
        listModel: state.listModel,
        car: state.car,
        isData: true,
      ),
    );
  }

  dynamic checkCar(UsersRegistrationModel elem) {
    emit(
      ReportCarState(
        startDate: state.startDate,
        finishDate: state.finishDate,
        listModel: state.listModel,
        car: elem,
        isData: false,
      ),
    );
  }

  dynamic addStart(DateTime startDate) {
    emit(
      ReportCarState(
        startDate: startDate,
        finishDate: state.finishDate,
        listModel: state.listModel,
        car: state.car,
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
      ReportCarState(
        startDate: state.startDate,
        finishDate: finishDate,
        listModel: state.listModel,
        car: state.car,
        isData: false,
      ),
    );
  }
}
