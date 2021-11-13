import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late String barcode = "";


  /// TODO : Scan QR Code
  Future scan() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", false, ScanMode.QR);
      setState(() {
        this.barcode = barcode;
      });
      checkingValue();
    } on PlatformException {
      barcode = 'Failed to get platform version.';
    }
  }

  /// TODO : Check if value is url
  checkingValue() {
    if (barcode != "") {
      if (barcode.contains("https") || barcode.contains("http")) {
        return launchURL(barcode);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid URL"),
          duration: Duration(seconds: 1),
        ));
      }
    }
  }

  /// TODO : open URL
  launchURL(String urlQrCode) async {
    String url = urlQrCode;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Can not Launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: scan,
              child: const Text('START SCAN QR'),
            ),
            Text(
              barcode,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
