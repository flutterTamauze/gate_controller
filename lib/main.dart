import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'DiscoveryPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(800.0, 1232.0),
        builder: (context) => const MaterialApp(
              title: 'Gate Controller',
              debugShowCheckedModeBanner: false,
              home: DiscoveryPage(),
            ));
  }
}
