import 'package:age_calculator/screens/homePage.dart';
import 'package:age_calculator/services/launch_calender.dart';
import 'package:age_calculator/shared/size_config.dart';
import 'package:age_calculator/shared/fbads_manager.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
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

  final Widget _setReminderSvg = SvgPicture.asset(
      'assets/notification_add-black.svg',
    semanticsLabel: 'Add Alert',
    width: 32,
    height: 32,
  );

  final Widget _ageCalcSvg = SvgPicture.asset(
      'assets/age-cal.svg',
    semanticsLabel: 'Age Calculator',
    width: 32,
    height: 32,
  );

  _launchURL() async {
    String url = LaunchCalender.getPlatformCalender;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Couldn't launch Calendar");
    }
  }

  bool _isInterstitialAdLoadedMainPg = false;

  Widget _currentAd = SizedBox(
    height: 0.0,
    width: 0.0,
  );

  void _loadNativeAd(){
    setState(() {
      _currentAd = FacebookNativeAd(
        adType: NativeAdType.NATIVE_AD,
        height: 450,
        width: double.infinity,
        placementId: FbAdsManager.nativeAdUnitIdMain,
        listener: (result, value) {
          print("Native Ad: $result --> $value");
          if (result == NativeAdResult.ERROR) {
            _loadNativeAd();
          }
        },
      );
    });
  }

  void _loadInterstitialAdMainPg() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: FbAdsManager.interstitialAdUnitIdAgeCalc,
      listener: (result, value) {
        print("Interstitial Ad: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          _isInterstitialAdLoadedMainPg = true;
        }
        if (result == InterstitialAdResult.DISMISSED &&
            value['invalidated'] == true) {
          _isInterstitialAdLoadedMainPg = false;
          _loadInterstitialAdMainPg();
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FacebookAudienceNetwork.init();
    _loadInterstitialAdMainPg();
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
                Future.delayed(const Duration(seconds: 1), () {
                  _showInterstitialAdMainPg();
                });
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "AGE CALCULATOR",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.safeBlockVertical * 30,
                          letterSpacing: SizeConfig.safeBlockHorizontal * 1.0,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _ageCalcSvg,
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                _launchURL();
                Future.delayed(const Duration(seconds: 1), () {
                  _showInterstitialAdMainPg();
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
                          "SET REMINDER",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: SizeConfig.safeBlockVertical * 30,
                            letterSpacing: SizeConfig.safeBlockHorizontal * 1.0,
                          ),
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      _setReminderSvg,
                    ],
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
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: SizeConfig.safeBlockHorizontal * 2.5,
              color: Color(0xffCDDC39),
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.safeBlockHorizontal * 12),
            ),
            SizedBox(
              height: 15,
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

  _showInterstitialAdMainPg() {
    if (_isInterstitialAdLoadedMainPg == true) {
      FacebookInterstitialAd.showInterstitialAd();
    } else {
      Fluttertoast.showToast(msg: "Ad Fail to load");
    }
  }
}
