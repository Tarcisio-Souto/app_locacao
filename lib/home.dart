import 'dart:convert';

import 'package:app_locacao/listLoans.old';
import 'package:app_locacao/variables.dart';
import 'package:app_locacao/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:app_locacao/login.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'listLoans.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var getResult = 'QR Code Result';
  var user = userLogged;
  var id = idUserLogged;
  final _formKey = GlobalKey<FormState>();
  var id_asset = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Container(
            width: 200,
            child: Image.asset(
              'assets/images/logo.png',
              width: 200,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white38,
          elevation: 15,
          toolbarHeight: 120,
        ),
        body: Align(

          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.indigo,
                  Colors.blueGrey,
                ],
              ),
            ),

            child: Column(
              children: [
                Container(
                  child: Row /*or Row*/(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(),
                      Container(
                        height: 50,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(25),
                            color: Colors.orangeAccent),
                        child: Text(userLogged,
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                          height: 50,
                          decoration: BoxDecoration(
                            //borderRadius: BorderRadius.circular(25),
                              color: Colors.redAccent),
                          child: IconButton(
                            alignment: Alignment.centerRight,
                            icon: Icon(
                              Icons.exit_to_app,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              bool exited = await logout();
                              if (exited) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Welcome(),
                                  ),
                                );
                              }
                            },
                          )
                      ),
                    ],
                  ),


                ),
                Container(
                    child: Padding(padding: EdgeInsets.symmetric(vertical: 80.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              scanQRCode();
                            },
                            child: Text('Escanear QR-Code do Objeto'),
                          ),
                          SizedBox(height: 20.0),
                          //Text(getResult),
                        ],
                      ),
                    )
                ),
                Container(
                    child: Padding(padding: EdgeInsets.symmetric(vertical: 80.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async{
                              bool loans = await listLoans();
                              if (loans) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DataTableDemo(),
                                  ),
                                );
                              }
                            },
                            child: Text('Lista de Empréstimos'),
                          ),
                          SizedBox(height: 20.0),
                          //Text(getResult),
                        ],
                      ),
                    )
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);

      if (!mounted) return;

      setState(() {
        getResult = qrCode;
        id_asset = qrCode;
      });

      registerLoan();

      getResult = '';
    } on PlatformException {
      getResult = 'Não foi possível ler o QR-Code';
    }
  }

  Future<bool> registerLoan() async {
    var url = Uri.parse('http://192.168.1.4:8001/api/register-loan');
    var resposta = await http.post(url, body: {
      'id': idUserLogged,
      'id_asset': getResult,
    });

    responseCode = jsonDecode(resposta.body)['status'].toString();

    if (responseCode == '200') {
      toast("Empréstimo registrado com sucesso.");
    } else if (responseCode == '400') {
      toast("Este objeto está em uso no momento.");
    } else if (responseCode == '404') {
      toast("Este objeto não está registrado ou o QR-Code é inválido.");
    }

    if (resposta.statusCode == 200) {
      //await sharedPreferences.setString('message', jsonDecode(resposta.body)['message']);
      print(jsonDecode(resposta.body)['message']);
      print('');
      print('STATUS: ' + jsonDecode(resposta.body)['status'].toString());
      return true;
    } else {
      print(jsonDecode(resposta.body));
      print('');
      print('alguma coisa deu errado aqui');
      return false;
    }
  }

  Future<bool?> toast(String message) {
    Fluttertoast.cancel();

    if (responseCode == '200') {
      return Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 15.0);
    } else {
      return Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 15.0);
    }
  }

  Future<bool> listLoans() async {
    return true;
  }

  Future<bool> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    return true;
  }
}
