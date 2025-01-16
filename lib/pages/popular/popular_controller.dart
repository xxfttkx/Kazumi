import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kazumi/request/bangumi.dart';
import 'package:kazumi/modules/bangumi/bangumi_item.dart';
import 'package:mobx/mobx.dart';

part 'popular_controller.g.dart';

class PopularController = _PopularController with _$PopularController;

abstract class _PopularController with Store {
  final ScrollController scrollController = ScrollController();

  @observable
  String currentTag = '';

  @observable
  ObservableList<BangumiItem> bangumiList = ObservableList.of([]);

  @observable
  ObservableList<BangumiItem> trendList = ObservableList.of([]);

  double scrollOffset = 0.0;

  @observable
  bool isLoadingMore = false;

  @observable
  bool isTimeOut = false;

  void setCurrentTag(String s) {
    currentTag = s;
  }

  void clearBangumiList() {
    bangumiList.clear();
  }

  Future<void> queryBangumiByTrend({String type = 'add'}) async {
    if (type == 'init') {
      trendList.clear();
    }
    isLoadingMore = true;
    int randomNumber = Random().nextInt(1000) + 1;
    var tag = currentTag;
    var result = await BangumiHTTP.getBangumiList(rank: randomNumber, tag: tag);
    if (currentTag == tag) {
      bangumiList.addAll(result);
      isLoadingMore = false;
      isTimeOut = bangumiList.isEmpty;
      return true;
    }
    return false;
  }

  Future<bool> queryBangumiListFeedByTag(String tag) async {
    currentTag = tag;
    isLoadingMore = true;
    int randomNumber = Random().nextInt(1000) + 1;
    var result = await BangumiHTTP.getBangumiList(rank: randomNumber, tag: tag);
    if (currentTag == tag) {
      bangumiList.clear();
    }
    isLoadingMore = true;
    int randomNumber = Random().nextInt(8000) + 1;
    var tag = currentTag;
    var result = await BangumiHTTP.getBangumiList(rank: randomNumber, tag: tag);
    bangumiList.addAll(result);
    isLoadingMore = false;
    isTimeOut = bangumiList.isEmpty;
  }
}
