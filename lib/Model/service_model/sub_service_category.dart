class SubServiceCategory {

  String id;
  String title;

  SubServiceCategory(this.id, this.title );

  SubServiceCategory.fromJson(Map<dynamic, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.title = jsonObject['title'];
  }
}