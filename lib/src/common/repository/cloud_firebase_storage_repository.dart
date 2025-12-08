import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CloudFirebaseRepository extends GetxService {
  final Reference storageRef;
  CloudFirebaseRepository(FirebaseStorage storage) : storageRef = storage.ref();

  Future<String> uploadFile(String mainPath, XFile file) async {
    var uuid = const Uuid();
    final uploadTask = storageRef
        .child("products/$mainPath/${uuid.v4()}.jpg")
        .putData(await file.readAsBytes(),
            SettableMetadata(contentType: 'image/jpeg'));
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // 웹 전용
  Future<String> uploadBytes(String mainPath, Uint8List data, String filename) async {
    final ref = storageRef.child("products/$mainPath/$filename");
    final uploadTask = ref.putData(
      data,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

}
