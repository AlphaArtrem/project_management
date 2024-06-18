// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_time_tracking.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskTimeTackingAdapter extends TypeAdapter<TaskTimeTacking> {
  @override
  final int typeId = 0;

  @override
  TaskTimeTacking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskTimeTacking(
      totalTimeTrackedInSeconds: fields[1] as int,
      millisecondSinceEpochSinceLastTimeTrackingStarted: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskTimeTacking obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.millisecondSinceEpochSinceLastTimeTrackingStarted)
      ..writeByte(1)
      ..write(obj.totalTimeTrackedInSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskTimeTackingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
