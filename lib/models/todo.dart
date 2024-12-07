class Tarefa {
  Tarefa({required this.tarefaNome, required this.dataHorario});

  Tarefa.fromJson(Map<String, dynamic> json)
      : tarefaNome = json['tarefaNome'] ?? '',
        dataHorario = json['DataHorario'] != null
            ? DateTime.parse(json['DataHorario'])
            : DateTime.now();

  String tarefaNome;
  DateTime dataHorario;

  Map<String, dynamic> toJson() {
    return {
      'tarefaNome': tarefaNome,
      'dataHorario': dataHorario.toIso8601String(),
    };
  }
}
