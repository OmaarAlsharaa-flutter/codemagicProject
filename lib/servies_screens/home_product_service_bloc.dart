import 'dart:async';
import 'package:delevery_online/Model/service_model/product_service_model.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeProductServiceBloc implements Disposable{
  List<ProductServiceModel> productsInService;
  HelpersApi helpersApi;

  final StreamController<List<ProductServiceModel>> _productInServiceController =StreamController<List<ProductServiceModel>>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<List<ProductServiceModel>> get productsStream => _productInServiceController.stream;
  StreamSink<String> get fetchProduct => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _productInServiceController.close();
    _categoryController.close();
  }

  String serviceId ;

  HomeProductServiceBloc(){
    this.serviceId = serviceId;
    helpersApi = HelpersApi();
    productsInService=[];
    _productInServiceController.add(productsInService);
    _categoryController.add(this.serviceId);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(String serviceId ) async{
    SharedPreferences category__Id = await SharedPreferences.getInstance();
    String category_Id =category__Id.get('category__Id');
    this.productsInService = await helpersApi.fetchProductByServiceId( category_Id , serviceId);
    _productInServiceController.add(this.productsInService);
  }

}