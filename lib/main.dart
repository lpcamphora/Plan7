
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'tarefa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  await Hive.initFlutter();
  Hive.registerAdapter(TarefaAdapter());
  await Hive.openBox<Tarefa>('tarefas');
  await Hive.openBox<Tarefa>('historico_tarefas');
  runApp(const Plan7App());
}

class Plan7App extends StatelessWidget {
  const Plan7App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plan7',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Tarefa> tarefasBox;
  late Box<Tarefa> historicoBox;

  @override
  void initState() {
    super.initState();
    tarefasBox = Hive.box<Tarefa>('tarefas');
    historicoBox = Hive.box<Tarefa>('historico_tarefas');
  }

  int getSemanaDoAno() {
    final now = DateTime.now();
    final beginningOfYear = DateTime(now.year, 1, 1);
    final daysPassed = now.difference(beginningOfYear).inDays;
    return ((daysPassed + beginningOfYear.weekday) / 7).ceil();
  }

  DateTime getInicioDaSemana(DateTime data) {
    return data.subtract(Duration(days: data.weekday - 1));
  }

  DateTime getFimDaSemana(DateTime data) {
    return data.add(Duration(days: DateTime.sunday - data.weekday));
  }

  String getIntervaloSemana() {
    final hoje = DateTime.now();
    final inicio = getInicioDaSemana(hoje);
    final fim = getFimDaSemana(hoje);
    final inicioFormatado = DateFormat("EEEE, d", "pt_BR").format(inicio);
    final fimFormatado = DateFormat("EEEE, d", "pt_BR").format(fim);
    return '$inicioFormatado à $fimFormatado';
  }

  void mostrarDialogo(Tarefa tarefa, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('O que deseja fazer?'),
        actions: [
          TextButton(
            onPressed: () {
              final novaTarefa = Tarefa(
                titulo: tarefa.titulo,
                lembreteAtivo: tarefa.lembreteAtivo,
                data: tarefa.data,
                hora: tarefa.hora,
                concluida: tarefa.concluida,
                dataConclusao: DateTime.now(),
                subTarefas: tarefa.subTarefas,
              );
              historicoBox.add(novaTarefa);
              tarefasBox.deleteAt(index);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Salvar'),
          ),
          TextButton(
            onPressed: () {
              tarefasBox.deleteAt(index);
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Excluir'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _editarTarefa(tarefa, index);
            },
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  void _editarTarefa(Tarefa tarefa, int index) {
    final controller = TextEditingController(text: tarefa.titulo);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Tarefa'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              tarefa.titulo = controller.text;
              tarefa.save();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void adicionarTarefa(Tarefa tarefa) {
    tarefasBox.add(tarefa);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final semana = getSemanaDoAno();
    final intervalo = getIntervaloSemana();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan7'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico de Tarefas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoricoPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cronograma Semanal', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('Semana $semana', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            Text(intervalo, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: tarefasBox.listenable(),
                builder: (context, Box<Tarefa> box, _) {
                  final tarefas = box.values.toList();
                  if (tarefas.isEmpty) {
                    return const Center(child: Text('Nenhuma tarefa adicionada.'));
                  }
                  return PageView.builder(
                    controller: PageController(viewportFraction: 0.8),
                    itemCount: tarefas.length,
                    itemBuilder: (context, index) {
                      final tarefa = tarefas[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Material(
                          elevation: 3,
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tarefa.titulo,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: tarefa.subTarefas.length,
                                    itemBuilder: (context, i) {
                                      final subtarefa = tarefa.subTarefas[i];
                                      return CheckboxListTile(
                                        value: subtarefa['concluida'] ?? false,
                                        onChanged: (value) {
                                          setState(() {
                                            subtarefa['concluida'] = value;
                                            tarefa.save();
                                          });
                                        },
                                        title: Text(subtarefa['titulo'] ?? ''),
                                        controlAffinity: ListTileControlAffinity.leading,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novaTarefa = await Navigator.push<Tarefa>(
            context,
            MaterialPageRoute(builder: (context) => const NovaTarefaPage()),
          );
          if (novaTarefa != null) {
            adicionarTarefa(novaTarefa);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NovaTarefaPage extends StatefulWidget {
  const NovaTarefaPage({super.key});

  @override
  State<NovaTarefaPage> createState() => _NovaTarefaPageState();
}

class _NovaTarefaPageState extends State<NovaTarefaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tarefaController = TextEditingController();
  final List<Map<String, dynamic>> _subTarefas = [];

  void _adicionarSubTarefa() async {
    final controller = TextEditingController();
    final resultado = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Sub-Tarefa'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Digite a sub-tarefa'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );

    if (resultado != null && resultado.trim().isNotEmpty) {
      setState(() {
        _subTarefas.add({'titulo': resultado.trim(), 'concluida': false});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _tarefaController,
                decoration: const InputDecoration(labelText: 'Título da tarefa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite a tarefa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sub-tarefas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: _adicionarSubTarefa,
                    icon: const Icon(Icons.add_box_rounded),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _subTarefas.length,
                  itemBuilder: (context, index) {
                    final subtarefa = _subTarefas[index];
                    return CheckboxListTile(
                      value: subtarefa['concluida'],
                      onChanged: (value) {
                        setState(() {
                          subtarefa['concluida'] = value;
                        });
                      },
                      title: Text(subtarefa['titulo']),
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final tarefa = Tarefa(
                        titulo: _tarefaController.text,
                        subTarefas: _subTarefas,
                      );
                      Navigator.pop(context, tarefa);
                    }
                  },
                  child: const Text('Salvar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HistoricoPage extends StatelessWidget {
  const HistoricoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historicoBox = Hive.box<Tarefa>('historico_tarefas');

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Tarefas')),
      body: ValueListenableBuilder(
        valueListenable: historicoBox.listenable(),
        builder: (context, Box<Tarefa> box, _) {
          final historico = box.values.toList();
          if (historico.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa no histórico.'));
          }
          return ListView.builder(
            itemCount: historico.length,
            itemBuilder: (context, index) {
              final tarefa = historico[index];
              final data = tarefa.dataConclusao != null
                  ? DateFormat('dd/MM/yyyy').format(tarefa.dataConclusao!)
                  : 'Data não registrada';
              return ListTile(
                title: Text(
                  '${tarefa.titulo} — salvo em: $data',
                  style: const TextStyle(decoration: TextDecoration.lineThrough),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
