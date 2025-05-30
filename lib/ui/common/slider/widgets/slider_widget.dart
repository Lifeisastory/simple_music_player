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
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 3),
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
