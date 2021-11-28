class TextUtils {
  static String trimOverflow(String content, int limit) {
    if (content.length > limit) {
      return content.substring(0, limit) + "...";
    }
    return content;
  }
}
