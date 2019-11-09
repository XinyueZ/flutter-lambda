import 'package:sprintf/sprintf.dart';

import '../config.dart';
import 'hn_type.dart';

class HNElement {
  final num _id;

  HNElement(this._id);

  @override
  String toString() => "$_id";
}

class HNItem extends HNElement {
  final String by;
  final num time;
  final HNType type;
  final String text;
  final List<dynamic> kids;

  HNItem(id, this.by, this.time, this.type, this.text, this.kids) : super(id);
}

class HNStory extends HNItem {
  final String title;
  final Uri uri;
  final num score;
  final num descendants;

  HNStory(id, by, time, type, text, kids, this.title, this.uri, this.score,
      this.descendants)
      : super(id, by, time, type, text, kids);

  factory HNStory.from(Map<String, dynamic> map) => HNStory(
      map["id"],
      map["by"] ?? NULL_UNKNOWN,
      map["time"],
      from(map["type"]),
      map["text"] ?? NULL_PLACEHOLDER,
      map["kids"] ?? List(),
      map["title"] ?? NULL_PLACEHOLDER,
      map["url"] != null ? Uri.parse(map["url"]) : Uri.parse(NULL_URI),
      map["score"],
      map["descendants"] ?? NULL_NUM);

  @override
  String toString() {
    final String string = sprintf("[%s]: %s", [_id, title]);
    return string;
  }
}

class HNComment extends HNItem {
  final num parentId;

  HNComment(id, by, time, type, text, kids, this.parentId)
      : super(id, by, time, type, text, kids);

  factory HNComment.from(Map<String, dynamic> map) => HNComment(
      map["id"],
      map["by"] ?? NULL_UNKNOWN,
      map["time"],
      from(map["type"]),
      map["text"] ?? NULL_PLACEHOLDER,
      map["kids"] ?? List(),
      map["parent"] ?? NULL_NUM);

  @override
  String toString() {
    final String string = sprintf("[%s] by %s: %s", [_id, by, text]);
    return string;
  }
}
