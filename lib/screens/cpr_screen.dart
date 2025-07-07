import 'dart:async';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
bool _pulseOn = false;
late Timer _metronomeTimer;

class CPRScreen extends StatefulWidget {
  const CPRScreen({super.key});

  @override
  State<CPRScreen> createState() => _CPRScreenState();
}

class _CPRScreenState extends State<CPRScreen> {
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _audioEnabled = true;
  bool _visualEnabled = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
    // Metronome: ~110 bpm (every 545ms)
    _metronomeTimer = Timer.periodic(const Duration(milliseconds: 545), (timer) {
      _playTick();
      if (_visualEnabled) {
        setState(() {
          _pulseOn = true;
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            setState(() => _pulseOn = false);
          }
        });
      }
    //   setState(() {
    //     _pulseOn = !_pulseOn; // Toggle visual cue
    //   });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
    _metronomeTimer.cancel();
    _audioPlayer.dispose();
  }

  void _playTick() async {
    // await _audioPlayer.play(AssetSource('sounds/tick.wav'));
    if (_audioEnabled) {
      await _audioPlayer.play(AssetSource('sounds/tick.wav'));
    }
  }

  String _formatElapsedTime() {
    final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }



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
            Text(
              'Elapsed Time: ${_formatElapsedTime()}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),


              Row( // does this go here?
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() => _audioEnabled = !_audioEnabled);
                    },
                    icon: Icon(
                      _audioEnabled ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => _visualEnabled = !_visualEnabled);
                    },
                    icon: Icon(
                      _visualEnabled ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),


            AnimatedContainer(
              width: double.infinity,
              height: 150,
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: Colors.black,
                border: _visualEnabled && _pulseOn
                    ? Border.all(color: Colors.white, width: 4)
                    : Border.all(color: Colors.transparent),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Compression Rhythm',
                style: TextStyle(color: Colors.white70, fontSize: 18),
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
