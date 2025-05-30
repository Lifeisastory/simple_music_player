import 'package:flutter/material.dart';
import '../../services/local/metadata_service.dart';

class HistoryRepository extends ChangeNotifier {
  List<String> _historySongs = [];
  get historySongs => _historySongs;

  void addToHistory(String songPath) {
    if (_historySongs.contains(songPath)) {
      _historySongs.remove(songPath);
      _historySongs.insert(0, songPath);
    } else {
      _historySongs.insert(0, songPath);
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> getTags(
      {required String currentMusicPath}) async {
    return await MetadataService().fetchTags(currentMusicPath);
  }

}
