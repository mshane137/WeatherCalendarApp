import '../models/activity_item.dart';

class ScheduleService {
  static final ScheduleService _instance = ScheduleService._internal();
  factory ScheduleService() => _instance;
  ScheduleService._internal();

  // Normal day-specific activities
  final Map<int, List<ActivityItem>> _activities = {};

  // Repeating daily activities
  final List<ActivityItem> _dailyRepeating = [];

  // Adds an activity for a specific day
  void addActivity(ActivityItem activity) {
    if (!activity.repeatDaily) {
      if (_activities.containsKey(activity.dayIndex)) {
        _activities[activity.dayIndex]!.add(activity);
      } else {
        _activities[activity.dayIndex] = [activity];
      }
    }

    // Repeating-daily activity
    if (activity.repeatDaily) {
      _dailyRepeating.add(activity);
    }
  }

  // Returns all activities for a given day
  List<ActivityItem> getActivitiesForDay(int dayIndex) {
    final normal = _activities[dayIndex] ?? [];

    // Repeating daily activities must be added dynamically
    final repeatingForThisDay = _dailyRepeating.map((a) {
      return ActivityItem(
        dayIndex: dayIndex,     // injected for this day
        time: a.time,
        activityType: a.activityType,
        repeatDaily: true,
      );
    }).toList();

    return [...normal, ...repeatingForThisDay];
  }

  // Removes a specific activity
  void removeActivity(ActivityItem activity) {
    if (activity.repeatDaily) {
      _dailyRepeating.removeWhere(
        (a) =>
            a.activityType == activity.activityType &&
            a.time == activity.time,
      );
    } else {
      _activities[activity.dayIndex]?.remove(activity);
    }
  }

  // Clears all activities for a specific day
  void clearDay(int dayIndex) {
    _activities.remove(dayIndex);
  }

  // Clears all activities across all days
  void clearAll() {
    _activities.clear();
    _dailyRepeating.clear();
  }
}
