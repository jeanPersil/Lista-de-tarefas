class Tarefa {
  Tarefa(
      {required this.tarefaNome, required this.dataHorario, required this.id});

  String id;
  String tarefaNome;
  DateTime dataHorario;

  Tarefa.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        tarefaNome = map['tarefaNome'],
        dataHorario = DateTime.parse(map['dataHorario']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tarefaNome': tarefaNome,
      'dataHorario': dataHorario.toIso8601String(),
    };
  }
}
