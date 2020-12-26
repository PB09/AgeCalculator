import 'package:age_calculator/screens/homePage.dart';
import 'package:age_calculator/services/launch_calender.dart';
import 'package:age_calculator/shared/size_config.dart';
import 'package:age_calculator/shared/fbads_manager.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Widget _currentAd = SizedBox(
    height: 0.0,
    width: 0.0,
  );

  void _loadNativeAd(){
    setState(() {
      _currentAd = FacebookNativeAd(
        adType: NativeAdType.NATIVE_AD,
        height: 350,
        width: double.infinity,
        placementId: FbAdsManager.nativeAdUnitId,
        listener: (result, value) {
          print("Native Ad: $result --> $value");
          if (result == NativeAdResult.ERROR) {
            _loadNativeAd();
          }
        },
      );
    });
  }

  void _loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: FbAdsManager.interstitialAdUnitId,
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

  @override
  void initState() {
    super.initState();
    FacebookAudienceNetwork.init();
    _loadInterstitialAd();
    _loadNativeAd();
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
                Future.delayed(const Duration(milliseconds: 300), () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                });
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "EXIT",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.safeBlockVertical * 30,
                          letterSpacing: SizeConfig.safeBlockHorizontal * 1.5,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: SizeConfig.safeBlockVertical * 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: SizeConfig.safeBlockHorizontal * 1.5,
              color: Color(0xffCDDC39),
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 12),
            ),
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.safeBlockVertical * 10,
                left: SizeConfig.safeBlockHorizontal * 25,
                right: SizeConfig.safeBlockHorizontal * 25,
                bottom: SizeConfig.safeBlockVertical * 10,
              ),
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.safeBlockVertical * 20,
              ),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(
                    SizeConfig.safeBlockVertical * 8,
                  )),
              child: Center(
                child: Text(
                  "ADVERTISEMENT",
                  style: TextStyle(
                    color: Color(0xffCDDC39),
                    fontWeight: FontWeight.w500,
                    fontSize: SizeConfig.safeBlockVertical * 25,
                    letterSpacing: SizeConfig.safeBlockHorizontal * 0.8,
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
}
