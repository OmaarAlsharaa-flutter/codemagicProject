import 'dart:async';

import 'package:delevery_online/Model/main_setting_model.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/interfaces/contracts.dart';



class  ContactUsBloc implements Disposable{
  MainSetting products;
  HelpersApi helpersApi;

  final StreamController<MainSetting> _mainSettingController =StreamController<MainSetting>.broadcast();
  final StreamController<String> _categoryController = StreamController<String>.broadcast();


  Stream<MainSetting> get mainSettingStream => _mainSettingController.stream;
  StreamSink<String> get fetchMainSetting => _categoryController.sink;
  Stream<String> get category =>_categoryController.stream;

  @override
  void dispose() {
    _mainSettingController.close();
    _categoryController.close();
  }

  String categoryId ;

  ContactUsBloc(){
    this.categoryId = categoryId;
    helpersApi = HelpersApi();
    products= new MainSetting();
    _mainSettingController.add(products);
    _categoryController.add(this.categoryId);
    _categoryController.stream.listen(_fetchMainSettingsFromApi);
  }

  Future<void> _fetchMainSettingsFromApi(String categoryId) async{
    this.products = await helpersApi.fetchMainSettings(categoryId);
    _mainSettingController.add(this.products);
  }

}