import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  RxInt menuIndex = 0.obs;

  void changeIndex(int index) {
    menuIndex(index);
  }
}