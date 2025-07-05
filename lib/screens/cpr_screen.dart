import 'package:flutter/material.dart';

class CPRScreen extends StatelessWidget {
  const CPRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CPR Guidance')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'CPR Mode Active',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text('Elapsed Time: 00:00'),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              height: 150,
              color: Colors.grey.shade800,
              alignment: Alignment.center,
              child: const Text(
                'Waveform Placeholder',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('End CPR'),
            )
          ],
        ),
      ),
    );
  }
}
