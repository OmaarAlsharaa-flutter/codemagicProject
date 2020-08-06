import 'dart:async';

import 'package:delevery_online/Model/category.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';



class  SubCategoryBloc implements Disposable{
  Category products;
  HelpersApi helpersApi;



  final StreamController<Category> _subCategoryController =StreamController<Category>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<Category> get categoryStream => _subCategoryController.stream;
  StreamSink<String> get fetchCategories => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _subCategoryController.close();
    _categoryController.close();
  }

  String categoryId ;

  SubCategoryBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    products= new Category();
    _subCategoryController.add(products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(String categoryId) async{

    this.products = await helpersApi.fetchCategoryInfo(categoryId);
    _subCategoryController.add(this.products);
  }

}