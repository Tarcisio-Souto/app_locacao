import 'package:app_locacao/home.dart';
import 'package:app_locacao/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    verificarToken().then((value) {
      if (value){
        Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (context) => Home()
          ),
        );
      } else {
        Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (context) => Login()
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<bool> verificarToken() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('access_token') != null) {
      return true;
    } else {
      return false;
    }



  }




}
