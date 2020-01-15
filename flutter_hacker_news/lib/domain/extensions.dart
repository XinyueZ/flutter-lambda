import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hacker_news/domain/hn_item.dart';
import 'package:sprintf/sprintf.dart';

import '../config.dart';
import '../decoder_helper.dart';

extension HNStoryGenerator on List<HNElement> {
  Future<List<HNStory>> buildStories(final Dio dio) async {
    final List<HNStory> stories = List();

    await Future.forEach(this, (element) async {
      final String getPath = sprintf(CONTENT, [element.toString()]);
      final Response response = await dio.get(getPath);
      if (response != null) {
        final Map<String, dynamic> feedsMap =
            DecoderHelper.getJsonDecoder().convert(response.toString());

        if (feedsMap != null) {
          final HNStory story = HNStory.from(feedsMap);
          stories.add(story);

          //Debug output
          debugPrint("Story: ${story.toString()}");
        }
      }
    });
    return stories;
  }
}

extension HNCommentGenerator on HNItem {
  Future<List<HNComment>> buildComments(final Dio dio,
      {bool loadAll = true}) async {
    final List<HNComment> comments = List();
    await Future.forEach(this.kids, (kid) async {
      final String getPath = sprintf(CONTENT, [kid.toString()]);
      final Response response = await dio.get(getPath);
      if (response != null) {
        final Map<String, dynamic> feedsMap =
            DecoderHelper.getJsonDecoder().convert(response.toString());
        if (feedsMap != null) {
          final HNComment comment = HNComment.from(feedsMap);
          comments.add(comment);
          if (loadAll) {
            comments.addAll(await comment.buildComments(dio, loadAll: loadAll));
          }
          //Debug output
          debugPrint("Comment: ${comment.toString()}");
        }
      }
    });
    return comments;
  }
}

extension HNCommentListGenerator on List<HNItem> {
  Future<List<HNComment>> buildComments(final Dio dio) async {
    final List<HNComment> comments = List();
    await Future.forEach(this, (HNItem hnItem) async {
      final List<HNComment> nextComments = await hnItem.buildComments(dio);
      comments.addAll(nextComments);
    });
    return comments;
  }
}
