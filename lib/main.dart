import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:window_size/window_size.dart';
// import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'data/repositories/global_repository.dart';
import 'data/repositories/history/history_repository.dart';
import 'data/repositories/local/local_repository.dart';
import 'data/repositories/cloud/cloud_repository.dart';
import 'data/repositories/playlist/playlist_repository.dart';
import 'data/repositories/song_info/song_info_repository.dart';
import 'ui/home/view_models/home_viewmodel.dart';
import 'ui/song_info/view_models/song_info_viewmodel.dart';
import 'ui/common/controller/view_models/controller_viewmodel.dart';
import 'ui/home/widgets/home_screen.dart';
import 'ui/song_info/widgets/song_info_screen.dart';
import 'ui/settings/widgets/settings_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //   setWindowMinSize(const Size(1610, 1130));
  // }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GlobalRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => HistoryRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => CloudRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaylistRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => SongInfoRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => ControllerViewModel(
            globalRepo: context.read<GlobalRepository>(),
            historyRepo: context.read<HistoryRepository>(),
            songInfoRepo: context.read<SongInfoRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              HomeViewModel(playlistRepo: context.read<PlaylistRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SongInfoViewModel(globalRepo: context.read<GlobalRepository>()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final GlobalRepository globalRepo = GlobalRepository();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // 程序启动时调用
    globalRepo.load(loadFrom: globalRepo.userDataPath['playQueue']);
    print("play_queue_data.txt loaded");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // 同时监听暂停和退出状态
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      await _savePlayQueue();
    }
  }

  Future<void> _savePlayQueue() async {
    try {
      await globalRepo.save(
          data: globalRepo.playQueue,
          saveToFile: globalRepo.userDataPath['playQueue']!);
      print("play_queue_data.txt saved successfully");
    } catch (e) {
      print("保存播放队列失败: $e");
    }
  }

  @override
  void dispose() {
    // 应用退出时强制保存
    _savePlayQueue();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      title: 'SMusicPlayer_test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 109, 103, 121),
          brightness: Brightness.dark,
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.oswald(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ),
      ),
      routes: {
        'home': (context) => HomeScreen(),
        'song_info': (context) =>
            SongInfoScreen(controllerVM: context.watch<ControllerViewModel>()),
        'settings': (context) => SettingsScreen(),
      },
    );
  }
}
