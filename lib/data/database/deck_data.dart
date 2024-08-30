import 'dart:convert';

import 'package:small_world/data/database/card_data_info.dart';

class DeckData{

  int? id;
  String name;
  List<CardInfo> cards;

  DeckData({
    this.id,
    required this.name,
    required this.cards,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cards': jsonEncode(cards.map((card) => card.toMap()).toList()),
    };
  }

  factory DeckData.fromMap(Map<String, dynamic> map) {
    return DeckData(
      id: map['id'],
      name: map['name'],
      cards: (jsonDecode(map['cards']) as List<dynamic>)
        .map((cardMap) => CardInfo.fromMap(cardMap as Map<String, dynamic>))
        .toList(),
    );
  }

}