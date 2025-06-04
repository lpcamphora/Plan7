
import 'package:hive/hive.dart';

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
  String? hora;

  @HiveField(4)
  bool concluida;

  @HiveField(5)
  DateTime? dataConclusao;

  @HiveField(6)
  List<Map<String, dynamic>> subTarefas;

  @HiveField(7)
  int cor;

  Tarefa({
    required this.titulo,
    this.lembreteAtivo = false,
    this.data,
    this.hora,
    this.concluida = false,
    this.dataConclusao,
    this.subTarefas = const [],
    this.cor = 0xFFE0E0E0,
  });
}
