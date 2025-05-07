import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String type; // 'assignment', 'exam', or 'project'
  final DateTime dueDate;
  final bool isCompleted;
  final String userId;

  Task({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.type,
    required this.dueDate,
    this.isCompleted = false,
    required this.userId,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'type': type,
      'dueDate': dueDate,
      'isCompleted': isCompleted,
      'userId': userId,
    };
  }

  // Create from Firestore document
  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? 'assignment',
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      isCompleted: map['isCompleted'] ?? false,
      userId: map['userId'] ?? '', // Ensure this exists
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? type,
    DateTime? dueDate,
    bool? isCompleted,
    String? userId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      type: type ?? this.type,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }

}