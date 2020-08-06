import 'package:delevery_online/myHomePage.dart';
import 'package:delevery_online/other/final_page_testing.dart';
import 'package:delevery_online/product/home_product.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        Locale('ar', 'AE')// OR Locale('ar', 'AE') OR Other RTL locales
      ],
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            color: ScreenUtileColors.mainBlue
        ),
        hoverColor: ScreenUtileColors.mainBlue,
        fontFamily: 'Cocon',
        backgroundColor: ScreenUtileColors.mainBlue,
        tabBarTheme: TabBarTheme(
          labelColor: ScreenUtileColors.fontColor,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
          labelPadding: EdgeInsets.only(right: 10,left: 10,bottom: 4 ,top: 4),
          indicatorSize: TabBarIndicatorSize.label,
          unselectedLabelColor: ScreenUtileColors.lightGray,
          unselectedLabelStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),),

      debugShowCheckedModeBanner: false,
      title: 'ديليفري أون لاين',
      home: SplashScreen(),
      routes: <String , WidgetBuilder> {
        '/homePage' : (BuildContext context) => new MyHomePage(),
        '/homeProduct' : (BuildContext context) => new HomeProduct(),
        '/finalPage' : (BuildContext context) => new FinalPageScreen(),
      },
    );
  }
}

