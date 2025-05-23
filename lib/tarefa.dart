import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'tarefa.g.dart';

@HiveType(typeId: 0)
class Tarefa extends HiveObject {
  @HiveField(0)
  String titulo;

  @HiveField(1)
  bool lembreteAtivo;

  @HiveField(2)
  DateTime? data;

  @HiveField(3)
  String? hora; // formatada como string

  @HiveField(4)
  bool concluida;

  @HiveField(5)
  DateTime? dataConclusao;  // ✅ novo campo para data de conclusão

  Tarefa({
    required this.titulo,
    this.lembreteAtivo = false,
    this.data,
    this.hora,
    this.concluida = false,
    this.dataConclusao,   // ✅ adiciona no construtor também
  });
}
