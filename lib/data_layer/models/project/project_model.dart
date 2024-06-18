import 'package:equatable/equatable.dart';

class ProjectModel extends Equatable {
  ProjectModel({
    required this.id,
    required this.name,
    required this.commentCount,
  });

  final String id;
  final String name;
  final int commentCount;

  ProjectModel copyWith({
    String? id,
    String? name,
    int? commentCount,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      commentCount: commentCount ?? this.commentCount,
    );
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] is String? ? json['id'] as String? ?? '' : '',
      name: json['name'] is String? ? json['name'] as String? ?? '' : '',
      commentCount: int.tryParse(json['comment_count'].toString()) ?? 0,
    );
  }

  @override
  String toString() {
    return '$id, $name, $commentCount, ';
  }

  @override
  List<Object?> get props => [
        id,
        name,
        commentCount,
      ];
}
