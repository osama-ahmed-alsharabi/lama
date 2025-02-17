import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p13/Analysis.dart';
import 'package:p13/WelcomeScreen.dart';
import 'package:p13/cubit/cubit/fetch_undertone_cubit.dart';
import 'package:p13/cubit/undertone_cubit.dart';
import 'package:p13/model/undertone_model.dart';
import 'Category.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UndertoneModelAdapter());
  await Hive.openBox<UndertoneModel>("undertone");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UndertoneCubit(),
        ),
        BlocProvider(
          create: (context) => FetchUndertoneCubit(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: WelcomeScreen(),
      ),
    );
  }
}

class TestColorNew extends StatefulWidget {
  const TestColorNew({super.key});

  @override
  _TestColorNewState createState() => _TestColorNewState();
}

class _TestColorNewState extends State<TestColorNew> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content:
              const Text('You must take a picture from Undertone page first'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
                print('User clicked Cancel');
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog

                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // رسم المنحنى
            CustomPaint(
              size: const Size(double.infinity, 100),
              painter: WavePainter(),
            ),
            const SizedBox(height: 20),
            const Text(
              "Start the color test now!",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0XFFFCD0DD),
              ),
            ),
            const SizedBox(height: 20),
            // التعديل على الـ Container ليكون أكبر ومتدرج الألوان مثل المنحنى
            Container(
              width: 250, // حجم أكبر
              height: 250, // حجم أكبر
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0XFFFCD0DD), width: 1),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFAD0C4), // اللون الأول من تدرج المنحنى
                    Color(0xFFFAD0C4), // اللون الثاني من تدرج المنحنى
                    Color(0xFFFAD0C7),
                    Color(0xFFFFD1FF), // اللون الثالث من تدرج المنحنى
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.camera_alt,
                  size: 80, color: Colors.black45), // حجم الأيقونة أكبر
            ),
            const SizedBox(height: 20),
            // الزر الأول "Take a photo" مع الحجم الكبير
            ElevatedButton(
              onPressed: () {
                if (BlocProvider.of<FetchUndertoneCubit>(context)
                        .value
                        ?.season !=
                    null) {
                  _pickImage(ImageSource.camera);
                } else {
                  _showAlertDialog(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFFFCD0DD),
                foregroundColor: Colors.white,
                minimumSize: const Size(250, 60), // حجم الزر أكبر
                padding: const EdgeInsets.symmetric(
                    vertical: 15), // المسافة الداخلية للزر
              ),
              child: const Text("Take a photo"),
            ),
            const SizedBox(height: 10),
            // الزر الثاني "Choose from photos" مع الحجم الكبير
            OutlinedButton(
              onPressed: () {
                if (BlocProvider.of<FetchUndertoneCubit>(context)
                        .value
                        ?.season !=
                    null) {
                  _pickImage(ImageSource.gallery);
                } else {
                  _showAlertDialog(context);
                }
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0XFFFCD0DD)),
                foregroundColor: const Color(0xFFFCD0DD),
                minimumSize: const Size(250, 60), // حجم الزر أكبر
                padding: const EdgeInsets.symmetric(
                    vertical: 15), // المسافة الداخلية للزر
              ),
              child: const Text("Choose from photos"),
            ),
            const SizedBox(height: 10),
            // الزر الثالث "Analysis" مع الحجم الكبير
            // OutlinedButton(
            //   onPressed: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (context) => Analysis()));
            //   },
            //   style: OutlinedButton.styleFrom(
            //     side: const BorderSide(color: Color(0XFFFCD0DD)),
            //     foregroundColor: const Color(0XFFFCD0DD),
            //     minimumSize: const Size(250, 60), // حجم الزر أكبر
            //     padding: const EdgeInsets.symmetric(
            //         vertical: 15), // المسافة الداخلية للزر
            //   ),
            //   child: const Text("Analysis"),
            // ),
          ],
        ),
      ),
    );
  }
}

// ✅ كلاس يرسم المنحنى العلوي بخلفية متدرجة
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFCCB90),
          Color(0xFFE6A0C3),
          Color(0xFFD57EEB),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(0, size.height * 0.85);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.6,
        size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(
        size.width * 0.7, size.height * 0.2, size.width, size.height * 0.1);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
