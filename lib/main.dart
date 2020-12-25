import 'package:age_calculator/screens/homePage.dart';
import 'package:age_calculator/services/launch_calender.dart';
import 'package:age_calculator/shared/size_config.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

Future main() async{
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Product Sans",
        scaffoldBackgroundColor: Colors.black,
        // primaryColor: Colors.black,
        //accentColor: Colors.black,
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF000000),
          onPrimary: Color(0xffCDDC39),
          surface: Colors.pink,
        ),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  _launchURL() async {
    String url = LaunchCalender.getPlatformCalender;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool _isInterstitialAdLoaded = false;
  bool _isExitAdLoaded = false;

  Widget _currentAd = SizedBox(
    height: 0.0,
    width: 0.0,
  );

  void _loadNativeAdLoaded(){
    setState(() {
      _currentAd = FacebookNativeAd(
        adType: NativeAdType.NATIVE_AD,
        height: 350,
        width: double.infinity,
        placementId: "142346887348606_151925876390707",
        listener: (result, value) {
          print("Native Ad: $result --> $value");
          if (result == NativeAdResult.ERROR) {
            _loadInterstitialAd();
          }
        },
      );
    });
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "142346887348606_151234816459813",
      listener: (result, value) {
        print("Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          _isInterstitialAdLoaded = true;
        }
        if (result == InterstitialAdResult.DISMISSED &&
            value['invalidated'] == true) {
          _isInterstitialAdLoaded = false;
          _loadInterstitialAd();
        }
      },
    );
  }

  void _loadExitAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "142346887348606_151976013052360",
      listener: (result, value) {
        print("Exit Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          _isExitAdLoaded = true;
        }
        if (result == InterstitialAdResult.DISMISSED &&
            value['invalidated'] == true) {
          _isExitAdLoaded = false;
          _loadExitAd();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FacebookAudienceNetwork.init();
    _loadInterstitialAd();
    _loadNativeAdLoaded();
    _loadExitAd();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                _showInterstitialAd();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              },
              child: Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.safeBlockVertical * 34,
                  left: SizeConfig.safeBlockHorizontal * 25,
                  right: SizeConfig.safeBlockHorizontal * 25,
                  bottom: SizeConfig.safeBlockVertical * 25,
                ),
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.safeBlockVertical * 20,
                ),
                decoration: BoxDecoration(
                    color: Color(0xffCDDC39),
                    borderRadius: BorderRadius.circular(
                      SizeConfig.safeBlockVertical * 8,
                    )),
                child: Center(
                  child: Text(
                    "AGE CALCULATOR",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.safeBlockVertical * 30,
                      letterSpacing: SizeConfig.safeBlockHorizontal * 1.5,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _launchURL,
              child: Container(
                margin: EdgeInsets.only(
                  left: SizeConfig.safeBlockHorizontal * 25,
                  right: SizeConfig.safeBlockHorizontal * 25,
                  bottom: SizeConfig.safeBlockVertical * 25,
                ),
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.safeBlockVertical * 20,
                ),
                decoration: BoxDecoration(
                    color: Color(0xffCDDC39),
                    borderRadius: BorderRadius.circular(
                      SizeConfig.safeBlockVertical * 8,
                    )),
                child: Center(
                  child: Text(
                      "SET REMINDER",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.safeBlockVertical * 30,
                        letterSpacing: SizeConfig.safeBlockHorizontal * 1.5,
                      ),
                    ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                _showExitAd();
                exit(0);
              },
              child: Container(
                margin: EdgeInsets.only(
                  left: SizeConfig.safeBlockHorizontal * 25,
                  right: SizeConfig.safeBlockHorizontal * 25,
                  bottom: SizeConfig.safeBlockVertical * 25,
                ),
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.safeBlockVertical * 20,
                ),
                decoration: BoxDecoration(
                    color: Color(0xffCDDC39),
                    borderRadius: BorderRadius.circular(
                      SizeConfig.safeBlockVertical * 8,
                    )),
                child: Center(
                  child: Text(
                    "EXIT",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.safeBlockVertical * 30,
                      letterSpacing: SizeConfig.safeBlockHorizontal * 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment(0, 1),
                child: _currentAd,
              ),
              fit: FlexFit.tight,
              flex: 2,
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 40,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  _showInterstitialAd() {
    if (_isInterstitialAdLoaded == true) {
      FacebookInterstitialAd.showInterstitialAd();
    } else {
      Fluttertoast.showToast(msg: "Interstitial Ad Fail to load");
    }
  }

  _showExitAd(){
    if(_isExitAdLoaded == true){
      FacebookInterstitialAd.showInterstitialAd();
    } else {
      Fluttertoast.showToast(msg: "Exit Ad Fail to load");
    }
  }
}
