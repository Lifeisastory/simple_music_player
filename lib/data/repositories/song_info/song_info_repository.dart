/// 维护tags和lyrics用于获取歌曲信息和歌词信息。
/// 包括loadTags和loadLyrics方法，用于加载歌曲信息和歌词信息。

import 'package:flutter/material.dart';
import '../../services/local/metadata_service.dart';
import '../../services/local/lyric_service.dart';

class SongInfoRepository extends ChangeNotifier {
  Map<String, dynamic> _tags = {};
  get tags => _tags;
  String _lyrics = '';
  get lyrics => _lyrics;

  Future<void> loadTags({required String currentMusicPath}) async {
    _tags = await MetadataService().fetchTags(currentMusicPath);
  }

  Future<void> loadLyrics({required String currentMusicPath}) async {
    _lyrics = await LyricService()
        .fetchLocalLyrics(currentMusicPath: currentMusicPath);
  }
}
