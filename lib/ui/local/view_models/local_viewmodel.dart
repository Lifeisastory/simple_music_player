import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/global_repository.dart';
import '../../../data/repositories/local/local_repository.dart';
import '../../../data/repositories/playlist/playlist_repository.dart';

class LocalViewModel extends ChangeNotifier {
  final LocalRepository _localRepo;
  List<String> localSongsPath = [];
  List<Map<String, dynamic>> localSongsInfo = [];

  LocalViewModel({required LocalRepository localRepo}) : _localRepo = localRepo;

  Future<void> load() async {
    await _localRepo.loadSongsPath();
    localSongsPath = _localRepo.localSongs;
    notifyListeners();
  }

  Future<void> loadLocalSongsInfo() async {
    localSongsInfo = [];
    await load();
    for (var songPath in localSongsPath) {
      await _localRepo.loadTags(currentMusicPath: songPath);
      localSongsInfo.add(_localRepo.tags);
    }
    notifyListeners();
  }

  void sortSongsByAlbum() {
    final indices = List.generate(localSongsPath.length, (i) => i);
    // 根据专辑信息排序索引
    indices.sort((a, b) {
      final albumA = localSongsInfo[a]['album']?.toLowerCase() ?? '';
      final albumB = localSongsInfo[b]['album']?.toLowerCase() ?? '';
      return albumA.compareTo(albumB);
    });
    // 同步排序两个列表
    localSongsInfo = [for (var i in indices) localSongsInfo[i]];
    localSongsPath = [for (var i in indices) localSongsPath[i]];
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
