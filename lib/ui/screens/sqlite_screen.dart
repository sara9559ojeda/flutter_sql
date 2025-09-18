import 'package:flutter/material.dart';
import 'package:flutter_sql/data/sqlite/database_helper.dart';
import 'package:flutter_sql/data/sqlite/models/medical_record.dart';
import 'package:flutter_sql/ui/widgets/card.dart';

class SQLiteScreen extends StatefulWidget {
  const SQLiteScreen({super.key});

  @override
  State<SQLiteScreen> createState() => _SQLiteScreenState();
}

class _SQLiteScreenState extends State<SQLiteScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<MedicalRecord> _records = [];

  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _resultsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _resultsController.dispose();
    super.dispose();
  }

  Future<void> _loadRecords() async {
    final rows = await _dbHelper.getRecords(); 
    setState(() {
      _records = rows.map((m) => MedicalRecord.fromMap(m)).toList();
    });
  }

  Future<void> _addRecord() async {
    final diag = _diagnosisController.text.trim();
    final res = _resultsController.text.trim();
    if (diag.isEmpty || res.isEmpty) return;

    final record = MedicalRecord(
      diagnosis: diag,
      date: DateTime.now().toIso8601String(),
      results: res,
    );

    await _dbHelper.insertRecord(record.toMap());
    _diagnosisController.clear();
    _resultsController.clear();
    await _loadRecords();
  }

  Future<void> _deleteRecord(int id) async {
    await _dbHelper.deleteRecord(id);
    await _loadRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial Médico (SQLite)'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _diagnosisController,
              decoration: const InputDecoration(
                labelText: 'Diagnóstico',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: TextField(
              controller: _resultsController,
              decoration: const InputDecoration(
                labelText: 'Resultados / Notas',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _addRecord,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar registro'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _loadRecords,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refrescar'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _records.isEmpty
                ? const Center(child: Text('No hay registros aún'))
                : ListView.builder(
                    itemCount: _records.length,
                    itemBuilder: (context, index) {
                      final record = _records[index];
                      return CustomCard(
                        title: record.diagnosis,
                        subtitle: "${record.date}\n${record.results}",
                        onDelete: () {
                          if (record.id != null) _deleteRecord(record.id!);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
