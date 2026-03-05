// features/library/data/services/love_list_service.dart
import 'package:btl_music_app/features/library/data/models/love_list_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoveListService {
  final CollectionReference _loveListsCollection =
      FirebaseFirestore.instance.collection('love_lists');

  // Lấy love list theo userId (dùng userId làm document ID)
  Stream<LoveListModel?> getLoveListStream(String userId) {
    return _loveListsCollection.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return LoveListModel.fromJson(doc.data() as Map<String, dynamic>, userId);
      }
      return null;
    });
  }

  // Tạo love list mới cho user (chỉ gọi khi chưa có)
  Future<void> createLoveList(String userId) async {
    final now = DateTime.now();
    await _loveListsCollection.doc(userId).set({
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
      'songIds': [],
    });
  }

  // Thêm bài hát vào love list
  Future<void> addSongToLoveList(String userId, String songId) async {
    await _loveListsCollection.doc(userId).update({
      'songIds': FieldValue.arrayUnion([songId]),
      'updatedAt': Timestamp.now(),
    });
  }

  // Xóa bài hát khỏi love list
  Future<void> removeSongFromLoveList(String userId, String songId) async {
    await _loveListsCollection.doc(userId).update({
      'songIds': FieldValue.arrayRemove([songId]),
      'updatedAt': Timestamp.now(),
    });
  }

  // Lấy love list một lần (dùng khi cần kiểm tra tồn tại)
  Future<LoveListModel?> getLoveListOnce(String userId) async {
    final doc = await _loveListsCollection.doc(userId).get();
    if (doc.exists) {
      return LoveListModel.fromJson(doc.data() as Map<String, dynamic>, userId);
    }
    return null;
  }
}