import 'dart:convert';

class CardInfo {
  int? id;
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
    required this.name,
    required this.attribute,
    required this.properties,
    required this.effectText,
    required this.level,
    required this.atk,
    required this.def,
  });

  // Map으로 변환 (저장할 때 사용)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'attribute': attribute,
      // 'properties': jsonEncode(properties),  
      'properties': properties.join(', '),
      'effectText': effectText,
      'level': level,
      'atk': atk,
      'def': def,
    };
  }

  // Map으로부터 객체 생성 (불러올 때 사용)
  factory CardInfo.fromMap(Map<String, dynamic> map) {
    return CardInfo(
      id: map['id'],
      name: map['name'],
      attribute: map['attribute'],
      // properties 필드가 단순 문자열일 경우 쉼표(,)로 분리
      properties: map['properties'].toString().split(', '), 
      // properties: List<String>.from(jsonDecode(map['properties'])),
      effectText: map['effectText'],
      level: map['level'],
      atk: map['atk'],
      def: map['def'],
    );
  }
}
