import 'package:flutter/material.dart';
import 'package:small_world/data/database/card_data_info.dart';
import 'package:small_world/data/database/deck_data.dart';
import 'package:small_world/data/deck_database_helper.dart';

class DetailScreen extends StatefulWidget {

  DeckData deck;
  var dbHelper = DeckDatabaseHelper();

  DetailScreen({super.key, required this.deck});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  TextStyle titleStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  TextStyle buttonStyle = TextStyle(color: Colors.blue, fontSize: 12);
  ShapeDecoration border = ShapeDecoration(shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)));
  List<CardInfo> selectedCardInfo = [];

  String initialStartMonsterName = 'null';
  String initialEndMonsterName = 'null';

  List<dynamic> defined = ['푸른 눈의 백룡', '빛', '드래곤족', 8, 3000, 2500];

  List<String> elementList = ['어둠', '빛', '땅', '물', '화염', '바람', '신'];
  List<String> typeList = ['마법사족', '드래곤족', '언데드족', '전사족', '야수전사족', '야수족', '비행야수족', '악마족', '천사족', '곤충족', '공룡족', '파충류족', '어류족', '해룡족', '물족', '화염족', '번개족', '암석족', '식물족', '기계족', '사이킥족', '환신야수족', '환룡족', '사이버스족', '환상마족'];
  List<int> levelList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  TextEditingController nameController = TextEditingController();
  TextEditingController atkController = TextEditingController();
  TextEditingController defController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedCardInfo = widget.deck.cards;
    selectedCardInfo.forEach((e) => print(e.properties));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset : false,

      appBar: AppBar(
        
        title: Text(widget.deck.name),

        actions: [

          // IconButton(onPressed: (){
          //   // 시작, 도착 몬스터 받아서 편집화면 이동 후 해당 조건 맞게 필터링 과정 거치기
          // }, 
          // icon: Icon(Icons.list_sharp)),

          TextButton(onPressed: (){
            showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Text("삭제하시겠습니까?"),
                actions: [
                    TextButton(onPressed: (){ // 팝업창 취소 버튼
                    Navigator.of(context).pop(); // 팝업창 닫음
                  }, 
                  // 취소 버튼 텍스트
                  child: Text("취소", style: TextStyle(color: Colors.black),)),

                  TextButton(onPressed: () async { // 팝업창 삭제 버튼

                    await setDeleteDeckData(widget.deck.id);

                    if(context.mounted){ // 처리가 완료될 시 실행
                      Navigator.of(context).pop(); // 팝업창 닫기
                      Navigator.pop(context);

                    }
                    // 삭제 버튼 텍스트
                  }, 
                  child: Text("확인", style: TextStyle(color: Colors.red),))
                ],
              );
            });

          }, 
          child: Text("삭제", style: TextStyle(color: Colors.red),))
        ],
      
      ),

      body: Container(

        margin: EdgeInsets.symmetric(horizontal: 10),

        child: Column(
        
          crossAxisAlignment: CrossAxisAlignment.start,
        
          children: [
        
            Expanded(
        
              flex: 1,
        
              child: Row(
              
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.center,
                
                children: [
              
                Text('사용하는 몬스터 카드', style: titleStyle,),

                Spacer(), // 사이 공간 다씀

                IconButton(onPressed: () async {
                  // 여기서 덱데이터에 카드 추가
                  var result = await dial(context, "사용자 정의 카드 추가");
                  
                  setState(() {
                    
                  });
                },
                icon: Icon(Icons.add), color: Colors.blue,),
              
                TextButton(onPressed: () async {
        
                  var result = await Navigator.pushNamed(context, '/edit', arguments: [widget.deck.cards, 'null', 'null']);

                  if(result != null){
                    selectedCardInfo = result as List<CardInfo>;

                    DeckData deck = DeckData(
                      id: widget.deck.id,
                      name: widget.deck.name, 
                      cards: selectedCardInfo);
          
                    await setUpdateDeckData(deck);
                  }
                  
                  setState(() {
                    initialStartMonsterName = 'null';
                    initialEndMonsterName = 'null';
                  });
                }, 

                child: Text("편집", style: TextStyle(color: Colors.blue),),),
              
              ],),
            ),
        
            Expanded(
        
              flex: 3,
        
              child: Container(
        
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: border,
        
                child: selectedCardInfo.isEmpty ? Center(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(' + 를 통해 사용자 정의 카드 추가,', style: TextStyle(color: Color(0xffa5a5a5)),),
                      Text('편집을 통해 사용하는 카드를 추가할 수 있습니다', style: TextStyle(color: Color(0xffa5a5a5)),),
                    ],
                  )) :
                
                ListView.builder(
                
                  itemCount: selectedCardInfo.length,
                  scrollDirection: Axis.vertical,
                
                  itemBuilder: 
                  (context, index){
                    return listItem(index);
                  }),
              ),
                
            ),
        
            Expanded(
        
              flex: 1,
        
              child: 
                Column(
                
                  children: [
                
                    Expanded(
                      child: Row(
                                      
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        
                        children: [
                                      
                          Text("시작하는 몬스터: "),
                                      
                          TextButton(
                          
                            onPressed: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                              
                                title: Text("시작하는 몬스터 선택"),
                              
                                content: Container(
                              
                                  width: double.maxFinite, // 이거 안쓰면 터짐
                              
                                  child: ListView.builder(
                              
                                    shrinkWrap: true,
                                    itemCount: selectedCardInfo.length + 1,
                                    
                                    itemBuilder: (context, index){
                                      return Container(
                              
                                        decoration: border,
                                        margin: EdgeInsets.symmetric(vertical: 5),
                              
                                        child: InkWell(
                                        
                                          onTap: () {
                                            
                                            initialStartMonsterName = index == 0 ? "null" : selectedCardInfo[index-1].name;
                                            if(initialStartMonsterName == initialEndMonsterName){
                                              initialEndMonsterName = "null";
                                            }
                                            Navigator.of(context).pop();
                                            setState(() {
                                              
                                            });
                                          },
                                          
                                          child: index == 0 ? nullListItem() : smallListItem(index - 1)
                                        
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              });
                            }, 
                      
                            child: Text(initialStartMonsterName, style: buttonStyle),
                      
                          // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          ),
                                      
                        ],
                      ),
                    ),
                
                    Expanded(
                      child: Row(
                                      
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      
                        children: [
                          
                          Text("도착하는 몬스터: "),
                                      
                          TextButton(
                            
                            
                            onPressed: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                              
                                title: Text("도착하는 몬스터 선택"),
                              
                                content: Container(
                              
                                  width: double.maxFinite, // 이거 안쓰면 터짐
                              
                                  child: ListView.builder(
                              
                                    shrinkWrap: true,
                                    itemCount: selectedCardInfo.length + 1,
                                    
                                    itemBuilder: (context, index){
                                      return Container(
                              
                                        decoration: border,
                                        margin: EdgeInsets.symmetric(vertical: 5),
                              
                                        child: InkWell(
                                        
                                          onTap: () {
                                            initialEndMonsterName = index == 0 ? "null" : selectedCardInfo[index-1].name; 
                                            if(initialEndMonsterName == initialStartMonsterName){
                                              initialStartMonsterName = "null";
                                            }
                                            Navigator.of(context).pop();
                                            setState(() {
                                              
                                            });
                                          },
                                          
                                          child: index == 0 ? nullListItem() : smallListItem(index - 1)
                                        
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              });
                            }, 
                      
                            child: Text(initialEndMonsterName, style: buttonStyle,),
                      
                          // style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          ),
                                      
                        ],
                      ),
                    ),
                
                  ],
                ),
            ),
        
            Expanded(
              
              child: Row(

                children: [
                  Expanded(
                    child: Container(
                    
                      margin: EdgeInsets.all(5),
                    
                      child: InkWell(
                      
                        borderRadius: BorderRadius.circular(10),
                        // splashColor: Colors.blue.withOpacity(0.3), // 클릭 시 스플래시 색상
                      
                        onTap: () async {

                          if(initialStartMonsterName == 'null' || initialEndMonsterName == 'null'){
                            snack(context, "시작/도착하는 몬스터를 선택하세요.", 2);
                          }
                          else{ // 매개변수 조정 핗료
                            
                            var result = await Navigator.pushNamed(context, '/edit', arguments: [widget.deck.cards, initialStartMonsterName, initialEndMonsterName]);                   
                            
                            if(result != null){
                              selectedCardInfo = result as List<CardInfo>;
                              DeckData deck = DeckData(
                                id: widget.deck.id,
                                name: widget.deck.name, 
                                cards: selectedCardInfo);
                    
                              await setUpdateDeckData(deck);
                            }
                  
                            setState(() {
                              initialStartMonsterName = 'null';
                              initialEndMonsterName = 'null';
                            });
                          }
                          
                        },
                      
                        child: Container(
                          
                          height: 50,
                          decoration: border,
                          alignment: Alignment.center,
                      
                          child: Text("중간다리 찾기"),
                      
                        )
                      ),
                    ),
                  ),

                  Expanded(
                    child: Container(
                    
                      margin: EdgeInsets.all(5),
                    
                      child: InkWell(
                      
                        borderRadius: BorderRadius.circular(10),
                        // splashColor: Colors.blue.withOpacity(0.3), // 클릭 시 스플래시 색상
                      
                        onTap: (){
                    
                          List<dynamic> cardData = [initialStartMonsterName, initialEndMonsterName, selectedCardInfo, ];
                          
                          if(initialStartMonsterName == initialEndMonsterName){
                            snack(context, "시작/도착하는 몬스터를 적어도 하나 선택하세요.", 2);
                          }
                          else{
                            Navigator.pushNamed(context, '/route', arguments: cardData);
                          }
                          
                        },
                      
                        child: Container(
                          
                          height: 50,
                          decoration: border,
                          alignment: Alignment.center,
                      
                          child: Text("루트 찾기"),
                      
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget smallListItem(int index){
    return Container(

      margin: EdgeInsets.all(5),
      
      child: Text(selectedCardInfo[index].name));
  }

  Widget listItem(int index){

      CardInfo card = selectedCardInfo[index];
      String properties = card.properties.join(' / ');
      // print(card.properties);

      return InkWell(

        onTap: (){

          showDialog(context: context, builder: (context){
            return AlertDialog(
              title: Text("카드 정보 :\n${card.name}", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
              content: Text(card.effectText),
              actions: [

                TextButton(onPressed: (){ // 팝업창 취소 버튼
                  Navigator.of(context).pop(); // 팝업창 닫음
                }, 
                // 취소 버튼 텍스트
                child: Text("확인", style: TextStyle(color: Colors.black),)),

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

  Widget nullListItem(){
    return Container(

      margin: EdgeInsets.all(5),
      
      child: Text("null"));
  }
  
  void snack(context, text, duration){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), duration: Duration(seconds: duration),)); 
  }
  
  setDeleteDeckData(int? id) async {
    await widget.dbHelper.initDatabase();
    await widget.dbHelper.deleteDeckData(id!);
  }
  
  setUpdateDeckData(DeckData deck) async {
    await widget.dbHelper.initDatabase();
    await widget.dbHelper.updateDeckData(deck);
  }
  
  Future<dynamic> dial(context, text, ) async {

    return showDialog(context: context, builder: (context){
              return StatefulBuilder(builder: (context, setState){

                return AlertDialog(
                  title: Text(text),
                
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    
                        Text('카드명:'),
                        TextField(
                          onChanged: (value){
                            defined[0] = value;
                          },
                          decoration: InputDecoration(
                          hintText: '카드명을 입력하세요',
                          suffixIcon: IconButton(
                            onPressed: (){
                              nameController.clear();
                            },
                          icon: Icon(Icons.clear),
                          )
                        ),
                        controller: nameController,
                        ),
                    
                        SizedBox(height: 20,),
                        Text('속성:'),
                        InkWell(
                          onTap: () async {
                
                            final selected = await selectDial(context, '속성 선택', elementList);
                            defined[1] = selected;
                            setState((){

                            });
                          },
                          child: Container(
                
                            width: double.maxFinite,
                            alignment: Alignment.center,
                
                            decoration: border,
                            padding: EdgeInsets.symmetric(vertical: 3),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            
                            child: Text(defined[1] ?? '빛')),
                        ),
                    
                        Text('종족:'),
                        InkWell(
                          onTap: () async {
                
                            final selected = await selectDial(context, '종족 선택', typeList);
                            defined[2] = selected;
                            setState((){

                            });
                          },
                          child: Container(
                
                            width: double.maxFinite,
                            alignment: Alignment.center,
                
                            decoration: border,
                            padding: EdgeInsets.symmetric(vertical: 3),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            
                            child: Text(defined[2] ?? '드래곤족')),
                        ),
                    
                        Text('레벨:'),
                        InkWell(
                          onTap: () async {
                
                            final selected = await selectDial(context, '레벨 선택', levelList);
                            defined[3] = selected == null ? 1 : selected;
                            setState((){

                            });
                          },
                          child: Container(
                
                            width: double.maxFinite,
                            alignment: Alignment.center,
                
                            decoration: border,
                            padding: EdgeInsets.symmetric(vertical: 3),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            
                            child: Text("${defined[3]}")),
                        ),
                    
                        Text('공격력:'),
                        TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value){
                            defined[4] = value;
                          },
                          decoration: InputDecoration(
                          hintText: '공격력을 입력하세요',
                          suffixIcon: IconButton(
                            onPressed: (){
                              atkController.clear();
                            },
                          icon: Icon(Icons.clear),
                          )
                        ),
                        controller: atkController,
                        ),
                    
                        SizedBox(height: 20,),
                        Text('수비력:'),
                        TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value){
                            defined[5] = value;
                          },
                          decoration: InputDecoration(
                          hintText: '수비력을 입력하세요',
                          suffixIcon: IconButton(
                            onPressed: (){
                              defController.clear();
                            },
                          icon: Icon(Icons.clear),
                          )
                        ),
                        controller: defController,
                        ),
                        
                      ],
                    ),
                  ),
                
                  actions: [
                      TextButton(onPressed: (){ // 팝업창 취소 버튼

                          nameController.clear();
                          atkController.clear();
                          defController.clear();

                          Navigator.of(context).pop(); // 팝업창 닫음
                        }, 
                        // 취소 버튼 텍스트
                        child: Text("취소", style: TextStyle(color: Colors.red),)),
                
                      TextButton(onPressed: () async { 

                          if(nameController.text.trim().isNotEmpty &&
                          atkController.text.trim().isNotEmpty &&
                          defController.text.trim().isNotEmpty){

                            if(isInteger(defined[4]) && isInteger(defined[5])){
                              selectedCardInfo.add(
                                CardInfo(
                                  name: defined[0], 
                                  attribute: defined[1], 
                                  properties: [defined[2]], 
                                  effectText: '사용자 정의 카드.', 
                                  level: defined[3], 
                                  atk: int.parse(defined[4]), 
                                  def: int.parse(defined[5]),
                                  )
                              );

                              nameController.clear();
                              atkController.clear();
                              defController.clear();

                              // 여기에 selectcardinfo 리스트 삽입 들어가야 함
                              DeckData deck = DeckData(
                                id: widget.deck.id,
                                name: widget.deck.name, 
                                cards: selectedCardInfo);

                              await setUpdateDeckData(deck);
  
                              Navigator.of(context).pop();
                              snack(context, '사용자 정의 카드 추가됨: ${defined[0]}', 1);
                            }
                            else{
                              Navigator.of(context).pop();
                              snack(context, '공격력/수비력은 숫자를 입력해 주세요.', 2);
                            }
                          }
                          else{
                            Navigator.of(context).pop();
                            snack(context, '공백이 존재합니다.', 2);
                          }

                        },
                        child: Text("확인", style: TextStyle(color: Colors.blue),))
                  ],
                );
              });
            });
    
  }

  selectDial(context, text, lst){

    return showDialog(context: context, builder: (context){
                
                                return AlertDialog(
                                
                                  title: Text(text),
                                
                                  content: Container(
                                
                                    width: double.maxFinite, // 이거 안쓰면 터짐
                                
                                    child: ListView.builder(
                                
                                      shrinkWrap: true,
                                      itemCount: lst.length,
                                      
                                      itemBuilder: (context, index){
                                        return InkWell(
                                        
                                          onTap: () {
                                            Navigator.of(context).pop(lst[index]);
                                          },
                                          
                                          child: Container(
                                            
                                            decoration: border,
                                            margin: EdgeInsets.symmetric(vertical: 5),
                                            padding: EdgeInsets.symmetric(vertical: 5),
                                            alignment: Alignment.center,
                                            
                                            child: Text('${lst[index]}'))
                                                              
                                        );
                                      }),
                                    ),
                                  );
                              });

  }

  dialCallBack(context) { 

    snack(context, "??", 2);
  }

  bool isInteger(String value) {
    return int.tryParse(value) != null;
  }
}