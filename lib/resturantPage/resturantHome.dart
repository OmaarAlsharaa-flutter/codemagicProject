import 'package:cached_network_image/cached_network_image.dart';
import 'package:delevery_online/Model/category.dart';
import 'package:delevery_online/api/apiUtil.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/resturantPage/list_food_of_resturant.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:delevery_online/utility/helpersWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ResturantHome extends StatefulWidget {
  @override
  _ResturantHomeState createState() => _ResturantHomeState();
}

class _ResturantHomeState extends State<ResturantHome> {
  HelpersApi helpersApi = new HelpersApi();
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  List<Category> resturant_categories = [];
  String imagesUrl = ApiUtil.imagesUrl;

  void getCategories() async {
    List data = await helpersApi.fetchRestaurantsCategories();
    for (int i = 0; i < data.length; i++) {
      setState(() {
        resturant_categories.add(data[i]);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: ScreenUtileColors.mainBlue,
          centerTitle: true,
          title: Text("المطاعم"),
        ),
        body: FutureBuilder(
          future: helpersApi.fetchRestaurantsCategories(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Category>> snapShot) {
            switch (snapShot.connectionState) {
              case ConnectionState.none:
                return error("No Thing Working");
                break;
              case ConnectionState.waiting:
                return loading();
                break;
              case ConnectionState.done:
              case ConnectionState.active:
                if(snapShot.hasError){
                  return error(snapShot.error.toString());
                }else{
                  if(! snapShot.hasData){
                    return Container(child: Text('No Data Avilaible'),);
                  }else{
                    if(snapShot.data.isEmpty){
                      return _noData();
                    }
                    return restaurantsGrid(snapShot.data);
                  }
                }
                break;
            }
            return Container();
          },

        ));
  }

  Widget restaurantsGrid(List<Category> restaurantsCategory) {
    return OrientationBuilder(builder: (context, orientation) {
      return CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 3 : 5,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return GestureDetector(
                  onTap: () {
                    String idSelected = restaurantsCategory[index].id.toString();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FoodInResturant(idSelected ,restaurantsCategory[index].title)));
                  },
                  child: Card(
                    child: CachedNetworkImage(
                      imageUrl:
                          "$imagesUrl${restaurantsCategory[index].pic}",
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${restaurantsCategory[index].title}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            textAlign: TextAlign.end,
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
                );
              }, childCount: restaurantsCategory.length))
        ],
      );
    });
  }

  Widget _noData (){
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Image(image: AssetImage("assests/images/lost-items.png"),height: 200,width:300 ,),
            SizedBox(height: 8,),
            Text("لا يوجد مطاعم هنا هنا :(  ", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black45 ),),

          ],
        ),
      ),
    );
  }
}
