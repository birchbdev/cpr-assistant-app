import 'package:flutter/material.dart';

enum PatientType { adult, child, infant }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PatientType _selectedType = PatientType.adult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Patient Type:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...PatientType.values.map((type) {
              return RadioListTile<PatientType>(
                title: Text(
                  type.name[0].toUpperCase() + type.name.substring(1),
                ),
                value: type,
                groupValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
