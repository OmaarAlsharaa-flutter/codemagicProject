import 'dart:async';
import 'dart:io';
import 'package:delevery_online/Model/main_setting_model.dart';
import 'package:delevery_online/Model/session.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/myHomePage.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  HelpersApi helpersApi = new HelpersApi();
  Animation flipAnimation;
  AnimationController animationController;

  var duration = Duration(milliseconds: 5000);
  Future<Null> checkInternetConnection() async {
    Timer.run(() {
      try {
        InternetAddress.lookup('google.com').then((result) {
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            new Timer(duration, () async {
              MainSetting mainSettingModel = await helpersApi.fetchMainSettings('0');
              SharedPreferences mainSettingsPref = await SharedPreferences.getInstance();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (prefs.get('hasSessionId') == null) {
                Session session = await helpersApi.fetchSessionId();
                prefs.setString('hasSessionId', session.result);
              }
              mainSettingsPref.setString(
                  'site_name', mainSettingModel.site_name);
              mainSettingsPref.setString('site_url', mainSettingModel.site_url);
              mainSettingsPref.setString(
                  'site_mail', mainSettingModel.site_mail);
              mainSettingsPref.setString(
                  'facebook_link', mainSettingModel.facebook_link);
              mainSettingsPref.setString(
                  'twitter_link', mainSettingModel.twitter_link);
              mainSettingsPref.setString(
                  'instagram_link', mainSettingModel.instagram_link);
              mainSettingsPref.setString('phone', mainSettingModel.phone);
              mainSettingsPref.setString('mobile', mainSettingModel.mobile);
              mainSettingsPref.setString('address', mainSettingModel.address);
              mainSettingsPref.setString('version_number', mainSettingModel.version_number);
              Navigator.of(context).pop(true);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            });
          } else {
            showDialogNoInternet(); // show dialog
          }
        }).catchError((error) {
          showDialogNoInternet(); // show dialog
        });
      } on SocketException catch (_) {
        showDialogNoInternet(); // show dialog
      }
    });
  }

  void showDialogNoInternet() {
    // dialog implementation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("غير متصل بالانترنت"),
        content: Text("الرجاء التأكد من الاتصال بالانترنت"),
        actions: <Widget>[
          FlatButton(
              child: Text("إعادة المحاولة"),
              onPressed: () {
                Navigator.of(context).pop(true);
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => SplashScreen()));
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    initAnimation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initAnimation() {
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    flipAnimation = Tween(begin: 1.0, end: 0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.bounceOut));
    animationController.forward();
  }

  ScreenConfig screenConfig;
  WidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);
    return new Scaffold(
      body: new Container(
          color: ScreenUtileColors.mainBlue,
          width: MediaQuery.of(context).size.width,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget widget) {
              return UiWithOutAnimation();
            },
          )),
    );
  }

  Widget UiWithOutAnimation() {
    //   final double pie = 3.4;
    // final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return new Scaffold(
      backgroundColor: ScreenUtileColors.mainBlue,
      body: Transform(
        transform: Matrix4.translationValues(0.0, -(height * flipAnimation.value), 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: new Image(
                image: AssetImage("assests/images/logo.png"),
                width: 200,
                height: 200,
              ),
            ),
            Text(
              "ديليفري أون لاين",
              style: TextStyle(
                color: ScreenUtileColors.fontColor,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "9090",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ScreenUtileColors.fontColor,
                    fontSize: 20,
                  ),
                ),
                SizedBox(width: 20,),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white,
                  child: Image.asset('assests/images/phone.png' ,width: 18 , height: 18,fit: BoxFit.contain,),
                ),
//                Container(
//                  width: 60,
//                  height:100,
////color: Colors.white,
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      shape: BoxShape.rectangle,
////                      image: DecorationImage(
////                        image: AssetImage('assests/images/phone.png'),
////                        fit: BoxFit.contain,
////                      ),
//                    ),
//                  child: Image.asset('assests/images/phone.png' , width: 2 ,height: 2,fit: BoxFit.contain,),
//                ),
//                CircleAvatar(
//                  backgroundImage:  AssetImage('assests/images/phone.png'),
//                  radius: 16,
//                  backgroundColor: ScreenUtileColors.fontColor,
//                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
