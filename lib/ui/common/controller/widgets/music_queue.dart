/*
* 音乐播放列表
* 控制栏右侧的播放列表功能
*/
import 'package:flutter/material.dart';

class MusicQueueWidget extends StatelessWidget {
  MusicQueueWidget({
    required this.musicQueue,
    required this.onSelect,
    required this.getSongInfo,
  });
  final List<String> musicQueue;
  final Function({required String songPath}) onSelect;
  final Future<Map<String, dynamic>> Function({required String songPath})
      getSongInfo;

  @override
  Widget build(context) {
    return Material(    // InkWell需要依赖Material
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: const Color.fromARGB(255, 44, 44, 44),
              width: 1,
            ),
          ),
        ),
        child: SizedBox(
          width: 350,
          height: 579,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  "播放列表",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Divider(
                  color: const Color.fromARGB(255, 44, 44, 44),
                  indent: 15,
                  height: 1,
                  // thickness: 0.5,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: musicQueue.length,
                  itemBuilder: (context, i) {
                    return FutureBuilder(
                      future: getSongInfo(songPath: musicQueue[i]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Padding(
                          padding: const EdgeInsets.only(left: 15, bottom: 10),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            height: 50,
                            child: InkWell(
                              onTap: () {
                                onSelect(songPath: musicQueue[i]);
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: snapshot.data!['artwork'] != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.memory(
                                              snapshot.data!['artwork']!,
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
                                          snapshot.data!['title'] ?? '未知歌曲',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.cyanAccent,
                                          ),
                                        ),
                                        Text(
                                          "${snapshot.data!['album'] ?? '未知专辑'} - ${snapshot.data!['artist'] ?? '未知歌手'}",
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
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
