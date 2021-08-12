import 'dart:async';
import 'package:coquimbofc/Check_Connection/No%20Internet.dart';
import 'package:coquimbofc/Check_Connection/check_internet.dart';
import 'package:coquimbofc/Home_Page/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {


  int checkInt = 0;

  @override
  void initState() {
    super.initState();
    Future<int> a = CheckInternet().checkInternetConnection();
    a.then((value) {
      if (value == 0) {
        setState(() {
          checkInt = 0;
        });
        Timer(
            Duration(seconds: 3),
                () =>
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => No_Internet_Connection()),
                        (route) => false));
      } else {
        setState(() {
          checkInt = 1;
        });
        Timer(
            Duration(seconds: 3),
                () =>
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(
                        url: 'http://aguirrecastillo.com/web_server/')),
                        (route) => false));

      }
    });
  }


  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(14, 129, 154,1),
      statusBarBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 129, 154,1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text("Bienvenidos",style:TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white,),textAlign: TextAlign.center,),
          SizedBox(height: 30,),

          Center(
            child: Container(
                height: 150,
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    "assets/slogo.png",
                  ),
                )),
          ),
          SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.only(left: 100,right: 100,top: 15),
            child: Text("La Film Commission Coquimbo es una corporación sin fines de lucro, que tiene como objetivo promover y facilitar los rodajes en toda la Región de Coquimbo y de estimular el área audiovisual y sus servicios derivados en todo el territorio.",
                style: TextStyle(fontSize: 16,color: Colors.white,),textAlign: TextAlign.center,),
          ),
          SizedBox(
            height: 20,
          ),

          Center(
            child: Container(
                width: 250,
                child: Image.asset(
                  "assets/sponsor.png",
                )),
          ),
          SizedBox(
            height: 40,
          ),
          SpinKitPulse(
            color: Colors.white,
            size: 25.0,
            controller: AnimationController(
                duration: const Duration(milliseconds: 1300), vsync: this),
          ),



          // _AnimatedLiquidLinearProgressIndicator(),
        ],
      ),
    );
  }
}
