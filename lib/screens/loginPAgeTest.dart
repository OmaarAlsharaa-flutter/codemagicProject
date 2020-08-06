import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreenDemo extends StatefulWidget {
  @override
  _LoginScreenDemoState createState() => _LoginScreenDemoState();
}

class _LoginScreenDemoState extends State<LoginScreenDemo> {
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = WidgetSize(screenConfig);

    return Scaffold(
        //resizeToAvoidBottomPadding: false,
        body: new Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white12,
      child: SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 80.0),
              child: new Stack(
                children: <Widget>[
                  new Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assests/images/logo.png"),
                      radius: 50,
                    )
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: new Column(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  Container(

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        Center(
                          child: Icon(
                            Icons.supervised_user_circle,
                            color: ScreenUtileColors.mainBlue,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                          child: Center(
                            child: TextField(
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                labelText: 'اسم المستخدم أو الرقم',
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.zero,
                                    right: Radius.zero,
                                  ),
                                  borderSide: BorderSide(
                                    color: ScreenUtileColors.mainBlue,
                                    width: 0.5,
                                    style: BorderStyle.solid
                                  ),
                                ),
                                labelStyle: TextStyle(
                                    fontSize: widgetSize.titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                        ),
                        Center(
                          child: Icon(
                            Icons.vpn_key,
                            color: ScreenUtileColors.mainBlue,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                          child: Center(
                            child: TextFormField(
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                labelText: 'كلمة المرور',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(

                                  borderSide: BorderSide(
                                      color: ScreenUtileColors.mainBlue,
                                      width: 0.5,
                                      style: BorderStyle.solid
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Center(
              child: Container(
                height: 40.0,
                width: 200,
                child: Material(
                  borderRadius: BorderRadius.circular(20.0),
                  color: ScreenUtileColors.mainBlue,
                  elevation: 7.0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'ليس لديك حساب؟',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  width: 5.0,
                ),
                new InkWell(
                  onTap: () {},
                  child: new Text(
                    'التسجيل الآن',
                    style: TextStyle(
                        color: ScreenUtileColors.mainBlue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    )
    );
  }
}
