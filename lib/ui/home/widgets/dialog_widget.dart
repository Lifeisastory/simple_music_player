import 'package:flutter/material.dart';

class DialogWidget {
  DialogWidget({required this.onConfirm});

  final bool Function({required String playlistName}) onConfirm;
  final controller = TextEditingController();

  Future<(String?, bool)> _buildDialog(BuildContext context) async {
    String? playlistName;
    bool isPlaylistExist = false;
    playlistName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Center(child: Text("新建歌单")),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "输入歌单名称",
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(Icons.close, color: Colors.red, size: 30),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context, controller.text);
                isPlaylistExist = onConfirm(playlistName: controller.text);
              } else {
                Navigator.pop(context);
              }
            },
            child: Icon(Icons.check, color: Colors.blue, size: 30),
          )
        ],
      ),
    );
    return (playlistName, isPlaylistExist);
  }

  void _resultDialog(BuildContext context, bool isPlaylistExist) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              color: isPlaylistExist ? Colors.red : Colors.blue,
              size: 30,
            ),
            SizedBox(width: 10),
            Text(isPlaylistExist ? "歌单已存在！" : "歌单创建成功！",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
    Future.delayed(Duration(seconds: 2), () {
      if (context.mounted) Navigator.pop(context);
    });
  }

  Future<void> show(BuildContext context) async {
    (String?, bool) result = await _buildDialog(context);
    if (result.$1 != null && context.mounted) {
      _resultDialog(context, result.$2);
    }
  }
}
