import 'dart:convert';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPageTest extends StatefulWidget {
  @override
  _RegisterPageTestState createState() => _RegisterPageTestState();
}

class _RegisterPageTestState extends State<RegisterPageTest> {
  final String data = '[{"ID": 1, "Code": "01", "Description": "دمشق",'
      ' "PSGCCode": "010000000"}, '
      '{"ID": 2, "Code": "02", '
      '"Description": "حلب", "PSGCCode": "020000000"}]';
  List<Region> _region = [];
  String selectedRegion;

  bool expanded = false;
  ScreenConfig screenConfig;
  WidgetSize widgetSize;
  @override
  Widget build(BuildContext context) {
    final json = JsonDecoder().convert(data);
    _region = (json).map<Region>((item) => Region.fromJson(item)).toList();
    selectedRegion = _region[0].regionDescription;
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
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.08),
              child: new Stack(
                children: <Widget>[
                  new Center(
                      child: CircleAvatar(
                    backgroundImage: AssetImage("assests/images/logo.png"),
                    radius: 50,
                  ))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
              child: new Column(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "تسجيل حساب جديد",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Center(
                          child: Icon(
                            Icons.person,
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
                                labelText: 'الاسم الكامل',
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.zero,
                                    right: Radius.zero,
                                  ),
                                  borderSide: BorderSide(
                                      color: ScreenUtileColors.mainBlue,
                                      width: 0.5,
                                      style: BorderStyle.solid),
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
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Center(
                          child: Icon(
                            Icons.email,
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
                                labelText: 'الايميل',
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.zero,
                                    right: Radius.zero,
                                  ),
                                  borderSide: BorderSide(
                                      color: ScreenUtileColors.mainBlue,
                                      width: 0.5,
                                      style: BorderStyle.solid),
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
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Center(
                          child: Icon(
                            Icons.phone,
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
                                labelText: 'رقم الهاتف',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.zero,
                                    right: Radius.zero,
                                  ),
                                  borderSide: BorderSide(
                                      color: ScreenUtileColors.mainBlue,
                                      width: 0.5,
                                      style: BorderStyle.solid),
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
                  SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
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
                            child: TextField(
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                labelText: 'كلمة السر',
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.zero,
                                    right: Radius.zero,
                                  ),
                                  borderSide: BorderSide(
                                      color: ScreenUtileColors.mainBlue,
                                      width: 0.5,
                                      style: BorderStyle.solid),
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
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Center(
                          child: Icon(
                            Icons.map,
                            color: ScreenUtileColors.mainBlue,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            hint: new Text(
                              "اختر البلد",
                            ),
                            value: selectedRegion,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                selectedRegion = newValue;
                              });
                              print(selectedRegion);
                            },
                            items: _region.map((Region map) {
                              return new DropdownMenuItem<String>(
                                value: map.regionDescription,
                                child: new Text("اختر البلد",
                                    style: new TextStyle(color: Colors.black)),
                              );
                            }).toList(),
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
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Center(
                          child: Icon(
                            Icons.map,
                            color: ScreenUtileColors.mainBlue,
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            hint: new Text(
                              "اختر المحافظة",
                            ),
                            value: selectedRegion,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                selectedRegion = newValue;
                              });
                              print(selectedRegion);
                            },
                            items: _region.map((Region map) {
                              return new DropdownMenuItem<String>(
                                value: map.regionDescription,
                                child: new Text("اختر المحافظة",
                                    style: new TextStyle(color: Colors.black)),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Center(
                          child: Icon(
                            Icons.place,
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
                                labelText: 'العنوان بالتفصيل',
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.zero,
                                    right: Radius.zero,
                                  ),
                                  borderSide: BorderSide(
                                      color: ScreenUtileColors.mainBlue,
                                      width: 0.5,
                                      style: BorderStyle.solid),
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
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
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
                        'التسجيل',
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
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  'لديك حساب!',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  width: 5.0,
                ),
                new InkWell(
                  onTap: () {},
                  child: new Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                        color: ScreenUtileColors.mainBlue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            )
          ],
        ),
      ),
    ));
  }
}

class Region {
  final int regionid;
  final String regionDescription;

  Region({this.regionid, this.regionDescription});
  factory Region.fromJson(Map<String, dynamic> json) {
    return new Region(
        regionid: json['ID'], regionDescription: json['Description']);
  }
}
