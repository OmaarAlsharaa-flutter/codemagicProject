import 'dart:async';
import 'package:delevery_online/Model/category.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';


class HomePageCategoryBloc implements Disposable{
  List<Category> categories;
  HelpersApi helpersApi;


  final StreamController<List<Category>> _categoryController =StreamController<List<Category>>.broadcast();




  Stream<List<Category>> get categoryStream => _categoryController.stream;
  StreamSink<List<Category>> get fetchcategory => _categoryController.sink;
  Stream<List<Category>> get category =>_categoryController.stream;

  @override
  void dispose() {

    _categoryController.close();
  }

  String categoryId ;

  HomePageCategoryBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    categories=[];
    _categoryController.add(categories);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(List<Category> list) async{
    this.categories = await helpersApi.fetchCategories();
    _categoryController.add(this.categories);
    print(categories);
  }

}