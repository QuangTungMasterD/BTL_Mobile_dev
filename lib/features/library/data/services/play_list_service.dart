import 'package:btl_music_app/features/library/data/models/play_list_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayListService {
  final CollectionReference _playlistsCollection = 
      FirebaseFirestore.instance.collection('play_lists');

  // Lấy tất cả playlist của một user
  Stream<List<PlayListModel>> getUserPlaylists(String userId) {
    return _playlistsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PlayListModel.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Thêm playlist mới
  Future<String> createPlaylist(PlayListModel playlist) async {
    final docRef = await _playlistsCollection.add(playlist.toJson());
    return docRef.id;
  }

  // Cập nhật playlist
  Future<void> updatePlaylist(PlayListModel playlist) async {
    await _playlistsCollection.doc(playlist.id).update(playlist.toJson());
  }

  // Xóa playlist
  Future<void> deletePlaylist(String playlistId) async {
    await _playlistsCollection.doc(playlistId).delete();
  }

  // Thêm bài hát vào playlist
  Future<void> addSongToPlaylist(String playlistId, String songId) async {
    await _playlistsCollection.doc(playlistId).update({
      'songIds': FieldValue.arrayUnion([songId]),
      'updatedAt': Timestamp.now(),
    });
  }

  // Xóa bài hát khỏi playlist
  Future<void> removeSongFromPlaylist(String playlistId, String songId) async {
    await _playlistsCollection.doc(playlistId).update({
      'songIds': FieldValue.arrayRemove([songId]),
      'updatedAt': Timestamp.now(),
    });
  }

  // Lấy 1 playlist theo ID
  Future<PlayListModel?> getPlaylistById(String playlistId) async {
    final doc = await _playlistsCollection.doc(playlistId).get();
    if (doc.exists) {
      return PlayListModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}