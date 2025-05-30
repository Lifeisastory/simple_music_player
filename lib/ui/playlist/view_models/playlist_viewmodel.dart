import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/global_repository.dart';
import '../../../data/repositories/playlist/playlist_repository.dart';

class PlaylistViewModel extends ChangeNotifier {
  PlaylistViewModel({required PlaylistRepository playlistRepo})
      : _playlistRepo = playlistRepo;
  final PlaylistRepository _playlistRepo;
  List<String> playlist = [];
  List<dynamic> playlistSongsInfo = [];

  Future<void> loadPlaylistSongsInfo({required String playlistName}) async {
    playlist = _playlistRepo.playlist[playlistName]!;
    playlistSongsInfo = [];

    for (var songPath in playlist) {
      await _playlistRepo.loadTags(currentMusicPath: songPath);
      playlistSongsInfo.add(_playlistRepo.tags);
    }
  }

  void addToPlayQueue(
      {required BuildContext context, required String songPath}) {
    context.read<GlobalRepository>().addSongToPlayQueue(songPath: songPath);
  }

  void addToFavorite(
      {required BuildContext context, required String songPath}) {
    context
        .read<PlaylistRepository>()
        .addToPlaylist(playlistName: '我喜欢', songPath: songPath);
  }
}
