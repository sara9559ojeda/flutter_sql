import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool? isCompleted;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const CustomCard({
    super.key,
    required this.title,
    this.subtitle,
    this.isCompleted,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: isCompleted != null
            ? Checkbox(
                value: isCompleted,
                onChanged: (_) => onToggle?.call(),
              )
            : const Icon(Icons.folder, color: Colors.blueGrey),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            decoration: (isCompleted ?? false)
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
