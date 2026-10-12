import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '상태 관리 Todo 앱',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

// 1. 동적 상태 변경이 필요한 화면이므로 StatefulWidget 사용
class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  // [상태 데이터 1] 할 일 목록 텍스트 리스트
  final List<String> _todoTitles = [
    '5주차 강의 복습하기',
    '플러터 상태관리 흐름도 작성',
    '과제 제출용 스크린샷 캡처',
    'GitHub 저장소에 커밋하기',
  ];

  // [상태 데이터 2] 각 항목의 완료 여부 (Checkbox 상태)
  final List<bool> _isDone = [
    false,
    false,
    false,
    false,
  ];

  // [파생 상태 / Computed State] 미완료된 남은 할 일 수 계산 (게터 사용)
  // 별도의 상태 변수로 보관하지 않고, 원본 상태(_isDone)에서 동적으로 연산하여 데이터 불일치 방지
  int get _remainingCount {
    return _isDone.where((done) => !done).length;
  }

  // [상태 변경 함수] Checkbox 클릭 시 호출
  void _toggleTodo(int index) {
    // =========================================================================
    // [setState 동작 원리]
    // 1. setState() 내부에 작성된 코드에 의해 실제 메모리 상의 _isDone[index] 값이 반전됩니다.
    // 2. Flutter 프레임워크는 setState() 호출을 감지하고 해당 위젯(_TodoListScreenState)을
    //    '더러워진 상태(Dirty State)'로 표시합니다.
    // 3. 다음 파이프라인 프레임에서 build() 메서드가 다시 호출(Rebuild)됩니다.
    // 4. build() 내부에서 변한 _isDone 값과 연산된 _remainingCount 값을 참조하여
    //    화면 UI를 새롭게 다시 그려서 반영합니다.
    // ==========================================
    setState(() {
      _isDone[index] = !_isDone[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [구조 위젯] AppBar: 상단 타이틀
      appBar: AppBar(
        title: const Text('나의 할 일 목록'),
        centerTitle: true,
        backgroundColor: Colors.teal.shade100,
      ),
      // [배치/스크롤 위젯] ListView: 화면 전체를 세로 스크롤 가능하게 구성
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 상단 현황 요약 카드
          Card(
            color: Colors.teal.shade50,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.teal.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '남은 할 일',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // 동적으로 차감/증가하는 남은 개수 표시
                  Text(
                    '$_remainingCount 개',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _remainingCount == 0 ? Colors.grey : Colors.teal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // [배치 위젯] 반복문을 통한 Todo 카드 목록 생성
          for (int i = 0; i < _todoTitles.length; i++) ...[
            Card(
              elevation: 2,
              child: CheckboxListTile(
                // [보여주기 위젯] 할 일 텍스트 (완료 시 취소선 및 색상 변경)
                title: Text(
                  _todoTitles[i],
                  style: TextStyle(
                    fontSize: 16,
                    decoration: _isDone[i] ? TextDecoration.lineThrough : null,
                    color: _isDone[i] ? Colors.grey : Colors.black,
                  ),
                ),
                // [동작/반응 위젯] Checkbox 상태 값 및 클릭 동작
                value: _isDone[i],
                onChanged: (bool? value) {
                  _toggleTodo(i);
                },
                activeColor: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}