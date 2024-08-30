import 'package:path/path.dart';
import 'package:small_world/data/database/deck_data.dart';
import 'package:sqflite/sqflite.dart';

class DeckDatabaseHelper{

  late Database database;

  Future<void> initDatabase() async {

    String path = join(await getDatabasesPath(), 'deck_archive.db');

    database = await openDatabase(path, version: 1, onCreate: (db, version){ // 데이터베이스를 사용하기 위해 open하며, 존재하지 않을 경우 생성

      db.execute(''' 
      CREATE TABLE IF NOT EXISTS tb_deck (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        cards TEXT
      )
      ''');
    },);
  }

  Future<int> insertDeckData(DeckData deck) async { // IdeaInfo 인스턴스를 받아 Map 객체로 변환 후 데이터베이스에 삽입
    return await database.insert('tb_deck', deck.toMap());
  }

  Future<List<DeckData>> getAllDeckData() async {
    final List<Map<String, dynamic>> result = await database.query('tb_deck');
    return List.generate(result.length, (index) {
      return DeckData.fromMap(result[index]);
    });
  }

  Future<int> deleteDeckData(int id) async {
    return await database.delete(
      'tb_deck', // 변경할 테이블
      where: "id = ?", // 검색 조건
      whereArgs: [id], // 검색 값
      );
  }

  Future<int> updateDeckData(DeckData deck) async {
    return await database.update(
      'tb_deck', // 업데이트할 테이블
      deck.toMap(), // 새로 업데이트할 데이터
      where: "id = ?", // id가 특정 값인 레코드를 찾는 조건
      whereArgs: [deck.id], // 새로 업데이트하는 레코드의 id
      );
  }

}