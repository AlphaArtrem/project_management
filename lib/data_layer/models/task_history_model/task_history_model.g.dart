// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskHistoryModelAdapter extends TypeAdapter<TaskHistoryModel> {
  @override
  final int typeId = 3;

  @override
  TaskHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskHistoryModel(
      taskModel: fields[0] as TaskModel,
      taskTimeTacking: fields[1] as TaskTimeTacking,
      comments: (fields[2] as List).cast<CommentModel>(),
      completionTimeStamp: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TaskHistoryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.taskModel)
      ..writeByte(1)
      ..write(obj.taskTimeTacking)
      ..writeByte(2)
      ..write(obj.comments)
      ..writeByte(3)
      ..write(obj.completionTimeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
