import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'DiscoveryPage.dart';
import 'connection.dart';
import 'led.dart';

class MyBluetooth extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: FutureBuilder(
        future: FlutterBluetoothSerial.instance.requestEnable(),
        builder: (context, future) {
          if (future.connectionState == ConnectionState.waiting ||
              future.connectionState == ConnectionState.none) {
            print('none || waiting');
            return const Scaffold(
              body: SizedBox(
                height: double.infinity,
                child: Center(
                  child: Icon(
                    Icons.bluetooth_disabled,
                    size: 200.0,
                    color: Colors.blue,
                  ),
                ),
              ),
            );
          } else if(future.connectionState == ConnectionState.done){
            print('go to home');
            return DiscoveryPage();
          }
          return Container();
        },
        // child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  discoverDevices() async {
    final BluetoothDevice selectedDevice = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DiscoveryPage();
        },
      ),
    );
    if (selectedDevice != null) {
      print('Discovery -> selected ' + selectedDevice.address);
    } else {
      print('Discovery -> no device selected');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
      if (mounted) {
        discoverDevices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
    /*  appBar: AppBar(
        title: const Text('Connection'),
      ),*/
      body: /*ListTile(
        title: ElevatedButton(
            child: const Text('Explore discovered devices'),
            onPressed: () async {
              final BluetoothDevice selectedDevice =
                  await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DiscoveryPage();
                  },
                ),
              );

              if (selectedDevice != null) {
                print('Discovery -> selected ' + selectedDevice.address);
              } else {
                print('Discovery -> no device selected');
              }
            }),
      )*/
          Container(),

/*      SelectBondedDevicePage(
        onCahtPage: (device1) {
          BluetoothDevice device = device1;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ChatPage(server: device);
              },
            ),
          );
        },
      )*/
    ));
  }
}
/*
* final BluetoothDevice selectedDevice =
                  await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return DiscoveryPage();
                  },
                ),
              );

              if (selectedDevice != null) {
                print('Discovery -> selected ' + selectedDevice.address);
              } else {
                print('Discovery -> no device selected');
              }*/
