import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'students.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DBHelper {
  static Database _db;
  static const String Id = 'controlum';
  static const String NAME = 'name';
  static const String SURNAME = 'surname';
  static const String LASTNAME = 'lastname';
  static const String MATRI = 'matri';
  static const String MAIL = 'mail';
  static const String TEL = 'tel';
  static const String TABLE = 'Students';
  static const String DB_NAME = 'students3.db';
  static const String NAMEFOTO = 'namefoto';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    else {
      _db = await initDb();
      return _db;
    }
  }

  initDb() async {
    io.Directory appDirectory = await getApplicationDocumentsDirectory();
    print(appDirectory);
    String path = join(appDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }


  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($Id INTEGER PRIMARY KEY,"
            "$NAME TEXT, $SURNAME TEXT, $LASTNAME TEXT, $MATRI TEXT, $MAIL TEXT, $TEL TEXT, $NAMEFOTO BLOB)");
  }

  Future<List<Student>> getStudents() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [Id, NAME, SURNAME, LASTNAME, MATRI, MAIL, TEL, NAMEFOTO]);
    List<Student> studentss = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        studentss.add(Student.fromMap(maps[i]));
      }
    }
    return studentss;
  }

  Future<bool> validateInsert(Student student) async {
    var dbClient = await db;
    var code = student.matri;
    List<Map> maps = await dbClient

        .rawQuery("select $Id from $TABLE where $MATRI = $code");
    if (maps.length == 0) {
      return true;
    }else{
      return false;
    }
  }

  Future<List<Student>>select(String buscar) async{
    print("ENTRANDO AL SELECT");
    final bd = await db;

    List<Map> maps = await bd.rawQuery("SELECT * FROM $TABLE WHERE $MATRI LIKE '$buscar%'");
    List<Student> studentss =[];
    print(maps);
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++){studentss.add(Student.fromMap(maps[i]));
      }
    }
    return studentss;
  }

  Future<Student> insert(Student student) async {
    var dbClient = await db;
    student.controlum = await dbClient.insert(TABLE, student.toMap());
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$Id = ?', whereArgs: [id]);
  }

  Future<int> update(Student student) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, student.toMap(), where: '$Id = ?', whereArgs: [student.controlum]);
  }

  Future closedb() async {
    var dbClient = await db;
    dbClient.close();
  }
}