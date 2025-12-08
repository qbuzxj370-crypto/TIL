import 'package:clone_project/src/splash/enum/step_type.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  Rx<StepType> loadStep = StepType.init.obs;

  changeStep(StepType type) {
    loadStep(type);
  }
}
