import 'package:age_calculator/screens/homePage.dart';
import 'package:age_calculator/shared/size_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:age_calculator/services/launch_calender.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

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
  _launchURL() async {
    String url = LaunchCalender.getPlatformCalender;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _currentAd = SizedBox(
    height: 0.0,
    width: 0.0,
  );


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FacebookAudienceNetwork.init(
      testingId: "37b1da9d-b48c-4103-a393-2e095e734bd6", //optional
    );
    setState(() {
      _currentAd = FacebookBannerAd(
        bannerSize: BannerSize.STANDARD,
        listener: (result, value){
          print("Banner Ad: $result --> $value");
        },
      );
    });
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
            Container(
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
                child: FlatButton(
                  onPressed: _launchURL,
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
            Flexible(
              child: Align(
                alignment: Alignment(0,1),
              ),
              fit: FlexFit.tight,
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
