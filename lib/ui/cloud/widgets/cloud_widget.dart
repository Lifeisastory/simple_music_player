import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/global_repository.dart';
import '../view_models/cloud_viewmodel.dart';

class CloudPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cloudVM = context.read<CloudViewModel>();

    return FutureBuilder(
      key: UniqueKey(),
      future: cloudVM.loadCacheSongsInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        cloudVM.sortSongsByAlbum();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '网盘音乐',
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.teal,
              ),
            ),
            backgroundColor:Colors.transparent, 
            surfaceTintColor: Colors.transparent, 
          ),
          body: ListView.builder(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            itemCount: cloudVM.cacheSongsPath.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  alignment: Alignment.centerLeft,
                  width: 60,
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
                                songPath: cloudVM.cacheSongsPath[i]);
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: cloudVM.cacheSongsInfo[i]['artwork'] !=
                                        null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(
                                          cloudVM.cacheSongsInfo[i]['artwork']!,
                                        ),
                                      )
                                    : Icon(Icons.music_note, size: 30),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cloudVM.cacheSongsInfo[i]['title'] ?? '未知歌曲',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.cyanAccent,
                                    ),
                                  ),
                                  Text(
                                    "${cloudVM.cacheSongsInfo[i]['album'] ?? '未知专辑'} - ${cloudVM.cacheSongsInfo[i]['artist'] ?? '未知歌手'}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.cyanAccent,
                                    ),
                                  ),
                                ],
                              )
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
                                cloudVM.addToPlayQueue(
                                    context: context,
                                    songPath: cloudVM.cacheSongsPath[i]);
                              },
                            ),
                            IconButton(
                              hoverColor: Colors.brown,
                              splashColor: Colors.brown,
                              highlightColor: Colors.brown,
                              iconSize: 20,
                              icon: Icon(Icons.favorite),
                              onPressed: () {
                                cloudVM.addToFavorite(context: context, songPath: cloudVM.cacheSongsPath[i]);
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
