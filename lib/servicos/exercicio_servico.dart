import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lista_de_tarefas/models/todo.dart';

class TarefaServico {
  String userID;

  TarefaServico() : userID = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarTarefa(Tarefa tarefa) async {
    await _firestore.collection(userID).doc(tarefa.id).set(tarefa.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>  conectarStreamTarefas() {
    return _firestore.collection(userID).snapshots();
  }
}
