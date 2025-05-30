import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/global_repository.dart';
import '../../../data/repositories/cloud/cloud_repository.dart';
import '../../../data/repositories/playlist/playlist_repository.dart';

class CloudViewModel extends ChangeNotifier {
  final CloudRepository _cloudRepo;
  List<String> cacheSongsPath = [];
  List<Map<String, dynamic>> cacheSongsInfo = [];

  CloudViewModel({required CloudRepository cloudRepo}) : _cloudRepo = cloudRepo;

  Future<void> load() async {
    await _cloudRepo.fetchCloudSongs();
    await _cloudRepo.loadSongsPath();
    cacheSongsPath = _cloudRepo.cacheSongs;
    notifyListeners();
  }

  Future<void> loadCacheSongsInfo() async {
    cacheSongsInfo = [];
    await load();
    for (var songPath in cacheSongsPath) {
      await _cloudRepo.loadTags(currentMusicPath: songPath);
      cacheSongsInfo.add(_cloudRepo.tags);
    }
    notifyListeners();
  }

  void sortSongsByAlbum() {
    final indices = List.generate(cacheSongsPath.length, (i) => i);
    // 根据专辑信息排序索引
    indices.sort((a, b) {
      final albumA = cacheSongsInfo[a]['album']?.toLowerCase() ?? '';
      final albumB = cacheSongsInfo[b]['album']?.toLowerCase() ?? '';
      return albumA.compareTo(albumB);
    });
    // 同步排序两个列表
    cacheSongsInfo = [for (var i in indices) cacheSongsInfo[i]];
    cacheSongsPath = [for (var i in indices) cacheSongsPath[i]];
  }

  void addToPlayQueue(
      {required BuildContext context, required String songPath}) {
    context.read<GlobalRepository>().addSongToPlayQueue(songPath: songPath);
  }

    void addToFavorite(
      {required BuildContext context, required String songPath}) {
    context
        .read<PlaylistRepository>()
        .addToPlaylist(playlistName: '我喜欢', songPath: songPath);
  }
}
