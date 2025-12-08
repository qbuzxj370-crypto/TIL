import 'package:image_picker/image_picker.dart';
import 'package:clone_project/src/common/components/multiful_image_view.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'image_picker_service.dart';

class ImagePickerServiceMobile implements ImagePickerService {
  @override
  Future<List<XFile>> pickImages() async {
    var selectedImages = await Get.to<List<AssetEntity>?>(
      const MultifulImageView(),
    );
    if (selectedImages != null && selectedImages.isNotEmpty) {
      List<XFile> files = [];
      for (var asset in selectedImages) {
        var file = await asset.file;
        if (file != null) {
          files.add(XFile(file.path));
        }
      }
      return files;
    }
    return [];
  }
}

ImagePickerService getImagePickerService() => ImagePickerServiceMobile();
