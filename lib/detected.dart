/*import 'package:flutter/material.dart';

class Detected extends StatelessWidget {
  const Detected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            painter: WavePainter(),
            child: Container(),
          ),
          // 
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFAD0C4),
                    Color(0xFFFAD0C4),
                    Color(0xFFFFD1FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: const Color.fromARGB(255, 99, 35, 110).withOpacity(0.6),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "Please detect your undertone first,\nfrom the undertone page",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.white.withOpacity(0.6),
                    height: 1,
                    thickness: 1,
                  ),
                  // ✅ 
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFAD0C4),
                          Color(0xFFFAD0C4),
                          Color(0xFFFFD1FF),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context); // ✅ الرجوع للصفحة السابقة
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ كود المنحنيات في الخلفية
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final upperWavePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color(0xFFFCCB90),
          Color(0xFFE6A0C3),
          Color(0xFFD57EEB),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final upperWavePath = Path();
    upperWavePath.moveTo(0, size.height * 0.1);
    upperWavePath.quadraticBezierTo(
        size.width * 0.25, size.height * 0.0, size.width, size.height * 0.1);
    upperWavePath.lineTo(size.width, 0);
    upperWavePath.lineTo(0, 0);
    upperWavePath.close();

    canvas.drawPath(upperWavePath, upperWavePaint);

    final lowerWavePaint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFFD57EEB),
          Color(0xFFE6A0C3),
          Color(0xFFFCCB90),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final lowerWavePath = Path();
    lowerWavePath.moveTo(0, size.height * 0.9);
    lowerWavePath.quadraticBezierTo(
        size.width * 0.25, size.height * 1.0, size.width, size.height * 0.9);
    lowerWavePath.lineTo(size.width, size.height);
    lowerWavePath.lineTo(0, size.height);
    lowerWavePath.close();

    canvas.drawPath(lowerWavePath, lowerWavePaint);
  }
.
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}................
class _AnalysisState extends State<Analysis> {
  bool isFaceDetected = false; // Flag 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            if (isFaceDetected) {
              // إذا تم التقاط الصورة بنجاح
              Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
            } else {
              // إذا لم يتم التقاط الصورة
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetectedPage()));
            }
          },
          child: Text(isFaceDetected ? 'Go to Camera' : 'Please detect face first'),
        ),
      ),
    );
  }
}
*/