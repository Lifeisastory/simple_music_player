import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Stream<Duration> get onPositionChanged => _player.onPositionChanged;
  Stream<void> get onComplete => _player.onPlayerComplete;
  Stream<Duration> get onDurationChanged => _player.onDurationChanged;

  Future<void> play(String path) async => await _player.play(DeviceFileSource(path));
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration pos) => _player.seek(pos);
  Future<void> resume() => _player.resume();
  Future<Duration?> getDuration() => _player.getDuration();
}
