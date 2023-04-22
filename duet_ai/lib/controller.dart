import 'dart:io';

import 'package:duet_ai/note.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_midi/flutter_midi.dart';

class Controller {
  List<Note> notes = [];
  final FlutterMidi flutterMidi;

  Controller(this.flutterMidi);

  bool get isEmpty => notes.isEmpty;
  Note get last => notes[notes.length - 1];

  void resetNotes() {
    notes = [];
  }

  void addNote(Note note) {
    notes.add(note);
    if (notes.length >= 25) {
      predictNotes();
      resetNotes();
    }
  }

  void predictNotes() async {
    List<List<num>> inputs = [
      for (Note note in notes) [note.midi, note.step, note.duration]
    ];

    final result = await http.post(
      Uri.parse('http://10.1.16.10:5000/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'data': inputs,
      }),
    );
    
    final output_notes = jsonDecode(result.body);
    for (dynamic note in output_notes) {
      flutterMidi.playMidiNote(midi: (note[0]).toInt());
      await Future.delayed(Duration(milliseconds: (note[1]*1000).toInt()));
    }
  }
}
