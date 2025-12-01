import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi-Ball Physics',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MultiBouncingBallScreen(),
    );
  }
}

/// 공 하나의 물리 상태를 나타내는 클래스
class BallPhysics {
  Offset position; // 공의 중심 위치
  Offset velocity; // 속도 벡터 (픽셀/초)
  final double radius; // 공의 반지름
  final Color color; // 공의 색상
  final int id; // 공의 고유 ID

  BallPhysics({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
    required this.id,
  });

  /// 두 공 사이의 거리 계산
  double distanceTo(BallPhysics other) {
    final dx = position.dx - other.position.dx;
    final dy = position.dy - other.position.dy;
    return sqrt(dx * dx + dy * dy);
  }

  /// 다른 공과 충돌했는지 확인
  bool isCollidingWith(BallPhysics other) {
    return distanceTo(other) < (radius + other.radius);
  }
}

/// 메인 화면 - 여러 개의 공이 물리 시뮬레이션되는 화면
class MultiBouncingBallScreen extends StatefulWidget {
  const MultiBouncingBallScreen({super.key});

  @override
  State<MultiBouncingBallScreen> createState() =>
      _MultiBouncingBallScreenState();
}

class _MultiBouncingBallScreenState extends State<MultiBouncingBallScreen>
    with SingleTickerProviderStateMixin {
  // 애니메이션 컨트롤러
  late AnimationController _controller;

  // 공들의 리스트
  final List<BallPhysics> _balls = [];

  // 드래그 중인 공의 ID (null이면 드래그 중이 아님)
  int? _draggingBallId;

  // 드래그 시작 정보
  Offset? _dragStartPosition;
  DateTime? _dragStartTime;

  // body 영역의 실제 크기 (AppBar 제외)
  Size _bodySize = const Size(400, 600);

  // 물리 상수
  static const double _gravity = 980.0; // 중력 가속도 (픽셀/초²)
  static const double _friction = 0.995; // 공기 저항 계수
  static const double _wallRestitution = 0.85; // 벽 반발 계수
  static const double _ballRestitution = 0.90; // 공끼리 충돌 반발 계수

  @override
  void initState() {
    super.initState();

    // 5개의 공 초기화 (다양한 색상)
    final colors = [
      Colors.orange,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.red,
    ];

    for (int i = 0; i < 5; i++) {
      _balls.add(
        BallPhysics(
          position: Offset(100.0 + i * 80.0, 150.0 + (i % 2) * 100.0),
          velocity: Offset.zero,
          radius: 30.0,
          color: colors[i],
          id: i,
        ),
      );
    }

    // 애니메이션 컨트롤러 초기화
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..addListener(_updatePhysics);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 매 프레임마다 호출되어 물리 시뮬레이션 업데이트
  void _updatePhysics() {
    setState(() {
      const double dt = 1.0 / 60.0; // 델타 타임 (초)

      // 각 공에 대해 물리 업데이트
      for (var ball in _balls) {
        // 드래그 중인 공은 물리 시뮬레이션 스킵
        if (_draggingBallId == ball.id) continue;

        // 중력과 마찰 적용
        ball.velocity = Offset(
          ball.velocity.dx * _friction,
          ball.velocity.dy + _gravity * dt,
        );

        // 새로운 위치 계산
        double newX = ball.position.dx + ball.velocity.dx * dt;
        double newY = ball.position.dy + ball.velocity.dy * dt;

        // 벽 충돌 감지 및 반사
        // 왼쪽 벽
        if (newX - ball.radius < 0) {
          newX = ball.radius;
          ball.velocity = Offset(
            ball.velocity.dx.abs() * _wallRestitution,
            ball.velocity.dy,
          );
        }

        // 오른쪽 벽
        if (newX + ball.radius > _bodySize.width) {
          newX = _bodySize.width - ball.radius;
          ball.velocity = Offset(
            -ball.velocity.dx.abs() * _wallRestitution,
            ball.velocity.dy,
          );
        }

        // 위쪽 벽
        if (newY - ball.radius < 0) {
          newY = ball.radius;
          ball.velocity = Offset(
            ball.velocity.dx,
            ball.velocity.dy.abs() * _wallRestitution,
          );
        }

        // 아래쪽 벽
        if (newY + ball.radius > _bodySize.height) {
          newY = _bodySize.height - ball.radius;
          ball.velocity = Offset(
            ball.velocity.dx,
            -ball.velocity.dy.abs() * _wallRestitution,
          );

          // 바닥에서 거의 정지 상태면 완전히 멈춤
          if (ball.velocity.dy.abs() < 50) {
            ball.velocity = Offset(ball.velocity.dx, 0);
          }
        }

        // 위치 업데이트 (경계 내로 제한)
        ball.position = Offset(
          newX.clamp(ball.radius, _bodySize.width - ball.radius),
          newY.clamp(ball.radius, _bodySize.height - ball.radius),
        );
      }

      // 공끼리 충돌 감지 및 처리
      _handleBallCollisions();
    });
  }

  /// 공끼리의 충돌을 감지하고 처리
  void _handleBallCollisions() {
    for (int i = 0; i < _balls.length; i++) {
      for (int j = i + 1; j < _balls.length; j++) {
        final ball1 = _balls[i];
        final ball2 = _balls[j];

        // 충돌 검사
        if (ball1.isCollidingWith(ball2)) {
          // 충돌 처리
          _resolveBallCollision(ball1, ball2);
        }
      }
    }
  }

  /// 두 공의 충돌을 물리적으로 해결
  void _resolveBallCollision(BallPhysics ball1, BallPhysics ball2) {
    // 충돌 벡터 계산 (ball1에서 ball2로 향하는 벡터)
    final dx = ball2.position.dx - ball1.position.dx;
    final dy = ball2.position.dy - ball1.position.dy;
    final distance = sqrt(dx * dx + dy * dy);

    // 거리가 0이면 처리하지 않음 (같은 위치)
    if (distance == 0) return;

    // 정규화된 충돌 벡터
    final nx = dx / distance;
    final ny = dy / distance;

    // 겹침 해소 - 공들을 밀어냄
    final overlap = (ball1.radius + ball2.radius) - distance;
    if (overlap > 0) {
      final separationX = nx * overlap / 2;
      final separationY = ny * overlap / 2;

      ball1.position = Offset(
        ball1.position.dx - separationX,
        ball1.position.dy - separationY,
      );
      ball2.position = Offset(
        ball2.position.dx + separationX,
        ball2.position.dy + separationY,
      );
    }

    // 상대 속도 계산
    final relativeVelocityX = ball1.velocity.dx - ball2.velocity.dx;
    final relativeVelocityY = ball1.velocity.dy - ball2.velocity.dy;

    // 충돌 방향으로의 상대 속도
    final velocityAlongNormal = relativeVelocityX * nx + relativeVelocityY * ny;

    // 이미 멀어지고 있으면 처리하지 않음
    if (velocityAlongNormal > 0) return;

    // 충격량 계산 (질량이 같다고 가정)
    final impulse = -(1 + _ballRestitution) * velocityAlongNormal / 2;

    // 속도 업데이트
    ball1.velocity = Offset(
      ball1.velocity.dx + impulse * nx,
      ball1.velocity.dy + impulse * ny,
    );
    ball2.velocity = Offset(
      ball2.velocity.dx - impulse * nx,
      ball2.velocity.dy - impulse * ny,
    );
  }

  /// 터치/마우스 위치에서 가장 가까운 공 찾기
  BallPhysics? _findBallAtPosition(Offset position) {
    for (var ball in _balls) {
      final dx = ball.position.dx - position.dx;
      final dy = ball.position.dy - position.dy;
      final distance = sqrt(dx * dx + dy * dy);

      if (distance <= ball.radius) {
        return ball;
      }
    }
    return null;
  }

  /// 드래그 시작
  void _onPanStart(DragStartDetails details) {
    final ball = _findBallAtPosition(details.localPosition);
    if (ball != null) {
      _draggingBallId = ball.id;
      _dragStartPosition = details.localPosition;
      _dragStartTime = DateTime.now();
      ball.velocity = Offset.zero;
    }
  }

  /// 드래그 중
  void _onPanUpdate(DragUpdateDetails details) {
    if (_draggingBallId != null) {
      final ball = _balls.firstWhere((b) => b.id == _draggingBallId);
      setState(() {
        ball.position = details.localPosition;
      });
    }
  }

  /// 드래그 종료
  void _onPanEnd(DragEndDetails details) {
    if (_draggingBallId != null &&
        _dragStartPosition != null &&
        _dragStartTime != null) {
      final ball = _balls.firstWhere((b) => b.id == _draggingBallId);

      // 드래그 거리와 시간으로 속도 계산
      final dragDistance = ball.position - _dragStartPosition!;
      final dragDuration = DateTime.now().difference(_dragStartTime!);
      final seconds = dragDuration.inMilliseconds / 1000.0;

      if (seconds > 0) {
        setState(() {
          ball.velocity = Offset(
            dragDistance.dx / seconds,
            dragDistance.dy / seconds,
          );

          // 속도 제한
          final speed = sqrt(
            ball.velocity.dx * ball.velocity.dx +
                ball.velocity.dy * ball.velocity.dy,
          );
          const maxSpeed = 2000.0;
          if (speed > maxSpeed) {
            ball.velocity = Offset(
              ball.velocity.dx * maxSpeed / speed,
              ball.velocity.dy * maxSpeed / speed,
            );
          }
        });
      }
    }

    _draggingBallId = null;
    _dragStartPosition = null;
    _dragStartTime = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('다중 공 물리 시뮬레이션'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // body 영역의 실제 크기 저장
          _bodySize = Size(constraints.maxWidth, constraints.maxHeight);

          return GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.transparent,
              child: Stack(
                children: [
                  // 안내 텍스트
                  Center(
                    child: Text(
                      '공을 드래그해서 던져보세요!\n공끼리 충돌합니다!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // 모든 공들 렌더링
                  ..._balls.map((ball) {
                    return Positioned(
                      left: ball.position.dx - ball.radius,
                      top: ball.position.dy - ball.radius,
                      child: Ball(
                        radius: ball.radius,
                        color: ball.color,
                        isBeingDragged: _draggingBallId == ball.id,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 공 위젯 - 원형 모양의 공을 그림
class Ball extends StatelessWidget {
  final double radius;
  final Color color;
  final bool isBeingDragged;

  const Ball({
    super.key,
    required this.radius,
    required this.color,
    this.isBeingDragged = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.8), color],
          stops: const [0.3, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isBeingDragged ? 0.8 : 0.5),
            blurRadius: isBeingDragged ? 20 : 15,
            spreadRadius: isBeingDragged ? 4 : 2,
          ),
        ],
        border: isBeingDragged
            ? Border.all(color: Colors.white, width: 2)
            : null,
      ),
    );
  }
}
