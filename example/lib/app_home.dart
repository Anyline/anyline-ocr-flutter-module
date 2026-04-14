import 'package:anyline_plugin_example/infinity/main_scan_screen.dart';
import 'package:anyline_plugin_example/legacy/home.dart';
import 'package:anyline_plugin_example/legacy/styles.dart';
import 'package:flutter/material.dart';

class AppHome extends StatelessWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/anyline_flutter_appbar.png',
              fit: BoxFit.fitHeight,
              height: 80,
            ),
            const SizedBox(height: 48),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Styles.anylineBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, InfinityMainScanScreen.routeName);
              },
              child: const Text(
                'Infinity Plugin Examples',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Styles.anylineBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, Home.routeName);
              },
              child: const Text(
                'Legacy Plugin Examples',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}