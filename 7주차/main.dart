import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '웹 탭에 나오는 텍스트',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MyHomePage(title: '플러터 데모 홈페이지'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: createbody(),
    );
  }
}

Widget createbody() {
  // return ;
  /*
  return Row(
    children: [
      /*
      // MainAxisAlignment의 속성
      Text("MainAxisAlignment.strat"),
      createS2(MainAxisAlignment.start),
      Text("MainAxisAlignment.center"),
      createS2(MainAxisAlignment.center),
      Text("MainAxisAlignment.end"),
      createS2(MainAxisAlignment.end),
      Text("MainAxisAlignment.spaceEvenly"),
      createS2(MainAxisAlignment.spaceEvenly),
      Text("MainAxisAlignment.spaceBetween"),
      createS2(MainAxisAlignment.spaceBetween),
      Text("MainAxisAlignment.spaceAround"),
      createS2(MainAxisAlignment.spaceAround),
      */
      /*
      // Text("CrossAxisAlignment.stretch"),
      createS3(CrossAxisAlignment.stretch),
      // Text("CrossAxisAlignment.start"),
      createS3(CrossAxisAlignment.start),
      // Text("CrossAxisAlignment.end"),
      createS3(CrossAxisAlignment.end),
      // Text("CrossAxisAlignment.center"),
      createS3(CrossAxisAlignment.center),
      */
    ]
  );
  */
  // return Center(child: createBox(11));
  //return createS4();
  //return createS5();
  return createS6();
}

Widget createS1() { // p.162
  return Container(
    padding: const EdgeInsets.only(left: 20, right: 20,),
    width: 200,
    height: 50,
    color: Colors.red,
    child: Center(child: Text("Container"),),
  );
}

Widget createS2(MainAxisAlignment alignment) {
  return Row(
    mainAxisAlignment: alignment,
    children: List.generate(
      5, 
      (index) => Container(
        width: 40,
        height: 40,
        color: Colors.red,
        margin: const EdgeInsets.all(5),
      )),
  );
}


Widget createS3(CrossAxisAlignment alignment) {
  return Container(
    color: Colors.blue[100],
    height: 100,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: alignment,
      children: List.generate(
      5, 
      (index) => Container(
        width: 40,
        height: 40,
        color: Colors.red,
        margin: const EdgeInsets.all(5),
        )
      ),
    ),
  );
}

Widget addBox(bool isShowable) {
  return Container(
    width: 40,
    height: 40,
    color: isShowable ? Colors.red : Colors.transparent,
    margin: const EdgeInsets.all(5),
  );
}

Widget createBox(int size) {
  List<Widget> result = [];

  for(var y = 0; y < size; y++) {
    List<Widget> line = [];
    for(var x = 0; x < size; x++) {
      var con = x == y || (size - 1 - x) == y;

      line.add(addBox(con));
    }
    result.add(Row(children: line));
  }
  
  return Column(children: result);
}

Widget createS4() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        child: Container(
        height: 40,
        color: Colors.red,
        margin: const EdgeInsets.all(5),
      ),
    ),
    ...List.generate(
      4, 
      (index) => Container(
        width: 40,
        height: 40,
        color: Colors.red,
        margin: const EdgeInsets.all(5),
      ),
    ),
    ],
  );
}

Widget createS5() {
  return Row(children: [addBox2(1), addBox2(2), addBox2(1)],);
}

Widget addBox2(int flex) {
  return Expanded(
    flex: flex,
    child: Container(
      height: 40,
      color: Colors.red,
      margin: const EdgeInsets.all(5),
    )
  );
}


Widget createS6() {
  return Center(child: addBox3(600, Colors.red, Colors.black, Colors.green));
}

Widget addBox3(double size, Color color1, Color color2, Color color3) {
  return Center(
    child: SizedBox(
      width: size,
      height: size,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: Container(color: color1,)),
                Expanded(child: Container(color: color2,)),
              ],
            ),
          ),
          Expanded(child: Container(color: color3,))
        ],
      ),
    )
  );
}