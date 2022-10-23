import 'package:app_locacao/variables.dart';
import 'package:app_locacao/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:app_locacao/login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  var getResult = 'QR Code Result';
  var user = userLogged;
  var id = idUserLogged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                  scanQRCode();
              },
                child: Text('Scan QR'),
              ),
              SizedBox(height: 20.0),
              Text(getResult),
            ],
          ),
          Text(userLogged,
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () async{
              bool exited = await logout();
              if (exited) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Welcome(),),);
              }
            },
            child: Text('Sair'),
          )
        ]
      ),
    );
  }

  void scanQRCode() async {
    try{
      final qrCode = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.BARCODE);

      if (!mounted) return;

      setState(() {
        getResult = qrCode;
      });
      print('QRCode_Result:--');
      print(qrCode);
    } on PlatformException {
      getResult = 'Failed to scan QR Code';
    }

  }

  Future<bool> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    return true;
  }



}
