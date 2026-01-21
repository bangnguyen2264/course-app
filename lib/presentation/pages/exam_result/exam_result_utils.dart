String formatDuration(int seconds) {
  final d = Duration(seconds: seconds);
  if (d.inHours > 0) {
    return '${d.inHours}h ${d.inMinutes.remainder(60)}p';
  } else if (d.inMinutes > 0) {
    return '${d.inMinutes}p ${d.inSeconds.remainder(60).toString().padLeft(2, '0')}s';
  } else {
    return '${d.inSeconds}s';
  }
}

String getResultTitle(double score) {
  if (score == 100.0) {
    return 'Tuyệt đối!';
  } else if (score >= 80.0) {
    return 'Làm tốt lắm!';
  } else if (score >= 65.0) {
    return 'Khá ổn!';
  } else if (score >= 40.0) {
    return 'Cố gắng hơn nữa!';
  } else {
    return 'Bạn cần luyện tập thêm!';
  }
}

String getResultSubtitle(double score) {
  if (score == 100.0) {
    return 'Bạn đã đạt điểm tuyệt đối. Một thành tích xuất sắc!';
  } else if (score >= 80.0) {
    return 'Bạn đã vượt qua bài kiểm tra một cách xuất sắc.';
  } else if (score >= 65.0) {
    return 'Bạn đã hoàn thành bài kiểm tra khá tốt!';
  } else if (score >= 40.0) {
    return 'Bạn đã hoàn thành bài kiểm tra, hãy cố gắng hơn ở lần sau!';
  } else {
    return 'Đừng nản lòng, hãy luyện tập thêm để cải thiện kết quả nhé!';
  }
}
