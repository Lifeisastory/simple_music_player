import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/global_repository.dart';
import '../view_models/playlist_viewmodel.dart';

class PlaylistPage extends StatelessWidget {
  PlaylistPage({required this.playlistName});
  final String playlistName;

  @override
  Widget build(BuildContext context) {
    final playlistVM = context.watch<PlaylistViewModel>();

    return FutureBuilder(
      key: UniqueKey(),
      future: playlistVM.loadPlaylistSongsInfo(playlistName: playlistName),
      builder: (context, snapshot) {
        print('playlist_widget: FutureBuilder rebuild');
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              playlistName,
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
            itemCount: playlistVM.playlist.length,
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
                                songPath: playlistVM.playlist[i]);
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: playlistVM.playlistSongsInfo[i]
                                            ['artwork'] !=
                                        null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(
                                          playlistVM.playlistSongsInfo[i]
                                              ['artwork']!,
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
                                      playlistVM.playlistSongsInfo[i]
                                              ['title'] ??
                                          '未知歌曲',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    Text(
                                      "${playlistVM.playlistSongsInfo[i]['album'] ?? '未知专辑'} - ${playlistVM.playlistSongsInfo[i]['artist'] ?? '未知歌手'}",
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
                                playlistVM.addToPlayQueue(
                                    context: context,
                                    songPath: playlistVM.playlist[i]);
                              },
                            ),
                            IconButton(
                              hoverColor: Colors.brown,
                              splashColor: Colors.brown,
                              highlightColor: Colors.brown,
                              iconSize: 20,
                              icon: Icon(Icons.favorite),
                              onPressed: () {
                                playlistVM.addToFavorite(
                                    context: context,
                                    songPath: playlistVM.playlist[i]);
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
