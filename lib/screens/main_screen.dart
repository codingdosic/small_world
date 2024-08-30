import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:small_world/data/database/deck_data.dart';
import 'package:small_world/data/deck_database_helper.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  TextEditingController deckNameController = TextEditingController();

  var dbHelper = DeckDatabaseHelper();
  List<DeckData> lstDeckData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync(); 
  }

  Future<void> initAsync() async {
    await getDeckData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("smallWorld calculator"),),

      body: Container(

        child: lstDeckData.isEmpty ? Center(child: Text("+ 를 눌러 덱 정보를 추가하세요", style: TextStyle(color: Color(0xffa5a5a5)),),) : 
        
        ListView.builder(

          itemCount: lstDeckData.length,
          scrollDirection: Axis.vertical,
          
          itemBuilder: (context, index){

            return Container(

              margin: EdgeInsets.all(10),
              decoration: ShapeDecoration(shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10))),

              child: InkWell(
                
                child: listItem(index),

                onTap: () async {
                  lstDeckData[index].cards.forEach((e) => print(e.properties));
                  var result = await Navigator.pushNamed(context, '/detail', arguments: lstDeckData[index]);
                  getDeckData();
                },

              ),
            );
          }
        ),
      ),

      floatingActionButton: FloatingActionButton(

        onPressed: (){
          // 팝업 화면 뜨면서 만들 덱 이름부터 입력받음
          // 입력받은 걸로 각 테스트 덱 만들어지게
          showDialog(context: context, builder: (context){
            return AlertDialog(

              title: Text("덱 이름을 입력하세요."),

              content: TextField(
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              
                            });
                            deckNameController.clear();

                            },
                          icon: Icon(Icons.clear),
                        )
                      ),
                      controller: deckNameController,
                  ),
              actions: [

                TextButton(onPressed: (){ // 팝업창 취소 버튼
                  deckNameController.clear();
                  Navigator.of(context).pop(); // 팝업창 닫음
                }, 
                // 취소 버튼 텍스트
                child: Text("취소", style: TextStyle(color: Colors.red),)),

                TextButton(onPressed: () async { // 팝업창 삭제 버튼
                  if(deckNameController.text.trim().isNotEmpty){
                    var deck = DeckData(
                      name: deckNameController.text.toString(), 
                      cards: []);

                    await setInsertDeckData(deck);

                    deckNameController.clear();
                    if(context.mounted){ // 처리가 완료될 시 실행
                      Navigator.of(context).pop(); // 팝업창 닫기
                    }
                    getDeckData();
                  }
                  else{
                    Navigator.of(context).pop();
                    snack(context, '덱 이름을 입력해 주세요', 2);
                  }
                }, 
                child: Text("추가", style: TextStyle(color: Colors.blue),))

              ],

            );
          });
        },

        child: Icon(Icons.add, color: Colors.black,),
      ),

    );
  }
  
  Widget listItem(int index){

    DeckData deck = lstDeckData[index]; 

    return Container(

      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 10),

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.center,
        
        children: [
          Text(deck.name),
        ],
      ),
    );
  }

  Future<void> getDeckData() async {
    await dbHelper.initDatabase();
    lstDeckData = await dbHelper.getAllDeckData();
    setState(() {
      
    });
  }
  
  setInsertDeckData(DeckData deck) {
    dbHelper.initDatabase();
    dbHelper.insertDeckData(deck);
  }

  void snack(context, text, duration){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), duration: Duration(seconds: duration),)); 
  }
}