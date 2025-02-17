import 'package:flutter/material.dart';
import 'package:p13/requires.dart';


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isChecked = false; // متغير لتتبع حالة الموافقة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // تغيير لون الخلفية إلى الأبيض
      body: Stack(
        children: [
          // الخلفية المنحنية
          CustomPaint(
            painter: BackgroundPainter(),
            child: Container(),
          ),
          Positioned(
            top: 40, // المسافة من الأعلى
            left: 20, // المسافة من اليسار
            child: const Text(
              "Welcome To,\n Color Assistant",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // المحتوى الرئيسي
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الصورة
                Image.asset(
                  'assets/1.png', // ضع مسار الصورة هنا
                  height: 220,
                  width: 220,
                ),
                const SizedBox(height: 20),
                // النص الوصفي
                const Text(
                  "Unveil your unique undertone\nand find your perfect colors",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF57EA1),
                  ),
                ),
                const SizedBox(height: 20),
                // Checkbox للموافقة على الشروط والأحكام
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    const Text(
                      "I agree to the Terms & Conditions",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // زر Get Started في الأسفل
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // اللون الأبيض للزر
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              onPressed: isChecked
    ? () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  Requires()), // الانتقال لصفحة Requires
        );
      }
    : null, // تعطيل الزر إذا لم يتم تحديد Checkbox
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.black, // لون النص في الزر بالأسود
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // رسم التدرجات العلوية
    final topGradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color(0xFFFAD0C4),
          Color(0xFFFAD0C4),
          Color(0xFFFFD1FF),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final topPath = Path();
    topPath.lineTo(0, size.height * 0.2);
    topPath.quadraticBezierTo(
        size.width * 0.5, size.height * 0.1, size.width, size.height * 0.2);
    topPath.lineTo(size.width, 0);
    topPath.close();
    canvas.drawPath(topPath, topGradientPaint);

    // رسم التدرجات السفلية
    final bottomGradientPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color(0xFFFAD0C4),
          Color(0xFFFAD0C4),
          Color(0xFFFFD1FF),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final bottomPath = Path();
    bottomPath.moveTo(0, size.height * 0.8);
    bottomPath.quadraticBezierTo(
        size.width * 0.5, size.height * 0.9, size.width, size.height * 0.8);
    bottomPath.lineTo(size.width, size.height);
    bottomPath.lineTo(0, size.height);
    bottomPath.close();
    canvas.drawPath(bottomPath, bottomGradientPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}