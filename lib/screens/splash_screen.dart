import 'package:flutter/material.dart';

// 정적인 페이지이므로 stl 위젯 사용
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // 페이지 이동 로직
    Future.delayed(Duration(seconds: 2), // 2초 대기 후 함수 실행
    (){
      Navigator.pushReplacementNamed(context, '/main'); // 메인 화면 이동
    });

    return Scaffold(
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [

            // Image.asset('assets/images/small_world.png'),

            Container(

              child: Text("small world", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
          ],
        ),
      )
    );
  }
}