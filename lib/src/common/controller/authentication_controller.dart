import 'dart:async';
import 'package:get/get.dart';
import 'package:clone_project/src/user/repository/authentication_repository.dart';
import 'package:clone_project/src/user/model/user_model.dart';
import 'package:clone_project/src/user/repository/user_repository.dart';
import 'package:clone_project/src/common/enum/authentication_status.dart';

class AuthenticationController extends GetxController {
  AuthenticationController(
      this._authenticationRepository, this._userRepository);

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  Rx<AuthenticationStatus> status = AuthenticationStatus.init.obs;
  Rx<UserModel> userModel = const UserModel().obs;

  StreamSubscription? _userSub;

  void authCheck() async {
    _userSub?.cancel();
    status(AuthenticationStatus.init);
    _userSub = _authenticationRepository.user.listen((user) {
      _userStateChangedEvent(user);
    });
  }

  void reload() {
    _userStateChangedEvent(userModel.value);
  }

  void _userStateChangedEvent(UserModel? user) async {
    if (user == null) {
      status(AuthenticationStatus.unknown);
    } else {
      var result = await _userRepository.findUserOne(user.uid!);
      if (result == null) {
        userModel(user);
        status(AuthenticationStatus.unAuthenticated);
      } else {
        status(AuthenticationStatus.authentication);
        userModel(result);
      }
    }
  }

  void logout() async {
    await _authenticationRepository.logout();
  }

  @override
  void onClose() {
    _userSub?.cancel();
    super.onClose();
  }
}
