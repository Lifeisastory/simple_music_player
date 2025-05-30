import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/global_repository.dart';
import '../../../data/repositories/history/history_repository.dart';

class HistoryViewModel extends ChangeNotifier {
  final HistoryRepository _historyRepo;
  List<String> itemsPath = [];
  List<Map<String, dynamic>> itemsInfo = [];

  HistoryViewModel({required HistoryRepository historyRepo})
      : _historyRepo = historyRepo {
    _historyRepo.addListener(_onHistoryRepoChanged);
  }

  void _onHistoryRepoChanged() {
    itemsPath = _historyRepo.historySongs;
    notifyListeners();
  }

  @override
  void dispose() {
    _historyRepo.removeListener(_onHistoryRepoChanged); // 释放监听
    super.dispose();
  }

  Future<void> loadItemsInfo() async {
    itemsInfo = [];
    for (var songPath in itemsPath) {
      itemsInfo.add(await _historyRepo.getTags(currentMusicPath: songPath));
    }
  }

  void addToPlayQueue(
      {required BuildContext context, required String songPath}) {
    context.read<GlobalRepository>().addSongToPlayQueue(songPath: songPath);
  }
}
