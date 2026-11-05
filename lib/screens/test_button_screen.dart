import 'package:flutter/material.dart';
import '../widgets/neon_fire_button.dart';

class TestButtonScreen extends StatelessWidget {
  const TestButtonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Neon Fire Button Test'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Neon Fire Button Test',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            NeonFireButtonWidget(
              radius: 50,
              enabled: true,
              onPressed: () {
                print('Fire button pressed!');
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Tap the button to see the lightning effect!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
