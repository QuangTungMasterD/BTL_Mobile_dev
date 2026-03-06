import 'package:flutter/material.dart';
import 'package:btl_music_app/features/music/data/models/artist_model.dart';

class ArtistCard extends StatelessWidget {
  final ArtistModel artist;
  final VoidCallback onTap;

  const ArtistCard({
    super.key,
    required this.artist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: artist.avatar != null
              ? DecorationImage(
                  image: NetworkImage(artist.avatar!),
                  fit: BoxFit.cover,
                )
              : null,
          color: artist.avatar == null ? Colors.grey.shade800 : null,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(12),
          child: Text(
            artist.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}