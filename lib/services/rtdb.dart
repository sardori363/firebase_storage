import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:real_time_db/models/user.dart';

class RTDBService {
  static DatabaseReference ref = FirebaseDatabase.instance.ref();

static Future<void> create({required PostModel postModel}) async {
  String? key = ref.child('users').push().key;
  postModel.id = key;
  try {
    await ref
        .child('users')
        .child(postModel.id ?? key!)
        .set(postModel.toJson());
    print('Data created successfully');
  } catch (e) {
    if (e is FirebaseException) {
      // Handle Firebase exceptions
      print('Firebase Error: ${e.message}');
    } else {
      // Handle generic errors
      print('Error: $e');
    }
  }
}

  static Future<List<PostModel>> getUsers() async {
    List<PostModel> postList = [];
    Query query = ref.child('users');
    DatabaseEvent databaseEvent = await query.once();
    Iterable<DataSnapshot> result = databaseEvent.snapshot.children;
    for (DataSnapshot e in result) {
      postList
          .add(PostModel.fromJson(Map<String, dynamic>.from(e.value as Map)));
        }
    return postList;
  }

  static Future<void> updateUser(PostModel postModel) async {
    await ref.child('users').child(postModel.id ?? "").set(postModel.toJson());
  }

  static Future<void> deleteUser(String id) async {
    print(id);
    await ref.child('users').child(id).remove();
    print("ayo");
  }
}
