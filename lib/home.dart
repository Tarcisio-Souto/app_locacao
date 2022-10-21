import 'package:app_locacao/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Home',
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
        ],
      ),
    );
  }

  Future<bool> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    return true;
  }



}
