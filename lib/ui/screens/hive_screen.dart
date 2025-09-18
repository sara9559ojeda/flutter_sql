import 'package:flutter/material.dart';
import 'package:flutter_sql/data/hive/hive_helper.dart';
import 'package:flutter_sql/ui/widgets/card.dart';

class HiveScreen extends StatefulWidget {
  const HiveScreen({super.key});

  @override
  State<HiveScreen> createState() => _HiveScreenState();
}

class _HiveScreenState extends State<HiveScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadReminders() {
    setState(() {
      _reminders = HiveHelper.getReminders();
    });
  }

  void _addReminder(String title) {
    final newReminder = {'title': title, 'isCompleted': false};
    HiveHelper.addReminder(newReminder);
    _controller.clear();
    _loadReminders();
  }

  void _toggleCompletion(int index) {
    final reminder = Map<String, dynamic>.from(_reminders[index]);
    reminder['isCompleted'] = !(reminder['isCompleted'] as bool? ?? false);
    HiveHelper.updateReminder(index, reminder);
    _loadReminders();
  }

  void _deleteReminder(int index) {
    HiveHelper.deleteReminder(index);
    _loadReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordatorios (Hive)'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nuevo recordatorio',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _addReminder(value.trim());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                final text = _controller.text.trim();
                if (text.isNotEmpty) _addReminder(text);
              },
              icon: const Icon(Icons.add),
              label: const Text('Agregar'),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _reminders.isEmpty
                ? const Center(child: Text('No hay recordatorios aún'))
                : ListView.builder(
                    itemCount: _reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = _reminders[index];
                      return CustomCard(
                        title: reminder['title']?.toString() ?? '',
                        isCompleted: reminder['isCompleted'] as bool? ?? false,
                        onToggle: () => _toggleCompletion(index),
                        onDelete: () => _deleteReminder(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
