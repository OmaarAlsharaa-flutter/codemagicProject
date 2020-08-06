class Session{
  String result ;

  Session(this.result);

  Session.fromJson(Map<String , dynamic> jsonObject){
    this.result = jsonObject['result'];
  }


}