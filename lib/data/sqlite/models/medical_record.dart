class MedicalRecord {
  int? id;
  String diagnosis;
  String date;
  String results;

  MedicalRecord({
    this.id,
    required this.diagnosis,
    required this.date,
    required this.results,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'diagnosis': diagnosis,
      'date': date,
      'results': results,
    };
  }

  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      id: map['id'] as int?,
      diagnosis: map['diagnosis'] as String,
      date: map['date'] as String,
      results: map['results'] as String,
    );
  }
}
