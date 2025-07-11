class AudioItemModel {
  final String title;
  final String path;
  final DateTime createAt;
  bool isPlaying = false;

  AudioItemModel({
    required this.title,
    required this.path,
    required this.createAt,
    required this.isPlaying,
  });
}
