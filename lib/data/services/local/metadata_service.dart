import 'package:audiotags/audiotags.dart';

class MetadataService {
  Future<Map<String, dynamic>> fetchTags(String path) async {
    final tag = await AudioTags.read(path);
    return {
      'title': tag?.title ?? '未知标题',
      'artist': tag?.trackArtist ?? '未知艺术家',
      'album': tag?.album ?? '未知专辑',
      'lyrics': tag?.lyrics ?? '暂无歌词',
      'artwork': (tag?.pictures.isNotEmpty ?? false)
        ? tag!.pictures.first.bytes
        : null,
    };
  }
}
