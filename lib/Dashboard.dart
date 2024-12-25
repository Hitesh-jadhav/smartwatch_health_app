import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smartwatch_health_app/db/health_data_db.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _heartRate = 0;
  int _steps = 0;

  late StreamSubscription<int> _heartRateSubscription;
  late StreamSubscription<int> _stepCountSubscription;

  @override
  void initState() {
    super.initState();

    _heartRateSubscription = MockBluetoothSDK().getHeartRateStream().listen((data) {
      setState(() {
        _heartRate = data;
      });
      _saveHealthData();
    });

    _stepCountSubscription = MockBluetoothSDK().getStepCountStream().listen((data) {
      setState(() {
        _steps = data;
      });
      _saveHealthData();
    });
  }

  Future<void> _saveHealthData() async {
    final timestamp = DateTime.now().toIso8601String();
    await HealthDataDB.insertHealthData({
      'heartRate': _heartRate,
      'stepCount': _steps,
      'timestamp': timestamp,
    });
  }

  @override
  void dispose() {
    _heartRateSubscription.cancel();
    _stepCountSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Heart Rate:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_heartRate BPM',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Steps:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '$_steps',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MockBluetoothSDK {
  Stream<int> getHeartRateStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      yield 60 + Random().nextInt(20); // Generate a random heart rate
    }
  }

  Stream<int> getStepCountStream() async* {
    int steps = 0;
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      steps += Random().nextInt(10); // Simulate step count increase
      yield steps;
    }
  }
}
