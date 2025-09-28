import 'package:flutter/material.dart';

import '../hawaj_voice/presentation/widgets/hawaj_widget.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hawaj Widget Test'),
      ),
      body: Stack(
        children: [
          // محتوى عادي للتجربة
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.android, size: 80, color: Colors.teal),
                SizedBox(height: 16),
                Text(
                  'شاشة اختبار HawajWidget',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // إضافة الـ HawajWidget كطبقة علوية
          Positioned(
            bottom: 30,
            right: 30,
            child: HawajWidget(
              welcomeMessage: 'مرحباً! كيف أستطيع مساعدتك اليوم؟',
              showOnInit: true,
            ),
          ),
        ],
      ),
    );
  }
}
