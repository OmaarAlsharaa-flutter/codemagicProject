
import 'package:delevery_online/Model/service_model/product_service_model.dart';
import 'package:delevery_online/Model/service_model/sub_service_category.dart';

class ServiceModel{
  String id;
  String title;
  String pic ;
  List<SubServiceCategory> sub_categories;
  List<ProductServiceModel> products;
  bool is_have_unites_in_final_page;

  ServiceModel({this.id, this.title, this.pic , this.is_have_unites_in_final_page , this.sub_categories,this.products} );


  ServiceModel.fromJson(Map<dynamic, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.title = jsonObject['title'];
    this.pic = jsonObject['pic'];
    this.is_have_unites_in_final_page = jsonObject['is_have_unites_in_final_page'];
    this.sub_categories =[];
    if(jsonObject['sub_categories']!= null){
      _setSubCategories(jsonObject['sub_categories']);
    }
    if(jsonObject['products']!= null){
      _setProduct(jsonObject['products']);
    }
  }
  void _setSubCategories(List<dynamic> jsonSubCategories){
    this.sub_categories = [];
    if(jsonSubCategories.length > 0){
      for(var item in jsonSubCategories){
        if(item != null){
          sub_categories.add(SubServiceCategory.fromJson(item));
        }
      }
    }
  }
  void _setProduct(List<dynamic> jsonSubCategories){
    this.products = [];
    if(jsonSubCategories.length > 0){
      for(var item in jsonSubCategories){
        if(item != null){
          products.add(ProductServiceModel.fromJson(item));
        }
      }
    }
  }
}