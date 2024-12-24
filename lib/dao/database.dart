import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../utils/utils.dart';

const CREATE_STOCK_SQL = '''
CREATE TABLE "stock" (
  "stock_id" INTEGER NOT NULL,
  "code" TEXT,
  "currentPrice" TEXT,
  "highestPrice" TEXT,
  "lowestPrice" TEXT,
  "volume" TEXT,
  "turnover" TEXT,
  "closingPrice" DATE,
  PRIMARY KEY ("stock_id")
);
''';



class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.windows:
        sqfliteFfiInit();
        var databaseFactory = databaseFactoryFfi;
        var databasePath = (await getApplicationSupportDirectory()).path;
        final path = join(databasePath, 'app_database.db');
        logPrint('数据库路径:: $path');

        return await databaseFactory.openDatabase(
          path,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) async {
              onUpgradeDatabase(db, 0, version);
            },
            onUpgrade: onUpgradeDatabase,
          ),
        );
      default:
        throw Exception('Unsupported platform');
    }
  }


  void onUpgradeDatabase(Database db, int oldVersion, int newVersion) async {
    logPrint( 'onUpgradeDatabase:: $oldVersion -> $newVersion');

    switch (oldVersion) {
      case 0:
        await db.execute(CREATE_STOCK_SQL);
    }


  }
}
