import 'package:delevery_online/screens/screenUtilties/screen_utility_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class PublicMethods {
  static showCustomDialog(BuildContext context , String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          child: AlertDialog(
            title:  Text("شكراً لك"),
            content:  Text(result),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              RaisedButton(
                color: ScreenUtileColors.mainBlue,
                child: new Text("تم" , style: TextStyle(color: ScreenUtileColors.fontColor),),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/homePage');
                },
              ),
            ],
          ), onWillPop: () async => false,
        );
      },
    );
  }
  static Dialog dialogForStartConnection( BuildContext context , String title){
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.only(top:16.0),
              child: Text('$title', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom :20.0),
              child: SpinKitThreeBounce(
                color: ScreenUtileColors.mainBlue,
                //  type: SpinKitWaveType.center,
                //  itemCount: 20,
                size: 35.0,

                //shape: BoxShape.circle,

                //strokeWidth: 2.0,
              ),
            )
          ],
        ),
      ),
    );
  }
  static startConnectionDialog(BuildContext context , String title){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return dialogForStartConnection(context , title);
        }
    );
  }
  static String unit = "تحويل رصيد اختياري";

}