import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:btl_music_app/features/profile/data/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _users => _firestore.collection('users');

  String get _currentUid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception("No authenticated user");
    return uid;
  }

  /// Tạo document user nếu chưa tồn tại (chạy sau khi auth thành công)
  Future<void> createUserIfNotExists() async {
    final docRef = _users.doc(_currentUid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      final email = _auth.currentUser?.email ?? '';
      final emptyUser = UserModel.empty(_currentUid, email);

      await docRef.set(emptyUser.toCreateMap());
      print("Created new user document for UID: $_currentUid");
    }
  }

  /// Lấy user một lần
  Future<UserModel> getUser() async {
    final doc = await _users.doc(_currentUid).get();
    if (!doc.exists || doc.data() == null) {
      throw Exception("User document not found");
    }
    return UserModel.fromDocument(doc);
  }

  /// Stream realtime
  Stream<UserModel> userStream() {
    return _users.doc(_currentUid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return UserModel.empty(_currentUid, _auth.currentUser?.email ?? '');
      }
      return UserModel.fromDocument(doc);
    });
  }

  /// Update user
  Future<void> updateUser(UserModel updated) async {
    await _users.doc(_currentUid).update(updated.toUpdateMap());
  }
}