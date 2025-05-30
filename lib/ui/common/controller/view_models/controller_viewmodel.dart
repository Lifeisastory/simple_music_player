import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import '../../../../data/repositories/global_repository.dart';
import '../../../../data/repositories/song_info/song_info_repository.dart';
import '../../../../data/repositories/history/history_repository.dart';

enum PlayerState { playing, paused, stopped }

class ControllerViewModel extends ChangeNotifier {
  ControllerViewModel(
      {required GlobalRepository globalRepo,
      required HistoryRepository historyRepo,
      required SongInfoRepository songInfoRepo})
      : _globalRepo = globalRepo,
        _historyRepo = historyRepo,
        _songInfoRepo = songInfoRepo,
        _currentMusicPath = globalRepo.currentSongPath {
    loadSongMetaData(_currentMusicPath);
    setVolume(volume);
    _globalRepo.addListener(_onGlobalRepoChanged);
  }

  void _onGlobalRepoChanged() {
    final newPath = _globalRepo.currentSongPath;
    final newQueue = _globalRepo.playQueue;

    if (newPath != _currentMusicPath) {
      _currentMusicPath = newPath;
      getSongPath(_currentMusicPath);
    }
    
    if (newQueue != musicQueue) {
      musicQueue = newQueue;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _globalRepo.removeListener(_onGlobalRepoChanged);
    super.dispose();
  }

  final List<String> playModes = ['repeat', 'repeat_one', 'random'];
  List<String> musicQueue = [];
  int currentIndex = 0;
  Map<String, dynamic> metaData = {};
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  PlayerState playState = PlayerState.stopped;
  double volume = 0.3;
  double lastVolume = 0.3;
  int playModeIndex = 0;

  final GlobalRepository _globalRepo;
  final HistoryRepository _historyRepo;
  final SongInfoRepository _songInfoRepo;
  AudioPlayer? _audioPlayer;
  String _currentMusicPath = '';

  void _completed() {
    if (musicQueue.isEmpty) {
      _audioPlayer = null;
      _play();
    } else {
      if (playModes[playModeIndex] == 'repeat') {
        currentIndex = (currentIndex + 1) % musicQueue.length;
        _globalRepo.selectSong(songPath: _globalRepo.playQueue[currentIndex]);
      } else if (playModes[playModeIndex] == 'repeat_one') {
        _audioPlayer = null;
        _play();
      } else if (playModes[playModeIndex] == 'random') {
        int previous = currentIndex;
        do {
          currentIndex = Random().nextInt(musicQueue.length);
        } while (currentIndex == previous);
        _globalRepo.selectSong(songPath: _globalRepo.playQueue[currentIndex]);
      }
    }
  }

  Future<void> loadSongMetaData(String path) async {
    await _songInfoRepo.loadTags(currentMusicPath: path);
    metaData = _songInfoRepo.tags;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getSongInfo2({required String songPath}) async {
    await _songInfoRepo.loadTags(currentMusicPath: songPath);
    return _songInfoRepo.tags;
  }

  Future<void> _play() async {
    if (_audioPlayer == null) {
      _audioPlayer = AudioPlayer()..play(DeviceFileSource(_currentMusicPath));
      _audioPlayer?.setVolume(volume);
      _audioPlayer?.onDurationChanged.listen((d) {
        duration = d;
      });
      _audioPlayer?.onPositionChanged.listen((d) {
        position = d;
        notifyListeners();
      });
      _audioPlayer?.onPlayerComplete.listen((_) => _completed());
    } else {
      _audioPlayer?.resume();
    }
    _historyRepo.addToHistory(_currentMusicPath);
    playState = PlayerState.playing;
    notifyListeners();
  }

  void getSongPath(String path) async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
      playState = PlayerState.stopped;
      _audioPlayer = null;
      notifyListeners();
    }
    await loadSongMetaData(path);
    await _play();
  }

  Future<void> seek(Duration pos) async {
    await _audioPlayer?.seek(pos);
    position = pos;
    notifyListeners();
  }

  void switchCover(BuildContext context) {
    if (ModalRoute.of(context)?.settings.name == "song_info") {
      Navigator.of(context).pop();
    } else if (ModalRoute.of(context)?.settings.name == "home") {
      Navigator.of(context).pushNamed("song_info");
    }
  }

  Future<void> playPause() async {
    if (playState == PlayerState.playing) {
      await _audioPlayer?.pause();
      playState = PlayerState.paused;
      notifyListeners();
    } else {
      await _play();
    }
  }

  void switchMode() {
    playModeIndex = (playModeIndex + 1) % playModes.length;
    notifyListeners();
  }

  void setVolume(double volumeValue) {
    _audioPlayer?.setVolume(volumeValue);
    lastVolume = volume;
    volume = volumeValue;
    notifyListeners();
  }

  void selectSong({required String songPath}) {
    _globalRepo.selectSong(songPath: songPath);
  }

  void skipNext() {
    if (musicQueue.isNotEmpty) {
      currentIndex = (currentIndex + 1) % musicQueue.length;
      _globalRepo.selectSong(songPath: _globalRepo.playQueue[currentIndex]);
    } else {
      getSongPath(_currentMusicPath);
    }
  }

  void skipPrevious() {
    if (musicQueue.isNotEmpty) {
      currentIndex = (currentIndex - 1 + musicQueue.length) % musicQueue.length;
      _globalRepo.selectSong(songPath: _globalRepo.playQueue[currentIndex]);
    } else {
      getSongPath(_currentMusicPath);
    }
  }
}
