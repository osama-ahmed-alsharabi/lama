import 'package:flutter/material.dart';

class TestColorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Color Page"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // تنفيذ الكود الذي تود اختباره هنا
            print("Test Check Button Pressed!");
          },
          child: Text("Test Check"),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), // حجم الزر
            textStyle: TextStyle(fontSize: 18), // تغيير حجم النص
          ),
        ),
      ),
    );
  }
}