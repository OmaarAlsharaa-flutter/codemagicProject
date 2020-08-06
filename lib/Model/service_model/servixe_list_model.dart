
class ServiceListModel{
  String id;
  String title;
  String pic ;
  String type ;
  bool is_have_unites_in_final_page;

  ServiceListModel({this.id, this.title, this.pic , this.is_have_unites_in_final_page , this.type});


  ServiceListModel.fromJson(Map<dynamic, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.title = jsonObject['title'];
    this.pic = jsonObject['pic'];
    this.type = jsonObject['type'];
    this.is_have_unites_in_final_page = jsonObject['is_have_unites_in_final_page'];
  }
}