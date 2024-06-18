import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/data_layer/models/time_tracking/task_time_tracking.dart';
import 'package:task_manager/repositories/time_tracking/time_tracking_repository_interface.dart';

class TimeTrackingRepository implements ITimeTrackingRepository {
  TimeTrackingRepository(this.timeTrackingBox);

  final Box<TaskTimeTacking> timeTrackingBox;

  @override
  TaskTimeTacking getTimeSpentOnTask(String taskID) {
    return timeTrackingBox.get(
      taskID,
      defaultValue: const TaskTimeTacking(
        totalTimeTrackedInSeconds: 0,
      ),
    )!;
  }

  @override
  void startTrackingTime(String taskID) {
    final existingInfo = getTimeSpentOnTask(taskID);
    timeTrackingBox.put(
      taskID,
      TaskTimeTacking(
        totalTimeTrackedInSeconds: existingInfo.totalTimeTrackedInSeconds,
        millisecondSinceEpochSinceLastTimeTrackingStarted:
            DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  @override
  void stopTrackingTime(String taskID) {
    final existingInfo = getTimeSpentOnTask(taskID);
    final totalTimeTracked = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(
          existingInfo.millisecondSinceEpochSinceLastTimeTrackingStarted!),
    );
    timeTrackingBox.put(
      taskID,
      TaskTimeTacking(
        totalTimeTrackedInSeconds:
            existingInfo.totalTimeTrackedInSeconds + totalTimeTracked.inSeconds,
      ),
    );
  }
}
