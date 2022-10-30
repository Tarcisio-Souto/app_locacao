import 'package:app_locacao/home.dart';
import 'package:flutter/material.dart';
import 'Loans.dart';
import 'Services.dart';

class DataTableDemo extends StatefulWidget {
  DataTableDemo() : super();

  final String title = "Flutter Laravel CRUD";

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  late List<Loans> _loans;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late Loans _selectedLoans;
  late bool _isUpdating;
  late String _titleProgress;

  @override
  void initState() {
    super.initState();
    _loans = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _getLoans();
  }

  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }


  _getLoans() {
    _showProgress('Loading Loans...');
    Services.getLoans().then((loans) {
      setState(() {
        _loans = loans;
      });
      _showProgress(widget.title);
      print("Length: ${loans.length}");
    });
  }

  SingleChildScrollView _dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          dataTextStyle: TextStyle(color: Colors.black),
          headingRowColor: MaterialStateColor.resolveWith((states) => Colors.indigo),
          headingTextStyle: TextStyle(fontWeight:FontWeight.bold, color: Colors.white) ,
          dataRowColor: MaterialStateColor.resolveWith((Set<MaterialState> states) => states.contains(MaterialState.selected)
              ? Colors.white
              : Colors.white
          ),
          columns: [
            DataColumn(
              label: Text("Nº Patrimônio"),
              numeric: false,),
            DataColumn(
                label: Text(
                  "Objeto",
                ),
                numeric: false),
            DataColumn(
                label: Text("Status"),
                numeric: false),
            DataColumn(
                label: Text("Data do Empréstimo"),
                numeric: false),
            DataColumn(
                label: Text("Data da Devolução"),
                numeric: false),
          ],
          rows: _loans.map(
                (loans) =>
                DataRow(
                  cells: [
                    DataCell(
                      Text(loans.pat_number,
                      ),
                    ),
                    DataCell(
                      Text(
                        loans.asset_name,
                      ),
                    ),
                    DataCell(
                      Text(
                        loans.lo_status,
                      ),
                    ),
                    DataCell(
                      Text(
                        loans.dt_loan,
                      ),
                    ),
                    DataCell(
                      Text(
                        loans.dt_devolution,
                      ),
                    ),
                  ],
                ),
          ).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
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
                        child: Text("Lista de Empréstimos",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(25),
                            color: Colors.blue),
                        child: IconButton(
                          alignment: Alignment.centerRight,
                          icon: Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            bool exited = await goHome();
                            if (exited) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Home(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(

              child: _dataBody(),
            )
            /*Padding(
                padding: EdgeInsets.all(16.0),,
                child: Expanded(
                  child: _dataBody(),
                )
            )*/

          ],
        ),
      ),
    );
  }

  Future<bool> goHome() async {
    return true;
  }


}
