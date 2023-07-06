import 'package:chatonym/Constants/firebase_consts.dart';
import 'package:universal_io/io.dart' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String uuid = const Uuid().v4();

  Future<String> uploadGroupImage({
    Uint8List? webImage,
    io.File? mobileImage,
    required bool isBanner,
  }) async {
    final ref = _storage.ref('${FirebaseConst.groups}/').child('$uuid/');
    if (isBanner) {
      if (webImage != null) {
        final uploadTask = ref.child('banner').putData(webImage);
        final snapshot = await uploadTask.whenComplete(() => null);
        final url = await snapshot.ref.getDownloadURL();
        return url;
      } else if (mobileImage != null) {
        final uploadTask = ref.child('banner').putFile(mobileImage);
        final snapshot = await uploadTask.whenComplete(() => null);
        final url = await snapshot.ref.getDownloadURL();
        return url;
      } else {
        throw Exception('No Image Provided');
      }
    } else {
      if (webImage != null) {
        final uploadTask = ref
            .child('profile')
            .putData(webImage, SettableMetadata(contentType: 'image/png'));

        final snapshot = await uploadTask.whenComplete(() => null);
        final url = await snapshot.ref.getDownloadURL();
        return url;
      } else if (mobileImage != null) {
        final uploadTask = ref.child('profile').putFile(mobileImage);
        final snapshot = await uploadTask.whenComplete(() => null);
        final url = await snapshot.ref.getDownloadURL();
        return url;
      } else {
        throw Exception('No Image Provided');
      }
    }
  }
}
