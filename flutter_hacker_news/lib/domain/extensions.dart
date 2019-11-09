import 'package:dio/dio.dart';
import 'package:sprintf/sprintf.dart';

import '../config.dart';
import '../decoder_helper.dart';
import 'hn_item.dart';

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
          print("Story: ${story.toString()}");
        }
      }
    });

    return stories;
  }
}

extension HNCommentGenerator on HNItem {
  Future<List<HNComment>> buildComments(final Dio dio) async {
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
          comments.addAll(await comment.buildComments(dio));
          //Debug output
          print("Comment: ${comment.toString()}");
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
