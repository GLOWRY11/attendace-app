import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const int DATABASE_VERSION = 22;
  static const String DATABASE_NAME = "attendance.db";

  static const String TABLE_CLASSES = "Seance";
  static const String SEANCE_ID = "SEANCE_ID";
  static const String SEANCE_CONTENUE = "SEANCE_CONTENUE";

  static const String TABLE_FONCTIONNAIRE = 'Fonctionnaire';
  static const String FONCTIONNAIRE_ID = 'ID';
  static const String FONCTIONNAIRE_NOM = 'Nom';
  static const String FONCTIONNAIRE_CIN = 'cin';
  static const String FONCTIONNAIRE_PRENOM = 'Prenom';
  static const String FONCTIONNAIRE_EMAIL = 'Email';
  static const String FONCTIONNAIRE_SEXE = "Sexe";
  static const String FONCTIONNAIRE_PHONENUMBER = "phone_number";
  static const String FONCTIONNAIRE_DATE = "date";
  static const String FONCTIONNAIRE_MOT_DE_PASSE = 'MotDePasse';

  static const String TABLE_ENSEIGNANT_ELEMENT = 'enseignant_element';
  static const String ENSEIGNANT_ELEMENT_ID = "enseignant_element_id";

  static const String TABLE_FILIER = "Filier";
  static const String FILIER_ID = "filier_id";
  static const String FILIER_NAME = "filier_name";
  static const String FILIER_Annee = "filier_annee";
  static const String TABLE_FILIERETUDIANT = "filier_Etudiant";

  static const String SEMESTRE_NAME = "semestre_name";

  static const String TABLE_ETUDIANT = "Etudiant";
  static const String ETUDIANT_ID = "s_id";
  static const String ETUDIANT_NOM = "nom";
  static const String ETUDIANT_PRENOM = "prenom";
  static const String ETUDIANT_SEXE = "Sexe";
  static const String ETUDIANT_MASSAR_ID = "massarID";
  static const String ETUDIANT_GMAIL = "gmail";
  static const String ETUDIANTE_PHONENUMBER = "phone_number";
  static const String ETUDIANTE_DATE = "date";

  static const String TABLE_NOTIFICATION = "Notification";
  static const String NOTIFICATION_ID = "notification_id";
  static const String NOTIFICATION_TITLE = "title";
  static const String NOTIFICATION_CONTENT = "content";
  static const String NOTIFICATION_DATE = "date";
  static const String NOTIFICATION_IS_READ = "isread";
  static const String NOTIFICATION_FONCTIONNAIRE_ID = "fonctionnaire_id";
  static const String NOTIFICATION_ENSEIGNANTE_ID = "enseignante_id";




  static const String TABLE_ABSENCE = "Absence";
  static const String ABSENCE_ID = "id";
  static const String IS_PRESENT = "isPresent";
  static const String ABSENCE_DATE = "date";
  static const String START_TIME = "startDate";
  static const String END_TIME = "endDate";

  // Changed from S_ID to ETUDIANT_ID
  static const String FOREIGN_KEY_ABSENCE_STUDENT =
      "FOREIGN KEY ($ETUDIANT_ID) REFERENCES $TABLE_ETUDIANT($ETUDIANT_ID)";
  static const String FOREIGN_KEY_ABSENCE_CLASS =
      "FOREIGN KEY ($SEANCE_ID) REFERENCES $TABLE_CLASSES($SEANCE_ID)";
  static const String FOREIGN_KEY_ETUDIANT_CLASS =
      "FOREIGN KEY ($SEANCE_ID) REFERENCES $TABLE_CLASSES($SEANCE_ID)";

  static const String TABLE_ENSEIGNANT = "Enseignant";
  static const String ENSEIGNANT_ID = "id";
  static const String ENSEIGNANT_CIN = "cin";
  static const String ENSEIGNANT_NOM = "nom";
  static const String ENSEIGNANT_PRENOM = "prenom";
  static const String ENSEIGNANT_SEXE = "Sexe";
  static const String ENSEIGNANT_EMAIL = "email";
  static const String ENSEIGNANT_PHONENUMBER = "phone_number";
  static const String ENSEIGNANT_DATE = "date";
  static const String ENSEIGNANT_MOT_DE_PASSE = "mot_de_passe";

  static const String TABLE_MODULE = "Module";
  static const String MODULE_ID = "module_id";
  static const String MODULE_NAME = "module_name";

  static const String TABLE_ELEMENT = "Element";
  static const String ELEMENT_ID = "element_id";
  static const String ELEMENT_NAME = "element_name";

  static const String TABLE_ATTENDANCE_HISTORY = "AttendanceHistory";
  static const String ATTENDANCE_HISTORY_ID = "AttendanceHistoryID";
  static const String ATTENDANCE_HISTORY_DATE = "AttendanceDate";
  static const String ATTENDANCE_HISTORY_PRESENT_COUNT = "PresentCount";
  static const String ATTENDANCE_HISTORY_ABSENT_COUNT = "AbsentCount";

  static const String FOREIGN_KEY_MODULE_ELEMENT =
      "FOREIGN KEY ($MODULE_ID) REFERENCES $TABLE_MODULE($MODULE_ID)";

  static const String FOREIGN_KEY_FILIER_COURS =
      "FOREIGN KEY ($FILIER_ID) REFERENCES $TABLE_FILIER($FILIER_ID)";

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      DATABASE_NAME,
      version: DATABASE_VERSION,
      onCreate: (db, version) async {


        await db.execute('''
            CREATE TABLE $TABLE_FILIER (
              $FILIER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
              $FILIER_NAME TEXT NOT NULL,
              $SEMESTRE_NAME TEXT NOT NULL,
              $FILIER_Annee TEXT NOT NULL
            )
          ''');
        await db.execute('''
              CREATE TABLE $TABLE_MODULE (
                $MODULE_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                $MODULE_NAME TEXT NOT NULL
              )
            ''');

        await db.execute('''
              CREATE TABLE $TABLE_ELEMENT (
                $ELEMENT_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                $ELEMENT_NAME TEXT NOT NULL,
                $MODULE_ID INTEGER NOT NULL,
                $FOREIGN_KEY_MODULE_ELEMENT
              )
            ''');

        await db.execute('''
            CREATE TABLE $TABLE_ETUDIANT (
              $ETUDIANT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
              $ETUDIANT_NOM TEXT NOT NULL,
              $ETUDIANT_PRENOM TEXT NOT NULL,
              $ETUDIANT_SEXE TEXT NOT NULL,
              $ETUDIANT_MASSAR_ID TEXT NOT NULL,
              $ETUDIANT_GMAIL TEXT,
              $ETUDIANTE_PHONENUMBER TEXT,
              $ETUDIANTE_DATE TEXT NOT NULL,
              $FILIER_ID INTEGER NOT NULL,
              FOREIGN KEY ($FILIER_ID) REFERENCES $TABLE_FILIER($FILIER_ID)
            )
          ''');
        await db.execute('''
          CREATE TABLE $TABLE_NOTIFICATION (
            $NOTIFICATION_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $NOTIFICATION_TITLE TEXT NOT NULL,
            $NOTIFICATION_CONTENT TEXT NOT NULL,
            $NOTIFICATION_DATE TEXT NOT NULL,
            $NOTIFICATION_FONCTIONNAIRE_ID INTEGER NOT NULL,
            $NOTIFICATION_ENSEIGNANTE_ID INTEGER NOT NULL,
            $NOTIFICATION_IS_READ INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY ($NOTIFICATION_FONCTIONNAIRE_ID) REFERENCES $TABLE_FONCTIONNAIRE($FONCTIONNAIRE_ID),
            FOREIGN KEY ($NOTIFICATION_ENSEIGNANTE_ID) REFERENCES $TABLE_ENSEIGNANT($ENSEIGNANT_ID)
          )
        ''');


        await db.execute('''
              CREATE TABLE $TABLE_ENSEIGNANT (
                $ENSEIGNANT_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                $ENSEIGNANT_NOM TEXT NOT NULL,
                $ENSEIGNANT_CIN TEXT NOT NULL,
                $ENSEIGNANT_SEXE TEXT NOT NULL,
                $ENSEIGNANT_PRENOM TEXT NOT NULL,
                $ENSEIGNANT_EMAIL TEXT NOT NULL,
                $ENSEIGNANT_PHONENUMBER TEXT NOT NULL,
                $ENSEIGNANT_DATE TEXT NOT NULL,
                $ENSEIGNANT_MOT_DE_PASSE TEXT NOT NULL
              )
              ''');
        await db.execute('''
              CREATE TABLE $TABLE_CLASSES (
                $SEANCE_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                $MODULE_NAME TEXT NOT NULL,
                $ELEMENT_NAME TEXT NOT NULL,
                $SEANCE_CONTENUE TEXT NOT NULL,
                $ENSEIGNANT_ID INTEGER NOT NULL,
                UNIQUE ($MODULE_NAME,$ELEMENT_NAME,$SEANCE_CONTENUE,$ENSEIGNANT_ID),
                FOREIGN KEY ($ENSEIGNANT_ID) REFERENCES $TABLE_ENSEIGNANT($ENSEIGNANT_ID)
              )
              ''');



        // Create Absence table
        await db.execute('''
                CREATE TABLE $TABLE_ABSENCE (
                  $ABSENCE_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                  $IS_PRESENT INTEGER NOT NULL,
                  $ABSENCE_DATE TEXT NOT NULL,
                  $START_TIME TEXT NOT NULL,
                  $END_TIME TEXT NOT NULL,
                  $ATTENDANCE_HISTORY_ID INTEGER NOT NULL,
                  $ETUDIANT_ID INTEGER NOT NULL,
                  $FOREIGN_KEY_ABSENCE_STUDENT,
                  FOREIGN KEY ($ATTENDANCE_HISTORY_ID) REFERENCES $TABLE_ATTENDANCE_HISTORY($ATTENDANCE_HISTORY_ID),
                  UNIQUE ($ETUDIANT_ID, $ABSENCE_DATE)
                )
                ''');
        await db.execute('''
          CREATE TABLE $TABLE_ATTENDANCE_HISTORY (
            $ATTENDANCE_HISTORY_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $SEANCE_ID INTEGER NOT NULL,
            $ATTENDANCE_HISTORY_DATE TEXT NOT NULL,
            $ATTENDANCE_HISTORY_PRESENT_COUNT INTEGER NOT NULL,
            $ATTENDANCE_HISTORY_ABSENT_COUNT INTEGER NOT NULL,
            $FILIER_ID INTEGER NOT NULL,
            $ENSEIGNANT_ID INTEGER NOT NULL,
            FOREIGN KEY ($SEANCE_ID) REFERENCES $TABLE_CLASSES($SEANCE_ID),
            FOREIGN KEY ($ENSEIGNANT_ID) REFERENCES $TABLE_ENSEIGNANT($ENSEIGNANT_ID),
            FOREIGN KEY ($FILIER_ID) REFERENCES $TABLE_FILIER($FILIER_ID)
            )
        ''');

        await db.execute('''
              CREATE TABLE $TABLE_FONCTIONNAIRE (
                $FONCTIONNAIRE_ID INTEGER PRIMARY KEY,
                $FONCTIONNAIRE_NOM TEXT NOT NULL,
                $FONCTIONNAIRE_PRENOM TEXT NOT NULL,
                $FONCTIONNAIRE_CIN TEXT NOT NULL,
                $FONCTIONNAIRE_EMAIL TEXT NOT NULL,
                $FONCTIONNAIRE_DATE TEXT NOT NULL,
                $FONCTIONNAIRE_SEXE TEXT NOT NULL,
                 $FONCTIONNAIRE_PHONENUMBER TEXT NOT NULL,
                $FONCTIONNAIRE_MOT_DE_PASSE TEXT NOT NULL
                )
              ''');
        await db.execute('''
                  CREATE TABLE $TABLE_ENSEIGNANT_ELEMENT (
                    $ENSEIGNANT_ELEMENT_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                    $ENSEIGNANT_ID INTEGER NOT NULL,
                    $ELEMENT_ID INTEGER NOT NULL,
                    FOREIGN KEY ($ENSEIGNANT_ID) REFERENCES $TABLE_ENSEIGNANT($ENSEIGNANT_ID),
                    FOREIGN KEY ($ELEMENT_ID) REFERENCES $TABLE_ELEMENT($ELEMENT_ID),
                    UNIQUE ($ENSEIGNANT_ID, $ELEMENT_ID)
                  )
  ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Drop old tables
        await db.execute('DROP TABLE IF EXISTS $TABLE_CLASSES');
        await db.execute('DROP TABLE IF EXISTS $TABLE_ETUDIANT');
        await db.execute('DROP TABLE IF EXISTS $TABLE_ABSENCE');
        await db.execute('DROP TABLE IF EXISTS $TABLE_ENSEIGNANT');
        await db.execute('DROP TABLE IF EXISTS $TABLE_MODULE');
        await db.execute('DROP TABLE IF EXISTS $TABLE_FILIER');
        await db.execute('DROP TABLE IF EXISTS $TABLE_FONCTIONNAIRE');
        await db.execute('DROP TABLE IF EXISTS $TABLE_ELEMENT');
        await db.execute('DROP TABLE IF EXISTS $TABLE_ATTENDANCE_HISTORY');
        await db.execute('DROP TABLE IF EXISTS $TABLE_ENSEIGNANT_ELEMENT');
        await db.execute('DROP TABLE IF EXISTS $TABLE_NOTIFICATION');

        await db.execute('''
            CREATE TABLE $TABLE_FILIER (
              $FILIER_ID INTEGER PRIMARY KEY AUTOINCREMENT,
              $FILIER_NAME TEXT NOT NULL,
              $SEMESTRE_NAME TEXT NOT NULL,
              $FILIER_Annee TEXT NOT NULL
            )
          ''');
        await db.execute('''
              CREATE TABLE $TABLE_MODULE (
                $MODULE_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                $MODULE_NAME TEXT NOT NULL
              )
            ''');

        await db.execute('''
              CREATE TABLE $TABLE_ELEMENT (
                $ELEMENT_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                $ELEMENT_NAME TEXT NOT NULL,
                $MODULE_ID INTEGER NOT NULL,
                $FOREIGN_KEY_MODULE_ELEMENT
              )
            ''');
        await db.execute('''
          CREATE TABLE $TABLE_NOTIFICATION (
            $NOTIFICATION_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $NOTIFICATION_TITLE TEXT NOT NULL,
            $NOTIFICATION_CONTENT TEXT NOT NULL,
            $NOTIFICATION_DATE TEXT NOT NULL,
            $NOTIFICATION_FONCTIONNAIRE_ID INTEGER NOT NULL,
            $NOTIFICATION_ENSEIGNANTE_ID INTEGER NOT NULL,
            $NOTIFICATION_IS_READ INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY ($NOTIFICATION_FONCTIONNAIRE_ID) REFERENCES $TABLE_FONCTIONNAIRE($FONCTIONNAIRE_ID),
            FOREIGN KEY ($NOTIFICATION_ENSEIGNANTE_ID) REFERENCES $TABLE_ENSEIGNANT($ENSEIGNANT_ID)
          )
        ''');

        await db.execute('''
            CREATE TABLE $TABLE_ETUDIANT (
              $ETUDIANT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
              $ETUDIANT_NOM TEXT NOT NULL,
              $ETUDIANT_PRENOM TEXT NOT NULL,
              $ETUDIANT_SEXE TEXT NOT NULL,
              $ETUDIANT_MASSAR_ID TEXT NOT NULL,
              $ETUDIANT_GMAIL TEXT,
              $ETUDIANTE_PHONENUMBER TEXT,
              $ETUDIANTE_DATE TEXT NOT NULL,
              $FILIER_ID INTEGER NOT NULL,
              FOREIGN KEY ($FILIER_ID) REFERENCES $TABLE_FILIER($FILIER_ID)
            )
          ''');


        await db.execute('''
              CREATE TABLE $TABLE_ENSEIGNANT (
                $ENSEIGNANT_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                $ENSEIGNANT_NOM TEXT NOT NULL,
                $ENSEIGNANT_CIN TEXT NOT NULL,
                $ENSEIGNANT_SEXE TEXT NOT NULL,
                $ENSEIGNANT_PRENOM TEXT NOT NULL,
                $ENSEIGNANT_EMAIL TEXT NOT NULL,
                $ENSEIGNANT_PHONENUMBER TEXT NOT NULL,
                $ENSEIGNANT_DATE TEXT NOT NULL,
                $ENSEIGNANT_MOT_DE_PASSE TEXT NOT NULL
              )
              ''');
        await db.execute('''
              CREATE TABLE $TABLE_CLASSES (
                $SEANCE_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                $MODULE_NAME TEXT NOT NULL,
                $ELEMENT_NAME TEXT NOT NULL,
                $SEANCE_CONTENUE TEXT NOT NULL,
                $ENSEIGNANT_ID INTEGER NOT NULL,
                UNIQUE ($MODULE_NAME,$ELEMENT_NAME,$SEANCE_CONTENUE,$ENSEIGNANT_ID),
                FOREIGN KEY ($ENSEIGNANT_ID) REFERENCES $TABLE_ENSEIGNANT($ENSEIGNANT_ID)
              )
              ''');



        // Create Absence table
        await db.execute('''
                CREATE TABLE $TABLE_ABSENCE (
                  $ABSENCE_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                  $IS_PRESENT INTEGER NOT NULL,
                  $ABSENCE_DATE TEXT NOT NULL,
                  $START_TIME TEXT NOT NULL,
                  $END_TIME TEXT NOT NULL,
                  $ATTENDANCE_HISTORY_ID INTEGER NOT NULL,
                  $ETUDIANT_ID INTEGER NOT NULL,
                  $FOREIGN_KEY_ABSENCE_STUDENT,
                  FOREIGN KEY ($ATTENDANCE_HISTORY_ID) REFERENCES $TABLE_ATTENDANCE_HISTORY($ATTENDANCE_HISTORY_ID)
                  UNIQUE ($ETUDIANT_ID, $ABSENCE_DATE)
                )
                ''');
        await db.execute('''
          CREATE TABLE $TABLE_ATTENDANCE_HISTORY (
            $ATTENDANCE_HISTORY_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $SEANCE_ID INTEGER NOT NULL,
            $ATTENDANCE_HISTORY_DATE TEXT NOT NULL,
            $ATTENDANCE_HISTORY_PRESENT_COUNT INTEGER NOT NULL,
            $ATTENDANCE_HISTORY_ABSENT_COUNT INTEGER NOT NULL,
            $FILIER_ID INTEGER NOT NULL,
            $ENSEIGNANT_ID INTEGER NOT NULL,
            FOREIGN KEY ($SEANCE_ID) REFERENCES $TABLE_CLASSES($SEANCE_ID),
            FOREIGN KEY ($ENSEIGNANT_ID) REFERENCES $TABLE_ENSEIGNANT($ENSEIGNANT_ID),
            FOREIGN KEY ($FILIER_ID) REFERENCES $TABLE_FILIER($FILIER_ID)
          )
        ''');

        await db.execute('''
              CREATE TABLE $TABLE_FONCTIONNAIRE (
                $FONCTIONNAIRE_ID INTEGER PRIMARY KEY,
                $FONCTIONNAIRE_NOM TEXT NOT NULL,
                $FONCTIONNAIRE_PRENOM TEXT NOT NULL,
                $FONCTIONNAIRE_CIN TEXT NOT NULL,
                $FONCTIONNAIRE_EMAIL TEXT NOT NULL,
                $FONCTIONNAIRE_DATE TEXT NOT NULL,
                $FONCTIONNAIRE_SEXE TEXT NOT NULL,
                 $FONCTIONNAIRE_PHONENUMBER TEXT NOT NULL,
                $FONCTIONNAIRE_MOT_DE_PASSE TEXT NOT NULL
                )
              ''');
        await db.execute('''
                  CREATE TABLE $TABLE_ENSEIGNANT_ELEMENT (
                    $ENSEIGNANT_ELEMENT_ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                    $ENSEIGNANT_ID INTEGER NOT NULL,
                    $ELEMENT_ID INTEGER NOT NULL,
                    FOREIGN KEY ($ENSEIGNANT_ID) REFERENCES $TABLE_ENSEIGNANT($ENSEIGNANT_ID),
                    FOREIGN KEY ($ELEMENT_ID) REFERENCES $TABLE_ELEMENT($ELEMENT_ID),
                    UNIQUE ($ENSEIGNANT_ID, $ELEMENT_ID)
                  )
  ''');
      },
    );
  }

  Future<int> addNotification(String title, String content, String date, int fonctionnaireId, int enseignanteId) async {
    final db = await database;
    return await db!.insert(TABLE_NOTIFICATION, {
      NOTIFICATION_TITLE: title,
      NOTIFICATION_CONTENT: content,
      NOTIFICATION_DATE: date,

      NOTIFICATION_FONCTIONNAIRE_ID: fonctionnaireId,
      NOTIFICATION_ENSEIGNANTE_ID: enseignanteId,
    });
  }
  Future<int> addFonctionnaire({
    required String nom,
    required String prenom,
    required String cin,
    required String email,
    required String date,
    required String sexe,
    required String phoneNumber,
    required String motDePasse,}) async {
    final  db = await database; // Assuming database is initialized somewhere else

    int fonctionnaireId = await db!.insert(TABLE_FONCTIONNAIRE, {
      FONCTIONNAIRE_NOM: nom,
      FONCTIONNAIRE_PRENOM: prenom,
      FONCTIONNAIRE_EMAIL: email,
      FONCTIONNAIRE_CIN:cin,
      FONCTIONNAIRE_DATE: date,
      FONCTIONNAIRE_SEXE: sexe,
      FONCTIONNAIRE_PHONENUMBER: phoneNumber,
      FONCTIONNAIRE_MOT_DE_PASSE: motDePasse,
    });

    return fonctionnaireId;
  }


  Future<List<Map<String, dynamic>>> getNotifications() async {
    final db = await database;
    return await db!.query(TABLE_NOTIFICATION);
  }

  Future<int> deleteNotification(int id) async {
    final db = await database;
    return await db!.delete(TABLE_NOTIFICATION, where: '$NOTIFICATION_ID = ?', whereArgs: [id]);
  }

  Future<void> insertAbsence({
    required int etudiantId,
    required int isPresent,
    required DateTime absenceDate,
    required DateTime startTime,
    required DateTime endTime,
    required int attendanceHistoryId,
  }) async {
    final db = await database;
    await db?.insert(
      TABLE_ABSENCE,
      {
        ETUDIANT_ID: etudiantId,
        IS_PRESENT: isPresent,
        ABSENCE_DATE: absenceDate.toIso8601String(),
        START_TIME: startTime.toIso8601String(),
        END_TIME: endTime.toIso8601String(),
        ATTENDANCE_HISTORY_ID: attendanceHistoryId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  Future<int?> addSeance(String moduleName, String elementName,
      String classSubject, int? enseignantId) async {
    final db = await database;
    final values = <String, dynamic>{
      MODULE_NAME: moduleName,
      ELEMENT_NAME: elementName,
      SEANCE_CONTENUE: classSubject,
      ENSEIGNANT_ID: enseignantId,
    };
    return await db
        ?.transaction((txn) async => await txn.insert(TABLE_CLASSES, values));
  }

  Future<int?> addEtudiant(String name, String prenom, int filier,
      String massar, String? sexe,String gmail,String phonenumber,String dateofbirth) async {
    final db = await database;
    final values = <String, dynamic>{
      ETUDIANT_NOM: name,
      ETUDIANT_PRENOM: prenom,
      ETUDIANT_SEXE: sexe,
      FILIER_ID: filier,
      ETUDIANT_GMAIL: gmail,
      ETUDIANTE_PHONENUMBER:phonenumber,
      ETUDIANT_MASSAR_ID: massar,
      ETUDIANTE_DATE:dateofbirth,

    };
    return await db
        ?.transaction((txn) async => await txn.insert(TABLE_ETUDIANT, values));
  }
  Future<List<Map<String, dynamic>>> getAttendanceHistoryWithDetails() async {
    final db = await database;
    if (db != null) {
      return await db.rawQuery('''
      SELECT ah.$ATTENDANCE_HISTORY_ID, ah.$ATTENDANCE_HISTORY_DATE, 
             e.$ENSEIGNANT_NOM AS enseignant_nom, e.$ENSEIGNANT_PRENOM AS enseignant_prenom, 
             f.$FILIER_NAME AS filiere_nom
      FROM $TABLE_ATTENDANCE_HISTORY ah
      JOIN $TABLE_ENSEIGNANT e ON ah.$ENSEIGNANT_ID = e.$ENSEIGNANT_ID
      JOIN $TABLE_FILIER f ON ah.$FILIER_ID = f.$FILIER_ID
    ''');
    }
    return [];
  }
  Future<List<Map<String, dynamic>>> getAttendanceHistoryWithDetailsbyidfilier(int filierId) async {
    final db = await database;
    if (db != null) {
      return await db.rawQuery('''
      SELECT ah.$ATTENDANCE_HISTORY_ID, ah.$ATTENDANCE_HISTORY_DATE, 
             f.$FILIER_NAME AS filiere_nom
      FROM $TABLE_ATTENDANCE_HISTORY ah
      JOIN $TABLE_FILIER f ON ah.$FILIER_ID = f.$FILIER_ID
      WHERE ah.$FILIER_ID = ?
    ''', [filierId]);
    }
    return [];
  }

    Future<List<Map<String, dynamic>>> getAttendanceHistoryWithDetailsForSeance(int scienceid) async {
      final db = await database;
      if (db != null) {
        return await db.rawQuery('''
        SELECT ah.$ATTENDANCE_HISTORY_ID, ah.$ATTENDANCE_HISTORY_DATE, 
               f.$FILIER_NAME AS filiere_nom
        FROM $TABLE_ATTENDANCE_HISTORY ah
        JOIN $TABLE_FILIER f ON ah.$FILIER_ID = f.$FILIER_ID
        WHERE ah.$SEANCE_ID = ?
      ''', [scienceid]);
      }
      return [];
    }
  Future<void> markNotificationAsRead(int? notificationId) async {
    final db = await database;
    await db!.update(
      TABLE_NOTIFICATION,
      {NOTIFICATION_IS_READ: 1}, // Update isRead to 1 (true) for the notification with the given ID
      where: '$NOTIFICATION_ID = ?',
      whereArgs: [notificationId],
    );
  }
  Future<List<Map<String, dynamic>>> getAttendanceHistoryWithDetailsForEnseignante(int id) async {
    final db = await database;
    if (db != null) {
      return await db.rawQuery('''
        SELECT ah.$ATTENDANCE_HISTORY_ID, ah.$ATTENDANCE_HISTORY_DATE, 
               f.$FILIER_NAME AS filiere_nom
        FROM $TABLE_ATTENDANCE_HISTORY ah
        JOIN $TABLE_FILIER f ON ah.$FILIER_ID = f.$FILIER_ID
        WHERE ah.$ENSEIGNANT_ID = ?
      ''', [id]);
    }
    return [];
  }

  Future<int?> addFilier(
      String filiername, String? semestre, String? annee) async {
    final db = await database;
    final values = <String, dynamic>{
      FILIER_NAME: filiername,
      SEMESTRE_NAME: semestre,
      FILIER_Annee: annee,
    };
    return await db
        ?.transaction((txn) async => await txn.insert(TABLE_FILIER, values));
  }
  Future<List<Map<String, dynamic>>> getAttendanceHistoryByDate(String date) async {
    final db = await database;

    if (db == null) {
      throw Exception("Database is not initialized"); // Throw an exception if database is not initialized
    }

    return await db.rawQuery('''
    SELECT * FROM $TABLE_ATTENDANCE_HISTORY
    WHERE $ATTENDANCE_HISTORY_DATE = ?
  ''', [date]);
  }

  Future<int> countAttendanceHistoryByEnseignant(int enseignantId) async {
    final db = await database;
    if (db != null) {
      final count = await db.rawQuery('''
      SELECT COUNT(*) AS count
      FROM $TABLE_ATTENDANCE_HISTORY
      WHERE $ENSEIGNANT_ID = ?
    ''', [enseignantId]);

      int result = Sqflite.firstIntValue(count)!;
      return result;
    } else {
      return -1; // Return -1 or handle the case where db is null
    }
  }
  Future<int> countEtudiants() async {
    final db = await database;

    if (db != null) {
      List<Map<String, dynamic>> count = await db.query(
        TABLE_ETUDIANT,
        columns: ['COUNT(*)'],
      );
      int result = Sqflite.firstIntValue(count)!;
      return result; // Return 0 if result is null
    } else {
      return -1; // Return -1 or handle the case where db is null
    }
  }
  Future<List<Map<String, dynamic>>> getFilieresForEnseignant(int enseignantId) async {
    final db =await database;
    if (db != null) {
      final List<Map<String, dynamic>> result = await db.rawQuery('''
        SELECT DISTINCT f.$FILIER_ID, f.$FILIER_NAME, f.$SEMESTRE_NAME, f.$FILIER_Annee
        FROM $TABLE_FILIER f
        JOIN $TABLE_ATTENDANCE_HISTORY ah ON f.$FILIER_ID = ah.$FILIER_ID
        WHERE ah.$ENSEIGNANT_ID = ?
      ''', [enseignantId]);
      return result;
    } else {
      throw Exception('Database is not initialized');
    }
  }

  Future<List<Map<String, dynamic>>> getAllFiliers() async {
    final db = await database;
    return await db!.query(TABLE_FILIER);
  }
  Future<List<Map<String, dynamic>>> getAllAttendanceHistory() async {
    final db = await database;
    return await db!.query(TABLE_ATTENDANCE_HISTORY);
  }



  Future<List<Map<String, dynamic>>> getAttendanceHistoryForSeance(int classId) async {
    final db = await database;
    if (db != null) {
      return db.query(
        TABLE_ATTENDANCE_HISTORY,
        where: '$SEANCE_ID = ?',
        whereArgs: [classId],
      );
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAttendanceHistory(
      int filierid) async {
    final db = await database;
    if (db != null) {
      return db.query(
        TABLE_ATTENDANCE_HISTORY,);
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getStudentsWithMoreThanFourAbsences() async {
    final db = await database;
    if (db != null) {
      const String query = '''
        SELECT e.*
        FROM $TABLE_ABSENCE a
        JOIN $TABLE_ETUDIANT e ON a.$ETUDIANT_ID = e.$ETUDIANT_ID
        WHERE a.$IS_PRESENT = 0
        GROUP BY e.$ETUDIANT_ID
        HAVING COUNT(a.$ETUDIANT_ID) > 4;
      ''';
      return await db.rawQuery(query);
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAttendanceHistoryForEnseignant(
      int enseignantid) async {
    final db = await database;
    if (db != null) {
      return db.query(
        TABLE_ATTENDANCE_HISTORY,
        where: '$ENSEIGNANT_ID = ?',
        whereArgs: [enseignantid],
      );
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getElementTableWithModuleNames() async {
    final db = await database;
    return await db!.rawQuery('''
              SELECT e.$ELEMENT_NAME, e.$ELEMENT_ID, m.$MODULE_NAME
              FROM $TABLE_ELEMENT e
              JOIN $TABLE_MODULE m ON e.$MODULE_ID = m.$MODULE_ID
            ''');
  }


  Future<List<Map<String, dynamic>>> getStudentsByFilier(int filierId) async {
    final db = await database;

    if (db != null) {
      return await db.query(
        TABLE_ETUDIANT,
        where: '$FILIER_ID = ?',
        whereArgs: [filierId],
      );
    } else {
      return []; // Return an empty list if database is null
    }
  }

  Future<List<Map<String, dynamic>>> getAbsenceRecords(
      int attendanceHistoryId) async {
    final db = await database; // Get reference to your database
    if (db != null) {
      return await db.query(
        TABLE_ABSENCE,
        where: '$ATTENDANCE_HISTORY_ID = ?',
        whereArgs: [attendanceHistoryId],
      );
    } else {
      return []; // Return an empty list if database is null
    }
  }

  Future<int?> addElementToEnseignant(int enseignantId, int elementId) async {
    final db = await database;

    if (db != null) {
      return await db.transaction((txn) async {
        int id = await txn.insert(TABLE_ENSEIGNANT_ELEMENT, {
          ENSEIGNANT_ID: enseignantId,
          ELEMENT_ID: elementId,
        });
        return id;
      });
    } else {
      return null;
    }
  }

  Future<int> countAbsencesInCurrentMonth() async {
    final db = await database;

    if (db != null) {
      // Get the current month and year
      DateTime now = DateTime.now();
      int currentMonth = now.month;
      int currentYear = now.year;

      // Calculate the start and end of the current month
      DateTime monthStart = DateTime(currentYear, currentMonth, 1);
      DateTime monthEnd = DateTime(currentYear, currentMonth + 1, 1).subtract(const Duration(days: 1));

      // Format the start and end dates to match your database schema
      String formattedMonthStart = '${monthStart.year}-${monthStart.month.toString().padLeft(2, '0')}-01';
      String formattedMonthEnd = '${monthEnd.year}-${monthEnd.month.toString().padLeft(2, '0')}-${monthEnd.day.toString().padLeft(2, '0')}';

      // Query the database to count absences within the current month
      int count = Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM $TABLE_ABSENCE WHERE $ABSENCE_DATE BETWEEN ? AND ?',
        [formattedMonthStart, formattedMonthEnd],
      )) ?? 0;

      return count;
    } else {
      return -1; // Return -1 or handle the case where db is null
    }
  }

  Future<int> countEnseignant() async {
    final db = await database;

    if (db != null) {
      List<Map<String, dynamic>> count = await db.query(
        TABLE_ENSEIGNANT,
        columns: ['COUNT(*)'],
      );
      int result = Sqflite.firstIntValue(count)!;
      return result;
    } else {
      return -1;
    }
  }

  Future<int> removeEnseignantElement(int enseignantElementId) async {
    final db = await database;

    if (db != null) {
      return await db.delete(
        TABLE_ENSEIGNANT_ELEMENT,
        where: '$ENSEIGNANT_ELEMENT_ID = ?',
        whereArgs: [enseignantElementId],
      );
    } else {
      return -1;
    }
  }

  Future<Map<String, dynamic>?> getElementDetails(int elementId) async {
    final db = await database;

    if (db != null) {
      List<Map<String, dynamic>> results = await db.query(
        TABLE_ELEMENT,
        where: '$ELEMENT_ID = ?',
        whereArgs: [elementId],
        limit: 1,
      );

      return results.isNotEmpty ? results.first : null;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>> getEnseignantDetails(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      TABLE_ENSEIGNANT,
      where: '$ENSEIGNANT_EMAIL = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    throw Exception('Enseignant not found');
  }
  Future<Map<String, String>> getEtudianteDetailsById(int idEtudiante) async {
    final db = await database;
    if (db != null) {
      List<Map<String, dynamic>> results = await db.query(
        TABLE_ETUDIANT,
        columns: [ETUDIANT_NOM, ETUDIANT_PRENOM],
        where: '$ETUDIANT_ID = ?',
        whereArgs: [idEtudiante],
      );

      if (results.isNotEmpty) {
        return {
          'nom': results.first[ETUDIANT_NOM] as String,
          'prenom': results.first[ETUDIANT_PRENOM] as String,
        };
      } else {
        return {
          'nom': 'Unknown',
          'prenom': '',
        };
      }
    } else {
      throw Exception('Database is not initialized');
    }
  }
  Future<Map<String, String>> getEnseignantDetailsById(int idEnseignante) async {
    final db = await database;
    if (db != null) {
      List<Map<String, dynamic>> results = await db.query(
        TABLE_ENSEIGNANT,
        columns: [ENSEIGNANT_NOM, ENSEIGNANT_PRENOM],
        where: '$ENSEIGNANT_ID = ?',
        whereArgs: [idEnseignante],
      );

      if (results.isNotEmpty) {
        return {
          'nom': results.first[ENSEIGNANT_NOM] as String,
          'prenom': results.first[ENSEIGNANT_PRENOM] as String,
        };
      } else {
        return {
          'nom': 'Unknown',
          'prenom': '',
        };
      }
    } else {
      throw Exception('Database is not initialized');
    }
  }
  Future<Map<String, String>> getFiliereDetailsById(int idFiliere) async {
    final db = await database;
    if (db != null) {
      List<Map<String, dynamic>> results = await db.query(
        TABLE_FILIER,
        columns: [FILIER_NAME],
        where: '$FILIER_ID = ?',
        whereArgs: [idFiliere],
      );

      if (results.isNotEmpty) {
        return {
          'filier_name': results.first[FILIER_NAME] as String,
        };
      } else {
        return {
          'filier_name': 'Unknown',
        };
      }
    } else {
      throw Exception('Database is not initialized');
    }
  }

  Future<Map<String, dynamic>> getFonctionnaireDetails(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      TABLE_FONCTIONNAIRE,
      where: '$FONCTIONNAIRE_EMAIL = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    throw Exception('Fonctionnaire not found');
  }

  Future<List<Map<String, dynamic>>?> getElementofModuleTable(
      int moduleId) async {
    final db = await database;
    return await db?.query(
      TABLE_ELEMENT,
      where: '$MODULE_ID = ?',
      whereArgs: [moduleId],
    );
  }

  Future<int?> addModule(String moduleName) async {
    final db = await database;
    final values = <String, dynamic>{
      MODULE_NAME: moduleName,
    };
    return await db
        ?.transaction((txn) async => await txn.insert(TABLE_MODULE, values));
  }

  Future<int?> addElement(int moduleId, String elementName) async {
    final db = await database;
    final values = <String, dynamic>{
      ELEMENT_NAME: elementName,
      MODULE_ID: moduleId
    };
    return await db
        ?.transaction((txn) async => await txn.insert(TABLE_ELEMENT, values));
  }

  Future<int?> addElementToEnseignat(int ensgeinantId, int elementId) async {
    final db = await database;
    final values = <String, dynamic>{
      ELEMENT_ID: elementId,
      ENSEIGNANT_ID: ensgeinantId
    };
    return await db?.transaction(
        (txn) async => await txn.insert(TABLE_ENSEIGNANT_ELEMENT, values));
  }

  Future<int?> addEnseignant(String nom, String prenom, String cin,
      String email, String motDePasse, String? gender,String phonenumber,String dateofbirth) async {
    final db = await database;
    final values = <String, dynamic>{
      ENSEIGNANT_NOM: nom,
      ENSEIGNANT_PRENOM: prenom,
      ENSEIGNANT_CIN: cin,
      ENSEIGNANT_SEXE: gender,
      ENSEIGNANT_EMAIL: email,
      ENSEIGNANT_MOT_DE_PASSE: motDePasse,
      ENSEIGNANT_PHONENUMBER:phonenumber,
     ENSEIGNANT_DATE:dateofbirth,
    };
    return await db?.transaction(
        (txn) async => await txn.insert(TABLE_ENSEIGNANT, values));
  }


  Future<int?> updateSeance(
      int cid, String moduleName, String classSubject) async {
    final db = await database;
    final values = <String, dynamic>{
      MODULE_NAME: moduleName,
      SEANCE_CONTENUE: classSubject,
    };
    return await db?.update(
      TABLE_CLASSES,
      values,
      where: '$SEANCE_ID = ?',
      whereArgs: [cid],
    );
  }

  Future<int?> updateEtudiante(
      int sid, String name, String prenome, String massarid,String gmail,String dateofbirth) async {
    final db = await database;
    final values = <String, dynamic>{
      ETUDIANT_NOM: name,
      ETUDIANT_PRENOM: prenome,
      ETUDIANT_MASSAR_ID: massarid,
      ETUDIANT_GMAIL: gmail,
      ETUDIANTE_DATE:dateofbirth,
    };
    return await db?.update(
      TABLE_ETUDIANT,
      values,
      where: '$ETUDIANT_ID = ?',
      whereArgs: [sid],
    );
  }


  Future<void> deleteEtudiant(int studentId) async {
    final db = await database;
    await db?.delete(
      DBHelper.TABLE_ETUDIANT,
      where: '$ETUDIANT_ID = ?',
      whereArgs: [studentId],
    );
  }

  Future<void> deleteEnseignant(int enseignantId) async {
    final db = await database;
    await db?.delete(
      DBHelper.TABLE_ENSEIGNANT,
      where: '$ENSEIGNANT_ID = ?',
      whereArgs: [enseignantId],
    );
  }
  Future<void> deleteFilier(int filierid) async {
    final db = await database;
    await db?.delete(
      DBHelper.TABLE_FILIER,
      where: '$FILIER_ID = ?',
      whereArgs: [filierid],
    );
  }

  Future<int?> insertFonctionnaire(Map<String, dynamic> row) async {
    final db = await database;
    return await db?.insert(TABLE_FONCTIONNAIRE, row);
  }

  Future<List<Map<String, dynamic>>?> queryAllFonctionnaires() async {
    final db = await database;
    return await db?.query(TABLE_FONCTIONNAIRE);
  }

  Future<int?> updateFonctionnaire(Map<String, dynamic> row) async {
    final db = await database;
    final id = row[FONCTIONNAIRE_ID];
    return await db?.update(TABLE_FONCTIONNAIRE, row,
        where: '$FONCTIONNAIRE_ID = ?', whereArgs: [id]);
  }

  Future<int?> deleteFonctionnaire(int id) async {
    final db = await database;
    return await db?.delete(TABLE_FONCTIONNAIRE,
        where: '$FONCTIONNAIRE_ID = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>?> getClassTable() async {
    final db = await database;
    return db?.query(TABLE_CLASSES);
  }

  Future<List<Map<String, dynamic>>?> getModuleTable() async {
    final db = await database;
    return db?.query(TABLE_MODULE);
  }

  Future<List<Map<String, dynamic>>> getElementTable() async {
    final db = await database;
    return db!.query(TABLE_ELEMENT);
  }

    Future<List<Map<String, dynamic>>> getEnseignantElementTable(
      int enseignant) async {
    final db = await database;
    return db!.query(TABLE_ENSEIGNANT_ELEMENT);
  }

  Future<List<Map<String, dynamic>>?> getAllEnseignantTable() async {
    final db = await database;
    return db?.query(TABLE_ENSEIGNANT);
  }

  Future<List<Map<String, dynamic>>?> getALLEtudianteTable() async {
    final db = await database;
    return db?.query(TABLE_ETUDIANT);
  }

  Future<List<Map<String, dynamic>>?> getEtudianteTable(
      {int? filiereId}) async {
    final db = await database;
    if (filiereId != null) {
      return await db?.query(TABLE_ETUDIANT,
          where: '$FILIER_ID = ?', whereArgs: [filiereId]);
    } else {
      return await db?.query(TABLE_ETUDIANT);
    }
  }

  Future<int?> deleteSeance(int cid) async {
    final db = await database;
    return db?.delete(TABLE_CLASSES, where: '$SEANCE_ID = ?', whereArgs: [cid]);
  }

  Future<int?> deleteEtudiante(int sid) async {
    final db = await database;
    return db
        ?.delete(TABLE_ETUDIANT, where: '$ETUDIANT_ID = ?', whereArgs: [sid]);
  }

  Future<int?> deleteModule(int moduleId) async {
    final db = await database;
    return db
        ?.delete(TABLE_MODULE, where: '$MODULE_ID = ?', whereArgs: [moduleId]);
  }

  Future<int?> deleteElement(int elementId) async {
    final db = await database;
    return db?.delete(TABLE_ELEMENT,
        where: '$ELEMENT_ID = ?', whereArgs: [elementId]);
  }

    Future<String> getModuleName(int moduleId) async {
    final db = await database;
    List<Map<String, dynamic>>? results = await db?.rawQuery('''
      SELECT $MODULE_NAME
      FROM $TABLE_MODULE
      WHERE $MODULE_ID = ?
    ''', [moduleId]);
    if (results?.isNotEmpty ?? false) {
      return results?.first[MODULE_NAME] as String;
    } else {
      return '';
    }
  }

  Future<int> insertAttendanceHistory({
    required int classID,
    required String date,
    required int presentCount,
    required int absentCount,
    required int filierid,
    required int enseignantId,
  }) async {
    try {
      final db = await database;
      int id = await db!.insert(
        TABLE_ATTENDANCE_HISTORY,
        {
          SEANCE_ID: classID,
          ATTENDANCE_HISTORY_DATE: date,
          ATTENDANCE_HISTORY_PRESENT_COUNT: presentCount,
          ATTENDANCE_HISTORY_ABSENT_COUNT: absentCount,
          FILIER_ID: filierid,
          ENSEIGNANT_ID: enseignantId,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return id;
    } catch (e) {
      print('Error inserting into AttendanceHistory table: $e');
      return -1; // or throw an appropriate exception
    }
  }

  Future<int> authenticateEnseignant(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      TABLE_ENSEIGNANT,
      where: '$ENSEIGNANT_EMAIL = ? AND $ENSEIGNANT_MOT_DE_PASSE = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return maps.first[ENSEIGNANT_ID];
    }

    return -1; // Enseignant not found
  }

  Future<bool> enseignantExists(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      TABLE_ENSEIGNANT,
      where: '$ENSEIGNANT_EMAIL = ?',
      whereArgs: [email],
    );

    return maps.isNotEmpty;
  }

  Future<int> authenticateFonctionnaire(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      TABLE_FONCTIONNAIRE,
      where: '$FONCTIONNAIRE_EMAIL = ? AND $FONCTIONNAIRE_MOT_DE_PASSE = ?',
      whereArgs: [email, password],
    );

    if (maps.isNotEmpty) {
      return maps.first[FONCTIONNAIRE_ID];
    }

    return -1; // Fonctionnaire not found
  }

  Future<void> printEnseignantDetails(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      TABLE_ENSEIGNANT,
      where: '$ENSEIGNANT_EMAIL = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      print('Détails de l\'enseignant:');
      print('ID: ${maps.first[ENSEIGNANT_ID]}');
      print('Nom: ${maps.first[ENSEIGNANT_NOM]}');
      print('Prénom: ${maps.first[ENSEIGNANT_PRENOM]}');
      print('Email: ${maps.first[ENSEIGNANT_EMAIL]}');
      print('CIN: ${maps.first[ENSEIGNANT_CIN]}');
      print('Sexe: ${maps.first[ENSEIGNANT_SEXE]}');
      print('Téléphone: ${maps.first[ENSEIGNANT_PHONENUMBER]}');
      print('Date de naissance: ${maps.first[ENSEIGNANT_DATE]}');
    } else {
      print('Aucun enseignant trouvé avec cet email');
    }
  }

  Future<void> printAllEnseignants() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(TABLE_ENSEIGNANT);

    if (maps.isNotEmpty) {
      print('Liste de tous les enseignants:');
      for (var enseignant in maps) {
        print('\nEnseignant:');
        print('ID: ${enseignant[ENSEIGNANT_ID]}');
        print('Nom: ${enseignant[ENSEIGNANT_NOM]}');
        print('Prénom: ${enseignant[ENSEIGNANT_PRENOM]}');
        print('Email: ${enseignant[ENSEIGNANT_EMAIL]}');
        print('CIN: ${enseignant[ENSEIGNANT_CIN]}');
        print('Sexe: ${enseignant[ENSEIGNANT_SEXE]}');
        print('Téléphone: ${enseignant[ENSEIGNANT_PHONENUMBER]}');
        print('Date de naissance: ${enseignant[ENSEIGNANT_DATE]}');
      }
    } else {
      print('Aucun enseignant trouvé dans la base de données');
    }
  }

  Future<bool> fonctionnaireExists(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      TABLE_FONCTIONNAIRE,
      where: '$FONCTIONNAIRE_EMAIL = ?',
      whereArgs: [email],
    );

    return maps.isNotEmpty;
  }

  Future<void> printFonctionnaireDetails(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(
      TABLE_FONCTIONNAIRE,
      where: '$FONCTIONNAIRE_EMAIL = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      print('Détails du fonctionnaire:');
      print('ID: ${maps.first[FONCTIONNAIRE_ID]}');
      print('Nom: ${maps.first[FONCTIONNAIRE_NOM]}');
      print('Prénom: ${maps.first[FONCTIONNAIRE_PRENOM]}');
      print('Email: ${maps.first[FONCTIONNAIRE_EMAIL]}');
      print('CIN: ${maps.first[FONCTIONNAIRE_CIN]}');
      print('Sexe: ${maps.first[FONCTIONNAIRE_SEXE]}');
      print('Téléphone: ${maps.first[FONCTIONNAIRE_PHONENUMBER]}');
      print('Date de naissance: ${maps.first[FONCTIONNAIRE_DATE]}');
    } else {
      print('Aucun fonctionnaire trouvé avec cet email');
    }
  }

  Future<void> printAllFonctionnaires() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db!.query(TABLE_FONCTIONNAIRE);

    if (maps.isNotEmpty) {
      print('Liste de tous les fonctionnaires:');
      for (var fonctionnaire in maps) {
        print('\nFonctionnaire:');
        print('ID: ${fonctionnaire[FONCTIONNAIRE_ID]}');
        print('Nom: ${fonctionnaire[FONCTIONNAIRE_NOM]}');
        print('Prénom: ${fonctionnaire[FONCTIONNAIRE_PRENOM]}');
        print('Email: ${fonctionnaire[FONCTIONNAIRE_EMAIL]}');
        print('CIN: ${fonctionnaire[FONCTIONNAIRE_CIN]}');
        print('Sexe: ${fonctionnaire[FONCTIONNAIRE_SEXE]}');
        print('Téléphone: ${fonctionnaire[FONCTIONNAIRE_PHONENUMBER]}');
        print('Date de naissance: ${fonctionnaire[FONCTIONNAIRE_DATE]}');
      }
    } else {
      print('Aucun fonctionnaire trouvé dans la base de données');
    }
  }

  Future<Map<String, dynamic>> getFonctionaireDetailsById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      TABLE_FONCTIONNAIRE,
      where: '$FONCTIONNAIRE_ID = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    throw Exception('Fonctionnaire not found');
  }
}
