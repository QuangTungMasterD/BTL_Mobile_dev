// lib/widgets/song_item.dart
import 'package:btl_music_app/core/database/database_helper.dart';
import 'package:btl_music_app/core/providers/love_list_provider.dart';
import 'package:btl_music_app/core/providers/song_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:btl_music_app/core/providers/play_list_provider.dart';

class SongItem extends StatelessWidget {
  final String title;
  final String artist;
  final String image;
  final String songId;
  final VoidCallback? onTap;

  const SongItem({
    super.key,
    required this.title,
    required this.artist,
    required this.image,
    required this.songId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 55,
                  height: 55,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.music_note, size: 30),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              height: 55,
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () async {
                  final dbHelper = DatabaseHelper.instance;
                  final isDownloaded = await dbHelper.isSongDownloaded(songId);
                  _showSongOptions(context, isDownloaded);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSongOptions(BuildContext context, bool isDownloaded) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text("Thêm vào playlist"),
                onTap: () {
                  Navigator.pop(context);
                  _showAddToPlaylistSheet(context);
                },
              ),
              ListTile(
                leading: Icon(
                  isDownloaded ? Icons.check_circle : Icons.download,
                ),
                title: Text(isDownloaded ? "Đã tải về" : "Tải về"),
                onTap: isDownloaded
                    ? () async {
                        // Đã tải: hiện dialog xác nhận xóa
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Xóa bài hát"),
                            content: const Text(
                              "Bạn có chắc muốn xóa bài hát này khỏi danh sách đã tải?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text("Hủy"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text("Xóa"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          final dbHelper = DatabaseHelper.instance;
                          await dbHelper.deleteDownloadedSong(songId);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Đã xóa khỏi danh sách tải về"),
                              ),
                            );
                          }
                        }

                        // Đóng bottom sheet sau khi dialog đóng (nếu context vẫn còn)
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    : () async {
                        // Chưa tải: lưu metadata
                        final songProvider = context.read<SongProvider>();
                        final song = await songProvider.getSongById(songId);
                        if (song != null) {
                          final dbHelper = DatabaseHelper.instance;
                          await dbHelper.insertDownloadedSong(
                            songId: song.id,
                            title: song.title,
                            artist: song.artist,
                            thumbnailUrl: song.thumbnail,
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Đã tải bài hát"),
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Không tìm thấy thông tin bài hát",
                                ),
                              ),
                            );
                          }
                        }

                        // Đóng bottom sheet
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
              ),
              ListTile(
                leading: Consumer<LoveListProvider>(
                  builder: (context, loveProvider, child) {
                    final isLoved = loveProvider.isLoved(songId);
                    return Icon(
                      isLoved ? Icons.favorite : Icons.favorite_border,
                    );
                  },
                ),
                title: Consumer<LoveListProvider>(
                  builder: (context, loveProvider, child) {
                    final isLoved = loveProvider.isLoved(songId);
                    return Text(
                      isLoved ? "Bỏ yêu thích" : "Thêm vào yêu thích",
                    );
                  },
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final loveProvider = context.read<LoveListProvider>();
                  final isLoved = loveProvider.isLoved(songId);
                  await loveProvider.toggleLoveSong(songId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isLoved ? "Đã bỏ yêu thích" : "Đã thêm vào yêu thích",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddToPlaylistSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Consumer<PlayListProvider>(
          builder: (context, playlistProvider, child) {
            final playlists = playlistProvider.playlists;
            if (playlists.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text("Chưa có playlist nào"),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                final isInPlaylist = playlist.songIds.contains(songId);

                return ListTile(
                  leading: playlist.coverUrl != null
                      ? Image.network(
                          playlist.coverUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.queue_music),
                  title: Text(playlist.name),
                  trailing: Icon(
                    isInPlaylist ? Icons.remove_circle : Icons.add_circle,
                    color: isInPlaylist ? Colors.red : Colors.green,
                  ),
                  onTap: () {
                    if (isInPlaylist) {
                      playlistProvider.removeSongFromPlaylist(
                        playlist.id,
                        songId,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Đã xóa khỏi ${playlist.name}")),
                      );
                    } else {
                      playlistProvider.addSongToPlaylist(playlist.id, songId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Đã thêm vào ${playlist.name}")),
                      );
                    }
                    Navigator.pop(context); // đóng bottom sheet
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
