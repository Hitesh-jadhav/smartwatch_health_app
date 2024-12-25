import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../db/health_data_db.dart';  // Correct import path for the local database
import '../services/connectivity_service.dart'; // Correct import path for the connectivity service

class HealthDataSync {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sync offline data with Firestore every 10 seconds when online
  void startSyncing() {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      if (await ConnectivityService.isOnline()) {
        // Sync offline data with Firestore
        List<Map<String, dynamic>> offlineData = await HealthDataDB.getHealthData();
        for (var data in offlineData) {
          await _syncDataToFirestore(data);
        }
        // Clear the local database after syncing
        await HealthDataDB.clearHealthData();
      }
    });
  }

  Future<void> _syncDataToFirestore(Map<String, dynamic> healthData) async {
    try {
      await _firestore.collection('health_data').add({
        'heartRate': healthData['heartRate'],
        'stepCount': healthData['stepCount'],
        'timestamp': DateTime.fromMillisecondsSinceEpoch(healthData['timestamp']),
      });
    } catch (e) {
      print("Error syncing data: $e");
    }
  }
}
