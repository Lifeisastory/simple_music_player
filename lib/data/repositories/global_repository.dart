import 'package:flutter/material.dart';
import '../services/local/song_service.dart';

class GlobalRepository extends ChangeNotifier {
  // 当前播放的歌曲路径
  String _currentSongPath = 'assets\\musics\\local\\周杰伦 - .印第安老斑鸠.mp3';
  get currentSongPath => _currentSongPath;
  // 播放列表
  List<String> _playQueue = [];
  get playQueue => _playQueue;
  // 用户数据
  final Map<String, String> _userDataPath = {
    'playQueue': 'user\\play_queue_data.txt'
  };
  get userDataPath => _userDataPath;

  void selectSong({required String songPath}) {
    _currentSongPath = '';
    _currentSongPath = songPath;
    notifyListeners();
  }

  void addSongToPlayQueue({required String songPath}) {
    if (!_playQueue.contains(songPath)) {
      _playQueue.add(songPath);
      notifyListeners();
    }
  }

  Future<void> save({required dynamic data, required String saveToFile}) async {
    await SongService().save(data: data, saveToFile: saveToFile);
  }

  Future<void> load({required String loadFrom}) async {
    final data = await SongService().load(loadFrom: loadFrom);
    if (data.isNotEmpty) {
      print(data);
      // _playQueue = data;
      notifyListeners();
    }
  }
}
