import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/Widgets/lista_de_tarefas.dart';
import 'package:lista_de_tarefas/models/todo.dart';
import 'package:lista_de_tarefas/paginas/login.dart';

import 'package:lista_de_tarefas/servicos/autenticacao_servicos.dart';
import 'package:lista_de_tarefas/servicos/exercicio_servico.dart';
import 'package:uuid/uuid.dart';

class ListPage extends StatefulWidget {
  ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Tarefa> tarefas = [];
  Tarefa? tarefaDeletada;
  int? indice_da_tarefaDeletada;
  AutenticacaoServicos _autenticacaoServicos = AutenticacaoServicos();

  String? mensagem_de_erro;

  TarefaServico _tarefaServico = TarefaServico();
  TarefaServico tarefa = TarefaServico();

  final TextEditingController controlarTarefas = TextEditingController();

  void onDelete(Tarefa tarefa) async {
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
        appBar: AppBar(),
        backgroundColor: Colors.white,
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Deslogar'),
                  onTap: () => {
                        _autenticacaoServicos.deslogar(),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => telaDelogin()),
                        )
                      })
            ],
          ),
        ),
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
                      onPressed: () async {
                        if (controlarTarefas.text.isEmpty) {
                          setState(() {
                            mensagem_de_erro = 'Por favor, adicione uma tarefa';
                          });
                          return;
                        }
                        Tarefa novaTarefa = Tarefa(
                          id: const Uuid().v1(),
                          tarefaNome: controlarTarefas.text,
                          dataHorario: DateTime.now(),
                        );

                        await _tarefaServico.adicionarTarefa(novaTarefa);

                        setState(() {
                          tarefas.add(novaTarefa);
                        });

                        mensagem_de_erro = null;
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
                  child: StreamBuilder(
                stream: tarefa.conectarStreamTarefas(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.docs.isNotEmpty) {
                      List<Tarefa> novasTarefas = [];
                      for (var doc in snapshot.data!.docs) {
                        novasTarefas.add(Tarefa.fromMap(doc.data()));
                      }
                      return ListView(
                        shrinkWrap: true,
                        children: [
                          for (Tarefa tarefa in novasTarefas)
                            ListaDeTarefas(
                              tarefa: tarefa,
                              onDelete: onDelete,
                            ),
                          const SizedBox(height: 16),
                        ],
                      );
                    } else {
                      return const Center(
                          child: Text('Adicione uma tarefa...'));
                    }
                  }
                },
              )),
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
