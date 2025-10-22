String shortText(String? text, {int limit = 30, String defaultText = "Tidak Tersedia"}) {
  if (text == null || text.trim().isEmpty) return defaultText;

  final cleanText = text.trim();
  return cleanText.length > limit
      ? "${cleanText.substring(0, limit).trim()}..."
      : cleanText;
}

