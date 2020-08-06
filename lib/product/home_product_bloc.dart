import 'dart:async';
import 'package:delevery_online/Model/product.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeProductBloc implements Disposable{
  List<Product> products;
  HelpersApi helpersApi;



  final StreamController<List<Product>> _productController =StreamController<List<Product>>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<List<Product>> get productsStream => _productController.stream;
  StreamSink<String> get fetchProduct => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _productController.close();
    _categoryController.close();
  }

  String categoryId ;

  HomeProductBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    products=[];
    _productController.add(products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(String categoryId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sessionId = prefs.get('hasSessionId');
    this.products = await helpersApi.fetchProductByCategoryId(categoryId,sessionId);
    _productController.add(this.products);
  }

}