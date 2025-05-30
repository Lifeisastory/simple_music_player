import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/global_repository.dart';
import '../view_models/history_viewmodel.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryViewModel>(builder: (context, historyVM, child) {
      return FutureBuilder(
        key: UniqueKey(),
        future: historyVM.loadItemsInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '播放历史',
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.teal,
                ),
              ),
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
            ),
            body: ListView.builder(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              itemCount: historyVM.itemsPath.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    // width: 60,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 左侧区域和中间区域合并为一个InkWell
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              context.read<GlobalRepository>().selectSong(
                                  songPath: historyVM.itemsPath[i]);
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: historyVM.itemsInfo[i]['artwork'] !=
                                          null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.memory(
                                            historyVM.itemsInfo[i]['artwork']!,
                                          ),
                                        )
                                      : Icon(Icons.music_note, size: 30),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        historyVM.itemsInfo[i]['title'] ??
                                            '未知歌曲',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.cyanAccent,
                                        ),
                                      ),
                                      Text(
                                        "${historyVM.itemsInfo[i]['album'] ?? '未知专辑'} - ${historyVM.itemsInfo[i]['artist'] ?? '未知歌手'}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.cyanAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 右侧按钮区域保持独立
                        SizedBox(
                          width: 120,
                          child: Row(
                            children: [
                              IconButton(
                                hoverColor: Colors.brown,
                                splashColor: Colors.brown,
                                highlightColor: Colors.brown,
                                iconSize: 20,
                                icon: Icon(Icons.playlist_add),
                                onPressed: () {
                                  historyVM.addToPlayQueue(
                                      context: context,
                                      songPath: historyVM.itemsPath[i]);
                                },
                              ),
                              IconButton(
                                hoverColor: Colors.brown,
                                splashColor: Colors.brown,
                                highlightColor: Colors.brown,
                                iconSize: 20,
                                icon: Icon(Icons.favorite),
                                onPressed: () {
                                  print('add to favorite');
                                },
                              ),
                              IconButton(
                                hoverColor: Colors.brown,
                                splashColor: Colors.brown,
                                highlightColor: Colors.brown,
                                iconSize: 20,
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  print('more');
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    });
  }
}
