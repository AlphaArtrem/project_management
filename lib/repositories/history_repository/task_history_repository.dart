import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/data_layer/models/task_history_model/task_history_model.dart';
import 'package:task_manager/repositories/history_repository/task_history_repository_interface.dart';

class TaskHistoryRepository implements ITaskHistoryRepository {
  TaskHistoryRepository({
    required this.taskHistoryBox,
    required this.historyTaskIdToIndexBox,
  });

  ///Box for tasks moved to history
  final Box<TaskHistoryModel> taskHistoryBox;

  ///Box to map achieved task id to history box key
  final Box<int> historyTaskIdToIndexBox;

  @override
  Future<void> addTaskToHistory(TaskHistoryModel historyModel) async {
    final index = await taskHistoryBox.add(historyModel);
    await historyTaskIdToIndexBox.put(historyModel.taskModel.id, index);
  }

  @override
  List<TaskHistoryModel> getAllTaskFromHistory() {
    return taskHistoryBox.values.toList();
  }
}
