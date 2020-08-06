class Product{
  String product_id ;
  String pic;
  String  title , description;
  String price ,quantity;
  String quantity_type;
  String category_id;
  bool price_visible;
  bool is_in_cart;
  double startFoodQuantityValue = 0.0;
  double startFlowerQuantityValue = 0.0;




  Product({this.product_id,this.pic, this.title, this.description,this.price_visible, this.price, this.quantity,
      this.quantity_type, this.category_id , this.is_in_cart , this.startFoodQuantityValue , this.startFlowerQuantityValue}); // List<ProductReview> reviews;


  Product.fromJson( Map<dynamic,dynamic> jsonObject ){
    this.pic = jsonObject['pic'];
    this.title = jsonObject['title'];
    this.description = jsonObject['description'];
    this.price = jsonObject['price'];
    this.price_visible = jsonObject['price_visible'];
    this.quantity = jsonObject['quantity'];
    this.quantity_type = jsonObject['quantity_type'];
    //  this.product_total = double.tryParse(jsonObject['product_total']);
    //  this.product_discount = double.tryParse(jsonObject['product_discount']);
    this.category_id = jsonObject['category_id'];
    this.product_id = jsonObject['product_id'];
    this.is_in_cart = jsonObject['is_in_cart'];

  }
//    assert(jsonObject['product_id']== null,"product_id is null");
//    assert(jsonObject['pic']==null,"pic is null");
//    assert(jsonObject['title']==null,"title is null");
//    assert(jsonObject['description']==null,"description is null");
//    assert(jsonObject['price_visible']==null,"price_visible is null");
//    assert(jsonObject['price']==null,"price is null");
//
//    if ( jsonObject['product_id'] == null){
//      throw PropertyIsRequired("product_id");
//    }
//    if ( jsonObject['pic'] == null){
//      throw PropertyIsRequired("pic");
//    }
//    if ( jsonObject['title'] == null){
//      throw PropertyIsRequired("title");
//    }
//    if ( jsonObject['description'] == null){
//      throw PropertyIsRequired("description");
//    }
//    if ( jsonObject['price'] == null){
//      throw PropertyIsRequired("price");
//    }
//    if ( jsonObject['price_visible'] == null){
//      throw PropertyIsRequired("price_visible");
//    }
//    if ( jsonObject['category_id'] == null){
//      throw PropertyIsRequired("category_id");
//    }

  String feuatredImage(){
    return "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ7nJB8g29IeZ31DK7JCuowgeYwl87NyGAI-fgTdTPmr4PT6A1ZDg";
  }

}