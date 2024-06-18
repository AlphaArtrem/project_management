import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/data_layer/models/task_history_model/task_history_model.dart';
import 'package:task_manager/data_layer/models/time_tracking/task_time_tracking.dart';

///Local hive storage service
class LocalStorageService {
  ///Box for tasks time tracking data
  static late final Box<TaskTimeTacking> timeTrackingBox;

  ///Box for tasks moved to history
  static late final Box<TaskHistoryModel> taskHistoryBox;

  ///Box to map achieved task id to history box key
  static late final Box<int> historyTaskIdToIndexBox;

  ///Initialise hive boxes
  static Future<void> init() async {
    timeTrackingBox = await Hive.openBox<TaskTimeTacking>('time_tracking');
    taskHistoryBox = await Hive.openBox<TaskHistoryModel>('history');
    historyTaskIdToIndexBox =
        await Hive.openBox<int>('history_task_id_to_index');
  }
}
