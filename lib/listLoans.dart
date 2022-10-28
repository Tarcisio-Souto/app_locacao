import 'dart:convert';

import 'package:app_locacao/variables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(SimpleDataTable());

class SimpleDataTable extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // MaterialApp with debugShowCheckedModeBanner false and home
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        // Scaffold with appbar ans body.
        appBar: AppBar(
          title: Text('Simple Data Table'),
        ),
        body:
        SingleChildScrollView(

          /*child: Container(
              child: Padding(padding: EdgeInsets.symmetric(vertical: 80.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async{
                        bool loans = await listLoansUser();
                        if (loans) {
                          //listLoansUser();
                        }
                      },
                      child: Text('Lista de Empréstimos'),
                    ),
                    SizedBox(height: 20.0),
                    //Text(getResult),
                  ],
                ),
              )

          ),*/

          scrollDirection: Axis.horizontal,
          child: DataTable(
            // Datatable widget that have the property columns and rows.
              columns: [
                // Set the name of the column
                DataColumn(label: Text('Objeto'),),
                DataColumn(label: Text('Patrimônio'),),
                DataColumn(label: Text('Status'),),
                DataColumn(label: Text('Data Locação'),),
                DataColumn(label: Text('Data Devolução'),),
              ],
              rows:[

                // Set the values to the columns
                /*DataRow(cells: [
                  DataCell(Text("1")),
                  DataCell(Text("Alex")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("18")),
                  DataCell(Text("")),
                ]),
                DataRow(cells: [
                  DataCell(Text("2")),
                  DataCell(Text("John")),
                  DataCell(Text("Anderson")),
                  DataCell(Text("24")),
                  DataCell(Text("")),
                ]),*/
              ]
          ),
        ),
      ),
    );
  }
}


void listLoansUser() async {
  var listLoansUser;
  var url = Uri.parse('http://192.168.1.4:8001/api/list-loans-user');
  var resposta = await http.post(url,
      body: {
        'id': idUserLogged
      }
  );
  if(resposta.statusCode == 200) {
    listLoansUser = jsonDecode(resposta.body)['loans'];
    print(jsonDecode(resposta.body));
    return listLoansUser;
  }
}