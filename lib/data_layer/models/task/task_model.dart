import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/data_layer/enums/task_status.dart';

part 'task_model.g.dart';

///[TaskModel] to store task details
@HiveType(typeId: 1)
class TaskModel extends Equatable {
  ///Default constructor for [TaskModel]
  const TaskModel({
    required this.createdAt,
    required this.commentCount,
    required this.content,
    required this.description,
    required this.id,
    required this.labels,
    required this.projectId,
    this.isCompleted = false,
  });

  ///Get [TaskModel] from API JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    var labels = ['todo'];
    if (json['labels'] != null && json['labels'] is List) {
      final labelsTemp = List<String>.from(
        (json['labels'] as List).map((label) => label),
      );
      for (final label in labelsTemp) {
        if (TaskStatus.values
            .where((status) => status.name == label)
            .isNotEmpty) {
          labels = [label];
          break;
        }
      }
    }
    return TaskModel(
      createdAt: json['created_at'] is String?
          ? json['created_at'] as String? ?? ''
          : '',
      commentCount: int.tryParse(json['comment_count'].toString()) ?? 0,
      content:
          json['content'] is String? ? json['content'] as String? ?? '' : '',
      description: json['description'] is String?
          ? json['description'] as String? ?? ''
          : '',
      id: json['id'] is String? ? json['id'] as String? ?? '' : '',
      labels: labels,
      projectId: json['project_id'] is String?
          ? json['project_id'] as String? ?? ''
          : '',
    );
  }

  ///Task creation timestamp
  @HiveField(0)
  final String createdAt;

  ///Task comment count
  @HiveField(1)
  final int commentCount;

  ///Task title
  @HiveField(2)
  final String content;

  ///Task description
  @HiveField(3)
  final String description;

  ///Task id
  @HiveField(4)
  final String id;

  ///Task labels
  @HiveField(5)
  final List<String> labels;

  ///Project id to which the task belongs
  @HiveField(6)
  final String projectId;

  ///If the task has been archived to history or not
  @HiveField(7)
  final bool isCompleted;

  ///Get [TaskStatus] from labels. Default to [TaskStatus.todo]
  ///if no match is found
  TaskStatus get status =>
      TaskStatus.values.firstWhere((status) => status.name == labels.first);

  ///
  TaskModel copyWith({
    String? createdAt,
    int? commentCount,
    String? content,
    String? description,
    int? duration,
    String? durationUnit,
    String? id,
    List<String>? labels,
    String? projectId,
    bool? isCompleted,
  }) {
    return TaskModel(
      createdAt: createdAt ?? this.createdAt,
      commentCount: commentCount ?? this.commentCount,
      content: content ?? this.content,
      description: description ?? this.description,
      id: id ?? this.id,
      labels: labels ?? this.labels,
      projectId: projectId ?? this.projectId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  ///Convert to json for updating task for API
  Map<String, dynamic> updateTaskJson() => {
        'content': content,
        'description': description,
        'labels': labels.map((x) => x).toList(),
      };

  @override
  String toString() {
    return '$createdAt, $commentCount, $content, '
        '$description, $id, $labels, $projectId, ';
  }

  @override
  List<Object?> get props => [
        createdAt,
        commentCount,
        content,
        description,
        id,
        labels,
        projectId,
      ];
}
