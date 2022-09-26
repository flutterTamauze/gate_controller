import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import '../../Utilities/Colors/colorManager.dart';
import '../../Utilities/Constants/constants.dart';
import '../../Utilities/Shared/sharedWidgets.dart';
import 'DiscoveryPage.dart';

class EntranceScreen extends StatefulWidget {
  final BluetoothDevice server;

  const EntranceScreen({this.server});

  @override
  _EntranceScreen createState() => _EntranceScreen();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _EntranceScreen extends State<EntranceScreen> {
  static const int clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  bool isConnecting = true;

  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

// FOR BARCODE READER
  String _barcode;
  bool visible;

  // FOR CAMERA
  final VlcPlayerController _vlcViewController = VlcPlayerController.network(
      'rtsp://admin:Secure@5050@10.0.0.200:554/cam/realmonitor?channel=1&subtype=0',
      autoPlay: true,
      options: VlcPlayerOptions());
  Uint8List _imageFile;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      log('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: const TextStyle(color: Colors.white)),
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    var serverName = widget.server.name ?? 'Unknown';
    return Scaffold(
      backgroundColor: Colors.white,
/*      appBar: AppBar(
          title: (isConnecting
              ? Text('Connecting chat to ' + serverName + '...')
              : isConnected
                  ? Text('Live chat with ' + serverName)
                  : Text('Chat log with ' + serverName))),*/
      body: SafeArea(
        child: isConnected
            ? Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 60.h,
                    ),
                    ZoomIn(
                      child: SizedBox(
                        height: (height * 0.17),
                        width: (width * 0.32),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: ColorManager.primary, width: 2.w),
                            image: const DecorationImage(
                                image:
                                    AssetImage('assets/images/tipasplash.png')),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    AutoSizeText(
                      'مرحبا بك فى دار الدفاع الجوى',
                      style: TextStyle(
                          fontSize: setResponsiveFontSize(34),
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 80.h,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                'من فضلك قم بإظهار بطاقتك',
                                style: TextStyle(
                                    fontSize: setResponsiveFontSize(30)),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Lottie.asset('assets/lotties/personalid.json',
                                  height: 270.h, width: 300.w),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    BarcodeKeyboardListener(
                      bufferDuration: const Duration(milliseconds: 200),
                      onBarcodeScanned: (barcode) {
                        // first we read the barcode
                        print('barcode  $barcode');
                        _barcode = barcode;
                        showToast(_barcode);
                        /*
                      // second we take an image
                        Uint8List x = await _vlcViewController.takeSnapshot();
                        setState(() {
                          _imageFile = x;
                        });*/
                        showToast('image picked');

                        if (isConnecting) {
                          log('isConnecting ggate');
                          Fluttertoast.showToast(
                              msg: 'Wait until connected...',
                              backgroundColor: Colors.green,
                              toastLength: Toast.LENGTH_LONG);
                        } else if (isConnected) {
                          showToast('gate opened');
                          log('isConnected ggate');
                          _sendMessage(
                              'Open Gate#'); /*then((value) {

                            Future.delayed(const Duration(milliseconds: 500)).then((value) {

                              showToast('gate closed');

                              _sendMessage('Close Gate#');
                            });
                          });*/

                        } else {
                          log('else ggate');
                          Fluttertoast.showToast(
                              msg: 'gate got disconnected...',
                              backgroundColor: Colors.green,
                              toastLength: Toast.LENGTH_LONG);
                        }
                      },
                      child: Container(),
                    ),
                    Stack(
                      children: [
                        VlcPlayer(
                          controller: _vlcViewController,
                          aspectRatio: 16 / 9,
                          placeholder: const Text('Loading camera'),
                        ),
                        // ADD THIS WHEN U WANT TO HIDE THE CAMERA
                        Container(
                          width: double.infinity,
                          height: 260,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ],
                ),
              )
            : isConnecting
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'حدث خطأ فالإتصال برجاء المحاولة لاحقاً',
                          style: TextStyle(fontSize: 26.h),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        RoundedButton(
                          ontap: () {
                            navigateTo(context, DiscoveryPage());
                          },
                          title: 'إعادة التحميل',
                          width: 300,
                          height: 70,
                          buttonColor: Colors.red,
                          titleColor: ColorManager.backGroundColor,
                        )
                      ],
                    ),
                  ),
      ),
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  Future<void> _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();
    print('inside send message $text');

    if (text.length > 0) {
      try {
        connection.output.add(Uint8List.fromList(utf8.encode(text + '\r\n')));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        /*   Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });*/
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}
