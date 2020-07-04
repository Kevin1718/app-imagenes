import 'dart:async';
import 'crud_operations.dart';
import 'package:flutter/material.dart';
import 'convertidor.dart';
import 'package:image_picker/image_picker.dart';
import 'students.dart';

class Update extends StatefulWidget {
  @override
  _myHomePageState createState() => new _myHomePageState();
}

class _myHomePageState extends State<Update> {

  Future<List<Student>> Studentss;
  TextEditingController contr = TextEditingController();
  TextEditingController contrP = TextEditingController();

  String valor;
  String name;
  String namefoto;
  String surname;
  String lastname;
  String mail;
  String tel;
  String matri;
  int opcion;
  int currentUserId;
  String descriptive_text = "Student Name";

  final formkey = new GlobalKey<FormState>();
  var dbHelper;
  bool isUpdating;
  bool change;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    change = true;
    refreshList();
  }

  void refreshList() {
    setState(() {
      Studentss = dbHelper.getStudents();
    });
  }

  void cleanData() {
    contr.text = "";
    contrP.text="";
  }

  void updateData(){
    print("Opcion");
    print(opcion);
    if (formkey.currentState.validate()) {
      formkey.currentState.save();

      if (opcion==1) {
        Student stu = Student(currentUserId, valor, surname, lastname , matri, mail, tel, namefoto);
        dbHelper.update(stu);
      }
      else if (opcion==2) {
        Student stu = Student(currentUserId, name, valor, surname, matri, mail, tel, namefoto);
        dbHelper.update(stu);
      }
      else if (opcion==3) {
        Student stu = Student(currentUserId, name, lastname, valor, matri, mail, tel, namefoto);
        dbHelper.update(stu);
      }
      else if (opcion==4) {
        Student stu = Student(currentUserId,name, surname, lastname, valor, mail, tel, namefoto);
        dbHelper.update(stu);
      }
      else if (opcion==5) {
        Student stu = Student(currentUserId,name, surname, lastname, matri, valor, tel, namefoto);
        dbHelper.update(stu);
      }
      else if (opcion==6) {
        Student stu = Student(currentUserId, name, surname, lastname, matri, mail, valor, namefoto);
        dbHelper.update(stu);
      }
      else if (opcion==7) {
        Student stu = Student(currentUserId, name, surname, lastname, matri, mail, tel,valor);
        dbHelper.update(stu);
      }
      cleanData();
      refreshList();
    }
  }

  void insertData() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      {
        Student stu = Student(null,name, surname, lastname, matri, mail, tel, namefoto);
        dbHelper.insert(stu);
      }
      cleanData();
      refreshList();
    }
  }

  pickImagefromGallery(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      namefoto = imgString;
      Navigator.of(context).pop();
      contrP.text = "ingresada";
      return namefoto;
    });
  }

  pickImagefromCamera(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      namefoto = imgString;
      Navigator.of(context).pop();
      contrP.text = "ingresada";
      return namefoto;
    });
  }


  Future<void> _selectfoto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Elija la imagen", textAlign: TextAlign.center,),
              backgroundColor: Colors.lightGreen,
              content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () { pickImagefromGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10.0),),
                  GestureDetector(
                    child: Text("Camara",),
                    onTap: () { pickImagefromCamera(context );
                    },
                  )
                ]),
              ));
        });
  }


  Widget form() {
    return Form(
      key: formkey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new SizedBox(height: 50.0),
            TextFormField(
              controller: change ? contr : contrP,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: descriptive_text),
              validator: (val) => change == false ? val.length == 0 ? 'Enter Data' : contrP.text != "ingresada"
                  ? "Solo se pueden ingresar fotografias" : null : val.length == 0 ? 'Enter Data' : null,
              onSaved: (val) => change ? valor = contr.text : valor = namefoto,
            ),
            SizedBox(height: 30,),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.greenAccent),
                  ),
                  onPressed: updateData,
                  child: Text('Update Data'),
                ),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.greenAccent),
                  ),
                  onPressed: () {
                    setState(() { isUpdating = false;
                    });
                    cleanData();
                    refreshList();
                  },
                  child: Text("Cancelar"),
                ),
              ],
            )
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
          DataColumn(
            label: Text("Imagen"),
          )
        ],
        rows: Studentss.map((student) =>
            DataRow(cells: [

              DataCell(Text(student.name.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = true;
                  descriptive_text = "Nombre";
                  currentUserId = student.controlum;
                  namefoto = student.namefoto;
                  name = student.name;
                  surname = student.surname;
                  lastname = student.lastname;
                  tel =student.tel;
                  mail = student.mail;
                  matri = student.matri;
                  opcion=1;
                });
                contr.text = student.name;
              }),

              DataCell(Text(student.lastname.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = true;
                  descriptive_text = "Primer apellido";
                  currentUserId = student.controlum;
                  namefoto = student.namefoto;
                  name = student.name;
                  surname = student.surname;
                  lastname = student.lastname;
                  tel =student.tel;
                  mail = student.mail;
                  matri = student.matri;
                  opcion=2;
                });
                contr.text= student.lastname;
              }),

              DataCell(Text(student.surname.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = true;
                  descriptive_text = "Segundo apellido";
                  currentUserId = student.controlum;
                  namefoto = student.namefoto;
                  name = student.name;
                  surname = student.surname;
                  lastname = student.lastname;
                  tel =student.tel;
                  mail = student.mail;
                  matri = student.matri;
                  opcion=3;
                });
                contr.text= student.surname;
              }),
              DataCell(Text(student.matri.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = true;
                  descriptive_text = "Numero de control";
                  currentUserId = student.controlum;
                  namefoto = student.namefoto;
                  name = student.name;
                  surname = student.surname;
                  lastname = student.lastname;
                  tel =student.tel;
                  mail = student.mail;
                  matri = student.matri;
                  opcion=4;
                });
                contr.text = student.matri;
              }),
              DataCell(Text(student.mail.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = true;
                  descriptive_text = "Correo lectronico";
                  currentUserId = student.controlum;
                  namefoto = student.namefoto;
                  name = student.name;
                  surname = student.surname;
                  lastname = student.lastname;
                  tel =student.tel;
                  mail = student.mail;
                  matri = student.matri;
                  opcion=5;
                });
                contr.text = student.mail;
              }),
              DataCell(Text(student.tel.toString().toUpperCase()), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = true;
                  descriptive_text = "Numero de telefono";
                  currentUserId = student.controlum;
                  namefoto = student.namefoto;
                  name = student.name;
                  surname = student.surname;
                  lastname = student.lastname;
                  tel =student.tel;
                  mail = student.mail;
                  matri = student.matri;
                  opcion=6;
                });
                contr.text = student.tel;
              }),
              DataCell(Convertir.imageFromBase64String(student.namefoto), onTap: () {
                setState(() {
                  isUpdating = true;
                  change = false;
                  descriptive_text = "Imagen";
                  currentUserId = student.controlum;
                  namefoto = student.namefoto;
                  name = student.name;
                  surname = student.surname;
                  lastname = student.lastname;
                  tel =student.tel;
                  mail = student.mail;
                  matri = student.matri;
                  opcion=7;
                });
                _selectfoto(context);
                contrP.text = "ingresada";
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
            return Text("No hay datos");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: Text('Actualizar'),
        backgroundColor: Colors.green,
        centerTitle: true, automaticallyImplyLeading: false,
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            form(),
            list(),
          ],
        ),
      ),
    );
  }
}