import 'package:flutter/material.dart';
import '../../../../data/services/local/audio_service.dart';


class SliderViewModel extends ChangeNotifier {

  // bool isTap = false;

  final _audioSvc = AudioService();

  Future<void> seekTo(Duration pos) async {
    await _audioSvc.seek(pos);
  }

}