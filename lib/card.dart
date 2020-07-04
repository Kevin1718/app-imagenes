import 'students.dart';
import 'convertidor.dart';
import 'package:flutter/material.dart';


class DetailPage extends StatelessWidget{
  final Student student;
  DetailPage(this.student);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          title: Text(student.name.toString().toUpperCase()),
          centerTitle: true,
          backgroundColor: Colors.greenAccent,
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              height: MediaQuery
                  .of(context)
                  .size.height / 1.5,
              width: MediaQuery
                  .of(context)
                  .size.width - 19,
              left: 10.0,
              top: MediaQuery
                  .of(context)
                  .size.height * 0.10,
              child: Container(
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft:  const  Radius.circular(40.0),
                            topRight: const  Radius.circular(40.0))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          height: 80.0,
                        ),

                        CircleAvatar(
                          minRadius: 80.0,
                          maxRadius:  80.0,
                          backgroundColor: Colors.greenAccent,
                          backgroundImage: Convertir.imageFromBase64String(student.namefoto).image,
                        ),
                        new Padding(padding: EdgeInsets.all(10.0),),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[

                            Text(
                              student.name.toString().toUpperCase(),
                              style: TextStyle( fontSize: 25.0,
                              ),
                            ),

                            Text(
                              student.lastname.toString().toUpperCase(),
                              style: TextStyle( fontSize: 25.0,
                              ),
                            ),

                            Text(
                              student.surname.toString().toUpperCase(),
                              style: TextStyle( fontSize: 25.0,
                              ),
                            ),
                          ],
                        ),


                        new Padding(padding: EdgeInsets.all(15.0),),

                        RaisedButton.icon(
                          onPressed: (){ print('Push.'); },
                          label: Text("Numero de control: "+ "     "+ "${student.matri}",

                            style: TextStyle(color: Colors.black),),
                          icon: Icon(Icons.format_list_numbered, color:Colors.lightBlueAccent,),

                          color: Colors.greenAccent,),

                        RaisedButton.icon(
                          onPressed: (){ print('Push.'); },
                          label: Text("Correo: "+ "     "+ "${student.mail}",

                            style: TextStyle(color: Colors.black),),
                          icon: Icon(Icons.mail_outline, color:Colors.lightBlueAccent,),

                          color: Colors.greenAccent,),

                        new Padding(padding: EdgeInsets.all(10.0),),

                        RaisedButton.icon(
                          onPressed: (){ print('Push.'); },
                          label: Text("Numero: "+ "     "+ "${student.tel}",

                            style: TextStyle(color: Colors.black),),
                          icon: Icon(Icons.phone_android, color:Colors.lightBlueAccent,),

                          color: Colors.greenAccent,),
                        Divider(

                            color: Colors.green,
                            indent: 10, endIndent: 10, thickness: 2.0
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}