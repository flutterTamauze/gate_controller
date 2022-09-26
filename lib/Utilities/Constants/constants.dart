
import 'package:fluttertoast/fluttertoast.dart';

import '../Colors/colorManager.dart';
import '../Fonts/fontsManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//const String BASE_URL = 'https://tibarose.tibarosehotel.com';
//const String BASE_URL = 'http://192.168.2.51:8007';
const String BASE_URL = 'http://10.0.0.51:8007';
//const String BASE_URL = 'http://10.0.0.242/GATE';
//const String BASE_URL = 'http://10.0.0.242/PARKING';

const kTextFieldDecorationWhite = InputDecoration(
  isDense: true,

  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
  hintText: 'Enter a value',
  hintStyle:
      TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w500),
  fillColor: Colors.white,
  filled: true,
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xffD7D7D7), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
//  contentPadding: EdgeInsets.symmetric(),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff4a4a4a), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff4a4a4a), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(15.0)),
  ),
);
TextStyle boldStyle = TextStyle(
    fontWeight: FontManager.bold, fontSize: setResponsiveFontSize(16));
TextStyle extraBoldStyle = TextStyle(
    fontWeight: FontManager.extraBold, fontSize: setResponsiveFontSize(20));

setResponsiveFontSize(size) {
  return ScreenUtil().setSp(size);
}

/*class DateUtil {
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat().add_yMMMd();
    final String formatted = formatter.format(date);

    return formatted;
  }
}

var logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      //   lineLength: 120, // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: true // Should each log print contain a timestamp
      ),
);*/


void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);


void navigateReplacementTo(context, widget) => Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void showToast(String message) => Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.green,
    toastLength: Toast.LENGTH_LONG);


void showShortToast(String message) => Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.green,
    toastLength: Toast.LENGTH_SHORT);

final ktextFieldDecoration = InputDecoration(
  errorStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(width: 2, color: Colors.orange),
  ),
  disabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 4)),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey, width: 0)),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey, width: 0)),
  hintStyle: TextStyle(
      fontWeight: FontWeight.w600, fontSize: setResponsiveFontSize(13)),
  hintText: 'قم بأدخال ملاحظتك هنا',
);
final menuBoxDecoartionCard = BoxDecoration(
  borderRadius: const BorderRadius.horizontal(
    left: Radius.circular(40.0),
    right: Radius.circular(10.0),
  ),
  color: ColorManager.lightBackGround,
  boxShadow: [
    BoxShadow(
        color: Colors.black.withOpacity(0.16),
        offset: const Offset(0, 3.0),
        blurRadius: 12.0,
        spreadRadius: 5),
  ],
);
const Color facebookColor = Color(0xff39579A);
const Color twitterColor = Color(0xff00ABEA);
const Color instaColor = Color(0xffBE2289);
const Color whatsappColor = Color(0xff075E54);
const Color googleColor = Color(0xffDF4A32);
