// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tarefa.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TarefaAdapter extends TypeAdapter<Tarefa> {
  @override
  final int typeId = 0;

  @override
  Tarefa read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tarefa(
      titulo: fields[0] as String,
      lembreteAtivo: fields[1] as bool,
      data: fields[2] as DateTime?,
      hora: fields[3] as String?,
      concluida: fields[4] as bool,
      dataConclusao: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Tarefa obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.titulo)
      ..writeByte(1)
      ..write(obj.lembreteAtivo)
      ..writeByte(2)
      ..write(obj.data)
      ..writeByte(3)
      ..write(obj.hora)
      ..writeByte(4)
      ..write(obj.concluida)
      ..writeByte(5)
      ..write(obj.dataConclusao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TarefaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
