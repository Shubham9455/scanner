// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  LocalAuthentication auth = LocalAuthentication();
  bool authSuccess = false;
  bool gotResult = false;
  
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
  String qrCodeResult = "Not Yet Scanned";

  _launchURLBrowser(String url,context) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
    }else{
      showDialog(context: context, builder: ((context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text("Could not launch: '$url'"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            )
          ],
        );
      }));
    }
  }
  Future authenticate() async {
    final bool isBiometricsAvailable = await auth.isDeviceSupported();
    

    if (!isBiometricsAvailable) {
      debugPrint("Biometrics not available");
      return false;
    }

    try {
      return await auth.authenticate(
        localizedReason: 'Scan Fingerprint To Open Scanner',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
          sensitiveTransaction: true,
        ),
      );
    } on PlatformException {
      return;
    }
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: "Scanner APP".text.make().centered(),
        ),
        body: Center(
          child: (!widget.gotResult
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                        color: Colors.green,
                        child: const Icon(Icons.qr_code_scanner_rounded,
                                size: 100, color: Colors.black)
                            .p12(),
                      ),
                      onTap: () async {
                        bool isAuthenticated = await widget.authenticate();

                        if (isAuthenticated) {
                          var codeSanner = await BarcodeScanner.scan();
                          setState(() {
                            if (codeSanner.rawContent != "") {
                              widget.qrCodeResult = codeSanner.rawContent;
                              widget.qrCodeResult = codeSanner.rawContent;
                              widget.gotResult = true;
                              widget.authSuccess = true;
                            }else{
                              showDialog(context: context, builder: ((context) {
                                return AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text("Please Scan Again"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    )
                                  ],
                                );
                              }));
                            }
                            
                          });
                        } else {
                          Container();
                        }
                      },
                    ),
                    "Click to Scan QR Code".text.make().pOnly(top: 20,left: 15),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(widget.qrCodeResult).p16(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed:(){

                                  Clipboard.setData(ClipboardData(text: widget.qrCodeResult));
                                },
                                child: "Copy To ClipBoard".text.make(),
                              ).py12(),
                              ElevatedButton(
                                onPressed:() async {
                                  await widget._launchURLBrowser(widget.qrCodeResult,context);
                                },
                                child: "Open In Browser".text.make(),
                              )
                            ],
                          )
                        ],
                      ),
                    ).py24().px12(),
                    GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                        color: Colors.green,
                        child: const Icon(Icons.restart_alt_outlined,
                                size: 70, color: Colors.black)
                            .p8(),
                      ),
                      onTap: () async {
                        setState(() {
                          widget.gotResult = false;
                          widget.qrCodeResult = "Not Yet Scanned";
                          widget.authSuccess = false;
                        });
                      },
                    ),
                     "Click to Scan Again"
                          .text
                          .make()
                          .pOnly(top: 20, left: 15),
                  ],
                ))
        )
        
        );
  }
}
