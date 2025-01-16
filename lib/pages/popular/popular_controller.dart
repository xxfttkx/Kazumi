import 'dart:math';
import 'package:flutter/material.dart';
import 'package:kazumi/request/bangumi.dart';
import 'package:kazumi/modules/bangumi/bangumi_item.dart';
import 'package:mobx/mobx.dart';

part 'popular_controller.g.dart';

class PopularController = _PopularController with _$PopularController;

abstract class _PopularController with Store {
  final ScrollController scrollController = ScrollController();

  String keyword = '';
  String searchKeyword = '';
  bool isSearching = false;

  @observable
  String currentTag = '';

  @observable
  ObservableList<BangumiItem> bangumiList = ObservableList.of([]);

  double scrollOffset = 0.0;

  @observable
  bool isLoadingMore = false;

  @observable
  bool isTimeOut = false;

  Set<BangumiItem> meatBangumis = {};

  void filterBangumiList(List<BangumiItem> list) {
    for (int i = list.length - 1; i >= 0; --i) {
      if (meatBangumis.contains(list[i])) {
        list.removeAt(i);
      } else {
        meatBangumis.add(list[i]);
      }
    }
  }

  void clearList() {
    bangumiList.clear();
    meatBangumis.clear();
  }

  void endQuery(List<BangumiItem> result) {
    filterBangumiList(result);
    bangumiList.addAll(result);
    isLoadingMore = false;
    isTimeOut = bangumiList.isEmpty;
  }

  void setSearchKeyword(String s) {
    isSearching = s.isNotEmpty;
    searchKeyword = s;
  }

  Future<bool> queryBangumiListFeed() async {
    isLoadingMore = true;
    int randomNumber = Random().nextInt(5000) + 1;
    var tag = currentTag;
    var result = await BangumiHTTP.getBangumiList(rank: randomNumber, tag: tag);
    if (currentTag == tag) {
      endQuery(result);
      return true;
    }
    return false;
  }

  Future<bool> queryBangumiListFeedByTag(String tag) async {
    currentTag = tag;
    isLoadingMore = true;
    int randomNumber = Random().nextInt(5000) + 1;
    var result = await BangumiHTTP.getBangumiList(rank: randomNumber, tag: tag);
    if (currentTag == tag) {
      clearList();
      endQuery(result);
      return true;
    }
    return false;
  }

  Future<bool> queryBangumiListFeedByRefresh() async{
    return await queryBangumiListFeedByTag(currentTag);
  }

  Future<void> queryBangumi(String keyword) async {
    currentTag = '';
    isLoadingMore = true;
    var result = await BangumiHTTP.bangumiSearch(keyword);
    clearList();
    bangumiList.addAll(result);
    isLoadingMore = false;
  }
}
