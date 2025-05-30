import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/global_repository.dart';
import '../view_models/local_viewmodel.dart';

class LocalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localVM = context.read<LocalViewModel>();

    return FutureBuilder(
      key: UniqueKey(),
      future: localVM.loadLocalSongsInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        localVM.sortSongsByAlbum();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '本地音乐',
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
            itemCount: localVM.localSongsPath.length,
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
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            context.read<GlobalRepository>().selectSong(
                                songPath: localVM.localSongsPath[i]);
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: localVM.localSongsInfo[i]['artwork'] !=
                                        null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(
                                          localVM.localSongsInfo[i]['artwork']!,
                                        ),
                                      )
                                    : Icon(Icons.music_note, size: 30),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localVM.localSongsInfo[i]['title'] ??
                                          '未知歌曲',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    Text(
                                      "${localVM.localSongsInfo[i]['album'] ?? '未知专辑'} - ${localVM.localSongsInfo[i]['artist'] ?? '未知歌手'}",
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
                                print('add to play queue');
                                localVM.addToPlayQueue(
                                    context: context,
                                    songPath: localVM.localSongsPath[i]);
                              },
                            ),
                            IconButton(
                              hoverColor: Colors.brown,
                              splashColor: Colors.brown,
                              highlightColor: Colors.brown,
                              iconSize: 20,
                              icon: Icon(Icons.favorite),
                              onPressed: () {
                                localVM.addToFavorite(context: context, songPath: localVM.localSongsPath[i]);
                              },
                              // mouseCursor: SystemMouseCursors.click,
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
                              // mouseCursor: SystemMouseCursors.click,
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
  }
}
