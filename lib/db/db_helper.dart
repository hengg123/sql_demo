import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite/sqlite_api.dart';

class DbHelper {
  static Database? _database;
  static Future<Database> getDB() async {
    if (_database != null) {
      return _database!;
    } else {
      return _database = await createDB();
    }
  }

  static Future<Database> createDB() async {
    var databasePath = await getDatabasesPath();// location of phone
    //var databaseFile = "$databasePath/tbStudent.db";
    var dbFile = join(databasePath, "student.db"); // join = +

    return openDatabase(
      dbFile,
      version: 1,
      onCreate: (db, version) {
        return db.execute("""
          CREATE TABLE "tbStudent" (
            "id"	INTEGER,
            "first_name"	TEXT,
            "last_name"	TEXT,
            "gender"	TEXT,
            "dob"	TEXT,
            "profile" TEXT,
            PRIMARY KEY("id" AUTOINCREMENT)
          );
          """);
      },
    );
  }

  static void insertStudents(
      {required String fn,
      required String ln,
      required String gender,
      required String dob,
      required String profile}) async {
    var db = await getDB();
    db.insert("tbStudent", {
      "first_name": fn,
      "last_name": ln,
      "gender": gender,
      "dob": dob,
      "profile": profile
    });
  }

  static Future<List<Map<String, dynamic>>> readStudents() async {
    var db = await getDB();

    return db.query("tbStudent");
  }

  static void updateStudents(
      {required String fn,
      required String ln,
      required String gender,
      required String dob,
      required String profile,
      required int id}) async {
    var db = await getDB();
    db.update("tbStudent", {
      "first_name": fn,
      "last_name": ln,
      "gender": gender,
      "dob": dob,
      "profile": profile
    },
    where: "id = ?",
    whereArgs: [id]
   );
  }

 static void deleteStudent(int id) async {
    var db = await getDB();

    db.delete(
      "tbStudent",
      where: "id = ?",
      whereArgs: [id], 
    );
  }
}
