import 'package:flutter/material.dart';
import 'package:smartwatch_health_app/db/health_data_db.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _records = [];

  /// Fetch health data from the 'health' table.
  Future<void> _fetchRecords() async {
    final records = await HealthDataDB.getHealthData();
    setState(() {
      _records = records;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchRecords(); // Load records when the screen initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: _records.isEmpty
          ? const Center(
              child: Text(
                'No history available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return ListTile(
                  title: Text('Heart Rate: ${record['heartRate']} BPM'),
                  subtitle: Text('Steps: ${record['stepCount']}'),
                  trailing: Text(
                    record['timestamp'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                );
              },
            ),
    );
  }
}
