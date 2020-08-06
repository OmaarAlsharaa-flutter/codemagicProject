
import 'package:delevery_online/exceptionStatus/all_exception.dart';

class UnitModel {
  String id;
  String unite_value;
  String unite_price;


  UnitModel(this.id, this.unite_value, this.unite_price);

  UnitModel.fromJson(Map<String, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.unite_value = jsonObject['unite_value'];
    this.unite_price = jsonObject['unite_price'];


    if (jsonObject['id'] == null) {
      throw PropertyIsRequired("id");
    }
    if (jsonObject['unite_value'] == null) {
      throw PropertyIsRequired("unite_value");
    }
    if (jsonObject['unite_price'] == null) {
      throw PropertyIsRequired("unite_price");
    }
  }

}