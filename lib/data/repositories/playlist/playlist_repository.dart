import 'package:flutter/material.dart';
import '../../services/local/metadata_service.dart';

class PlaylistRepository extends ChangeNotifier {
  Map<String, List<String>> playlist = {
    '我喜欢': [
      'assets\\musics\\local\\周杰伦 - .斗牛.mp3',
    ],
    '华语乐坛': [
      'assets\\musics\\local\\周杰伦 - .反方向的钟.mp3',
      'assets\\musics\\local\\周杰伦 - .黑色幽默.mp3',
    ],
  };
  Map<String, dynamic> tags = {};

  Future<void> loadTags({required String currentMusicPath}) async {
    tags = {};
    tags = await MetadataService().fetchTags(currentMusicPath);
  }

  Future<void> addToPlaylist(
      {required String playlistName, required String songPath}) async {
    if (!playlist.containsKey(playlistName)) {
      print('添加失败！该歌单不存在!');
      return; 
    } else if (playlist[playlistName]!.contains(songPath)) {
      print('添加失败！该歌曲已存在!');
      return;
    }
    playlist[playlistName]?.insert(0, songPath);
    print("playlist_repository: addToPlaylist success");
    notifyListeners();
  }

  bool createPlaylist({required String playlistName}) {
    if (playlist.containsKey(playlistName)) {
      print('创建失败！该歌单已存在!');
      return true;    // true表示isPlaylistExist为真
    }
    playlist.putIfAbsent(playlistName, () => []);
    notifyListeners();
    return false;
  }
}
