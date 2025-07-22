import 'dart:async';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:fl_chart/fl_chart.dart';

import '../screens/settings_screen.dart';

final AudioPlayer _audioPlayer = AudioPlayer();
bool _pulseOn = false;
late Timer _metronomeTimer;

class CPRScreen extends StatefulWidget {
  final PatientType patientType;
  const CPRScreen({super.key, required this.patientType});

  @override
  State<CPRScreen> createState() => _CPRScreenState();
}

class _CPRScreenState extends State<CPRScreen> {
  late Timer _timer;
  int _elapsedSeconds = 0;
  bool _audioEnabled = true;
  bool _visualEnabled = true;
  double _x = 0.0;
  double _y = 0.0;
  double _z = 0.0;
  late StreamSubscription<AccelerometerEvent> _accelSubscription;

  double _lastZ = 0.0;
  bool _compressionDetected = false;
  int _compressionCount = 0;
  final double _compressionThreshold = 1.5; // Placeholder for now

  List<FlSpot> _zData = [];
  int _timeCounter = 0;
  final int _maxDataPoints = 50;

  late PatientType _patientType;


  @override
  void initState() {
    super.initState();
    _patientType = widget.patientType;
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


      _accelSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
    setState(() {
      _x = event.x;
      _y = event.y;
      _z = event.z;

      double deltaZ = (_z - _lastZ).abs();

      if (!_compressionDetected && deltaZ > _compressionThreshold) {
        _compressionDetected = true;
        _compressionCount++;
      } else if (_compressionDetected && deltaZ < 0.5) {
        _compressionDetected = false;
      }

      _lastZ = _z;


      _zData.add(FlSpot(_timeCounter.toDouble(), _z));
      _timeCounter++;

      if (_zData.length > _maxDataPoints) {
        _zData.removeAt(0);
      }
    });
  });


  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
    _metronomeTimer.cancel();
    _audioPlayer.dispose();
    _accelSubscription.cancel();
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


            const SizedBox(height: 20),
            Text(
              'Accelerometer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('X: ${_x.toStringAsFixed(2)}'),
            Text('Y: ${_y.toStringAsFixed(2)}'),
            Text('Z: ${_z.toStringAsFixed(2)}'),

            const SizedBox(height: 20),
            Text(
              'Compressions: $_compressionCount',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),



            SizedBox(
              height: 150,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: false),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _zData,
                      isCurved: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                      color: Colors.greenAccent,
                      barWidth: 3,
                    ),
                  ],
                ),
              ),
            ),



            const SizedBox(height: 30),


              Row( 
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
