
class AboutUsModel{
  String title;
  String description ;


  AboutUsModel({this.title, this.description});

  AboutUsModel.fromJson(Map<dynamic , dynamic> jsonObject){
    this.title = jsonObject['title'];
    this.description = jsonObject['description'];

  }


}