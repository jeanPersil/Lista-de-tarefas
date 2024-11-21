import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/paginas/listpage.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ListPage());
  }
}
