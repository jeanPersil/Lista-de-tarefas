import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/Widgets/lista_de_tarefas.dart';
import 'package:lista_de_tarefas/models/todo.dart';

class ListPage extends StatefulWidget {
  ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Tarefa> tarefas = [];
  Tarefa? tarefaDeletada;
  int? indice_da_tarefaDeletada;

  final TextEditingController controlarTarefas = TextEditingController();

  void onDelete(Tarefa tarefa) {
    tarefaDeletada = tarefa;
    indice_da_tarefaDeletada = tarefas.indexOf(tarefa);

    setState(() {
      tarefas.remove(tarefa);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: const Text(
          'Tarefa removida com sucesso!',
          style: TextStyle(color: Colors.black),
        ),
        action: SnackBarAction(
            backgroundColor: Colors.white,
            label: 'Desfazer',
            textColor: const Color(0xff08cdc7),
            onPressed: () {
              setState(() {
                tarefas.insert(indice_da_tarefaDeletada!, tarefaDeletada!);
              });
            }),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void mostrar_Confirmacao_Para_excluirTudo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar tudo?'),
        content: const Text('Você tem certeza que deseja excluir todas as tarefas?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.blue),
              )),
          TextButton(
            onPressed: () {
              setState(() {
                tarefas.clear();
                Navigator.of(context).pop();
              });
            },
            child: const Text(
              'Limpar tudo',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: controlarTarefas,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Adicione uma tarefa',
                        hintText: 'Estudar flutter'),
                  )),
                  const SizedBox(width: 15),
                  ElevatedButton(
                      onPressed: () {
                        Tarefa novaTarefa = Tarefa(
                            tarefaNome: controlarTarefas.text,
                            DataHorario: DateTime.now());
                        setState(() {
                          tarefas.add(novaTarefa);
                        });

                        controlarTarefas.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff08cdc7),
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ))
                ],
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Tarefa tarefa in tarefas)
                      ListaDeTarefas(
                        tarefa: tarefa,
                        onDelete: onDelete,
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child:
                        Text('Você possui ${tarefas.length} tarefas pendentes'),
                  ),
                  ElevatedButton(
                      onPressed: mostrar_Confirmacao_Para_excluirTudo,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff08cdc7)),
                      child: const Text(
                        'Limpar tudo',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
