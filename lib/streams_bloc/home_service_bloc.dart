import 'dart:async';
import 'package:delevery_online/Model/service_model/serviceModel.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';

class  HomeServiceBloc implements Disposable{
  List<ServiceModel> products;
  HelpersApi helpersApi;



  final StreamController<List<ServiceModel>> _homeServiceController =StreamController<List<ServiceModel>>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<List<ServiceModel>> get homeServiceStream => _homeServiceController.stream;
  StreamSink<String> get fetchHomeService => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _homeServiceController.close();
    _categoryController.close();
  }

  String categoryId ;

  HomeServiceBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    products=[];
    _homeServiceController.add(products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(String categoryId) async{
    this.products = await helpersApi.fetchHomeServiceCategories(categoryId);
    _homeServiceController.add(this.products);

  }

}