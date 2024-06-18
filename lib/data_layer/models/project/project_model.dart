import 'package:equatable/equatable.dart';

///ProjectModel to store project details
class ProjectModel extends Equatable {
  ///Constructor for [ProjectModel]
  const ProjectModel({
    required this.id,
    required this.name,
    required this.commentCount,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] is String? ? json['id'] as String? ?? '' : '',
      name: json['name'] is String? ? json['name'] as String? ?? '' : '',
      commentCount: int.tryParse(json['comment_count'].toString()) ?? 0,
    );
  }

  ///Project id
  final String id;

  ///Project name
  final String name;

  ///Project comment count
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
