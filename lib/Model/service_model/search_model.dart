class SearchModel{
  String id ;
  String product_id ;
  String pic;
  String  title , description;
  String price ,quantity;
  String quantity_type;
  String category_id;
  bool price_visible;
  bool is_have_unites_in_final_page;
  bool is_in_cart;
  String type;

  SearchModel({this.id,product_id,this.pic, this.title, this.description,this.price_visible, this.price, this.quantity,
    this.quantity_type, this.category_id , this.is_have_unites_in_final_page , this.type , this.is_in_cart}); // List<ProductReview> reviews;


  SearchModel.fromJson( Map<dynamic,dynamic> jsonObject ){
    this.pic = jsonObject['pic'];
    this.title = jsonObject['title'];
    this.description = jsonObject['description'];
    this.price = jsonObject['price'];
    this.price_visible = jsonObject['price_visible'];
    this.is_have_unites_in_final_page = jsonObject['is_have_unites_in_final_page'];
    this.quantity = jsonObject['quantity'];
    this.quantity_type = jsonObject['quantity_type'];
    this.category_id = jsonObject['category_id'];
    this.id = jsonObject['id'];
    this.product_id = jsonObject['product_id'];
    this.type = jsonObject['type'];
    this.is_in_cart = jsonObject['is_in_cart'];

  }

  String feuatredImage(){
    return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7nJB8g29IeZ31DK7JCuowgeYwl87NyGAI-fgTdTPmr4PT6A1ZDg";
  }

}