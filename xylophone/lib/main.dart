import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

void main() async { // Make main async
  WidgetsFlutterBinding.ensureInitialized(); // Required for FlameAudio

  // Pre-load sounds for better performance (optional but recommended)
  await FlameAudio.audioCache.loadAll([
    'assets/voice/note1.wav',
    'assets/voice/note2.wav',
    'assets/voice/note3.wav',
    'assets/voice/note4.wav',
    'assets/voice/note5.wav',
    'assets/voice/note6.wav',
    'assets/voice/note7.wav',
  ]);

  runApp(XylophoneApp());
}

class XylophoneApp extends StatelessWidget {

  void playSound(int soundNumber) {
    FlameAudio.play('voice/note$soundNumber.wav');  // Relative path from assets
  }

  Expanded buildKey({required Color color, required int soundNumber}) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            return color; // Use the provided color
          }),
        ),
        onPressed: () {
          playSound(soundNumber);
        },
        child: SizedBox.shrink(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildKey(color: Colors.red, soundNumber: 1),
              buildKey(color: Colors.orange, soundNumber: 2),
              buildKey(color: Colors.yellow, soundNumber: 3),
              buildKey(color: Colors.green, soundNumber: 4),
              buildKey(color: Colors.teal, soundNumber: 5),
              buildKey(color: Colors.blue, soundNumber: 6),
              buildKey(color: Colors.purple, soundNumber: 7),
            ],
          ),
        ),
      ),
    );
  }
}