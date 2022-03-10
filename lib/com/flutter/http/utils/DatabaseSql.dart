import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///数据库做缓存sqlite
class DatabaseSql {
  static late Database database;
  static bool isDatabaseReady = false;
  static int dbVersion = 1;
  static String dbName = "httpCache.db";
  static String dbTableName = "HttpCache";

  // 初始化
  static Future<void> initDatabase() async {
    if (!isDatabaseReady) {
      String databasePath = await createDatabase();
      Database database = await openCacheDatabase(databasePath);
      DatabaseSql.database = database;
      isDatabaseReady = true;
      print("====数据库初始化完毕==>");
    }
  }

  //创建数据库
  static Future<String> createDatabase() async {
    //获取数据库基本路径
    var databasePath = await getDatabasesPath();
    //创建数据的表名
    return join(databasePath, dbName);
  }

  //删除数据库
  static delDB() async {
    createDatabase().then((path) => {deleteDatabase(path)});
  }

  //删除表
  static Future clearData(Database db) async {
    await database
        .rawQuery('SELECT * FROM $dbTableName limit 1')
        .then((list) => {closeDb(db, list)});
  }

  //删除表并关闭数据库
  static Set<Map<String, dynamic>> closeDb(
      Database db, List<Map<String, dynamic>> list) {
    if (list.length > 0) {
      db.execute('DROP TABLE $dbTableName');
      db.close();
      deleteDatabase(db.path);
    }
    return new Set<Map<String, dynamic>>();
  }

  //打开数据库
  static Future<Database> openCacheDatabase(String paths) async {
    Database database =
        await openDatabase(paths, singleInstance: false, version: dbVersion,
            //如果没有表则创建表
            onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE If Not Exists $dbTableName (cacheKey TEXT PRIMARY KEY ,value TEXT)');
    }, //如果表存在则直接打开
            onOpen: (Database db) async {
      await db.execute(
          'CREATE TABLE If Not Exists $dbTableName (cacheKey TEXT PRIMARY KEY ,value TEXT)');
    });
    return database;
  }

  //关闭数据库
  static closeDatabase(Database db) async {
    return db.close();
  }

  /*
   * 查询 单条数据
   */
  static Future<String> queryHttp(Database database, String cacheKey) async {
    return await database
        .rawQuery('SELECT value FROM $dbTableName WHERE cacheKey = \'' +
            cacheKey +
            "\'")
        .then((value) {
      if (value.length > 0) {
        return value.first.values.first.toString();
      } else {
        return "";
      }
    });
  }

  /*
   * 查询
   */
  static Future<List<Map<String, dynamic>>> queryAll(
      Database database, String cacheKey) async {
    return await database.rawQuery(
        'SELECT value FROM $dbTableName WHERE cacheKey = \'' + cacheKey + "\'");
  }

  /*
   * 插入
   */
  static Future<int> insertHttp(
      Database database, String cacheKey, String value) async {
    cacheKey = cacheKey.replaceAll("\"", "\"\"");
    return await database.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO $dbTableName(cacheKey, value) VALUES( \'' +
              cacheKey +
              '\', \'' +
              value +
              '\')');
    });
  }

  /*
   * 更新
   */
  static Future<int> updateHttp(
      Database? database, String cacheKey, String value) async {
    cacheKey = cacheKey.replaceAll("\"", "\\\"");
    return await database!.rawUpdate('UPDATE $dbTableName SET '
            ' value = \'' +
        value +
        '\' WHERE '
            'cacheKey = \'' +
        cacheKey +
        '\'');
  }

  /*
   * 删除
   */
  static Future<int> deleteHttpCache(
      Database? database, String cacheKey) async {
    return await database!.rawDelete(
        'DELETE FROM $dbTableName WHERE name = \'' + cacheKey + '\'');
  }
}
