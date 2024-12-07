import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/Widgets/lista_de_tarefas.dart';
import 'package:lista_de_tarefas/models/todo.dart';
import 'package:lista_de_tarefas/repositories/repositorio_tarefa.dart';

class ListPage extends StatefulWidget {
  ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Tarefa> tarefas = [];
  Tarefa? tarefaDeletada;
  int? indice_da_tarefaDeletada;

  String? mensagem_de_erro;

  final TextEditingController controlarTarefas = TextEditingController();
  final TarefaRepositorio tarefaRepositorio = TarefaRepositorio();

  @override
  void initState() {
    super.initState();

    tarefaRepositorio.ler_lista_de_tarefas().then((value) {
      setState(() {
        tarefas = value;
      });
    });
  }

  void onDelete(Tarefa tarefa) {
    tarefaDeletada = tarefa;
    indice_da_tarefaDeletada = tarefas.indexOf(tarefa);

    setState(() {
      tarefas.remove(tarefa);
    });
    tarefaRepositorio.salvar_lista_de_tarefas(tarefas);
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
              tarefaRepositorio.salvar_lista_de_tarefas(tarefas);
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
        content:
            const Text('Você tem certeza que deseja excluir todas as tarefas?'),
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
              tarefaRepositorio.salvar_lista_de_tarefas(tarefas);
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
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Adicione uma tarefa',
                      hintText: 'Estudar flutter',
                      errorText: mensagem_de_erro,
                    ),
                  )),
                  const SizedBox(width: 15),
                  ElevatedButton(
                      onPressed: () {
                        if (controlarTarefas.text.isEmpty) {
                          setState(() {
                            mensagem_de_erro = 'Por favor, adicione uma tarefa';
                          });
                          return;
                        }
                        Tarefa novaTarefa = Tarefa(
                            tarefaNome: controlarTarefas.text,
                            dataHorario: DateTime.now());
                        setState(() {
                          tarefas.add(novaTarefa);
                        });
                        mensagem_de_erro = null;
                        controlarTarefas.clear();
                        tarefaRepositorio.salvar_lista_de_tarefas(tarefas);
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
