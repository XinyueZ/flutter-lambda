enum HNType {
  COMMENT,
  JOB,
  STORY,
}

HNType from(String label) {
  switch (label) {
    case "comment":
      return HNType.COMMENT;
    case "job":
      return HNType.JOB;
    default:
      return HNType.STORY;
  }
}
