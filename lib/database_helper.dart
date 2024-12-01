import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  Database? _db;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_db != null) {
      return _db!; 
    }

    if (kIsWeb) {
      _db = await databaseFactoryMemory.openDatabase('repos.db');
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(appDir.path, 'repos.db');
      _db = await databaseFactoryIo.openDatabase(dbPath);
    }
    return _db!;
  }

  Future<void> insertRepo(Map<String, dynamic> repo) async {
    final db = await database;  
    final store = intMapStoreFactory.store('repos');  
    await store.add(db, repo);  
  }

  Future<List<Map<String, dynamic>>> getRepos() async {
    final db = await database;  
    final store = intMapStoreFactory.store('repos');  
    final records = await store.find(db);  
    return records.map((record) => record.value).toList(); 
  }
}
