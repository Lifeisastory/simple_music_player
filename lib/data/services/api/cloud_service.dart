import 'package:path/path.dart';
import 'package:webdav_client/webdav_client.dart' as webdav;
import 'dart:io';

class CloudService {
  late webdav.Client client;
  final url = 'https://dav.jianguoyun.com/dav/';
  final user = '******';
  final pwd = '******';
  final dirPath = '/MyMusics';
  String cachePath = "assets/musics/cache";

  CloudService() {
    client = webdav.newClient(
      url,
      user: user,
      password: pwd,
      debug: true,
    );
    try {
      Directory(cachePath).create(recursive: true);
      print("目录创建成功: ${Directory(cachePath).absolute.path}");
    } catch (e) {
      print("无法创建缓存目录: $e");
      rethrow;
    }
  }

  Future<List<String>> getCloudSongsName() async {
    List<webdav.File> songsInfo = [];
    List<String> songsName = [];
    songsInfo = await client.readDir(dirPath);
    for (var song in songsInfo) {
      songsName.add(song.name!);
    }
    return songsName;
  }

  Future<List<String>> getCacheSongsName({required String cachePath}) async {
    return await Directory(cachePath)
        .list(recursive: true)
        .where((entity) =>
            entity is File && entity.path.toLowerCase().endsWith('.mp3'))
        .map((entity) => basename(entity.path))
        .toList();
  }

  Future<int> cacheMusics() async {
    int count = 0;
    if (url.isEmpty || user.isEmpty || pwd.isEmpty) {
      print("you need add url || user || pwd");
      return 0;
    }
    List<String> cacheSongsName = await getCacheSongsName(cachePath: cachePath);
    List<String> cloudSongsName = await getCloudSongsName();
    for (var song in cloudSongsName) {
      if (!cacheSongsName.contains(song)) {
        print("downloading $song");
        try {
          await client.read2File("$dirPath\\$song", "$cachePath\\$song");
          count++;
        } catch (e) {
          if (count != 0) {
            print("download unfinished");
            return 1; // 下载未完成
          } else if (count == 0) {
            print("download failed");
            return -1; // 下载失败
          }
        }
      }
    }
    print("Download $count songs from cloud. finished.");
    // 再次检查缓存目录中的文件是否与云目录中的文件一致
    cacheSongsName = await getCacheSongsName(cachePath: cachePath);
    count = 0; 
    for (var song in cacheSongsName) {
      if (!cloudSongsName.contains(song)) {
        print("deleting $song ...");
        try {
          await File("$cachePath\\$song").delete();
          count++;
        } catch (e) {
          print("delete failed");
          return -1;
        }
      }
    }
    print("Delete $count songs in cache. Synchronize finished.");
    return 0; // 下载完成
  }
}
