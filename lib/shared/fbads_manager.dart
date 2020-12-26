import 'dart:io';

class FbAdsManager{
  static String get bannerAdUnitId{
    if(Platform.isAndroid){
      return "142346887348606_152391836344111";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get nativeBannerAdUnitId {
    if (Platform.isAndroid) {
      return "142346887348606_142350877348207";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "142346887348606_151925876390707";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "142346887348606_151234816459813";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}