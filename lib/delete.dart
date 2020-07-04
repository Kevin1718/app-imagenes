import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'students.dart';
import 'crud_operations.dart';
import 'dart:async';

class delete extends StatefulWidget {
  @override
  _mydata createState() => new _mydata();
}

class _mydata extends State<delete> {

  Future<List<Student>> Studentss;
  TextEditingController contr1 = TextEditingController();
  TextEditingController contr2 = TextEditingController();
  TextEditingController contr3 = TextEditingController();
  TextEditingController contr4 = TextEditingController();
  TextEditingController contr5 = TextEditingController();
  TextEditingController contr6 = TextEditingController();
  String name;
  String surname;
  String lastname;
  String mail;
  String tel;
  String matri;
  int currentUserId;
  var bdHelper;
  bool isUpdating;
  final _scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    bdHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = bdHelper.getStudents();
    });
  }

  void cleanData() {
    contr1.text = "";
    contr2.text = "";
    contr3.text = "";
    contr4.text = "";
    contr5.text = "";
    contr6.text = "";
  }

  void guardar() {
    setState(() {
      _snack(context, "Datos eliminados!");
    });
  }

  //Mostrar datos
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text("Borrar")),
          DataColumn(
            label: Text("Nombre"),
          ),
          DataColumn(
            label: Text("Primer apellido"),
          ),
          DataColumn(
            label: Text("Segundo apellido"),
          ),
          DataColumn(
            label: Text("Numero de control"),
          ),
          DataColumn(
            label: Text("correo electronico"),
          ),
          DataColumn(
            label: Text("Numero de telefono"),
          ),
        ],
        rows: Studentss.map((student) => DataRow(cells: [
          DataCell(IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () { bdHelper.delete(student.controlum);
              refreshList();
            },
          )),
          DataCell(
            Text(student.name.toString().toUpperCase()),
            onTap: () {
              setState(() { isUpdating = true;
                currentUserId = student.controlum;
              });
              contr1.text = student.name;
            },
          ),
          DataCell(Text(student.surname.toString().toUpperCase())),
          DataCell(Text(student.lastname.toString().toUpperCase())),
          DataCell(Text(student.matri.toString().toUpperCase())),
          DataCell(Text(student.mail.toString().toUpperCase())),
          DataCell(Text(student.tel.toString().toUpperCase())),
        ])).toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,

        builder: (context, snapshot) {
          if (snapshot.hasData) { return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("Not data founded");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  final formkey = new GlobalKey<FormState>();

  _snack(BuildContext context, String texto) {
    final snackbar = SnackBar(
      content: new Text(texto),
      backgroundColor: Colors.greenAccent,
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      appBar: new AppBar(
        title: Text("Eliminar"),
        centerTitle: true, backgroundColor: Colors.greenAccent,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            list(),
          ],
        ),
      ),
    );
  }
}
