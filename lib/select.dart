import 'crud_operations.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'students.dart';


class select extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<select> {
  Future<List<Student>> Studentss;
  TextEditingController contr1 = TextEditingController();
  TextEditingController contr2 = TextEditingController();
  TextEditingController contr3 = TextEditingController();
  TextEditingController contr4 = TextEditingController();
  TextEditingController contr5 = TextEditingController();
  TextEditingController contr6 = TextEditingController();
  TextEditingController contrsearch = TextEditingController();
  String name;
  String surname;
  String lastname;
  String mail;
  String tel;
  String matri;
  int currentUserId;
  String valor;
  int opcion;

  final formkey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = dbHelper.select(contrsearch.text);
    });
  }
  void cleanData() {
    contrsearch.text = "";
  }

  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn( label: Text("Nombre"),
          ),
          DataColumn( label: Text("Primer apellido"),
          ),
          DataColumn( label: Text("Segundo apellido"),
          ),
          DataColumn( label: Text("Numero de control"),
          ),
          DataColumn( label: Text("Correo electronico"),
          ),
          DataColumn( label: Text("Telefono"),
          ),
        ],
        rows: Studentss.map((student) => DataRow(cells: [

          DataCell(Text(student.name.toString().toUpperCase()), onTap: () {
            setState(() { isUpdating = true;
              currentUserId = student.controlum;
            });
            contr1.text = student.name;
          }),

          DataCell(Text(student.lastname.toString().toUpperCase()),
              onTap: () {
                setState(() { isUpdating = true;
                  currentUserId = student.controlum;
                });
                contr2.text = student.lastname;
              }),


          DataCell(Text(student.surname.toString().toUpperCase()), onTap: () {
            setState(() { isUpdating = true;
              currentUserId = student.controlum;
            });
            contr3.text = student.surname;
          }),

          DataCell(Text(student.matri.toString().toUpperCase()), onTap: () {
            setState(() { isUpdating = true;
              currentUserId = student.controlum;
            });
            contr6.text = student.matri;
          }),
          DataCell(Text(student.mail.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true; currentUserId = student.controlum;
            });
            contr4.text = student.mail;
          }),
          DataCell(Text(student.tel.toString().toUpperCase()), onTap: () {
            setState(() {
              isUpdating = true; currentUserId = student.controlum;
            });
            contr5.text = student.tel;
          }),
        ])).toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: FutureBuilder(
        future: Studentss,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Text("No data");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return new Scaffold(//new line
      appBar: new AppBar(
        title: isUpdating ? TextField(
            autofocus: true,
            controller: contrsearch,
            onChanged: (text){ refreshList();
            })
            : Text("Buscar alumnos"),
        leading: IconButton(
          icon: Icon(isUpdating ? Icons.done: Icons.search),
          onPressed: (){
            print("Is typing"+ isUpdating.toString());
            setState(() { isUpdating = !isUpdating;
              contrsearch.text = "";
            });
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
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