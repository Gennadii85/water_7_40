// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../model/price_model.dart';

class PriceEntity {
  List<PriceCategories> categoriesList;
  PriceEntity({
    required this.categoriesList,
  });
}

class PriceCategories {
  String nameCategories;
  List<PriceModel> priceModelList;
  List<int> countList;
  PriceCategories({
    required this.nameCategories,
    required this.priceModelList,
    required this.countList,
  });
}
