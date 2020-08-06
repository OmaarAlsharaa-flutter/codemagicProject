import 'dart:async';

import 'package:delevery_online/Model/slider.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';


class  SliderBloc implements Disposable{
  List<SliderInfo> products;
  HelpersApi helpersApi;



  final StreamController<List<SliderInfo>> _sliderController =StreamController<List<SliderInfo>>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<List<SliderInfo>> get sliderStream => _sliderController.stream;
  StreamSink<String> get fetchSliderData => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _sliderController.close();
    _categoryController.close();
  }

  String categoryId ;

  SliderBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    products=[];
    _sliderController.add(products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchCategoriesFromApi);
  }

  Future<void> _fetchCategoriesFromApi(String categoryId) async{
    this.products = await helpersApi.getSliderData();
    _sliderController.add(this.products);

  }

}