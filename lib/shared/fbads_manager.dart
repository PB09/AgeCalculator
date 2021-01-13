import 'dart:io';

class FbAdsManager{
  static String get nativeBannerAdUnitIdHome {
    if (Platform.isAndroid) {
      return "319038029286199_319039822619353";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get nativeAdUnitIdMain {
    if (Platform.isAndroid) {
      return "319038029286199_319039045952764";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialAdUnitIdAgeCalc {
    if (Platform.isAndroid) {
      return "319038029286199_319039565952712";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
  static String get interstitialAdUnitIdSetRemHome {
    if (Platform.isAndroid) {
      return "319038029286199_325229635333705";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
