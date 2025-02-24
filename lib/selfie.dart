import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p13/UNDERTONE.dart';
import 'package:http/http.dart' as http;
import "package:http_parser/src/media_type.dart";
import 'package:p13/cubit/cubit/fetch_undertone_cubit.dart';
import 'package:p13/cubit/undertone_cubit.dart';
import 'package:p13/model/undertone_model.dart';

class Selfie extends StatefulWidget {
  const Selfie({super.key});

  @override
  _SelfieState createState() => _SelfieState();
}

class _SelfieState extends State<Selfie> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // تعيين الخلفية إلى اللون الأبيض
      body: SafeArea(
        child: Column(
          children: [
            // العنوان والنصوص في الأعلى
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Text(
                    "What is your undertone?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Take a selfie to find out!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // الصورة فقط
            Expanded(
              child: Center(
                child: _image == null
                    ? Image.asset(
                        'asset/1.png', // استبدل بهذا المسار لصورتك
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            // الأزرار في الأسفل
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[200],
                      minimumSize:
                          const Size(300, 50), // تحديد عرض وارتفاع الزر
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Take a photo",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.pink[200]!),
                      minimumSize:
                          const Size(300, 50), // تحديد عرض وارتفاع الزر
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Choose from photos",
                      style: TextStyle(fontSize: 18, color: Colors.pink[200]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
    BlocProvider.of<UndertoneCubit>(context).fun(UndertoneModel(
        season: BlocProvider.of<UndertoneCubit>(context).getRandomSeason()));
    // BlocProvider.of(context).

    BlocProvider.of<FetchUndertoneCubit>(context).fetch();

    // UNDERTONE(undertoneModel: undertoneModel ,);
    // undertoneModel = ;
    Navigator.pop(context);
  }
}
