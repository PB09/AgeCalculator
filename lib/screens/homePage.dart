import 'package:age/age.dart';
import 'package:age_calculator/services/age_calculation.dart';
import 'package:age_calculator/services/launch_calender.dart';
import 'package:age_calculator/shared/size_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:age_calculator/shared/fbads_manager.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime todayDate = DateTime.now();
  DateTime dob = DateTime(2000, 1, 1);
  int _birthWeekDay;
  AgeDuration _ageDuration;
  AgeDuration _nextBirthday;
  List<String> _months = [
    "Months",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  List<String> _weekDays = [
    "Week Days",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  final Widget setReminderSvg = SvgPicture.asset(
    'assets/notification_add-black.svg',
    semanticsLabel: 'Alert',
    width: 32,
    height: 32,
  );

  bool _isInterstitialAdLoadedSetRem = false;

  void _loadInterstitialAdSetReminder() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: FbAdsManager.interstitialAdUnitIdSetRemHome,
      listener: (result, value) {
        print("Interstitial Ad SM - Home PG: $result --> $value");
        if (result == InterstitialAdResult.LOADED) {
          _isInterstitialAdLoadedSetRem = true;
        }
        if (result == InterstitialAdResult.DISMISSED &&
            value['invalidated'] == true) {
          _isInterstitialAdLoadedSetRem = false;
          _loadInterstitialAdSetReminder();
        }
      },
    );
  }

  Widget _currentHomeAd = SizedBox(
    height: 0.0,
    width: 0.0,
  );

  void _loadNativeBannerAd(){
    setState(() {
      _currentHomeAd = FacebookNativeAd(
        adType: NativeAdType.NATIVE_BANNER_AD,
        keepAlive: true,
        bannerAdSize: NativeBannerAdSize.HEIGHT_50,
        placementId: FbAdsManager.nativeBannerAdUnitIdHome,
        listener: (result, value) {
          print("Native Banner Ad: $result --> $value");
          if (result == NativeAdResult.ERROR) {
            _loadNativeBannerAd();
          }
        },
      );
    });
  }

  _launchURL() async {
    String url = LaunchCalender.getPlatformCalender;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: "Couldn't launch Calendar");
    }
  }

  Future<Null> _selectTodayDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: todayDate,
        firstDate: dob,
        lastDate: DateTime(2101));
    if (picked != null && picked != todayDate)
      setState(() {
        todayDate = picked;
        _ageDuration = AgeCalculation().calculateAge(todayDate, dob);
        _nextBirthday = AgeCalculation().nextBirthday(todayDate, dob);
        _birthWeekDay = AgeCalculation().nextbday(todayDate, dob);
      });
  }

  Future<Null> _selectDOBDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dob,
        firstDate: DateTime(1900),
        lastDate: todayDate);
    if (picked != null && picked != dob)
      setState(() {
        dob = picked;
        _ageDuration = AgeCalculation().calculateAge(todayDate, dob);
        _nextBirthday = AgeCalculation().nextBirthday(todayDate, dob);
        _birthWeekDay = AgeCalculation().nextbday(todayDate, dob);
      });
  }

  @override
  void initState() {
    super.initState();
    FacebookAudienceNetwork.init();
    _loadNativeBannerAd();
    _loadInterstitialAdSetReminder();
    _ageDuration = AgeCalculation().calculateAge(todayDate, dob);
    _nextBirthday = AgeCalculation().nextBirthday(todayDate, dob);
    _birthWeekDay = AgeCalculation().nextbday(todayDate, dob);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 35,
                    width: double.infinity,
                  ),
                  Text(
                    "AGE CALCULATOR",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.safeBlockHorizontal * 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 45,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeHorizontal * 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _selectTodayDate(context);
                              },
                              child: Text(
                                "${todayDate.day} ${_months[todayDate.month]} ${todayDate.year}",
                                style: TextStyle(
                                  color: Color(0xffCDDC39),
                                  fontSize: SizeConfig.blockSizeHorizontal * 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 25,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date Of Birth",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.blockSizeHorizontal * 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _selectDOBDate(context);
                              },
                              child: Text(
                                "${dob.day} ${_months[dob.month]} ${dob.year}",
                                style: TextStyle(
                                  color: Color(0xffCDDC39),
                                  fontSize: SizeConfig.blockSizeHorizontal * 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 35,
                    width: double.infinity,
                  ),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Color(0xff333333),
                      borderRadius: BorderRadius.circular(
                        SizeConfig.blockSizeVertical * 15,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: SizeConfig.safeBlockVertical * 195,
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.safeBlockVertical * 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "AGE",
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${_ageDuration.years}",
                                        style: TextStyle(
                                          color: Color(0xffCDDC39),
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal * 72,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: SizeConfig.safeBlockVertical * 15,
                                        ),
                                        child: Text(
                                          "  YEARS",
                                          style: TextStyle(
                                            color: Color(0xffffffff),
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal * 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "${_ageDuration.months} months | ${_ageDuration.days} days",
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: SizeConfig.blockSizeHorizontal * 0.8,
                              height: SizeConfig.safeBlockVertical * 160,
                              color: Color(0xff999999),
                              margin: EdgeInsets.only(
                                top: SizeConfig.safeBlockVertical * 20,
                                bottom: SizeConfig.safeBlockVertical * 15,
                              ),
                            ),
                            Container(
                              height: SizeConfig.safeBlockVertical * 195,
                              padding: EdgeInsets.symmetric(
                                  vertical: SizeConfig.safeBlockVertical * 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "NEXT BIRTHDAY",
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Icon(
                                    Icons.cake,
                                    color: Color(0xffCDDC39),
                                    size: SizeConfig.safeBlockHorizontal * 40,
                                  ),
                                  Text(
                                    "${_weekDays[_birthWeekDay]}",
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${_nextBirthday.months} months | ${_nextBirthday.days} days",
                                    style: TextStyle(
                                      fontSize: SizeConfig.safeBlockHorizontal * 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.maxFinite,
                          height: SizeConfig.safeBlockHorizontal * 0.8,
                          color: Color(0xff999999),
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.safeBlockHorizontal * 15),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.safeBlockHorizontal * 24,
                            bottom: SizeConfig.safeBlockVertical * 15,
                          ),
                          child: Text(
                            "SUMMARY",
                            style: TextStyle(
                              color: Color(0xffCDDC39),
                              fontSize: SizeConfig.safeBlockHorizontal * 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.safeBlockHorizontal * 40,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "YEARS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockHorizontal * 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.safeBlockVertical * 3,
                                  ),
                                  Text(
                                    "${_ageDuration.years}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockHorizontal * 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "MONTHS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockHorizontal * 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.safeBlockVertical * 3,
                                  ),
                                  Text(
                                    "${((_ageDuration.years) * 12) + (_ageDuration.months)}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockHorizontal * 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "WEEKS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockHorizontal * 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.safeBlockVertical * 3,
                                  ),
                                  Text(
                                    "${(todayDate.difference(dob).inDays / 7).floor()}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockHorizontal * 24,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: SizeConfig.safeBlockHorizontal * 40,
                            left: SizeConfig.safeBlockHorizontal * 40,
                            top: SizeConfig.safeBlockVertical * 20,
                            bottom: SizeConfig.safeBlockVertical * 33,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "DAYS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockHorizontal * 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.safeBlockVertical * 3,
                                  ),
                                  Text(
                                    "${todayDate.difference(dob).inDays}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockHorizontal * 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "HOURS",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockHorizontal * 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.safeBlockVertical * 3,
                                  ),
                                  Text(
                                    "${todayDate.difference(dob).inHours}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockHorizontal * 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "MINUTES",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockHorizontal * 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.safeBlockVertical * 3,
                                  ),
                                  Text(
                                    "${todayDate.difference(dob).inMinutes}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.safeBlockHorizontal * 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      _launchURL();
                      Future.delayed(const Duration(seconds: 1), () {
                        _showInterstitialAdSetRim();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                        top: SizeConfig.safeBlockVertical * 34,
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
                        child:  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "SET REMINDER",
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
                            setReminderSvg,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment(0, 1),
                      child: _currentHomeAd,
                    ),
                    fit: FlexFit.tight,
                    flex: 2,
                  ),
                ],
              ),
            ),
      ),
    );
  }
  _showInterstitialAdSetRim() {
    if (_isInterstitialAdLoadedSetRem == true) {
      FacebookInterstitialAd.showInterstitialAd();
    } else {
      Fluttertoast.showToast(msg: "Ad Fail to load");
    }
  }
}
