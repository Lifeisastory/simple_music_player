import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'dart:ui';
import '../view_models/song_info_viewmodel.dart';
import '../../common/controller/view_models/controller_viewmodel.dart';
import '../../common/controller/widgets/controller_widget.dart';
import 'lyric_ui1.dart';

class SongInfoScreen extends StatelessWidget {
  SongInfoScreen({required ControllerViewModel controllerVM, super.key})
      : _controllerVM = controllerVM;
  final ControllerViewModel _controllerVM;

  @override
  Widget build(BuildContext context) {
    final songInfoVM = context.watch<SongInfoViewModel>();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          songInfoVM.metaData['artwork'] != null
              ? Image.memory(
                  songInfoVM.metaData['artwork'],
                  fit: BoxFit.fill,
                )
              : Image.asset(
                  'assets/images/default_background.png',
                  fit: BoxFit.cover,
                ),
          // 毛玻璃模糊层
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
              child: Container(
                color: Colors.black.withValues(alpha: 0.3), // 可选，叠加一层半透明色
              ),
            ),
          ),
          // 主内容
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        iconSize: 45,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                    Center(
                      child: Text(
                        songInfoVM.metaData['title'] ?? '未知歌曲',
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  songInfoVM.metaData['artist'] ?? '未知歌手',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: LyricsReader(
                    model: songInfoVM.lyricModel,
                    position: _controllerVM.position.inMilliseconds,
                    lyricUi: UI1(highlight: false),
                    playing: _controllerVM.playState == PlayerState.playing,
                    size: Size(
                      double.infinity,
                      MediaQuery.of(context).size.height,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    emptyBuilder: () => Center(
                      child: Text(
                        songInfoVM.metaData['lyrics'] ?? '未知歌词',
                      ),
                    ),
                    selectLineBuilder: (progress, confirm) {
                      return Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (_controllerVM.playState ==
                                    PlayerState.stopped) {
                                  _controllerVM.playPause();
                                }
                                _controllerVM
                                    .seek(Duration(milliseconds: progress));
                                if (_controllerVM.playState ==
                                    PlayerState.paused) {
                                  _controllerVM.playPause();
                                }
                                confirm.call();
                              },
                              icon:
                                  Icon(Icons.play_arrow, color: Colors.green)),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(color: Colors.green),
                              height: 1,
                              width: double.infinity,
                            ),
                          ),
                          Text(
                            '${Duration(milliseconds: progress).inMinutes}:${(Duration(milliseconds: progress).inSeconds % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(color: Colors.green),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent, // 先设为透明
        elevation: 0,
        padding: EdgeInsets.zero,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35), // 调整模糊程度
            child: ControllerWidget(),
          ),
        ),
      ),
    );
  }
}
