import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class Camera extends StatefulWidget {
  const Camera({required this.OnAddExpense, super.key});
  final void Function(Expense expense) OnAddExpense;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();

    _requestCameraPermission();
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: _scanImage, icon: const Icon(Icons.camera_alt_outlined));
  }

  Future<void> _requestCameraPermission() async {
    await Permission.camera.request();
  }

  void _scanImage() async {
    final imagepicker = ImagePicker();
    final pickedimage = await imagepicker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedimage == null) {
      return;
    }
    final text = await textRecognizer
        .processImage(InputImage.fromFile(File(pickedimage.path)));
    RegExp regExp = RegExp(
      r"\d{1,2}\/\d{1,2}\/\d{2,4}",
    );
    RegExp value = RegExp(
      r"\$[0-9]+(\.[0-9]{1,2})?",
    );
    DateTime date = DateTime.now();
    DateFormat format = DateFormat("dd/MM/yyyy");
    var number = 0.0;
    for (final i in text.blocks) {
      for (final j in i.lines) {
        if (value.hasMatch(j.text)) {
          if (number <
              double.parse(value.stringMatch(j.text)!.replaceAll(r'$', ''))) {
            number =
                double.parse(value.stringMatch(j.text)!.replaceAll(r'$', ''));
          }
        }
        if (regExp.hasMatch(j.text)) {
          date = format.parse(regExp.stringMatch(j.text)!);
        }
      }
    }

    final expense = Expense(
        title: text.blocks[0].text,
        amount: number,
        date: date,
        category: Category.leisure);
    widget.OnAddExpense(expense);
    Navigator.of(context).pop();
  }
}
