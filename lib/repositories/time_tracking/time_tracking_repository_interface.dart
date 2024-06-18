import 'package:task_manager/business_layer/create_update_task/create_update_task_cubit.dart';
import 'package:task_manager/data_layer/models/project/project_model.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/data_layer/models/time_tracking/task_time_tracking.dart';
import 'package:task_manager/service_layer/api_service/api_service_interface.dart';

///Interface for tracking time
abstract class ITimeTrackingRepository {
  ///Default constructor for [ITimeTrackingRepository].
  ITimeTrackingRepository();

  ///Function to get time spent on a task
  TaskTimeTacking getTimeSpentOnTask(String taskID);

  ///Function to start time tracking
  void startTrackingTime(String taskID);

  ///Function to stop time tracking
  void stopTrackingTime(String taskID);
}
