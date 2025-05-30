import 'dart:io';

class SongService {
  /// 扫描指定目录下所有 mp3 文件，返回文件路径列表
  Future<List<String>> fetchLocalSongs({required final String dirPath}) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) return [];
    final files = await dir
        .list(recursive: true)
        .where((entity) =>
            entity is File && entity.path.toLowerCase().endsWith('.mp3'))
        .map((entity) => entity.path)
        .toList();
    return files;
  }

  /// 将播放列表、播放历史和用户歌单等数据持久化到本地文件中
  Future<void> save({required dynamic data, required String saveToFile}) async {
    String jsonString;
    final file = File(saveToFile);
    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }
    if (data is List) {
      jsonString = data.map((e) => e.toString()).join('\n');
    } else {
      jsonString = data.toString();
    }
    await file.writeAsString(jsonString);
    print("save to $saveToFile");
  }
  // String _encodeData(dynamic data) {
  //   if (data is List) {
  //     return data.map((e) => e.toString()).join('\n');
  //   }
  //   return data.toString();
  // }

  /// 从本地文件或数据库中加载播放列表、播放历史和用户歌单等数据
  Future<dynamic> load({required String loadFrom}) async {
    final file = File(loadFrom);
    if (!await file.exists()) return [];
    final jsonString = await file.readAsString();
    return jsonString;
  }

}
