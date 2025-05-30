import 'package:flutter/material.dart';
import '../../../data/repositories/playlist/playlist_repository.dart';
import '../../../data/repositories/home/home_repository.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required PlaylistRepository playlistRepo})
      : _playlistRepo = playlistRepo {
    _playlistRepo.addListener(_onPlaylistRepoChanged);
  }

  final HomeRepository _homeRepo = HomeRepository();
  final PlaylistRepository _playlistRepo;
  Map<String, String> _playlistFirst = {};
  Map<String, int> playlistLength = {};
  Map<String, dynamic> playlistInfo = {};

  void _onPlaylistRepoChanged() async {
    await loadPlaylistInfo();
    print('home_viewmodel: playlistInfo updated');
    notifyListeners();
  }

  @override
  void dispose() {
    _playlistRepo.removeListener(_onPlaylistRepoChanged); 
    super.dispose();
  }

  Future<void> loadPlaylistInfo() async {
    for (var playlistName in _playlistRepo.playlist.keys) {
      playlistLength[playlistName] =
          _playlistRepo.playlist[playlistName]!.length;
      _playlistFirst[playlistName] =
          _playlistRepo.playlist[playlistName]!.isEmpty
              ? ''
              : _playlistRepo.playlist[playlistName]!.first;
    }
    await _homeRepo.loadTags(playlistFirst: _playlistFirst);
    playlistInfo = _homeRepo.tags;
  }

  bool createPlaylist({required String playlistName}) {
    return _playlistRepo.createPlaylist(playlistName: playlistName);
  }

  void gotoSettings(BuildContext context) {
    Navigator.of(context).pushNamed("settings");
  }
}
