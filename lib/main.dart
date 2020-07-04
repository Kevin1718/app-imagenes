import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'convertidor.dart';
import 'students.dart';
import 'crud_operations.dart';
import 'dart:async';
import 'delete.dart';
import 'consultar.dart';
import 'select.dart';
import 'insert.dart';
import 'update.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
      ThemeData(brightness: Brightness.light, primarySwatch: Colors.green),
      darkTheme: ThemeData( brightness: Brightness.dark, primarySwatch: Colors.blue),
      home: homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<homePage> {
  Future<List<Student>> Studentss;
  TextEditingController contr1 = TextEditingController();
  TextEditingController contr3 = TextEditingController();
  TextEditingController contr4 = TextEditingController();
  TextEditingController contr5 = TextEditingController();
  TextEditingController contr6 = TextEditingController();
  TextEditingController contr7 = TextEditingController();
  String name;
  String surname;
  String lastname;
  String mail;
  String tel;
  String matri;
  String namefoto;
  int currentUserId;
  var bdHelper;
  bool isUpdating;
  final _scaffoldkey=GlobalKey<ScaffoldState>();

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
    contr3.text = "";
    contr4.text = "";
    contr5.text = "";
    contr6.text = "";
    contr7.text = "";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Center(
                child: Text( "Menu",
                  style: TextStyle(color: Colors.black, fontSize: 23),
                ),
              ),
              decoration: BoxDecoration(color: Colors.greenAccent),
            ),
            ListTile(
              leading: Icon(Icons.plus_one),
              title: Text('INSERTAR'), onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => insertar()));
            },

            ),
            ListTile(
              leading: Icon(Icons.system_update),
              title: Text('ACTUALIZAR'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Update()));
              },
            ),
            ListTile(
              leading: Icon(Icons.youtube_searched_for),
              title: Text('BUSQUEDA'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => select()));
              },
            ),

            ListTile(
              leading: Icon(Icons.location_searching),
              title: Text('CONSULTAR'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Consultar()));
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_sweep),
              title: Text('DELETE'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => delete()));
              },
            ),
          ],
        ),
      ),
      key: _scaffoldkey,
      appBar: new AppBar(
        title: Text("Basic SQL operations"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,

        leading: IconButton(
          icon: Icon(Icons.system_update_alt),
          onPressed: (){
            setState(() {
              refreshList();
            });
          },
        ),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[ list(),
          ],
        ),
      ),
    );
  }
  SingleChildScrollView dataTable(List<Student> Studentss) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
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
            label: Text("Correo electronico"),
          ),
          DataColumn(
            label: Text("Numero de telefono"),
          ),
          //DataColumn(
            //label: Text("Fotografia"),
          //)
        ],
        rows: Studentss.map((student) => DataRow(cells: [
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
          //DataCell(Convertir.imageFromBase64String(student.namefoto)),
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
          if (snapshot.data == null || snapshot.data.length < 1) {
            return Text("Not data founded");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }


  _snack(BuildContext context, String texto) {
    final snackbar = SnackBar(
      content: new Text(texto), backgroundColor: Colors.greenAccent,
    );
    _scaffoldkey.currentState.showSnackBar(snackbar);
  }
}