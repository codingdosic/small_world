import 'package:flutter/material.dart';
import 'package:small_world/data/database/card_data_info.dart';
import 'package:small_world/data/database/deck_data.dart';
import 'package:small_world/screens/detail_screen.dart';
import 'package:small_world/screens/edit_screen.dart';
import 'package:small_world/screens/main_screen.dart';
import 'package:small_world/screens/route_screen.dart';
import 'package:small_world/screens/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      // 디버그 라벨 제거
      debugShowCheckedModeBanner: false,

      // 앱 이름
      title: "smallWorld",

      // 초기 화면
      initialRoute: '/',

      // 경로 지정
      routes: {
        '/': (context) { return const SplashScreen(); },
        '/main' : (context) { return const MainScreen(); }
      },

      // 동적 경로 생성
      onGenerateRoute: (settings){

        // 덱 세부사항 화면
        if(settings.name == '/detail'){

          // 호출시 필요한 매개변수 타입
          DeckData deck = settings.arguments as DeckData;

          // 매개변수를 가지고 페이지 호출
          return MaterialPageRoute(builder: (context){
            return DetailScreen(deck: deck);
          });

        }

        // 덱 편집 화면
        else if(settings.name == '/edit'){

          // 매개변수 타입 지정
          List<dynamic> cards = settings.arguments as List<dynamic>;

          // 페이지 호출
          return MaterialPageRoute(builder: (context){
              return EditScreen(cards: cards,);
            });
        }

        // 루트 화면
        else if(settings.name == '/route'){

          // 매개변수 타입 지정
          List<dynamic> cardData = settings.arguments as List<dynamic>;

          // 페이지 호출
          return MaterialPageRoute(builder: (context){
            return RouteScreen(cardData: cardData,);
          });
        }
      },

    );
    
  }

  
}
