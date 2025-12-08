import 'package:clone_project/src/common/components/app_font.dart';
import 'package:clone_project/src/common/controller/common_layout_controller.dart';
import 'package:clone_project/src/common/enum/market_enum.dart';
import 'package:clone_project/src/common/model/product.dart';
import 'package:clone_project/src/common/repository/cloud_firebase_storage_repository.dart';
import 'package:clone_project/src/product/repository/product_repository.dart';
import 'package:clone_project/src/user/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class ProductWriteController extends GetxController {
  final UserModel owner;
  final Rx<Product> product = const Product().obs;
  final ProductRepository _productRepository;
  final CloudFirebaseRepository _cloudFirebaseRepository;
  RxBool isPossibleSubmit = false.obs;
  RxList<XFile> selectedImages = <XFile>[].obs;
  ProductWriteController(
    this.owner,
    this._productRepository,
    this._cloudFirebaseRepository,
  );

  @override
  void onInit() {
    super.onInit();
    product.stream.listen((event) {
      _isValidSubmitPossible();
    });
  }

  _isValidSubmitPossible() {
    if (selectedImages.isNotEmpty &&
        (product.value.productPrice ?? 0) >= 0 &&
        product.value.title != '') {
      isPossibleSubmit(true);
    } else {
      isPossibleSubmit(false);
    }
  }

  changeSelectedImages(List<XFile>? images) {
    selectedImages(images);
  }

  deleteImage(int index) {
    selectedImages.removeAt(index);
  }

  changeTitle(String value) {
    product(product.value.copyWith(title: value));
  }

  changeCategoryType(ProductCategoryType? type) {
    product(product.value.copyWith(categoryType: type));
  }

  changePrice(String price) {
    if (price.isEmpty) {
      product(product.value.copyWith(productPrice: 0, isFree: true));
      return;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(price)) return;
    product(product.value.copyWith(
        productPrice: int.parse(price), isFree: int.parse(price) == 0));
  }

  changeIsFreeProduct() {
    product(product.value.copyWith(isFree: !(product.value.isFree ?? false)));
    if (product.value.isFree!) {
      changePrice('0');
    }
  }

  changeDescription(String value) {
    product(product.value.copyWith(description: value));
  }

  changeTradeLocationMap(Map<String, dynamic> mapInfo) {
    product(product.value.copyWith(
        wantTradeLocationLabel: mapInfo['label'],
        wantTradeLocation: mapInfo['location']));
  }

  clearWantTradeLocation() {
    product(product.value
        .copyWith(wantTradeLocationLabel: '', wantTradeLocation: null));
  }

  submit() async {
    CommonLayoutController.to.loading(true);
    var downloadUrls = await uploadImages(selectedImages);
    product(product.value.copyWith(
      owner: owner,
      imageUrls: downloadUrls,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    var savedId = await _productRepository.saveProduct(product.value.toMap());
    CommonLayoutController.to.loading(false);
    if (savedId != null) {
      await showDialog(
        context: Get.context!,
        builder: (context) {
          return CupertinoAlertDialog(
            content: const AppFont(
              '물건이 등록되었습니다.',
              color: Colors.black,
              size: 16,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const AppFont(
                  '확인',
                  size: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          );
        },
      );
      Get.back(result: true);
    }
  }

  Future<List<String>> uploadImages(List<XFile> images) async {
    List<String> imageUrls = [];

    // UID 체크
    if (owner.uid == null || owner.uid!.isEmpty) {
      throw Exception("Owner UID is null or empty. Cannot upload images.");
    }

    // 이미지 리스트 체크
    if (images.isEmpty) {
      return [];
    }

    for (var image in images) {
      try {
        if (kIsWeb) {
          // 웹에서는 bytes 기반 업로드
          final bytes = await image.readAsBytes();
          if (bytes.isEmpty) {
            continue; // null 방지
          }
          var downloadUrl = await _cloudFirebaseRepository.uploadBytes(
            owner.uid!,
            bytes,
            image.name,
          );
          imageUrls.add(downloadUrl);
        } else {
          // 모바일에서는 File 기반 업로드
          var downloadUrl = await _cloudFirebaseRepository.uploadFile(
            owner.uid!,
            image,
          );
          imageUrls.add(downloadUrl);
        }
      } catch (e) {
        // 업로드 중 에러 발생 시 로그 남기고 다음 파일로 진행
        debugPrint("Error uploading image ${image.name}: $e");
        continue;
      }
    }
    return imageUrls;
  }
}
