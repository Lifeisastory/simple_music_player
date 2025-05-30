import 'package:flutter/material.dart';
import '../../services/local/song_service.dart';
import '../../services/local/metadata_service.dart';
import '../../services/local/lyric_service.dart';

class LocalRepository extends ChangeNotifier {
  Map<String, dynamic> _tags = {};
  String _lyrics = '';
  final String _localSongsDir = 'assets\\musics\\local';
  List<String> localSongs = [];
  Map<String, dynamic> get tags => _tags;
  String get lyrics => _lyrics;

  Future<void> loadSongsPath() async {
    localSongs = await SongService().fetchLocalSongs(dirPath: _localSongsDir);
  }

  Future<void> loadTags({required String currentMusicPath}) async {
    _tags = {};
    _tags = await MetadataService().fetchTags(currentMusicPath);
  }

  Future<void> loadLyrics({required String currentMusicPath}) async {
    _lyrics = await LyricService()
        .fetchLocalLyrics(currentMusicPath: currentMusicPath);
  }
}
