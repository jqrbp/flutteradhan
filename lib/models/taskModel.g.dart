// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taskModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final int typeId = 3;

  @override
  TaskStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskStatus(
      id: fields[0] as String,
      runFlag: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.runFlag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
