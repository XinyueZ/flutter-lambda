import 'package:sprintf/sprintf.dart';

import '../config.dart';
import 'hn_type.dart';

abstract class HNElement {
  final num id;

  HNElement(this.id);

  @override
  String toString() => "$id";
}

class HNObject extends HNElement {
  HNObject(num id) : super(id);
}

abstract class HNTextItem extends HNElement {
  final String by;
  final num time;
  final HNType type;
  final String text;

  HNTextItem(id, this.by, this.time, this.type, this.text) : super(id);
}

abstract class HNParent {
  List<dynamic> kids;
}

abstract class HNItem extends HNTextItem with HNParent {
  HNItem(id, by, time, type, text, kids) : super(id, by, time, type, text) {
    this.kids = kids;
  }
}

abstract class HNLink {
  Uri uri;
}

abstract class HNScore {
  num score;
}

abstract class HNTitle {
  String title;
}

class HNStory extends HNItem with HNLink, HNScore, HNTitle {
  final num descendants;

  HNStory(id, by, time, type, text, kids, title, uri, score, this.descendants)
      : super(id, by, time, type, text, kids) {
    this.uri = uri;
    this.score = score;
    this.title = title;
  }

  factory HNStory.from(Map<String, dynamic> map) => HNStory(
        map["id"],
        map["by"] ?? NULL_UNKNOWN,
        map["time"],
        from(map["type"]),
        map["text"] ?? (map["title"] ?? NULL_PLACEHOLDER),
        map["kids"] ?? List(),
        map["title"] ?? NULL_PLACEHOLDER,
        map["url"] != null ? Uri.parse(map["url"]) : Uri.parse(NULL_URI),
        map["score"],
        map["descendants"] ?? NULL_NUM,
      );

  @override
  String toString() => sprintf("[%s]: %s", [id, title]);
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
        map["parent"] ?? NULL_NUM,
      );

  @override
  String toString() => sprintf("[%s] by %s: %s", [id, by, text]);
}

class HNJob extends HNTextItem with HNLink, HNScore, HNTitle {
  HNJob(id, by, time, type, text, title, uri, score)
      : super(id, by, time, type, text) {
    this.uri = uri;
    this.score = score;
    this.title = title;
  }

  factory HNJob.from(Map<String, dynamic> map) => HNJob(
        map["id"],
        map["by"] ?? NULL_UNKNOWN,
        map["time"],
        from(map["type"]),
        map["text"] ?? (map["title"] ?? NULL_PLACEHOLDER),
        map["title"] ?? NULL_PLACEHOLDER,
        map["url"] != null ? Uri.parse(map["url"]) : Uri.parse(NULL_URI),
        map["score"],
      );

  @override
  String toString() => sprintf("[%s] job at %s: %s", [id, by, title]);
}
