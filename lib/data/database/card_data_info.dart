import 'dart:convert';

class CardInfo {
  int? id; // 널 가능 자료형
  String name;
  String attribute;
  List<String> properties;
  String effectText;
  int level;
  int atk;
  int def;

  // 생성자
  CardInfo({
    this.id,
    required this.name, // 널 세이프티가 적용되지 않은 필드에 대해선 required로 선언되어야 함
    required this.attribute,
    required this.properties,
    required this.effectText,
    required this.level,
    required this.atk,
    required this.def,
  });

  // db 저장하기 위해 Map으로 변환하는 메서드
  // 맵은 파이썬의 딕셔너리와도 같음
  Map<String, dynamic> toMap() {
    return {
      'id': id, // 필드와 키값으로 이루어짐
      'name': name,
      'attribute': attribute,
      // 'properties': jsonEncode(properties),  
      'properties': properties.join(', '), // 리스트 형태를 문자열로 변환
      'effectText': effectText,
      'level': level,
      'atk': atk,
      'def': def,
    };
  }

  // Map으로부터 객체 생성 (불러올 때 사용)
  factory CardInfo.fromMap(Map<String, dynamic> map) {
    return CardInfo(
      id: map['id'], // map 객체의 각 필드 값으로 인스턴스 생성
      name: map['name'],
      attribute: map['attribute'],
      properties: map['properties'].toString().split(', '), // 세퍼레이터를 기준으로 다시 문자열을 리스트화
      // properties: List<String>.from(jsonDecode(map['properties'])),
      effectText: map['effectText'],
      level: map['level'],
      atk: map['atk'],
      def: map['def'],
    );
  }

  //
}
