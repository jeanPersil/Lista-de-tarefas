import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/paginas/listpage.dart';
import 'package:lista_de_tarefas/paginas/teladecadastro.dart';
import 'package:lista_de_tarefas/servicos/autenticacao_servicos.dart';

class telaDelogin extends StatefulWidget {
  const telaDelogin({super.key});

  @override
  State<telaDelogin> createState() => _telaDeloginState();
}

class _telaDeloginState extends State<telaDelogin> {
  TextEditingController _emailUsuario = TextEditingController();
  TextEditingController _senhaUsuario = TextEditingController();
  AutenticacaoServicos logar_usuario = AutenticacaoServicos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              height: 500,
              width: 600,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Seja bem vindo(a)',
                      style: TextStyle(
                          fontSize: 30,
                          color: Color(0xff08cdc7),
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 15),
                    Flexible(
                        child: TextField(
                      controller: _emailUsuario,
                      decoration: InputDecoration(
                        labelText: "E-mail",
                        hintText: "emailexemplo@gmail.com",
                      ),
                    )),
                    const SizedBox(height: 15),
                    Flexible(
                        child: TextField(
                      controller: _senhaUsuario,
                      decoration: InputDecoration(
                        labelText: "Senha",
                      ),
                    )),
                    const SizedBox(height: 15),
                    TextButton(
                        onPressed: () {
                          logar_usuario
                              .logar_usuario(
                                  email: _emailUsuario.text,
                                  senha: _senhaUsuario.text)
                              .then((value) {
                            if (value != null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(content: Text(value)));
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListPage()),
                              );
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xff08cdc7)),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )),
                    const SizedBox(height: 15),
                    const Text('OU'),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        "Login com o google",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Não tem uma conta?'),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const Telacadastro()),
                            );
                          },
                          child: const Text(
                            "Cadastrar",
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
