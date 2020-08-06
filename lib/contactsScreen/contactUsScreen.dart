import 'package:delevery_online/Model/main_setting_model.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/contactsScreen/contactUsBloc.dart';
import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  final String site_name;
  final String site_url;
  final String site_mail;
  final String facebook_link;
  final String twitter_link;
  final String instagram_link;
  final String phone;
  final String mobile;
  final String address;


  ContactUs(this.site_name, this.site_url, this.site_mail, this.facebook_link,
      this.twitter_link, this.instagram_link, this.phone, this.mobile,
      this.address);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  var helpersApi = new HelpersApi();
  //MainSetting widget = new MainSetting();
  ContactUsBloc contactUsBloc;

//  String site_name;
//  String site_url ;
//  String site_mail;
//  String facebook_link ;
//  String twitter_link ;
//  String instagram_link ;
//  String phone ;
//  String mobile ;
//  String address ;

//  void getMainSettings () async{
//    SharedPreferences mainSettingsPref = await SharedPreferences.getInstance();
//    setState(() {
//      widget.site_name      = mainSettingsPref.get('site_name');
//      widget.site_url       = mainSettingsPref.get('site_url');
//      widget.site_mail      = mainSettingsPref.get('site_mail');
//      widget.facebook_link  = mainSettingsPref.get('facebook_link');
//      widget.twitter_link   = mainSettingsPref.get('twitter_link');
//      widget.instagram_link = mainSettingsPref.get('instagram_link');
//      widget.phone          = mainSettingsPref.get('phone');
//      widget.mobile         = mainSettingsPref.get('mobile');
//      widget.address        = mainSettingsPref.get('address');
//    });
//  }
  ScreenConfig screenConfig;
  WidgetSize widgetSize;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
 //   getMainSettings();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = new WidgetSize(screenConfig);
    return Scaffold(
      appBar: AppBar(
        title: Text("تواصل معنا"),
          leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pushReplacementNamed(context, '/homePage')
          )
      ),
      body: _drawScreen(context)
    );
  }

  Widget _drawScreen(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white12,
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 6),
                ),
                Visibility(
                  visible: (widget.site_url != '') ? true : false,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 12.0, top: 12, bottom: 12),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.language,
                            color: ScreenUtileColors.mainBlue,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            "الموقع الالكتروني : ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Flexible(
                            child: InkWell(
                              child: Text(
                                widget.site_url,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: widgetSize.descriptionFontSize,
                                ),
                              ),
                              onTap: () async {
                                await _launchURL("${widget.site_url}");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (widget.site_mail != '') ? true : false,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 12.0, top: 12, bottom: 12),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.alternate_email,
                            color: ScreenUtileColors.mainBlue,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            "البريد الالكتروني : ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Flexible(
                            child: InkWell(
                              child: Text(
                                widget.site_mail,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: widgetSize.descriptionFontSize,
                                ),
                              ),
                              onTap: () async {
                                await _launchURL(
                                    "mailto:${widget.site_mail}");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (widget.phone != '') ? true : false,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 12.0, top: 12, bottom: 12),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.phone,
                            color: ScreenUtileColors.mainBlue,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            "رقم الهاتف : ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Flexible(
                            child: InkWell(
                              child: Text(
                                widget.phone,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: widgetSize.descriptionFontSize,
                                ),
                              ),
                              onTap: () async {
                                await _launchURL("tel:${widget.phone}");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (widget.mobile != '') ? true : false,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 12.0, top: 12, bottom: 12),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.phone_android,
                            color: ScreenUtileColors.mainBlue,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            "رقم الجوال : ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Flexible(
                            child: InkWell(
                              child: Text(
                                widget.mobile,
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: widgetSize.descriptionFontSize,
                                ),
                              ),
                              onTap: () async {
                                await _launchURL("tel:${widget.mobile}");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 12.0, top: 12, bottom: 12),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.phone_android,
                          color: ScreenUtileColors.mainBlue,
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          "رقم الشكاوي : ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 4.0,
                        ),
                        Flexible(
                          child: InkWell(
                            child: Text(
                              "0967173030",
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widgetSize.descriptionFontSize,
                              ),
                            ),
                            onTap: () async {
                              await _launchURL("tel:${widget.mobile}");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (widget.address != '') ? true : false,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 12.0, top: 12, bottom: 12),
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: ScreenUtileColors.mainBlue,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            "العنوان : ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Flexible(
                            child: Text(
                              widget.address,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: widgetSize.descriptionFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 5,
                  thickness: 1,
                  color: Colors.black,
                ),
                SizedBox(height: 8,),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "️ تم التصميم من قبل شركة سيريا ويب ❤ ",
                        style: TextStyle(fontSize: widgetSize.titleFontSize),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL("http://syweb.co/");
                        },
                        child: Text(
                          "http://syweb.co/",
                          style: TextStyle(color: Colors.blueAccent),
                          textDirection: TextDirection.ltr,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 60,
                    child: OutlineButton(
                      onPressed: () async {
                        await _launchURL("${widget.facebook_link}");
                      },
                      child: Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    child: OutlineButton(
                      onPressed: () async {
                        await _launchURL("${widget.twitter_link}");
                      },
                      child: Icon(
                        FontAwesomeIcons.twitter,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Container(
                    height: 60,
                    child: OutlineButton(
                      onPressed: () async {
                        await _launchURL("${widget.instagram_link}");
                      },
                      child: Icon(
                        FontAwesomeIcons.instagram,
                        color: Colors.red.shade200,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
