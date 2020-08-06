class AddOrderModel{

  String result;
  List  errors_code = []  ;
  List  errors_text  = [] ;

  AddOrderModel(this.result, this.errors_code, this.errors_text);

  AddOrderModel.fromJson(Map<dynamic, dynamic> jsonObject){
    this.result = jsonObject['result'];
    this.errors_code = jsonObject['errors_code'];
    this.errors_text = jsonObject['errors_text'];

  }
}