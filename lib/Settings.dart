import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Logic to connect/disconnect smartwatch
        },
        child: const Text('Connect Smartwatch'),
      ),
    );
  }
}
