class Reminder {
  String title;
  bool isCompleted;

  Reminder({
    required this.title,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      title: map['title'] as String,
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }
}
