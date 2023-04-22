import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:duet_ai/piano/piano_key.dart';
import 'package:duet_ai/controller.dart';

class Piano extends StatefulWidget {
  const Piano({super.key});

  @override
  PianoState createState() => PianoState();
}

class PianoState extends State<Piano> {
  FlutterMidi flutterMidi = FlutterMidi();
  late Controller controller;

  @override
  initState() {
    flutterMidi.unmute();
    rootBundle.load("assets/Piano.sf2").then((sf2) {
      flutterMidi.prepare(sf2: sf2, name: "Piano.sf2");
    });
    controller = Controller(flutterMidi);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemCount: 7,
      scrollDirection: Axis.horizontal,
      controller: ScrollController(initialScrollOffset: 1500.0),
      itemBuilder: (BuildContext context, int index) {
        final int i = index * 12;
        return SafeArea(
            child: Stack(children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PianoKey.white(
                  midi: 24 + i,
                  controller: controller),
              PianoKey.white(
                  midi: 26 + i,
                  controller: controller),
              PianoKey.white(
                  midi: 28 + i,
                  controller: controller),
              PianoKey.white(
                  midi: 29 + i,
                  controller: controller),
              PianoKey.white(
                  midi: 31 + i,
                  controller: controller),
              PianoKey.white(
                  midi: 33 + i,
                  controller: controller),
              PianoKey.white(
                  midi: 35 + i,
                  controller: controller),
            ],
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 100,
            top: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: keyWidth * .5),
                PianoKey.black(
                    midi: 25 + i,
                    controller: controller),
                PianoKey.black(
                    midi: 27 + i,
                    controller: controller),
                Container(width: keyWidth),
                PianoKey.black(
                    midi: 30 + i,
                    controller: controller),
                PianoKey.black(
                    midi: 32 + i,
                    controller: controller),
                PianoKey.black(
                    midi: 34 + i,
                    controller: controller),
                Container(width: keyWidth * .5),
              ],
            ),
          )
        ]));
      },
    ));
  }
}
