import 'package:flutter/material.dart';

import '../screens/settings_screen.dart';

class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('CPR Assistant'),
                centerTitle: true,
            ),
            body: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    ElevatedButton(
                        onPressed: () {
                        Navigator.pushNamed(
                            context,
                            '/cpr',
                            arguments: PatientType.adult,
                        );
                        },
                        style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(80),
                        textStyle: const TextStyle(fontSize: 24),
                        ),
                        child: const Text('Start CPR'),
                    ),
                    const SizedBox(height: 40),
                    OutlinedButton(
                        onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                        },
                        child: const Text('Settings / Info'),
                    ),
                    OutlinedButton(
                        onPressed: () {
                        // placeholder for AED locator
                        },
                        child: const Text('AED Locator'),
                    ),
                    OutlinedButton(
                        onPressed: () {
                        // Placeholder for Training Mode
                        },
                        child: const Text('Training Mode'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Calling 911... -- PLACEHOLDER')),
                        );
                        },
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size.fromHeight(60),
                        textStyle: const TextStyle(fontSize: 20),
                        ),
                        child: const Text('Call 911'),
                    ),
                    ],

                ),
            ),
        );
    }
}