import 'dart:io';

class LaunchCalender{
  static String get getPlatformCalender {
    if (Platform.isAndroid) {
      return "content://com.android.calendar/time/";
    } else if(Platform.isIOS){
      return "calshow://";
    }
    else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}