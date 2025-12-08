import 'package:clone_project/src/common/components/app_font.dart';
import 'package:clone_project/src/common/components/getx_listener.dart';
import 'package:clone_project/src/common/controller/authentication_controller.dart';
import 'package:clone_project/src/common/controller/data_load_controller.dart';
import 'package:clone_project/src/common/enum/authentication_status.dart';
import 'package:clone_project/src/splash/controller/splash_controller.dart';
import 'package:clone_project/src/splash/enum/step_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthenticationController>();
    final dataCtrl = Get.find<DataLoadController>();

    return Scaffold(
      body: Center(
        child: GetxListener<AuthenticationStatus>(
          stream: authCtrl.status,
          listen: (AuthenticationStatus status) {
            switch (status) {
              case AuthenticationStatus.authentication:
                Get.offNamed('/home');
                break;
              case AuthenticationStatus.unAuthenticated:
                final user = authCtrl.userModel.value;
                if (user.uid == null) {
                  Get.offNamed('/login');
                } else {
                  Get.offNamed('/signup/${user.uid}');
                  authCtrl.reload();
                }
                break;
              case AuthenticationStatus.unknown:
                Get.offNamed('/login');
                break;
              case AuthenticationStatus.init:
                // 초기 상태에서는 아무 동작 없음
                break;
            }
          },
          child: GetxListener<bool>(
            stream: dataCtrl.isDataLoad,
            listen: (bool loaded) {
              if (loaded) {
                controller.loadStep(StepType.authCheck);
              }
            },
            child: GetxListener<StepType>(
              stream: controller.loadStep,
              initCall: () {
                controller.loadStep(StepType.dataLoad);
              },
              listen: (StepType? step) {
                if (step == null) return;
                switch (step) {
                  case StepType.init:
                  case StepType.dataLoad:
                    dataCtrl.loadData();
                    break;
                  case StepType.authCheck:
                    authCtrl.authCheck();
                    break;
                }
              },
              child: const _SplashView(),
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashView extends GetView<SplashController> {
  const _SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 200),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 99,
                height: 116,
                child: Image.asset('assets/images/logo_simbol.png'),
              ),
              const SizedBox(height: 40),
              const AppFont(
                '당신 근처의 밤톨마켓',
                fontWeight: FontWeight.bold,
                size: 20,
              ),
              const SizedBox(height: 15),
              AppFont(
                '중고 거래부터 동네 정보까지,\n지금 내 동네를 선택하고 시작해보세요!',
                align: TextAlign.center,
                size: 18,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: Column(
            children: [
              Obx(() {
                return Text(
                  '${controller.loadStep.value.name} 중 입니다.',
                  style: const TextStyle(color: Colors.white),
                );
              }),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                strokeWidth: 1,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
