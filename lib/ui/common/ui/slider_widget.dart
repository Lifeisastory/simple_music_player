import 'package:flutter/material.dart';

class ProgressSlider extends StatefulWidget {
  final Duration current;
  final Duration total;
  final ValueChanged<Duration> onChangedEnd;
  const ProgressSlider({
    required this.current,
    required this.total,
    required this.onChangedEnd,
    super.key,
  });

  @override
  State<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  Duration process = Duration.zero;
  bool isTap = false;

  @override
  Widget build(BuildContext context) {
    if (!isTap) {
      process = widget.current;
    }
    return SizedBox(
      height: 2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 2),
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 0), // 移除点击时的圆形覆盖
            ),
            child: Slider(
              min: 0,
              max: widget.total.inMilliseconds.toDouble(),
              value: process.inMilliseconds
                  .clamp(0, widget.total.inMilliseconds)
                  .toDouble(),
              onChanged: (value) {
                setState(() {
                  process = Duration(milliseconds: value.toInt());
                });
              },
              onChangeStart: (value) {
                isTap = true;
              },
              onChangeEnd: (value) {
                isTap = false;
                widget.onChangedEnd(process);
              },
              padding: EdgeInsets.zero, // 清除内边距
            ),
          );
        },
      ),
    );
  }
}

class VolumeSlider extends StatefulWidget {
  final ValueChanged<double> onChanged;
  final double volume;

  VolumeSlider({
    required this.onChanged,
    required this.volume,
    super.key,
  });

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  double _volume = 0.0;
  bool _isTap = false;
  @override
  Widget build(BuildContext context) {
    if (!_isTap) {
      _volume = widget.volume;
    }
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 40,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), // 这里设置倒角
        ),
        child: RotatedBox(
          quarterTurns: -1,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 3),
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 0), // 移除点击时的圆形覆盖
            ),
            child: Slider(
              value: _volume,
              min: 0.0,
              max: 1.0,
              onChanged: (v) {
                setState(() {
                  _volume = v;
                });
              },
              onChangeStart: (value) {
                _isTap = true;
              },
              onChangeEnd: (value) {
                widget.onChanged(_volume);
                _isTap = false;
              },
            ),
          ),
        ),
      ),
    );
  }
}
