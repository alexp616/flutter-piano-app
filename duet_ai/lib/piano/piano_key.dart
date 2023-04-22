import 'package:flutter/material.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:tonic/tonic.dart';
import 'package:duet_ai/controller.dart';
import 'package:duet_ai/note.dart';

class PianoKey extends StatelessWidget {
  final int midi;
  final bool accidental;
  final Controller controller;

  const PianoKey.white(
      {super.key,
      required this.midi,
      required this.controller})
      : accidental = false;

  const PianoKey.black(
      {super.key,
      required this.midi,
      required this.controller})
      : accidental = true;

  void playNote() {
    try {
      controller.flutterMidi.playMidiNote(midi: midi);
      final difference = controller.isEmpty
        ? 0.0
        : (DateTime.now().millisecondsSinceEpoch - controller.last.time).toDouble()/1000;
      controller.addNote(Note(midi: midi, step: difference, duration: 0.5));
    } catch (e) {
      print('Error playing note: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = Pitch.fromMidiNumber(midi).toString();
    final key = Stack(children: <Widget>[
      Semantics(
          button: true,
          hint: name,
          child: Material(
              borderRadius: borderRadius,
              color: accidental ? Colors.black : Colors.white,
              child: InkWell(
                borderRadius: borderRadius,
                highlightColor: Colors.grey,
                onTap: () {},
                onTapDown: (_) => playNote(),
              ))),
      Positioned(
          left: 0.0,
          right: 0.0,
          bottom: 20.0,
          child: Text(name,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: !accidental ? Colors.black : Colors.white)))
    ]);

    if (accidental) {
      return Container(
          width: keyWidth,
          margin: const EdgeInsets.symmetric(horizontal: 2.0),
          padding: const EdgeInsets.symmetric(horizontal: keyWidth * .1),
          child: Material(
              elevation: 6.0,
              borderRadius: borderRadius,
              shadowColor: const Color(0x802196F3),
              child: key));
    } else {
      return Container(
        width: keyWidth,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        child: key,
      );
    }
  }
}

const borderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0));
const keyWidth = 80.0;
