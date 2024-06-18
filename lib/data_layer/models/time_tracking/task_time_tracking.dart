import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'task_time_tracking.g.dart';

///Model for tracking task and it's durations
@HiveType(typeId: 0)
class TaskTimeTacking extends Equatable {
  ///Default constructor for [TaskTimeTacking]
  const TaskTimeTacking({
    required this.totalTimeTrackedInSeconds,
    this.millisecondSinceEpochSinceLastTimeTrackingStarted,
  });

  ///Timestamp when time tracking was started last
  ///If null then time is not being tracked for task
  @HiveField(0)
  final int? millisecondSinceEpochSinceLastTimeTrackingStarted;

  ///Total time already tracked in seconds
  @HiveField(1)
  final int totalTimeTrackedInSeconds;

  ///Get time tracked from seconds to human readable form
  String getDuration() =>
      Duration(seconds: totalTimeTrackedInSeconds).toString().split('.').first;

  ///Get live time tracked from
  ///[millisecondSinceEpochSinceLastTimeTrackingStarted] and
  ///[totalTimeTrackedInSeconds] to human readable form
  String getLiveDuration() => Duration(
        seconds: DateTime.now()
                .difference(
                  DateTime.fromMillisecondsSinceEpoch(
                    millisecondSinceEpochSinceLastTimeTrackingStarted ?? 0,
                  ),
                )
                .inSeconds +
            totalTimeTrackedInSeconds,
      ).toString().split('.').first;

  @override
  List<Object?> get props => [
        millisecondSinceEpochSinceLastTimeTrackingStarted,
        totalTimeTrackedInSeconds,
      ];
}
