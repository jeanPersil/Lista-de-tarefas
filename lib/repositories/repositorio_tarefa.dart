import 'package:lista_de_tarefas/models/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const chave_da_lista = 'Lista de tarefas';

class TarefaRepositorio {
  TarefaRepositorio() {
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
      print(sharedPreferences.getString('Lista de tarefas'));
    });
  }

  late SharedPreferences sharedPreferences;

  Future<List<Tarefa>> ler_lista_de_tarefas() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String toJason = sharedPreferences.getString(chave_da_lista) ?? '[]';
    final List jsonDecoder = jsonDecode(toJason);
    return jsonDecoder.map((e) => Tarefa.fromJson(e)).toList();
  }

  void salvar_lista_de_tarefas(List<Tarefa> tarefa) {
    final toJason = json.encode(tarefa);
    print(toJason);
    sharedPreferences.setString(chave_da_lista, toJason);
  }
}
