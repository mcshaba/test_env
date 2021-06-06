import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'model/save_ocr.dart';

class LocalOCRDb {
  /// File path to a file in the current directory
  DatabaseFactory dbFactory = databaseFactoryIo;

/// We use the database factory to open the database
  Database _db;
  /// dynamically typed store
  final store = intMapStoreFactory.store('ocr_table');


  static LocalOCRDb _singleton = LocalOCRDb._internal();

  factory LocalOCRDb(){
    return _singleton;
  }
  LocalOCRDb._internal();

  Future<Database> init() async {
    if(_db == null){
      _db = await _openDb();
    }
    return _db;
  }
  Future _openDb() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docsDir.path, 'envision.db');
    _db = await dbFactory.openDatabase(dbPath, );//codec: codec
    return _db;
  }


  Future<int> addEventsToDb(SaveOcrModel model) async {
    await init();
    int id = await store.add(_db, model.toJson());
    return id;
  }

  Future getEventFromDb() async {
    await init();
    final finder = Finder(sortOrders: [SortOrder("timestamp")]);
    final snapshot = await store.find(_db, finder: finder);

    return snapshot.map((eventItem) {
      final event = SaveOcrModel.fromJson(eventItem.value);
      event.id = eventItem.key;
      return event;
    }).toList();
  }

  Future<int> updateEvent(SaveOcrModel event) async {
    final finder = Finder(filter: Filter.byKey(event.id));
    int result = await store.update(_db, event.toJson(), finder: finder);
    return result;
  }

  Future<int> deleteEvent(SaveOcrModel event) async {
    final finder = Finder(filter: Filter.byKey(event.id));
    int result = await store.delete(_db, finder: finder);
    return result;
  }

  Future<int> findPosition() async {
    final finder = Finder(sortOrders: [SortOrder("timestamp")]);
    final snapshot = await store.find(_db, finder: finder);
    int position = snapshot.first.value.values.first;
    position = (position == null) ? 0 : ++position;
    return position;
  }
  Future updatePosition(bool increment, int start, int end) async {
    final finder = Finder(sortOrders: [SortOrder("timestamp")]);
    final snapshot = await store.find(_db, finder: finder);
    int position = snapshot.first.value.values.first;
    position = (position == null) ? 0 : ++position;
    return position;
  }

  Future deleteAll() async {
    await store.delete(_db);
  }
}

LocalOCRDb db = LocalOCRDb();
