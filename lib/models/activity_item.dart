import 'package:flutter/material.dart';

class ActivityItem {
  final int dayIndex;
  final TimeOfDay time;
  final String activityType;
  final bool repeatDaily;

  ActivityItem({
    required this.dayIndex,
    required this.time,
    required this.activityType,
    required this.repeatDaily,
  });
}
