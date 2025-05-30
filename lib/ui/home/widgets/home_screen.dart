import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/history/history_repository.dart';
import '../../../data/repositories/cloud/cloud_repository.dart';
import '../../../data/repositories/local/local_repository.dart';
import '../../../data/repositories/playlist/playlist_repository.dart';
import '../view_models/home_viewmodel.dart';
import '../../history/view_models/history_viewmodel.dart';
import '../../local/view_models/local_viewmodel.dart';
import '../../cloud/view_models/cloud_viewmodel.dart';
import '../../playlist/view_models/playlist_viewmodel.dart';
import 'dialog_widget.dart';
import '../../history/widgets/history_widget.dart';
import '../../local/widgets/local_widget.dart';
import '../../cloud/widgets/cloud_widget.dart';
import '../../playlist/widgets/playlist_widget.dart';
import '../../common/controller/widgets/controller_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, Icon> navigationIcons = {
    "最近播放": Icon(Icons.history),
    "本地音乐": Icon(Icons.folder),
    "云盘音乐": Icon(Icons.cloud),
  };
  Widget page = LocalPage();

  @override
  Widget build(BuildContext context) {
    print('home_screen: Widget rebuild');
    final HomeViewModel homeVM = context.read<HomeViewModel>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HistoryViewModel>(
          create: (_) =>
              HistoryViewModel(historyRepo: context.read<HistoryRepository>()),
        ),
        ChangeNotifierProvider<CloudViewModel>(
          create: (_) =>
              CloudViewModel(cloudRepo: context.read<CloudRepository>()),
        ),
        ChangeNotifierProvider<PlaylistViewModel>(
          create: (_) => PlaylistViewModel(
              playlistRepo: context.read<PlaylistRepository>()),
        ),
        ChangeNotifierProvider<LocalViewModel>(
          create: (_) =>
              LocalViewModel(localRepo: context.read<LocalRepository>()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: const Text('SMusicPlayer'),
          leading: IconButton(
            icon: Image.asset('assets/images/logo.png'),
            onPressed: () {
              homeVM.gotoSettings(context);
            },
          ),
        ),
        body: Column(
          children: [
            Divider(
              indent: 15,
              height: 1,
              color: const Color.fromARGB(255, 44, 44, 44),
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 180,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      switch (index) {
                                        case 0:
                                          page = HistoryPage();
                                          break;
                                        case 1:
                                          page = LocalPage();
                                          break;
                                        case 2:
                                          page = CloudPage();
                                          break;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                      255, 231, 240, 244)
                                                  .withValues(alpha: 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: navigationIcons.values
                                                .elementAt(index),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  navigationIcons.keys
                                                      .elementAt(index),
                                                  style:
                                                      TextStyle(fontSize: 14)),
                                              const SizedBox(height: 4),
                                              Text(
                                                  navigationIcons.keys
                                                      .elementAt(index),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                "我的歌单",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () async {
                                  await DialogWidget(
                                          onConfirm: homeVM.createPlaylist)
                                      .show(context);
                                },
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: FutureBuilder(
                            future: homeVM.loadPlaylistInfo(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return Consumer<HomeViewModel>(
                                  builder: (context, vm, child) {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: vm.playlistInfo.keys.length,
                                  itemBuilder: (context, index) {
                                    print('home_srceen: FutureBuilder rebuild');
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            page = PlaylistPage(
                                                playlistName: vm
                                                    .playlistInfo.keys
                                                    .toList()[index]);
                                          });
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: vm.playlistInfo.values
                                                                .toList()[index]
                                                            ["artwork"] ==
                                                        ''
                                                    ? Image.asset(
                                                        'assets/images/logo.png',
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.memory(
                                                        vm.playlistInfo.values
                                                                .toList()[index]
                                                            ["artwork"],
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      vm.playlistInfo.keys
                                                          .toList()[index],
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "${vm.playlistLength.values.toList()[index]}首歌",
                                                      style: TextStyle(
                                                          color: Colors.grey),
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
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                    color: const Color.fromARGB(255, 44, 44, 44),
                  ),
                  Expanded(
                    child: page,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.zero,
          child: ControllerWidget(),
        ),
      ),
    );
  }
}
