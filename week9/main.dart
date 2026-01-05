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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int len = 11;
  double cellSize = 40;
  final TextEditingController _controller = TextEditingController(text: '11');

  late TabController _tabController;
  var opacity = true;

  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: // createX(),
      /*
        Center(
          child: createS5(),
        )
        */
        createbody(),
      );
  }

  Widget createbody() {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              createS1(),
              createS2(),
              createS3(),
              createS4(),
              createS5(),
              createS6(),
            ],
          ),
        ),
        TabBar(
          controller: _tabController,
          tabs: const [Text("createS1"), Text("createS2"), Text("createS3"), Text("createS4"), Text("createS5"), Text("createS6")],
        ),
      ],
    );
  }

  Widget createS1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(color: Colors.red, width: 100, height: 40,),
        const SizedBox(height: 10,),
        Container(color: Colors.blue, width: 100, height: 40,),
      ],
    );
  }

  Widget createS2() {
    return ListView(
      scrollDirection: Axis.vertical,
      children: List.generate(
        10,
        (index) => Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(5),
          color: Colors.red.withAlpha(25 * (index + 1)),
          child: Center(
            child: Text(
              index.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 20,),
            ),
          )
        ),
      ),
    );
  }

  Widget createS3() {
    return PageView(
      scrollDirection: Axis.vertical,
      pageSnapping: false,
      children: [
        Container(
          color: Colors.red,
          child: const Center(
            child: Text(
              '1',
              style: TextStyle(color: Colors.white, fontSize: 50,),
            ),
          ),
        ),
        Container(
          color: Colors.blue,
          child: const Center(
            child: Text(
              '2',
              style: TextStyle(color: Colors.white, fontSize: 50,),
            ),
          ),
        ),
        Container(
          color: Colors.yellow,
          child: const Center(
            child: Text(
              '3',
              style: TextStyle(color: Colors.white, fontSize: 50,),
            ),
          ),
        ),
      ],
    );
  }

  Widget createS4() {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                color: Colors.blue,
                child: Center(child: Text("메뉴 1 페이지")),
              ),
              Container(
                color: Colors.orange,
                child: Center(child: Text("메뉴 2 페이지")),
              ),
              Container(
                color: Colors.green,
                child: Center(child: Text("메뉴 3 페이지")),
              ),
            ],
          ),
        ),
        TabBar(
          controller: _tabController,
          tabs: const [Text("메뉴1"), Text("메뉴2"), Text("메뉴3")],
        ),
      ],
    );
  }

  Widget createS5() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 1000),
            opacity: opacity ? 0.2 : 1.0,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                opacity = !opacity;
                setState(() {});
              });
            },
            child: const Text('투명하게/불투명하게'),
          ),
        ],
      ),
    );
  }
  
  Widget createS6() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: opacity ? 100 : 150,
          height: opacity ? 100 : 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: opacity ?  Colors.blue : Colors.red,
          ),
          onEnd: () {
            print("adsfdsf");
          },
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                opacity = !opacity;
                setState(() {});
              });
            },
            child: const Text('크기 변경'),
          ),
        ),
      ],
    );
  }

  Widget createX() {
    return Column(
        children: [
          _buildControlPanel(),
          _buildGridView(),
      ],
    );
  }

  Widget _buildGridSizeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('격자 길이: '),
        SizedBox(
          width: 100,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            setState(() {
              len = int.tryParse(_controller.text) ?? 11;
            });
          },
          child: const Text('적용'),
        ),
      ],
    );
  }

  Widget _buildCellSizeSlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('격자 크기: '),
        SizedBox(
          width: 200,
          child: Slider(
            value: cellSize,
            min: 20,
            max: 100,
            divisions: 80,
            label: cellSize.round().toString(),
            onChanged: (double value) {
              setState(() {
                cellSize = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildGridSizeInput(),
          const SizedBox(height: 16),
          _buildCellSizeSlider(),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: createBox(len),
          ),
        ),
      ),
    );
  }

  Widget createBox(var len) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(len, (y) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(len, (x) {
            bool isDiagonal = x == y || x == len - 1 - y || x == 0 || y == 0 || x == len - 1 || y == len - 1;
            return isDiagonal ? Container(
              width: cellSize,
              height: cellSize,
              margin: const EdgeInsets.all(5),
              color: Colors.red,
            ) : SizedBox(width: cellSize + 10, height: cellSize + 10);
          }),
        );
      }),
    );
  }
}
