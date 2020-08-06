import 'dart:async';

import 'package:delevery_online/Model/category.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';


class  CategoryBloc implements Disposable{
  List<Category> products;
  HelpersApi helpersApi;



  final StreamController<List<Category>> _CategoryController =StreamController<List<Category>>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<List<Category>> get categoryStream => _CategoryController.stream;
  StreamSink<String> get fetchCategories => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _CategoryController.close();
    _categoryController.close();
  }

  String categoryId ;

  CategoryBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    products=[];
    _CategoryController.add(products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(String categoryId) async{

    this.products = await helpersApi.fetchCategories();
    _CategoryController.add(this.products);
  }

}