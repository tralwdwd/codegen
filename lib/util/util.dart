String formatDuration(int? totalSeconds) {
  if (totalSeconds == null || totalSeconds.isNaN) return "";
  final duration = Duration(seconds: totalSeconds);
  final minutes = duration.inMinutes;
  final seconds = totalSeconds % 60;

  final minutesString = '$minutes'.padLeft(2, '0');
  final secondsString = '$seconds'.padLeft(2, '0');
  return '$minutesString:$secondsString remaining';
}