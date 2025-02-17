import 'package:flutter/material.dart';
import 'package:p13/main.dart';
import 'MyPalettePage.dart'; // Ensure this file exists
import 'MyWardrobePage.dart'; // Ensure this file exists
import 'UNDERTONE.dart'; // Ensure this file exists
import 'TestColorPage.dart'; // Ensure this file exists

class Categoryy extends StatefulWidget {
  const Categoryy({super.key});

  @override
  _CategoryyState createState() => _CategoryyState();
}

class _CategoryyState extends State<Categoryy> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const UNDERTONE(), // Assuming UNDERTONE is the correct page
    const TestColorNew(),
    const PaletteScreen(),
    const Wardrobe(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "HOME",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: "MY UNDERTONE",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: "CHECK COLOR",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: "MY PALETTE",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            label: "MY NWARDROBE",
          ),
        ],
      ),
    );
  }
}

// HomePage content
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: CustomPaint(
              size: const Size(double.infinity, 100),
              painter: WavePainter(),
            ),
          ),
          Image.asset(
            'assetss/logo.png', // Ensure this asset exists
            height: 250,
            width: 250,
          ),

          const SizedBox(height: 30),
          // About us section
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFED1F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "About us:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Info boxes
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.pink, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What is color theory?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Color theory explains color mixing and visual effects...",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.pink, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What is color Undertones?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Undertones are the subtle hues beneath the skin...",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pink, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "How does the app work?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "The app uses the camera to capture facial images...",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// WavePainter class
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final upperWavePaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFFCCB90),
          Color(0xFFE6A0C3),
          Color(0xFFD57EEB),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final upperWavePath = Path();
    upperWavePath.moveTo(0, size.height * 0.85);
    upperWavePath.quadraticBezierTo(size.width * 0.3, size.height * 0.6,
        size.width * 0.5, size.height * 0.4);
    upperWavePath.quadraticBezierTo(
        size.width * 0.7, size.height * 0.2, size.width, size.height * 0.1);
    upperWavePath.lineTo(size.width, 0);
    upperWavePath.lineTo(0, 0);
    upperWavePath.close();

    canvas.drawPath(upperWavePath, upperWavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
