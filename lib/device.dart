import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Shared/sharedWidgets.dart';

class BluetoothDeviceListEntry extends StatelessWidget {
  final  Function onTap;
  final BluetoothDevice device;

  const BluetoothDeviceListEntry({this.onTap, @required this.device});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RoundedButton(
          ontap: onTap,
          title: 'الإتصال بالبوابة',
          width: 300,
          height: 70,
          buttonColor: Colors.green,
          titleColor: ColorManager.backGroundColor,
        ),
      ),
    );

  }
}
