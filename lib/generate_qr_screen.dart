import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';


class GenerateQrScreen extends StatefulWidget {
  const GenerateQrScreen({Key? key}) : super(key: key);

  @override
  _GenerateQrScreenState createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  final TextEditingController _controller = TextEditingController();
  late String _dataString = "Hello from this QR";
  final GlobalKey globalKey = GlobalKey();


  /// TODO: Capture And Share QR Image
  Future<void> captureAndSharePng() async {
    try {
      final RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // convert the widget to Image object
      var image = await boundary.toImage();
      // convert the Image object using toByteData with png format.
      final ByteData? byteData =
          await image.toByteData(format: ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      ///  Get file Path
      final tempDir = await getTemporaryDirectory();

      /// save file
      final file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytes(pngBytes);

      await Share.shareFiles([file.path]);

    } catch (e) {
      log(e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: (){
              captureAndSharePng();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 5.0, top: 20.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a custom message',
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _controller.text.isNotEmpty
                            ? _dataString = _controller.text
                            : null;
                      });
                    },
                    child: const Text('Submit'))
              ],
            ),
            Expanded(
              child: Center(
                child: RepaintBoundary(
                  key: globalKey,
                  child: QrImage(
                    data: _dataString,
                    size: 0.4 * bodyHeight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
