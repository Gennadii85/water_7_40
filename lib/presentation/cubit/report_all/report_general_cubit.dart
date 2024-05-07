import 'package:bloc/bloc.dart';
import '../../../data/model/order_model.dart';

part 'report_general_state.dart';

class ReportGeneralCubit extends Cubit<ReportGeneralState> {
  ReportGeneralCubit()
      : super(
          ReportGeneralState(
            startDate: DateTime.now(),
            finishDate: DateTime.now(),
            cityStreetListModel: [],
            isData: false,
            cityStreetHouseListModel: [],
            cityStreetHouseApartmentListModel: [],
          ),
        );

  dynamic setApartmentList(List<OrderModel> cityStreetHouseApartmentListModel) {
    emit(
      ReportGeneralLoaded(
        startDate: state.startDate,
        finishDate: state.finishDate,
        cityStreetListModel: state.cityStreetListModel,
        isData: true,
        cityStreetHouseListModel: state.cityStreetHouseListModel,
        cityStreetHouseApartmentListModel: cityStreetHouseApartmentListModel,
      ),
    );
  }

  dynamic setHouseList(List<OrderModel> cityStreetHouseListModel) {
    emit(
      ReportGeneralLoaded(
        startDate: state.startDate,
        finishDate: state.finishDate,
        cityStreetListModel: state.cityStreetListModel,
        isData: true,
        cityStreetHouseListModel: cityStreetHouseListModel,
        cityStreetHouseApartmentListModel:
            state.cityStreetHouseApartmentListModel,
      ),
    );
  }

  dynamic setCityList(List<OrderModel> cityStreetListModel) {
    emit(
      ReportGeneralLoaded(
        startDate: state.startDate,
        finishDate: state.finishDate,
        cityStreetListModel: cityStreetListModel,
        isData: true,
        cityStreetHouseListModel: state.cityStreetHouseListModel,
        cityStreetHouseApartmentListModel:
            state.cityStreetHouseApartmentListModel,
      ),
    );
  }

  dynamic getStartFinishOrders() {
    emit(
      ReportGeneralLoaded(
        startDate: state.startDate,
        finishDate: state.finishDate,
        cityStreetListModel: state.cityStreetListModel,
        isData: true,
        cityStreetHouseListModel: state.cityStreetHouseListModel,
        cityStreetHouseApartmentListModel:
            state.cityStreetHouseApartmentListModel,
      ),
    );
  }

  dynamic addStart(DateTime startDate) {
    emit(
      ReportGeneralState(
        startDate: startDate,
        finishDate: state.finishDate,
        cityStreetListModel: state.cityStreetListModel,
        isData: false,
        cityStreetHouseListModel: state.cityStreetHouseListModel,
        cityStreetHouseApartmentListModel:
            state.cityStreetHouseApartmentListModel,
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
        cityStreetListModel: state.cityStreetListModel,
        isData: false,
        cityStreetHouseListModel: state.cityStreetHouseListModel,
        cityStreetHouseApartmentListModel:
            state.cityStreetHouseApartmentListModel,
      ),
    );
  }
}
