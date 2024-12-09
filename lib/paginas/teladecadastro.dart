import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/paginas/login.dart';
import 'package:lista_de_tarefas/servicos/autenticacao_servicos.dart';

class Telacadastro extends StatefulWidget {
  const Telacadastro({super.key});
  @override
  _TelacadastroState createState() => _TelacadastroState();
}

class _TelacadastroState extends State<Telacadastro> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  AutenticacaoServicos _autenticacaoServicos = AutenticacaoServicos();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                height: 500,
                width: 600,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cadastrar',
                        style: TextStyle(
                            fontSize: 30,
                            color: Color(0xff08cdc7),
                            fontWeight: FontWeight.w500),
                      ),
                      Flexible(
                          child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Usuario",
                          hintText: "Fulano De tal",
                        ),
                      )),
                      SizedBox(height: 15),
                      Flexible(
                          child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "E-mail",
                          hintText: "emailexemplo@gmail.com",
                        ),
                      )),
                      SizedBox(height: 15),
                      Flexible(
                          child: TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Senha",
                        ),
                      )),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          _autenticacaoServicos
                              .cadastrarUsuarios(
                                  nome: _nameController.text,
                                  senha: _passwordController.text,
                                  email: _emailController.text)
                              .then((value) {
                            if (value != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(value)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(value),
                                ),
                              );
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff08cdc7)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.app_registration,
                              color: Colors.white,
                            ),
                            Text(
                              'Registrar',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Já tem uma conta?'),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => telaDelogin()),
                              );
                            },
                            child: Text(
                              "Entrar",
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
      ),
    );
  }
}
