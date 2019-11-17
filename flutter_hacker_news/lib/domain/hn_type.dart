enum HNType {
  COMMENT,
  STORY,
}

HNType from(String label) {
  switch (label) {
    case "comment":
      return HNType.COMMENT;
    default:
      return HNType.STORY;
  }
}
