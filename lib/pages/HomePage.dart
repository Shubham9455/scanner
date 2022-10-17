import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class HomePage extends StatefulWidget {
  LocalAuthentication auth = LocalAuthentication();
  bool authSuccess = false;
  bool gotResult = false;

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
  String qrCodeResult = "Not Yet Scanned";
  Future authenticate() async {
    final bool isBiometricsAvailable = await auth.isDeviceSupported();
    bool isBiometricSupported = await auth.isDeviceSupported();

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
          title: "Scanner APP".text.make().pOnly(left: 20),
        ),
        body: Center(
          child: widget.gotResult
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
                            }
                            widget.qrCodeResult = codeSanner.rawContent;
                            widget.gotResult = true;
                            widget.authSuccess = true;
                          });
                        } else {
                          Container();
                        }
                      },
                    ),
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
                                onPressed:(){},
                                child: "Copy Text".text.make(),
                              ).py12(),
                              ElevatedButton(
                                onPressed:(){},
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
                  ],
                ),
        ));
  }
}
