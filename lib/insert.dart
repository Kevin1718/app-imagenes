import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'students.dart';
import 'crud_operations.dart';
import 'package:image_picker/image_picker.dart';
import 'convertidor.dart';

class insertar extends StatefulWidget {
  @override
  _Insert createState() => new _Insert();
}

class _Insert extends State<insertar> {

  Future<List<Student>> Studentss;
  TextEditingController contr1 = TextEditingController();
  TextEditingController contr2 = TextEditingController();
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
  String imagen;
  int currentUserId;
  var bdHelper;
  bool isUpdating;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final formkey = new GlobalKey<FormState>();


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
    contr7.text = "";
  }

  void dataValidate() async {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      if (isUpdating) {
        Student stu =
        Student(currentUserId, name, surname, lastname, matri, mail, tel, imagen);
        bdHelper.update(stu);
        setState(() { isUpdating = false;
        });
      } else {
        Student stu = Student(null, name,surname, lastname, matri, mail, tel, imagen);

        var validation = await bdHelper.validateInsert(stu);
        print(validation);
        if (validation) { bdHelper.insert(stu);
          final snackbar = SnackBar(
            content: new Text("Alumno insertado"),
            backgroundColor: Colors.greenAccent,
          );
          _scaffoldkey.currentState.showSnackBar(snackbar);
        } else {
          final snackbar = SnackBar(
            content: new Text("Hay una matricula igual"),
            backgroundColor: Colors.greenAccent,
          );
          _scaffoldkey.currentState.showSnackBar(snackbar);
        }
      }
      cleanData();
      refreshList();
    }
  }

  pickImagefromCamera(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.camera).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      imagen = imgString;
      Navigator.of(context).pop();
      contr7.text = "ingresada";
      return imagen;
    });
  }

  pickImagefromGallery(BuildContext context) {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Convertir.base64String(imgFile.readAsBytesSync());
      imagen = imgString;
      Navigator.of(context).pop();
      contr7.text = "ingresada";
      return imagen;
    });
  }


  Future<void> _selectfoto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Obtener imagen", textAlign: TextAlign.center,),
              backgroundColor: Colors.lightGreenAccent,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: new AppBar(
        title: Text("Insertar datos de alumno "),
        centerTitle: true,  backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                TextFormField(
                  controller: contr7,
                  decoration: InputDecoration(
                      labelText: "Imagen",
                      suffixIcon: RaisedButton(
                        color: Colors.greenAccent,
                        onPressed: () { _selectfoto(context);
                        },
                        child: Text("Seleccionar una imagen", textAlign: TextAlign.center,),
                      )),
                  validator: (val) => val.length == 0
                      ? 'Debes ingresar una imagen'
                      : contr7.text == "ingresada"
                      ? null
                      : "Solo se pueden subir imagenes imagenes",
                ),
                TextFormField(
                  controller: contr1,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Nombre"),
                  validator: (val) => val.length == 0 ? 'Ingrese un nombre' : null, onSaved: (val) => name = val,
                ),
                TextFormField(
                  controller: contr2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Primer apellido"),
                  validator: (val) => val.length == 0 ? 'Ingrese el primer apellido' : null, onSaved: (val) => surname = val,
                ),
                TextFormField(
                  controller: contr3,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Segundo apellido"),
                  validator: (val) => val.length == 0 ? 'Ingrese el segundo apellido' : null, onSaved: (val) => lastname= val,
                ),
                TextFormField(
                  controller: contr6,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: "Numero de control"),
                  validator: (val) => val.length == 0 ? 'Ingrese el numero de control' : null, onSaved: (val) => matri = val,
                ),
                TextFormField(
                  controller: contr4,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Correo electronico"),
                  validator: (val) => !val.contains('@') ? 'Ingresa el correo' : null, onSaved: (val) => mail = val,
                ),
                TextFormField(
                  controller: contr5,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: "Telefono"),
                  validator: (val) =>
                  val.length < 10 ? 'Ingrese el numero de telefono' : null, onSaved: (val) => tel = val,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.greenAccent)),
                      onPressed: dataValidate,
                      child: Text(isUpdating ? 'Update' : 'Add Data'),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.green)),
                      onPressed: () {
                        setState(() { isUpdating = false;
                        });
                        cleanData();
                      },
                      child: Text('Cancelar'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}