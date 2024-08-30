import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:small_world/data/database/card_data_info.dart';
import 'package:small_world/data/card_database_helper.dart';

class EditScreen extends StatefulWidget {

  List<dynamic> cards;

  EditScreen({super.key, required this.cards});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

  ShapeDecoration border = ShapeDecoration(shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)));

  List<String> elementList = ['어둠', '빛', '땅', '물', '화염', '바람', '신'];
  List<bool> selectedElement = List.generate(7, (index) => false);
  List<String> typeList = ['마법사족', '드래곤족', '언데드족', '전사족', '야수전사족', '야수족', '비행야수족', '악마족', '천사족', '곤충족', '공룡족', '파충류족', '어류족', '해룡족', '물족', '화염족', '번개족', '암석족', '식물족', '기계족', '사이킥족', '환신야수족', '환룡족', '사이버스족', '환상마족'];
  List<bool> selectedType = List.generate(25, (index) => false);
  List<String> classList = ['일반', '효과', '의식', '툰', '스피릿', '유니온', '듀얼', '튜너', '리버스', '펜듈럼', '특수 소환'];
  List<bool> selectedClass = List.generate(11, (index) => false);
  List<bool> selectedLv = List.generate(12, (index) => false);

  var dbHelper = DatabaseHelper();
  List<CardInfo> lstCardInfo = [];
  List<CardInfo> selectedCardInfo = [];
  List<CardInfo> backupCardInfo = [];
  List<CardInfo> middleCardInfo = [];

  TextEditingController searchController = TextEditingController();

  // false일 때 or
  bool andOrisClicked = true;
  bool isMiddleRoute = false;

  @override
  void initState() {
    super.initState();

    // initState를 비동기로 만들기 위해 async 사용
    initAsync();
  }

  Future<void> initAsync() async {
    await getCardInfo();

    selectedCardInfo = [];
    selectedCardInfo = widget.cards[0];

    if (widget.cards[1] != 'null') {
      isMiddleRoute = true;

      middleCardInfo = findMiddleRoute(widget.cards[1], widget.cards[2]);
      // print(result.length);
      lstCardInfo = middleCardInfo;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: Drawer(
        child: ListView.builder(

          itemCount: selectedCardInfo.length+1,

          itemBuilder: (context, index){
            if(index == 0){
              return Container(
                height: 70,
                child: DrawerHeader(
                  child: Text("추가된 카드")
                ),
              );
            }
            return drawerItem(index-1);
          }
        ),
      ),

      appBar: AppBar(

        title: Text(isMiddleRoute ? "중간다리 추가하기" : '카드 추가하기'),

        actions: [
          // IconButton(
            
          //   onPressed: 

          //   (){
          //     showDialog(context: context, builder: (context){

          //       return StatefulBuilder(builder: (context, setState){

          //         return AlertDialog(

          //           title: Text("정렬 기준"),

          //           content: Column(
                      
          //             children: [

          //               Row(

          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          
          //                 children: [
          //                   Text('카드 이름 : '),
          //                   GestureDetector(
          //                     onTap: (){

          //                     }, 
          //                     child: Text('오름차순')
          //                   ),
          //                   GestureDetector(
          //                     onTap: (){

          //                     }, 
          //                     child: Text('내림차순')
          //                   ), 
          //                 ],
          //               ),

          //               Row(

          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,

          //                 children: [
          //                   Text('레벨 / 랭크 : '),
          //                   GestureDetector(
          //                     onTap: (){

          //                     }, 
          //                     child: Text('낮은 순서')
          //                   ),
          //                   GestureDetector(
          //                     onTap: (){

          //                     }, 
          //                     child: Text('높은 순서')
          //                   ), 
          //                 ],
          //               ),

          //               Row(

          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,

          //                 children: [
          //                   Text('ATK : '),
          //                   GestureDetector(
          //                     onTap: (){

          //                     }, 
          //                     child: Text('낮은 순서')
          //                   ),
          //                   GestureDetector(
          //                     onTap: (){

          //                     }, 
          //                     child: Text('높은 순서')
          //                   ), 
          //                 ],
          //               ),

          //               Row(

          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,

          //                 children: [
          //                   Text('DEF : '),
          //                   GestureDetector(
          //                     onTap: (){

          //                     }, 
          //                     child: Text('낮은 순서')
          //                   ),
          //                   GestureDetector(
          //                     onTap: (){

          //                     }, 
          //                     child: Text('높은 순서')
          //                   ), 
          //                 ],
          //               ),

          //             ],),

          //         );
          //       },);
          //     });
          //   }, 
          //   icon: Icon(Icons.unfold_more, color: Colors.black,),

          // ),

          IconButton(

            onPressed: 
            (){

              showDialog(context: context, builder: (context){

                return StatefulBuilder(builder: (context, setState){

                  return AlertDialog(

                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("카드 조건"),
                        TextButton(onPressed: (){
                          initializeSelectedButton();
                          andOrisClicked = true;
                          setState((){

                          });
                        },
                        child: Text("초기화", style: TextStyle(color: Colors.red),))
                      ],
                    ),

                    actions: [

                      TextButton(onPressed: (){ // 팝업창 취소 버튼
                          Navigator.of(context).pop(); // 팝업창 닫음
                        }, 
                        // 취소 버튼 텍스트
                        child: Text("취소", style: TextStyle(color: Colors.red),)),

                      TextButton(onPressed: () { // 팝업창 삭제 버튼
                        if(context.mounted){ // 처리가 완료될 시 실행
                          Navigator.of(context).pop(); // 팝업창 닫기
                        }}, 
                        child: Text("확인", style: TextStyle(color: Colors.blue),))
                        ],

                    content: SingleChildScrollView(

                      child: Column(
                      
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                        
                          Text('속성'),
                          SizedBox(height: 10,),
                          SizedBox(
                          
                            // height: 100,
                            width: double.maxFinite,

                            child: GridView.count(
                            
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 4,
                              mainAxisSpacing: 8.0, // 아이템들 간의 세로 간격
                              crossAxisSpacing: 8.0,
                              childAspectRatio: 2 / 1,
                              shrinkWrap: true,  

                              children: List.generate(7, (index){
                                return InkWell(

                                  onTap: (){
                                    setState(() {
                                      selectedElement[index] = !selectedElement[index];
                                    });
                                  },

                                  child: Container(

                                    decoration: ShapeDecoration(color: selectedElement[index] ? Colors.blue : Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10))),
                                    alignment: Alignment.center,

                                    child: Text('${elementList[index]}', style: TextStyle(fontSize: 12, color: selectedElement[index] ? Colors.white : Colors.black,),),
                                  ),
                                );
                              }
                            )

                            ),
                          ),
                          SizedBox(height: 20,),

                          Text('종족'),
                          SizedBox(height: 10,),
                          SizedBox(
                          
                            // height: 300,
                            width: double.maxFinite,

                            child: GridView.count(
                            
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 4,
                              mainAxisSpacing: 8.0, // 아이템들 간의 세로 간격
                              crossAxisSpacing: 8.0,
                              childAspectRatio: 2 / 1,
                              shrinkWrap: true, 

                              children: List.generate(25, (index){
                                return GestureDetector(

                                  onTap: (){
                                    setState((){
                                      selectedType[index] = !selectedType[index];
                                    });
                                  },

                                  child: Container(

                                    decoration: ShapeDecoration(color: selectedType[index] ? Colors.blue : Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10))),
                                    alignment: Alignment.center,

                                    child: Text('${typeList[index]}', style: TextStyle(fontSize: 10, color: selectedType[index] ? Colors.white : Colors.black)),
                                  ),
                                );
                              }
                            )

                            ),
                          ),
                          SizedBox(height: 20,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('그 외 항목'),
                              TextButton(onPressed: (){
                                setState((){
                                  andOrisClicked = !andOrisClicked;
                                });
                              }, 
                              child: andOrisClicked ? Text("or", style: TextStyle(color: Colors.blue)) : Text("and", style: TextStyle(color: Colors.blue)))
                            ],
                          ),
                          SizedBox(height: 10,),
                          SizedBox(
                          
                            // height: 220,
                            width: double.maxFinite,

                            child: GridView.count(
                            
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 4,
                              mainAxisSpacing: 8.0, // 아이템들 간의 세로 간격
                              crossAxisSpacing: 8.0,
                              childAspectRatio: 2 / 1,
                              shrinkWrap: true, 

                              children: List.generate(11, (index){
                                return GestureDetector(

                                  onTap: (){
                                    setState((){
                                      selectedClass[index] = !selectedClass[index];
                                    });
                                  },

                                  child: Container(

                                    decoration: ShapeDecoration(color: selectedClass[index] ? Colors.blue : Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10))),
                                    alignment: Alignment.center,

                                    child: Text('${classList[index]}', style: TextStyle(fontSize: 10, color: selectedClass[index] ? Colors.white : Colors.black,),),
                                  ),
                                );
                              }
                            )

                            ),
                          ),
                          SizedBox(height: 20,),

                          Text('레벨/랭크'),
                          SizedBox(height: 10,),
                          SizedBox(
                          
                            // height: 120,
                            width: double.maxFinite,

                            child: GridView.count(
                            
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 6,
                              mainAxisSpacing: 8.0, // 아이템들 간의 세로 간격
                              crossAxisSpacing: 8.0,
                              childAspectRatio: 3 / 2,
                              shrinkWrap: true, 

                              children: List.generate(12, (index){
                                return GestureDetector(

                                  onTap: (){
                                    setState((){
                                      selectedLv[index] = !selectedLv[index];
                                    });
                                  },

                                  child: Container(

                                    padding: EdgeInsets.all(1),

                                    decoration: ShapeDecoration(color: selectedLv[index] ? Colors.blue : Colors.white, shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10))),
                                    alignment: Alignment.center,

                                    child: Text('${index+1}', style: TextStyle(fontSize: 10, color: selectedLv[index] ? Colors.white : Colors.black,),),
                                  ),
                                );
                              }
                            )

                            ),
                          ),

                        ],
                    ),
                  ),

                );
                });
              });
            }, 
            icon: Icon(Icons.sort, color: Colors.black,),

          ),
            
          ],

      ),

      body: Container(

        margin: EdgeInsets.all(5),
        
        child: Column(

          children: [
            
            Row(

              children: [

                Expanded(

                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: TextField(

                      onSubmitted:(value) {
                        String searchValue = searchController.text.toString().trim().toLowerCase();

                        if(!isMiddleRoute){
                          lstCardInfo = backupCardInfo;
                        }
                        else{
                          lstCardInfo = middleCardInfo;
                        }

                        if(searchValue != ""){
                          List<CardInfo> filterdCardInfo = lstCardInfo.where((card) => card.name.contains(searchValue) || card.effectText.toLowerCase().contains(searchValue)).toList();
                          lstCardInfo = filterdCardInfo;
                        }
                        setState(() {

                        });
                      },
                      
                      decoration: InputDecoration(
                        hintText: '카드명을 입력하세요',
                        suffixIcon: IconButton(
                          onPressed: (){
                            if(!isMiddleRoute){
                              lstCardInfo = backupCardInfo;
                            }
                            else{
                              lstCardInfo = middleCardInfo;
                            }
                            
                            setState(() {
                              
                            });
                            searchController.clear();

                            },
                          icon: Icon(Icons.clear),
                        )
                      ),
                      controller: searchController,
                      
                    
                    ),
                  ),
                ),

                IconButton(
            
                  onPressed: 
                  (){
                    String searchValue = searchController.text.toString().trim().toLowerCase();
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(searchValue), duration: Duration(seconds: 2),)); 
                    if(!isMiddleRoute){
                      lstCardInfo = backupCardInfo;
                    }
                    else{
                      lstCardInfo = middleCardInfo;
                    }

                    List<dynamic> attributeCondition = selection(selectedElement, elementList);
                    List<dynamic> typeCondition = selection(selectedType, typeList);                                  
                    List<dynamic> levelCondition = selection(selectedLv, [1,2,3,4,5,6,7,8,9,10,11,12]);               
                    List<dynamic> propertyCondition = selection(selectedClass, classList);                                                     

                    // 텍스트 검사
                    List<CardInfo> filterdCardInfo = lstCardInfo.where((card) => card.name.contains(searchValue) || card.effectText.toLowerCase().contains(searchValue)).toList();
                    
                    // 속성 검사
                    if(attributeCondition.isNotEmpty){
                      filterdCardInfo = filterdCardInfo.where((card) => attributeCondition.contains(card.attribute)).toList();
                    }

                    // 종족 검사
                    if(typeCondition.isNotEmpty){
                      filterdCardInfo = filterdCardInfo.where((card) => typeCondition.contains(card.properties[0])).toList();
                    }

                    // 레벨 검사
                    if(levelCondition.isNotEmpty){
                      filterdCardInfo = filterdCardInfo.where((card) => levelCondition.contains(card.level)).toList();
                    }

                    // 그 외 항목 검사
                    if(propertyCondition.isNotEmpty){

                      // or인 경우
                      if(andOrisClicked){
                        filterdCardInfo = filterdCardInfo.where((card) => card.properties.sublist(1).any((item) => propertyCondition.contains(item))).toList();
                      }
                      // and인 경우
                      else {
                        filterdCardInfo = filterdCardInfo.where((card) => propertyCondition.every((item) => card.properties.sublist(1).contains(item))).toList();
                      }
                    }
                    
                    lstCardInfo = filterdCardInfo;

                    setState(() {
                      
                    });
                  }, 
                  icon: Icon(Icons.search, color: Colors.black,),

                  ),
              ],
            ),

            Expanded(

              // 카드 목록
              child: Scrollbar(

                radius: Radius.circular(10),
                thickness: 11,
                interactive: true,
                // controller: ScrollController(),

                child: ListView.builder(
                  
                    itemCount: lstCardInfo.length, // 카드 수만큼 아이템 생성
                  
                    itemBuilder: (context, index){
                      return listItem(index); 
                    }
                    
                  ),
              ),
            ),
          ],

        ),

      ),
      floatingActionButton: FloatingActionButton(

        onPressed: (){
          snack(context, '저장되었습니다.', 2);
          // print(selectedCardInfo.length);
          // selectedCardInfo.forEach((e) => print(e.properties));
          Navigator.pop(context, selectedCardInfo);
        },

        child: Icon(Icons.check, color: Colors.black,),
      ),
    );
  }

  Widget listItem(int index){

      CardInfo card = lstCardInfo[index];
      String properties = card.properties.join(' / ');

      return InkWell(

        onTap: (){
          // print(List.from(card.properties.sublist(1))..sort());
          showDialog(context: context, builder: (context){
            return AlertDialog(
              title: Text("카드 추가 :\n${card.name}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
              content: Text(card.effectText),
              actions: [

                TextButton(onPressed: (){ // 팝업창 취소 버튼
                  Navigator.of(context).pop(); // 팝업창 닫음
                }, 
                // 취소 버튼 텍스트
                child: Text("취소", style: TextStyle(color: Colors.red),)),

                TextButton(onPressed: () async { // 팝업창 삭제 버튼

                  if(!selectedCardInfo.any((selected) => selected.name == card.name)){
                    selectedCardInfo.add(card);
                    setState(() {
                      
                    });
                    Navigator.of(context).pop();
                    snack(context, "카드 추가됨: ${card.name}", 1);
                  }
                  else{
                    Navigator.of(context).pop();
                    snack(context, "동일한 카드가 존재합니다.", 2);
                  } 

                }, 
                child: Text("추가", style: TextStyle(color: Colors.blue),))

              ],
            );
          });
        },

        child: Container(
        
          height: 80,
          decoration: border,
          margin: EdgeInsets.all(5),
        
          child: Stack(
            
            children: [

              Container(

                margin: EdgeInsets.only(top: 5),
                
                child: Align(
                
                  alignment: Alignment.topCenter,
                
                  child: Text(card.name)
                  
                  ),
              ),

              Container(

                margin: EdgeInsets.only(left: 30),

                child: Align(
                
                  alignment: Alignment.centerLeft,
                
                  child: Text('레벨: ${card.level}')
                  
                  ),
              ),

              Container(

                margin: EdgeInsets.only(right: 30),

                child: Align(
                
                  alignment: Alignment.centerRight,
                
                  child: Text('${card.attribute}속성')
                  
                  ),
              ),

              Container(

                margin: EdgeInsets.only(bottom: 5, left: 30),

                child: Align(
                
                  alignment: Alignment.bottomLeft,
                
                  child: Text(properties)
                  
                  ),
              ),

              Container(

                margin: EdgeInsets.only(bottom: 5, right: 30),

                child: Align(
                
                  alignment: Alignment.bottomRight,
                
                  child: Text('${card.atk == -1 ? '?' : card.atk} / ${card.def == -1 ? '?' : card.def}')
                  
                  ),
              )
              
            ]
          )
        ),
      );
    }
      
  Future<void> getCardInfo() async {
    await dbHelper.initDatabase();
    lstCardInfo = await dbHelper.getAllCardInfo();
    backupCardInfo = await dbHelper.getAllCardInfo();
    setState(() {
      
    });
  }

  void snack(context, text, duration){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), duration: Duration(seconds: duration),)); 
  }
  
  Widget drawerItem(int index) {

    CardInfo card = selectedCardInfo[index];

    return Container(

      child: Row(

        children: [

          Align(
            alignment: Alignment.centerLeft,

            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(card.name, style: TextStyle(fontSize: 13),)
              ),
          ),
          Spacer(), // 이거 넣어야 딱 안붙고 지정됨
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: (){
              selectedCardInfo.removeAt(index);
              setState(() {
                
              });
            }, 
            
            icon: Icon(Icons.close, color: Colors.red,)
            ),
          )
        ],
      ),

    );
  }
  
  List selection(List<bool> condition, List<dynamic> lst) {
    List<dynamic> selected = [];
    for(int i = 0; i < lst.length; i++){
      if(condition[i]){
        selected.add(lst[i]);
      }
    }
    return selected;
  }
  
  void initializeSelectedButton() {
    List<List<bool>> lsts = [selectedClass, selectedElement, selectedLv, selectedType];
    for (var list in lsts) {
      for (int j = 0; j < list.length; j++) {
        list[j] = false;
      }
    }
  }

  List<dynamic> makeList(CardInfo card){
    return [card.atk, card.def, card.properties[0], card.level, card.attribute];
  }
  
  List<CardInfo> findMiddleRoute(start, end) {

    List<CardInfo> result = [];

    CardInfo startMonster = selectedCardInfo.firstWhere((card) => card.name == start);
    CardInfo endMonster = selectedCardInfo.firstWhere((card) => card.name == end);

    // 시작 몬스터의 공/수, 종족, 레벨, 속성을 리스트로
    List<dynamic> startInfo = makeList(startMonster);
    List<dynamic> endInfo = makeList(endMonster);

    // print('lstcardinfo: ${lstCardInfo.length}');
    // print('selected: ${selectedCardInfo.length}');

    // 단순히 클래스를 contains로 비교하면 동일한 값을 가지는 다른 인스턴스로 간주하기에 동작하지 않았음
    List<CardInfo> filtered = lstCardInfo.where((b) => !selectedCardInfo.any((a) => a.name == b.name)).toList();
    // print('filtered: ${filtered.length}');

    filtered.forEach((card){

      // selectedCardInfo에 있던것들 다 걸러내고 봐야함 근데또 중간다리에서 추가한건 안나오네

      List<dynamic> middleInfo = makeList(card);
      // 교집합이 하나인 카드 정보를 찾음
      int lengthA = startInfo.toSet().intersection(middleInfo.toSet()).length;
      if(lengthA == 1){
        int lengthB = endInfo.toSet().intersection(middleInfo.toSet()).length;
        if(lengthB == 1){
          result.add(card);
        }
      }
    });
    
    return result;
  }

}

