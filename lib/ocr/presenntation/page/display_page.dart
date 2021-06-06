import 'package:envision_test/ocr/data/model/save_ocr.dart';
import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final SaveOcrModel item;
  const DisplayPictureScreen({Key key,  this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Envision OCR Library')),
      body: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 14, bottom: 13, top: 31),
          child: Container(
            color: Colors.white,
            child: AspectRatio(
              aspectRatio: 1,
              child: Text(item.message),
            ),
          )),
    );
  }
}