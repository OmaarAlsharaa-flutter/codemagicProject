import 'package:delevery_online/Model/subCategory.dart';

class Category{
  var id;
  String title;
  String pic ;
  bool has_sub_categories ;
  List<SubCategory> sub_categories;
  String type ;
  bool is_have_unites_in_final_page;

  Category({this.id, this.title, this.pic, this.has_sub_categories,
    this.sub_categories , this.type , this.is_have_unites_in_final_page} );


  Category.fromJson(Map<dynamic, dynamic> jsonObject) {

    this.id = jsonObject['id'];
    this.title = jsonObject['title'];
    this.pic = jsonObject['pic'];
    this.has_sub_categories = jsonObject['has_sub_categories'];
    this.type = jsonObject['type'];
    this.is_have_unites_in_final_page = jsonObject['is_have_unites_in_final_page'];

    this.sub_categories =[];
    if(jsonObject['sub_categories']!= null){
      _setSubCategories(jsonObject['sub_categories']);
    }

  }
  void _setSubCategories(List<dynamic> jsonSubCategories){
    this.sub_categories = [];
    if(jsonSubCategories.length > 0){
      for(var item in jsonSubCategories){
        if(item != null){
          sub_categories.add(SubCategory.fromJson(item));
        }
      }
    }
  }
}