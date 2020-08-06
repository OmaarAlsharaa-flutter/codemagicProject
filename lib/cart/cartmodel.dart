
class CartModel {
  String product_id ;
  String item_in_cart_id ;
  String requested_quantity ;
  String product_pic ;
  String product_title ;
  String product_price ;
  String quantity_type ;
  double finalValue = 0.0;

  CartModel(this.product_id, this.item_in_cart_id, this.requested_quantity,
      this.product_pic, this.product_title, this.product_price,this.quantity_type , {this.finalValue});

  CartModel.fromJson( Map<dynamic,dynamic> jsonObject ){


    this.product_id = jsonObject['product_id'];
    this.item_in_cart_id = jsonObject['item_in_cart_id'];
    this.requested_quantity = jsonObject['requested_quantity'].toString();
    this.product_pic = jsonObject['product_pic'];
    this.product_title = jsonObject['product_title'];
    this.product_price = jsonObject['product_price'];
    this.quantity_type = jsonObject['quantity_type'];

  }


}