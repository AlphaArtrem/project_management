class APIConstants {
  static const String projects = '/projects';
  static const String tasks = '/tasks';
  static const String comments = '/comments';
  static String getTasks(String projectID) => '$tasks?project_id=$projectID';
  static String getTaskComments(String taskID) => '$comments?task_id=$taskID';
  static String closeTask(String taskID) => '$tasks/$taskID/close';
}
