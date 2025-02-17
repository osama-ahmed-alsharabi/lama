import 'dart:ui';
import 'package:flutter/material.dart';
import 'Category.dart';

class Requires extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // رسم الخلفية المتدرجة مع الموجات
          CustomPaint(
            painter: WavePainter(),
            child: Container(),
          ),

          // نافذة الإذن في المنتصف
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // تأثير الضبابية
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent.withOpacity(0.3), // لون شفاف للصندوق
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "To provide the best user experience, this app requires frequent access to your camera and photo library",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Do you allow this?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Categoryy()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent.withOpacity(0.3), // لون مطابق للصندوق
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                              ),
                              child: Text("Allow"),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent.withOpacity(0.3), // لون مطابق للصندوق
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                              ),
                              child: Text("Don't Allow"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// كلاس رسم الخلفية الموجية
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
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final upperWavePath = Path();
    upperWavePath.moveTo(0, size.height * 0.05);
    upperWavePath.quadraticBezierTo(
        size.width * 0.5, size.height * 0.1, size.width, size.height * 0.05);
    upperWavePath.lineTo(size.width, 0);
    upperWavePath.lineTo(0, 0);
    upperWavePath.close();
    canvas.drawPath(upperWavePath, upperWavePaint);

    final lowerWavePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color(0xFFD57EEB),
          Color(0xFFE6A0C3),
          Color(0xFFFCCB90),
        ],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final lowerWavePath = Path();
    lowerWavePath.moveTo(0, size.height * 0.9);
    lowerWavePath.quadraticBezierTo(
        size.width * 0.5, size.height, size.width, size.height * 0.9);
    lowerWavePath.lineTo(size.width, size.height);
    lowerWavePath.lineTo(0, size.height);
    lowerWavePath.close();
    canvas.drawPath(lowerWavePath, lowerWavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
           