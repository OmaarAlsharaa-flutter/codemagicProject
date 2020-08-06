class SubCategory {

  String id;
  String title;

  SubCategory(this.id, this.title );

  SubCategory.fromJson(Map<dynamic, dynamic> jsonObject) {
    this.id = jsonObject['id'];
    this.title = jsonObject['title'];
  }
}

