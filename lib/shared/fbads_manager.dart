import 'dart:io';

class FbAdsManager{

  static String get bannerAdUnitIdMain{
    if(Platform.isAndroid){
      return "142346887348606_152391836344111";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get nativeBannerAdUnitIdHome {
    if (Platform.isAndroid) {
      return "142346887348606_142350877348207";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get nativeAdUnitIdMain {
    if (Platform.isAndroid) {
      return "142346887348606_151925876390707";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialAdUnitIdAgeCalc {
    if (Platform.isAndroid) {
      return "142346887348606_151234816459813";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialAdUnitIdSetRemHome {
    if (Platform.isAndroid) {
      return "142346887348606_154179216165373";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialAdUnitIdSetRemMain {
    if (Platform.isAndroid) {
      return "142346887348606_151976013052360";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}