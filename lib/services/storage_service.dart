import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static const String parentPath = "fl22";

  static final ref = FirebaseStorage.instance.ref();

  static Future<String> upload({required File file}) async {
    final Reference reference = ref.child('media').child(
        "file_${DateTime.now().toIso8601String()}${file.path.substring(file.path.lastIndexOf("."))}");
    UploadTask uploadTask = reference.putFile(file);
    log("\n\nmessage1111\n\n");
    await uploadTask.whenComplete(() {});
    log("\n\nmessage22222\n\n");
    String url = await reference.getDownloadURL();
    print('here: ${url}');
    return url;
  }

  static Future<List<String>> getFile() async {
    List<String> itemList = [];
    final Reference reference = ref.child("media");
    ListResult listResult = await reference.listAll();
    for (Reference e in listResult.items) {
      itemList.add(await e.getDownloadURL());
    }
    return itemList;
  }

  static Future<void> delete(String url) async {
    final Reference reference = FirebaseStorage.instance.refFromURL(url);
    await reference.delete();
  }
}
