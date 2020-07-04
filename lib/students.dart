class Student{
  int controlum;
  String name;
  String surname;
  String lastname;
  String matri;
  String mail;
  String tel;
  String namefoto;

  Student(this.controlum, this.name, this.surname, this.lastname, this.matri, this.mail, this.tel, this.namefoto);

  Map<String,dynamic>toMap(){
    var map = <String,dynamic>{
      'controlum':controlum,
      'name':name,
      'surname':surname,
      'lastname':lastname,
      'matri':matri,
      'mail':mail,
      'tel':tel,
      'namefoto':namefoto
    };
    return map;
  }
  Student.fromMap(Map<String,dynamic> map){
    controlum=map['controlum'];
    name=map['name'];
    surname=map['surname'];
    lastname=map['lastname'];
    matri=map['matri'];
    mail=map['mail'];
    tel=map['tel'];
    namefoto=map['namefoto'];
  }
}