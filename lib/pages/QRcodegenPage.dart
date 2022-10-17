import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:qr_flutter/qr_flutter.dart';




class QRcodegenPage extends StatefulWidget {
  const QRcodegenPage({super.key});

  @override
  State<QRcodegenPage> createState() => _QRcodegenPageState();
}

class _QRcodegenPageState extends State<QRcodegenPage> {
  var textEditingController = TextEditingController();
  String data= "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: "SCANNER".text.bold.wide.letterSpacing(4).make().centered(),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                "QR Code Generator".text.bold.xl4.make().pOnly(top:20),
                10.heightBox,
                "Enter the text to generate QR Code".text.make(),
                10.heightBox,
                TextField(
                  controller: textEditingController,
                  onChanged: (value){
                    setState(() {
                      data = value;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    hintText: "Enter the text",
                    icon: const Icon(Icons.qr_code),
                    // suffix: const Icon(Icons.paste)
                    // .onInkTap(() { 
                    //   Clipboard.getData(Clipboard.kTextPlain).then((value) {
                    //   String? pastedString =value?.text;
                    //   setState(() {
                    //     textEditingController.text = pastedString!;
                    //   });
                      
                    // });
                    // }),
                    // suffixIcon: GestureDetector(
                    //   onTap: () {
                    //     print(textEditingController.text);
                    //     textEditingController.clear();
                    //     print(textEditingController.text);
                    //   },
                    //   child: const Icon(Icons.clear),
                    // ),
                  ),
                ).p16(),
                10.heightBox,
                Container(
                  color: Colors.white,
                  child: QrImage(
                    data: data,
                    version: QrVersions.auto,
                    size: 320,
                    gapless: true,
                    errorStateBuilder: (cxt, err) {
                      return const Center(
                        child: Text(
                          "Uh oh! Something went wrong...",
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}