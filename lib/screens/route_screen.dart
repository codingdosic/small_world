import 'package:flutter/material.dart';
import 'package:small_world/data/database/card_data_info.dart';

class RouteScreen extends StatefulWidget {

  List<dynamic> cardData;

  RouteScreen({super.key, required this.cardData});

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {

  ShapeDecoration border = ShapeDecoration(shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)));
  
  @override
  Widget build(BuildContext context) {

    String initialStartMonsterName = widget.cardData[0];
    String initialEndMonsterName = widget.cardData[1];
    List<CardInfo> selectedCardInfo = widget.cardData[2];
    
    List<List<String>> foundedRoute = findSearchRoute(initialStartMonsterName, initialEndMonsterName, selectedCardInfo);
    foundedRoute.sort((a, b) => a[0].compareTo(b[0]));

    return Scaffold(

      appBar: AppBar(
        title: Text("발견한 루트: ${foundedRoute.length}가지"),
        // actions: [
        //   IconButton(onPressed: (){
        //     Navigator.pushReplacementNamed(context, '/edit', arguments: selectedCardInfo);
        //   }, 
        //   icon: Icon(Icons.add))
        // ],
      ),

      body: Container(

        margin: EdgeInsets.all(5),

        child: Column(
        
          children: [
        
            Column(
                  
                    children: [
                  
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                                          
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          
                          children: [
                                          
                            Text("시작하는 몬스터: "),
                                          
                            Text(initialStartMonsterName, style: TextStyle(fontSize: 12),)
                                          
                          ],
                        ),
                      ),
                  
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                                          
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          
                          children: [
                            
                            Text("도착하는 몬스터: "),
                                          
                            Text(initialEndMonsterName, style: TextStyle(fontSize: 12))
                                          
                          ],
                        ),
                      ),
                  
                    ],
                  ),
        
            Expanded(
        
              child: ListView.builder(
              
                itemCount: foundedRoute.length,
              
                itemBuilder: (context, index){
                  return listItem(foundedRoute[index]); 
                }
                
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listItem(List<String> route){

    String start = route[0];
    String middle = route[1];
    String end = route[2];

    return Container(
      height: 50,
      decoration: border,
      margin: EdgeInsets.all(5),
    
      child: Center(
        
        child: Text('${start} > ${middle} > ${end}', style: TextStyle(fontSize: 10),)));
    }


  List<dynamic> makeList(CardInfo card){
    return [card.atk, card.def, card.properties[0], card.level, card.attribute];
  }
      

  List<List<String>> findSearchRoute(String start, String end, List<CardInfo> lstCard) {
    
    List<List<String>> foundedRoute = [];

    // 출발과 도착 몬스터 모두가 주어진 경우
    if(start != 'null' && end != "null"){

      CardInfo startMonster = lstCard.firstWhere((card) => card.name == start);
      CardInfo endMonster = lstCard.firstWhere((card) => card.name == end);

      // 시작 몬스터의 공/수, 종족, 레벨, 속성을 리스트로
      List<dynamic> startInfo = makeList(startMonster);
      List<dynamic> endInfo = makeList(endMonster);

      lstCard.forEach((card){

        if(card.name != start && card.name != end){

          List<dynamic> middleInfo = makeList(card);
          // 교집합이 하나인 카드 정보를 찾음
          int lengthA = startInfo.toSet().intersection(middleInfo.toSet()).length;

          if(lengthA == 1){
            int lengthB = endInfo.toSet().intersection(middleInfo.toSet()).length;
            if(lengthB == 1){
              List<String> route = [start, card.name, end];
              foundedRoute.add(route);
            }
          }
        }

      });

    }
    else if(start == "null" && end != 'null'){

      CardInfo endMonster = lstCard.firstWhere((card) => card.name == end);
      List<dynamic> endInfo = makeList(endMonster);

      lstCard.forEach((middleCard){
        if(middleCard.name != end){
          List<dynamic> middleInfo = makeList(middleCard);
          int lengthA = endInfo.toSet().intersection(middleInfo.toSet()).length;
          if(lengthA == 1){
            lstCard.forEach((startCard){
              if(startCard.name != middleCard && startCard.name != end){
                List<dynamic> startInfo = makeList(startCard);
                int lengthB = startInfo.toSet().intersection(middleInfo.toSet()).length;
                if(lengthB == 1){
                  List<String> route = [startCard.name, middleCard.name, end];
                  foundedRoute.add(route);
                }
              }
            });
          }
        }
      });
      
    }

    else if(start != "null" && end == 'null'){

      CardInfo startMonster = lstCard.firstWhere((card) => card.name == start);
      List<dynamic> startInfo = makeList(startMonster);

      lstCard.forEach((middleCard){
        if(middleCard.name != start){
          List<dynamic> middleInfo = makeList(middleCard);
          int lengthA = startInfo.toSet().intersection(middleInfo.toSet()).length;
          if(lengthA == 1){
            lstCard.forEach((endCard){
              if(endCard.name != middleCard && endCard.name != start){
                List<dynamic> endInfo = makeList(endCard);
                int lengthB = endInfo.toSet().intersection(middleInfo.toSet()).length;
                if(lengthB == 1){
                  List<String> route = [start, middleCard.name, endCard.name];
                  foundedRoute.add(route);
                }
              }
            });
          }
        }
      });
      
    }

    return foundedRoute;

  }

}