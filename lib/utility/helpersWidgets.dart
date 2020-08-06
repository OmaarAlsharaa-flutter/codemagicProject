import 'package:cached_network_image/cached_network_image.dart';
import 'package:delevery_online/Model/service_model/search_model.dart';
import 'package:delevery_online/other/final_page_testing.dart';
import 'package:delevery_online/product/home_product.dart';
import 'package:delevery_online/product/single_product.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/servies_screens/home_services.dart';
import 'package:delevery_online/servies_screens/products_in_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget loading() {
  return Container(
    color: Colors.white,
    child: Center(
      child: CircularProgressIndicator(
        backgroundColor: ScreenUtileColors.fontColor,
        strokeWidth: 2.0,
      ),
    ),
  );
}
Widget error(String error) {
  return Container(
    child: Center(
      child: Text(
        error,
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    ),
  );
}
Widget searchResult(List<SearchModel> list, BuildContext context, String imageUrl) {
  return Container(
    child: Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, position) {
                return GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String sessionId = prefs.get('hasSessionId');
                    String idSelected = list[position].id;
                    String serviceName = list[position].title;
                    prefs.setString('serviceId', idSelected);
                    switch (list[position].type) {
                      case 'product':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            maintainState: true,
                            settings: RouteSettings(name: "product"),
                            builder: (context) => SingleProduct(list[position] , false , null ,null ,null , null),
                          ),
                        );
                        Navigator.popUntil(
                            context, ModalRoute.withName("product"));

//                          Navigator.canPop(context);
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) =>
//                                      SingleProduct(list[position])));
                        break;
                      case 'category':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            maintainState: true,
                            settings: RouteSettings(name: "category"),
                            builder: (context) => HomeProduct(
                              sessionId: sessionId,
                             // todo
                              idComing: idSelected,
                              nameCategory: list[position].title,
                              currIndex : 0
                            ),
                          ),
                        );
                        Navigator.popUntil(
                            context, ModalRoute.withName("category"));

//                          Navigator.canPop(context);
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => HomeProduct(
//                                        idComing: idSelected,
//                                        nameCategory: list[position].title,
//                                      )));
                        break;
                      case 'service_categories':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            maintainState: true,
                            settings: RouteSettings(name: "service_categories"),
                            builder: (context) => HomeService(
                              sessionId: sessionId,
                              idComing: idSelected,
                              nameComing: serviceName,
                              isHasUnit:
                                  list[position].is_have_unites_in_final_page,
                              servicePic: list[position].pic,
                            ),
                          ),
                        );
                        Navigator.popUntil(
                            context, ModalRoute.withName("service_categories"));

//                          Navigator.canPop(context);
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => HomeService(
//                                      idSelected,
//                                      serviceName,
//                                      list[position]
//                                          .is_have_unites_in_final_page,
//                                      list[position].pic)));
                        break;
                      case 'service_products':
                        SharedPreferences category__Id =
                            await SharedPreferences.getInstance();
                        category__Id.setString('category__Id', '0');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            maintainState: true,
                            settings: RouteSettings(name: "service_products"),
                            builder: (context) => ProductsInServices(
                                '0',
                                idSelected,
                                serviceName,
                                list[position].is_have_unites_in_final_page,
                                list[position].pic,
                            sessionId , 0,0,true),
                          ),
                        );
                        Navigator.popUntil(
                            context, ModalRoute.withName("service_products"));

//                          Navigator.canPop(context);
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => ProductsInServices(
//                                      '0',
//                                      idSelected,
//                                      serviceName,
//                                      list[position]
//                                          .is_have_unites_in_final_page,
//                                      list[position].pic)));
//                          print(list[position].is_have_unites_in_final_page);
                        break;
                      case 'final_page':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            maintainState: true,
                            settings: RouteSettings(name: "final_page"),
                            builder: (context) => FinalPageScreen(
                              serviceIdComing: idSelected,
                              serviceNameComing: serviceName,
                              isHasUnitInFinalPage:
                                  list[position].is_have_unites_in_final_page,
                              serviceCover: list[position].pic,
                            ),
                          ),
                        );
                        Navigator.popUntil(
                            context, ModalRoute.withName("final_page"));
//                          Navigator.canPop(context);
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => FinalPageTesting(
//                                        serviceIdComing: idSelected,
//                                        serviceNameComing: serviceName,
//                                        isHasUnitInFinalPage: list[position]
//                                            .is_have_unites_in_final_page,
//                                        serviceCover: list[position].pic,
//                                      )));
//                          print(list[position].is_have_unites_in_final_page);
                        break;
                      default:
                        return null;
                        break;
                    }
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Container(
                            width: 90,
                            height:90,
                            child: CachedNetworkImage(
                              imageUrl: "$imageUrl${list[position].pic}",
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Image(
                                image: AssetImage("assests/images/giphy.gif"),
                                width: 12,
                                height: 12,
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
//                          CircleAvatar(
//                            radius: 35,
//                            backgroundImage: NetworkImage(
//                                '$imageUrl${list[position].pic}'),
//                            backgroundColor: Colors.transparent,
//                          ),
                          SizedBox(
                            width: 60.0,
                          ),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${list[position].title}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    ),
  );
}
Widget noSearchData(BuildContext context) {
  return Container(
    color: Colors.white,
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage("assests/images/no_search_result.png"),
            height: 120,
            width: 150,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "لا يوجد نتائج لعملية البحث ",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black45),
          ),
        ],
      ),
    ),
  );
}
