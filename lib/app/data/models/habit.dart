import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Habit {
  final String id;
  final String name;
  final IconData icon;
  final Color? color;
  final DateTime? startDate;
  final DateTime createdAt;
  final int durationDays;
  final Map<String, bool> completionHistory;

  Habit({
    required this.id,
    required this.name,
    required this.icon,
    this.color,
    this.startDate,
    required this.createdAt,
    this.durationDays = 7,
    Map<String, bool>? completionHistory,
  }) : completionHistory = completionHistory ?? {};

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon.codePoint,
      'color': color?.toARGB32(),
      'startDate': startDate?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'durationDays': durationDays,
      'completionHistory': completionHistory,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map, String documentId) {
    Map<String, bool> parsedHistory = {};
    if (map['completionHistory'] != null) {
      final Map<dynamic, dynamic> history = map['completionHistory'] as Map<dynamic, dynamic>;
      history.forEach((key, value) {
        parsedHistory[key.toString()] = value == true;
      });
    }

    return Habit(
      id: documentId,
      name: map['name'] ?? '',
      icon: IconData(map['icon'] ?? Icons.fitness_center.codePoint, fontFamily: 'MaterialIcons'),
      color: map['color'] != null ? Color(map['color']) : null,
      startDate: map['startDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['startDate']) : null,
      createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) : DateTime.now(),
      durationDays: map['durationDays'] ?? 7,
      completionHistory: parsedHistory,
    );
  }

  bool isCompletedOn(DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    return completionHistory[key] ?? false;
  }

  int get completedCount {
    return completionHistory.values.where((v) => v).length;
  }
}
