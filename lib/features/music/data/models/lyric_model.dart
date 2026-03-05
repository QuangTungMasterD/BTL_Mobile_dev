class LyricLine {
  final double time;  // Thời gian bắt đầu của dòng (giây)
  final String text;  // Nội dung lời

  LyricLine({
    required this.time,
    required this.text,
  });

  factory LyricLine.fromJson(Map<String, dynamic> json) {
    return LyricLine(
      time: (json['time'] as num?)?.toDouble() ?? 0.0,
      text: json['text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'text': text,
    };
  }
}