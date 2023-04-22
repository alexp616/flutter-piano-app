class Note {
  final int midi;
  final double step;
  final double duration;
  int time;

  Note({required this.midi, required this.step, required this.duration})
      : time = DateTime.now().millisecondsSinceEpoch;
}
