import 'dart:convert';
import 'dart:developer';
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

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UndertoneModelAdapter());
  await Hive.openBox<UndertoneModel>("undertone");
  runApp(const MyApp());
}

class SeasonClassifierApp extends StatelessWidget {
  const SeasonClassifierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Season Classifier',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ClassificationScreen(),
    );
  }
}

class ClassificationScreen extends StatefulWidget {
  const ClassificationScreen({super.key});

  @override
  _ClassificationScreenState createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  Uint8List? _imageBytes;
  String? _season;
  double? _hue;
  double? _value;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndAnalyzeImage() async {
    setState(() => _isLoading = true);

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() => _imageBytes = bytes);

        final uri = Uri.parse('http://127.0.0.1:5000/analyze');
        final request = http.MultipartRequest('POST', uri)
          ..files.add(http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: image.name,
            contentType: MediaType('image', _getImageFormat(image)),
          ));

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          final data = json.decode(responseBody);
          setState(() {
            _season = data['season'];
            _hue = data['hue'].toDouble();
            _value = data['value'].toDouble();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error: ${json.decode(responseBody)['error']}')),
          );
          log('Error: ${json.decode(responseBody)['error']}');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      log('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getImageFormat(XFile image) {
    final extension = image.path.split('.').last.toLowerCase();
    if (extension == 'png') return 'png';
    if (extension == 'jpeg' || extension == 'jpg') return 'jpeg';
    return 'jpg'; // default
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Season Classifier')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageBytes != null)
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.memory(_imageBytes!, fit: BoxFit.cover),
              )
            else
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.image, size: 50, color: Colors.grey),
              ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: const Text('Pick Image'),
                onPressed: _pickAndAnalyzeImage,
              ),
            if (_season != null) ...[
              const SizedBox(height: 30),
              const Text('Dominant Color Analysis',
                  style: TextStyle(fontSize: 20)),
              const SizedBox(height: 10),
              Text('Hue: ${_hue?.toStringAsFixed(2)}°',
                  style: const TextStyle(fontSize: 16)),
              Text('Value: ${_value?.toStringAsFixed(2)}%',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              const Text('Season:', style: TextStyle(fontSize: 24)),
              Text(_season!,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _getSeasonColor(),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Color _getSeasonColor() {
    switch (_season) {
      case 'Spring':
        return Colors.green;
      case 'Summer':
        return Colors.red;
      case 'Autumn':
        return Colors.orange;
      case 'Winter':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}

//---------------------------------------------------------------------
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

  // Future<void> _pickImage(ImageSource source) async {
  //   final pickedFile = await ImagePicker().pickImage(source: source);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  Future<void> _pickAndAnalyzeImage(ImageSource source) async {
    // setState(() => _isLoading = true);
    final Uint8List bytes;
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 90,
      );

      if (image != null) {
        bytes = await image.readAsBytes();
        // setState(() => _imageBytes = bytes);

        final uri = Uri.parse('http://127.0.0.1:5000/analyze');
        final request = http.MultipartRequest('POST', uri)
          ..files.add(http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: image.name,
            contentType: MediaType('image', _getImageFormat(image)),
          ));

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          final data = json.decode(responseBody);
          log(data['season']);
          // setState(() {

          // BlocProvider.of<UndertoneCubit>(context)
          //     .fun(UndertoneModel(season: data['season']));
          String? newSeason =
              BlocProvider.of<FetchUndertoneCubit>(context).value?.season;
          BlocProvider.of<FetchUndertoneCubit>(context).fetch();
          if (BlocProvider.of<FetchUndertoneCubit>(context).value?.season ==
              data["season"].toString().toLowerCase()) {
            BlocProvider.of<FetchUndertoneCubit>(context).value?.delete();
            _showAlertDialog2(context);
            BlocProvider.of<UndertoneCubit>(context)
                .fun(UndertoneModel(season: newSeason!, image: bytes));
            BlocProvider.of<FetchUndertoneCubit>(context).fetch();
          } else {
            _showAlertDialog3(context);
          }

          // _season = data['season'];
          // _hue = data['hue'].toDouble();
          // _value = data['value'].toDouble();
          // });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error: ${json.decode(responseBody)['error']}')),
          );
          log('Error: ${json.decode(responseBody)['error']}');
        }
      }
      // Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      log('Error: ${e.toString()}');
    } finally {
      // setState(() => _isLoading = false);
    }
  }

  String _getImageFormat(XFile image) {
    final extension = image.path.split('.').last.toLowerCase();
    if (extension == 'png') return 'png';
    if (extension == 'jpeg' || extension == 'jpg') return 'jpeg';
    return 'jpg'; // default
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

  void _showAlertDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('The Color Matching with your Undertone'),
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

  void _showAlertDialog3(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('The Color Does not Match with your Undertone'),
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
    return BlocBuilder<FetchUndertoneCubit, FetchUndertoneState>(
      builder: (context, state) {
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
                    border:
                        Border.all(color: const Color(0XFFFCD0DD), width: 1),
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
                    if (state is FetchUndertonehasData) {
                      _pickAndAnalyzeImage(ImageSource.camera);
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
                    if (state is FetchUndertonehasData) {
                      _pickAndAnalyzeImage(ImageSource.gallery);
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
      },
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
