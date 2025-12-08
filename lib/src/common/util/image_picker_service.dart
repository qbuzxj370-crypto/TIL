import 'package:image_picker/image_picker.dart';
import 'image_picker_service_stub.dart'
    if (dart.library.io) 'image_picker_service_mobile.dart'
    if (dart.library.html) 'image_picker_service_web.dart';

abstract class ImagePickerService {
  Future<List<XFile>> pickImages();

  factory ImagePickerService() => getImagePickerService();
}
