import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Loans.dart';
import 'variables.dart';

class Services {
  static const ROOT = 'http://192.168.1.4:8001/api/list-loans-user';
  //static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_ALL_ACTION = 'GET_ALL';
  //static const _ADD_EMP_ACTION = 'ADD_EMP';
  //static const _UPDATE_EMP_ACTION = 'UPDATE_EMP';
  //static const _DELETE_EMP_ACTION = 'DELETE_EMP';


  static Future<List<Loans>> getLoans() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      //final response = await http.get(Uri.parse(ROOT));

      var url = Uri.parse('http://192.168.1.4:8001/api/list-loans-user');
      final response = await http.post(url,
          body: {
            'id': idUserLogged
          }
      );

      print('getLoans Response: ${response.body}');
      print(response.statusCode);
      print(200 == response.statusCode);
      if (200 == response.statusCode) {
        List<Loans> list = parseResponse(response.body);
        print(list.length);
        return list;
      } else {
        return <Loans>[];
      }
    } catch (e) {
      return <Loans>[];
    }
  }

  static List<Loans> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody);
    print(parsed);
    return parsed.map<Loans>((json) => Loans.fromJson(json)).toList();
  }
}