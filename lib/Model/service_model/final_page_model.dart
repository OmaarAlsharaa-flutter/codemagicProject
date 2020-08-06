import 'package:delevery_online/interfaces/contracts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FinalPageModel implements Disposable{


  String id , input_type , hint ,service_id , placeholder;
  bool is_required , is_phone;
  String option_1 , option_2 , option_3;
  String testText = '';
  TextEditingController textEditingController =  new TextEditingController();
  TextEditingController textEditingControllerForTextArea =  new TextEditingController();




  FinalPageModel({this.id, this.input_type, this.hint, this.service_id,
      this.is_required, this.is_phone, this.option_1, this.option_2,
      this.option_3 , this.placeholder});

  FinalPageModel.fromJson(Map<dynamic, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.input_type = jsonObject['input_type'];
    this.hint = jsonObject['hint'];
    this.service_id = jsonObject['service_id'];
    this.is_required = jsonObject['is_required'];
    this.is_phone = jsonObject['is_phone'];
    this.option_1 = jsonObject['option_1'];
    this.option_2 = jsonObject['option_2'];
    this.option_3 = jsonObject['option_3'];
    this.placeholder = jsonObject['placeholder'];
  }

  @override
  void dispose() {
    textEditingController.dispose();
    textEditingControllerForTextArea.dispose();
  }


}