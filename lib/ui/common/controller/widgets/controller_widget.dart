import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/controller_viewmodel.dart';
import 'music_queue.dart';
import '../../ui/marquee_widget.dart';
import '../../ui/slider_widget.dart';

class ControllerWidget extends StatefulWidget {
  @override
  State<ControllerWidget> createState() => _ControllerWidgetState();
}

class _ControllerWidgetState extends State<ControllerWidget> {
  OverlayEntry? _volumeOverlay; // 音量控制浮层
  OverlayEntry? _musicQueueOverlay; // 播放队列浮层
  bool _isMute = false; // 静音状态
  bool _isEnter = false; // 鼠标是否放在了音量按钮上
  bool _isShowMusicQueue = false; // 播放队列是否显示
  final GlobalKey _volumeKey = GlobalKey(); // 音量按钮的key
  final GlobalKey _musicQueueKey = GlobalKey(); // 播放队列按钮的key

  @override
  Widget build(BuildContext context) {
    final controllerVM = context.watch<ControllerViewModel>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /// 进度条
        ProgressSlider(
          current: controllerVM.position,
          total: controllerVM.duration,
          onChangedEnd: controllerVM.seek,
        ),

        /// 底部播放栏
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// 底部左侧内容
              SizedBox(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 歌曲封面
                    IconButton(
                      iconSize: 50,
                      icon: ModalRoute.of(context)!.settings.name == 'song_info'
                          ? Icon(Icons.keyboard_double_arrow_down)
                          : controllerVM.metaData['artwork'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.memory(
                                    controllerVM.metaData['artwork']!,
                                  ),
                                )
                              : Icon(Icons.music_note),
                      onPressed: () {
                        controllerVM.switchCover(context);
                      },
                    ),
                    // 歌曲标题、时长
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: MarqueeWidget(
                                  "${controllerVM.metaData['title'] ?? '未知歌曲'} - ${controllerVM.metaData['artist'] ?? '未知歌手'}"),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${controllerVM.position.inMinutes}:${(controllerVM.position.inSeconds % 60).toString().padLeft(2, '0')}/${controllerVM.duration.inMinutes}:${(controllerVM.duration.inSeconds % 60).toString().padLeft(2, '0')}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: "NewTimesRoman",
                                      fontWeight: FontWeight.w700,
                                      color: Colors.tealAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              /// 底部中间控制按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: IconButton(
                      iconSize: 45,
                      icon: Icon(Icons.skip_previous),
                      onPressed: () {
                        controllerVM.skipPrevious();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: IconButton.filled(
                      iconSize: 35,
                      icon: Icon(
                        controllerVM.playState == PlayerState.playing
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: controllerVM.playPause,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: IconButton(
                      iconSize: 45,
                      icon: Icon(Icons.skip_next),
                      onPressed: () {
                        controllerVM.skipNext();
                      },
                    ),
                  ),
                ],
              ),

              /// 底部右侧内容
              SizedBox(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Builder(
                      /// 音量控制
                      builder: (context) {
                        return MouseRegion(
                          onEnter: (event) {
                            // 获取IconButton的全局坐标
                            final RenderBox box = _volumeKey.currentContext!
                                .findRenderObject() as RenderBox;
                            final Offset pos = box.localToGlobal(Offset.zero);
                            final Size size = box.size;
                            _volumeOverlay = OverlayEntry(
                              builder: (context) => Positioned(
                                left: pos.dx + size.width / 2 - 20, // 居中显示
                                top: pos.dy - 100,
                                child: Consumer<ControllerViewModel>(
                                    // OverLay独立于widget树，所以使用context.watch<T>()会重建整个页面，但不会
                                    // 重建OverLay；而Consumer<T>()只会重建其builder函数返回的
                                    // 子树。建议：顶层使用context.read<T>()避免频繁重建，在需要
                                    // 重建的地方使用Consumer<T>()。
                                    // 另外，context.select<T, V>((T value) => V) 可以指定监听具体的状态来重建
                                    // 子树；context.read<T>()仅获取一次状态，适合用来调用ViewModel中的方法
                                    builder: (context, vm, child) {
                                  return MouseRegion(
                                    onEnter: (event) {
                                      _isEnter = true;
                                    },
                                    onExit: (_) {
                                      _volumeOverlay?.remove();
                                      _volumeOverlay = null;
                                      _isEnter = false;
                                    },
                                    child: VolumeSlider(
                                      onChanged: controllerVM.setVolume,
                                      volume: controllerVM.volume,
                                    ),
                                  );
                                }),
                              ),
                            );
                            Overlay.of(context).insert(_volumeOverlay!);
                          },
                          onExit: (event) {
                            Future.delayed(Duration(milliseconds: 1), () {
                              if (!_isEnter && _volumeOverlay != null) {
                                _volumeOverlay?.remove();
                                _volumeOverlay = null;
                              }
                            });
                          },
                          child: IconButton(
                            key: _volumeKey,
                            iconSize: 35,
                            icon: _isMute
                                ? Icon(Icons.volume_off)
                                : Icon(Icons.volume_up),
                            onPressed: () {
                              setState(() {
                                _isMute = !_isMute;
                              });
                              _isMute
                                  ? controllerVM.setVolume(0)
                                  : controllerVM
                                      .setVolume(controllerVM.lastVolume);
                            },
                          ),
                        );
                      },
                    ),
                    IconButton(
                      iconSize: 35,
                      icon: Icon([
                        Icons.repeat,
                        Icons.repeat_one,
                        Icons.shuffle,
                      ][controllerVM.playModeIndex]),
                      onPressed: controllerVM.switchMode,
                    ),
                    IconButton(
                      key: _musicQueueKey,
                      iconSize: 35,
                      icon: Icon(Icons.queue_music),
                      onPressed: () {
                        final RenderBox box = _musicQueueKey.currentContext!
                            .findRenderObject() as RenderBox;
                        final Offset pos = box.localToGlobal(Offset.zero);
                        (_isShowMusicQueue = !_isShowMusicQueue)
                            ? {
                                _musicQueueOverlay = OverlayEntry(
                                  builder: (context) => Stack(
                                    children: [
                                      Positioned.fill(
                                        child: GestureDetector(
                                          onTapDown: (_) {
                                            _musicQueueOverlay?.remove();
                                            _musicQueueOverlay = null;
                                            _isShowMusicQueue = false;
                                          },
                                          behavior: HitTestBehavior.opaque,
                                        ),
                                      ),
                                      Positioned(
                                        left: pos.dx - 295,
                                        top: pos.dy - 595,
                                        child: MusicQueueWidget(
                                          musicQueue: controllerVM.musicQueue,
                                          onSelect: controllerVM.selectSong,
                                          getSongInfo: controllerVM.getSongInfo2, 
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Overlay.of(context).insert(_musicQueueOverlay!)
                              }
                            : {
                                _musicQueueOverlay?.remove(),
                                _musicQueueOverlay = null
                              };
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
