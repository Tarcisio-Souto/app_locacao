import 'dart:convert';
import 'dart:ffi';

import 'package:app_locacao/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  /*late AnimationController _controller;*/

  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    /*_controller = AnimationController(vsync: this);*/
  }

  @override
  void dispose() {
    /*_controller.dispose();*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'CPF',
                  ),
                  controller: _cpfController,
                  keyboardType: TextInputType.text,
                  validator: (cpf) {
                    if (cpf == null || cpf.isEmpty) {
                      return 'O campo CPF não pode estar vazio';
                    }
                    return null;
                  }
                ),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Senha',
                    ),
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (password){
                    if (password == null || password.isEmpty) {
                      return 'O campo senha não pode estar vazio';
                    }
                    return null;
                  }
                ),
                ElevatedButton(
                  onPressed: () async{
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (_formKey.currentState!.validate()){
                      bool correct = await login();
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      if (correct) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(),
                        ));
                      } else {
                        _passwordController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      }
                    }
                  },
                  child: Text('ENTRAR'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final snackBar = SnackBar(content: Text(
    'CPF ou senha inválido',
    textAlign: TextAlign.center,
  ),
    backgroundColor: Colors.redAccent ,
  );

  Future<bool> login() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse('http://192.168.1.4:8001/api/auth');
    var resposta = await http.post(url,
      body: {
        'cpf': _cpfController.text,
        'senha': _passwordController.text
      }
    );
    if(resposta.statusCode == 200) {
      await sharedPreferences.setString('access_token', jsonDecode(resposta.body)['access_token']);
      print(jsonDecode(resposta.body)['access_token']);
      return true;
    } else {
      print(jsonDecode(resposta.body));
      return false;
    }
  }


}
