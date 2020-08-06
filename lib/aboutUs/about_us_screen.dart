import 'package:delevery_online/Model/about_us_model.dart';
import 'package:delevery_online/Model/main_setting_model.dart';
import 'package:delevery_online/aboutUs/aboutUsBloc.dart';
import 'package:delevery_online/api/helpersApi.dart';
import 'package:delevery_online/screens/screenUtilties/sizeconfigration.dart';
import 'package:delevery_online/utility/helpersWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  var helpersApi = new HelpersApi();
  MainSetting mainSettingObject;
  AboutUsBloc aboutUsBloc;
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
    aboutUsBloc = new AboutUsBloc();
    super.initState();
  }

  @override
  void dispose() {
    aboutUsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenConfig = ScreenConfig(context);
    widgetSize = new WidgetSize(screenConfig);
    return Scaffold(
      appBar: AppBar(
        title: Text("من نحن"),
          leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pushReplacementNamed(context, '/homePage')
          ),
      ),
      body: StreamBuilder(
        stream: aboutUsBloc.aboutUsStream,
        builder: (BuildContext context,
            AsyncSnapshot<AboutUsModel> snapShotMainSetting) {
          switch (snapShotMainSetting.connectionState) {
            case ConnectionState.none:
              error("No Main Setting");
              break;
            case ConnectionState.waiting:
              aboutUsBloc.fetchAboutUs.add('0');
              return loading();
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (!snapShotMainSetting.hasData) {
                return Text("no data");
              } else {
                return _drawScreen(context, snapShotMainSetting.data);
              }
              break;
          }
          return Container();
        },
      ),
    );
  }

  Widget _drawScreen(BuildContext context, AboutUsModel aboutUsModel) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white12,
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 6),
                ),
                Visibility(
                  visible: (aboutUsModel.description != '') ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.only(top:10.0, bottom: 10.0 , right: 14.0 ,left: 14.0),
                    child: Html(data: '${aboutUsModel.description}',
                        customTextAlign: (dom.Node node) {
                          if (node is dom.Element) {
                            switch (node.localName) {
                              case "p":
                                return TextAlign.right;
                            }
                          }
                        }),
                    //textAlign: TextAlign.justify,
                    //style: TextStyle(height: 1.5, color: Color(0xFF6F8398)),
                  )
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
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
