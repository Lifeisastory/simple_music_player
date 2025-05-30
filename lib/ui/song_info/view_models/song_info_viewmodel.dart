import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';
import '../../../data/repositories/global_repository.dart';
import '../../../data/repositories/song_info/song_info_repository.dart';

class SongInfoViewModel extends ChangeNotifier {
  SongInfoViewModel({required GlobalRepository globalRepo})
      : _globalRepo = globalRepo {
    loadMeta(_globalRepo.currentSongPath);
    _globalRepo.addListener(_onTestSongChanged);
  }

  @override
  void dispose() {
    _globalRepo.removeListener(_onTestSongChanged);
    super.dispose();
  }

  final GlobalRepository _globalRepo;
  final SongInfoRepository _songInfoRepo = SongInfoRepository();
  String _lastLyric = '';
  Map<String, dynamic> metaData = {};
  LyricsReaderModel? lyricModel;

  void _onTestSongChanged() {
    loadMeta(_globalRepo.currentSongPath); // 重新加载元数据和歌词
  }

  Future<void> loadMeta(String currentMusicPath) async {
    await _songInfoRepo.loadTags(currentMusicPath: currentMusicPath);
    metaData = _songInfoRepo.tags;
    if (metaData['lyrics'] == '暂无歌词') {
      await _songInfoRepo.loadLyrics(currentMusicPath: currentMusicPath);
      metaData['lyrics'] = _songInfoRepo.lyrics;
    }

    final currentLyric = metaData['lyrics'] ?? '未知歌词';
    if (_lastLyric != currentLyric) {
      lyricModel =
          LyricsModelBuilder.create().bindLyricToMain(currentLyric).getModel();
      _lastLyric = currentLyric;
    }
    notifyListeners();
  }
}
