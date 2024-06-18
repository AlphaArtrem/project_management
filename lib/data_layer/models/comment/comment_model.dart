import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'comment_model.g.dart';

///[CommentModel] to store task comments
@HiveType(typeId: 2)
class CommentModel extends Equatable {
  ///Default constructor for [CommentModel]
  const CommentModel({
    required this.content,
    required this.taskId,
    this.postedAt,
  });

  ///Get [CommentModel] from API JSON
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        content:
            json['content'] is String? ? json['content'] as String? ?? '' : '',
        postedAt: DateTime.tryParse(json['posted_at'] is String?
            ? json['posted_at'] as String? ?? ''
            : ''),
        taskId:
            json['task_id'] is String? ? json['task_id'] as String? ?? '' : '');
  }

  ///Comment content
  @HiveField(0)
  final String content;

  ///Comment timestamp
  @HiveField(1)
  final DateTime? postedAt;

  ///Comment task's id
  @HiveField(2)
  final String taskId;

  ///Copy with constructor for [CommentModel]
  CommentModel copyWith({
    String? content,
    DateTime? postedAt,
    String? taskId,
  }) {
    return CommentModel(
      content: content ?? this.content,
      postedAt: postedAt ?? this.postedAt,
      taskId: taskId ?? this.taskId,
    );
  }

  ///Convert [CommentModel] to JSON [Map]
  Map<String, dynamic> toJson() => {
        'content': content,
        'task_id': taskId,
      };

  @override
  String toString() {
    return '$content, $postedAt, $taskId, ';
  }

  @override
  List<Object?> get props => [
        content,
        postedAt,
        taskId,
      ];
}
