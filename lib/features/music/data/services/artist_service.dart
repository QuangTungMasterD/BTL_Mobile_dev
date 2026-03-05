import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:btl_music_app/features/music/data/models/artist_model.dart';

class ArtistService {
  final CollectionReference _artistsCollection = FirebaseFirestore.instance.collection('artist');

  // Lấy tất cả nghệ sĩ (một lần)
  Future<List<ArtistModel>> getAllArtists() async {
    final snapshot = await _artistsCollection.get();
    return snapshot.docs.map((doc) {
      return ArtistModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Lấy nghệ sĩ theo ID
  Future<ArtistModel?> getArtistById(String id) async {
    final doc = await _artistsCollection.doc(id).get();
    if (doc.exists) {
      return ArtistModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Tìm kiếm nghệ sĩ theo tên (prefix search)
  Future<List<ArtistModel>> searchArtists(String query) async {
    if (query.trim().isEmpty) return [];
    
    final snapshot = await _artistsCollection
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .orderBy('name')
        .limit(10)
        .get();
        
    List<ArtistModel> result =  snapshot.docs.map((doc) {
      return ArtistModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    return result;
  }
}