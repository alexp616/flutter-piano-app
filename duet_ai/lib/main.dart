import 'package:flutter/material.dart';
import 'package:duet_ai/piano/piano.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Duet AI', theme: ThemeData.dark(), home: const Piano());
  }
}