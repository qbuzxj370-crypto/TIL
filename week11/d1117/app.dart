import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _count = 0;
  bool _isFirstRun = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// SharedPreferences에서 데이터 로드
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count = prefs.getInt('count') ?? 0;
      _isFirstRun = prefs.getBool('isFirstRun') ?? true;
    });

    /// 최초 실행 시 설명창 띄우기
    if (_isFirstRun) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showDescriptionDialog();
      });
    }
  }

  /// 숫자 증가 및 저장
  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _count++;
    });
    await prefs.setInt('count', _count);
  }

  /// 설명창 띄우기
  void _showDescriptionDialog() async {
    final prefs = await SharedPreferences.getInstance();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("앱 설명"),
        content: const Text(
          "이 앱은 버튼을 눌러 숫자를 증가시키고 저장합니다.\n"
          "앱을 종료해도 마지막 숫자가 유지됩니다.\n"
          "최초 실행 시 설명창이 나타나며, 이후에는 나타나지 않습니다."
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await prefs.setBool('isFirstRun', false);
              Navigator.of(context).pop();
            },
            child: const Text("닫기"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Preferences Demo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showDescriptionDialog, // 언제든 설명 다시 보기
          ),
        ],
      ),
      body: Center(
        child: Text(
          '$_count',
          style: const TextStyle(fontSize: 48),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
