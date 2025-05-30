import '../../services/local/metadata_service.dart';

class HomeRepository {
  Map<String, dynamic> tags = {};
  final MetadataService _metadataSvc = MetadataService();
  Future<void> loadTags({required Map<String, String> playlistFirst}) async {
    tags = {};
    for (var playlistName in playlistFirst.keys) {
      if (playlistFirst[playlistName] == '') {
        tags[playlistName] = {'artwork': ''};
        continue;
      }
      tags[playlistName] =
          await _metadataSvc.fetchTags(playlistFirst[playlistName]!);
    }
  }
}
