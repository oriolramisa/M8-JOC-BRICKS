import 'package:brick_breaker/screens/easy_screen.dart';
import 'package:brick_breaker/screens/hard_screen.dart';
import 'package:brick_breaker/screens/medium_screen.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.blue[200],
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EasyScreen()),
                );
              },
              child: const Text('FÀCIL'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.yellow[700],
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MediumScreen()),
                );
              },
              child: const Text('MITJÀ'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red[700],
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HardScreen()),
                );
              },
              child: const Text('DIFÍCIL'),
            ),
          ],
        ),
      ),
    );
  }
}
