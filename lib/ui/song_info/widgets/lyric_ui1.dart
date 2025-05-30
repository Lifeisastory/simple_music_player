import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/lyric_ui.dart';

///Sample Netease style
///should be extends LyricUI implementation your own UI.
///this property only for change UI,if not demand just only overwrite methods.
class UI1 extends LyricUI {
  double defaultSize;
  double defaultExtSize;
  double otherMainSize;
  double bias;
  double lineGap;
  double inlineGap;
  LyricAlign lyricAlign;
  LyricBaseLine lyricBaseLine;
  bool highlight;
  HighlightDirection highlightDirection;

  UI1(
      {this.defaultSize = 22,
      this.defaultExtSize = 14,
      this.otherMainSize = 18,
      this.bias = 0.5,
      this.lineGap = 25,
      this.inlineGap = 25,
      this.lyricAlign = LyricAlign.CENTER,
      this.lyricBaseLine = LyricBaseLine.CENTER,
      this.highlight = true,
      this.highlightDirection = HighlightDirection.LTR});

  UI1.clone(UI1 ui1)
      : this(
          defaultSize: ui1.defaultSize,
          defaultExtSize: ui1.defaultExtSize,
          otherMainSize: ui1.otherMainSize,
          bias: ui1.bias,
          lineGap: ui1.lineGap,
          inlineGap: ui1.inlineGap,
          lyricAlign: ui1.lyricAlign,
          lyricBaseLine: ui1.lyricBaseLine,
          highlight: ui1.highlight,
          highlightDirection: ui1.highlightDirection,
        );

  @override
  TextStyle getPlayingExtTextStyle() =>
      TextStyle(color: Colors.grey[300], fontSize: defaultExtSize);

  @override
  TextStyle getOtherExtTextStyle() => TextStyle(
        color: Colors.grey[300],
        fontSize: defaultExtSize,
      );

  @override
  TextStyle getOtherMainTextStyle() => TextStyle(
      color: Colors.grey,
      fontSize: otherMainSize,
      fontWeight: FontWeight.normal);

  @override
  TextStyle getPlayingMainTextStyle() => TextStyle(
      color: Colors.lightBlueAccent,
      fontSize: defaultSize,
      fontWeight: FontWeight.bold);

  @override
  double getInlineSpace() => inlineGap;

  @override
  double getLineSpace() => lineGap;

  @override
  double getPlayingLineBias() => bias;

  @override
  LyricAlign getLyricHorizontalAlign() => lyricAlign;

  @override
  LyricBaseLine getBiasBaseLine() => lyricBaseLine;

  @override
  bool enableHighlight() => highlight;

  @override
  HighlightDirection getHighlightDirection() => highlightDirection;
}
