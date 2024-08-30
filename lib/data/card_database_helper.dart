import 'package:flutter/services.dart'; // For rootBundle
import 'package:path/path.dart';
import 'package:small_world/data/database/card_data_info.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'dart:async';

class DatabaseHelper {
  late Database database;

  Future<void> initDatabase() async {
    try {
      // 앱의 로컬 데이터베이스 디렉토리 경로를 가져옵니다.
      String path = join(await getDatabasesPath(), 'card_archive.db');

      // 데이터베이스 파일이 로컬에 존재하지 않으면, assets에서 복사합니다.
      if (!await io.File(path).exists()) {
        // assets에서 데이터베이스 파일을 읽습니다.
        final data = await rootBundle.load('assets/database/card_archive.db');
        final bytes = data.buffer.asUint8List();

        // 로컬 저장소에 데이터베이스 파일을 씁니다.
        await io.File(path).writeAsBytes(bytes);
        print('Database copied from assets to local storage.');
      } else {
        print('Database already exists at path: $path');
      }

      // 데이터베이스를 엽니다.
      database = await openDatabase(
        path,
        version: 1,
        // 데이터베이스가 처음 생성될 때의 테이블 생성 로직 (필요 시)
        onCreate: (db, version) {
          // 필요한 경우 테이블 생성 로직을 여기에 추가
        },
      );

      print('Database opened successfully at path: $path');
      
    } catch (e) {
      print('Failed to open database: $e');
    }
  }

  Future<List<CardInfo>> getAllCardInfo() async {
    final List<Map<String, dynamic>> result = await database.query('cards');
    return List.generate(result.length, (index) {
      return CardInfo.fromMap(result[index]);
    });
  }

  Future<int> updateCardInfo(CardInfo card) async {
    return await database.update(
      'cards',
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<void> closeDatabase() async {
    await database.close();
    print('Database closed successfully.');
  }
}
