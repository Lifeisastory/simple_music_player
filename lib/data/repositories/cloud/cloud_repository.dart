import 'package:flutter/material.dart';
import '../../services/api/cloud_service.dart';
import '../../services/local/song_service.dart';
import '../../services/local/metadata_service.dart';
import '../../services/local/lyric_service.dart';

class CloudRepository extends ChangeNotifier {
  int flag = 0;
  Map<String, dynamic> _tags = {};
  String _lyrics = '';
  final String _cacheSongsDir = 'assets\\musics\\cache';
  List<String> cacheSongs = [];
  Map<String, dynamic> get tags => _tags;
  String get lyrics => _lyrics;
  CloudService _cloudService = CloudService();

  Future<void> fetchCloudSongs() async {
    flag = await _cloudService.cacheMusics();
  }

  Future<void> loadSongsPath() async {
    cacheSongs = await SongService().fetchLocalSongs(dirPath: _cacheSongsDir);
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
