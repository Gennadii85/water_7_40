import 'package:bloc/bloc.dart';
import '../../../data/model/address_model.dart';

part 'add_address_state.dart';

class AddAddressCubit extends Cubit<AddAddressState> {
  final List<CityModel> data;
  AddAddressCubit(this.data)
      : super(
          AddAddressState(
            cityList: data.map((e) => e.cityName).toList(),
            city: '',
            streetList: [],
            street: '',
          ),
        );

  void addCity() {
    if (state.city.isEmpty) {
      return;
    }
    if (state.cityList.contains(state.city)) {
      emit(
        AddAddressState(
          cityList: state.cityList,
          city: state.city,
          streetList: data
              .where((element) => element.cityName == state.city)
              .first
              .street,
          street: state.street,
        ),
      );
    }
  }
}
