import 'package:task_manager/data_layer/models/task_history_model/task_history_model.dart';

///Interface for tracking task history
abstract class ITaskHistoryRepository {
  ///Default constructor for [ITaskHistoryRepository].
  ITaskHistoryRepository();

  ///Function to get time spent on a task
  void addTaskToHistory(TaskHistoryModel historyModel);

  ///Function to get tasks from history
  List<TaskHistoryModel> getAllTaskFromHistory();
}
