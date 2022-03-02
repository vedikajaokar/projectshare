import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
//import 'package:jarvis_object_detection_app/MySplashPage.dart';
import 'package:jarvis_object_detection_app/HomePage.dart';
//ignore: import_of_legacy_library_into_null_safe

class MySplashPage extends StatefulWidget {

  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<MySplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 12,
      navigateAfterSeconds:HomePage(),
      imageBackground: Image.asset("assets/background.jpg").image,
      useLoader: true,
      loaderColor: Colors.white,
      loadingText: Text("loading ...", style: TextStyle(color: Colors.black),),
    );


  }
}