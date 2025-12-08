import 'package:image_picker/image_picker.dart';
import 'image_picker_service.dart';

class ImagePickerServiceWeb implements ImagePickerService {
  @override
  Future<List<XFile>> pickImages() async {
    return await ImagePicker().pickMultiImage();
  }
}

ImagePickerService getImagePickerService() => ImagePickerServiceWeb();
