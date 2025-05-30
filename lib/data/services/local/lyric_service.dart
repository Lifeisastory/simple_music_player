import 'dart:io';

/// 搜索本地歌曲同名歌词文件
class LyricService {
  Future<String> fetchLocalLyrics({required String currentMusicPath}) async {
    final dir = Directory('assets\\musics\\local');
    if (!await dir.exists()) return '';
    // 提取歌曲文件名（不含扩展名）
    final songName = currentMusicPath.split(Platform.pathSeparator).last.split('.').first;
    await for (var entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.toLowerCase().endsWith('${songName.toLowerCase()}.lrc')) {
        // 读取歌词文件内容并返回
        return await entity.readAsString();
      }
    }
    return '';
  }
}