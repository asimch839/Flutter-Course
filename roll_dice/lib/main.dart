import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dice Roller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  DiceRollerPage(),
    );
  }
}

class DiceRollerPage extends StatefulWidget {
  //const DiceRollerPage({Key? key}) : super(key: key);

  @override
  State<DiceRollerPage> createState() => _DiceRollerPageState();
}

class _DiceRollerPageState extends State<DiceRollerPage>
    with TickerProviderStateMixin {
  int diceNumber = 1;
  bool _isRotating = false;
  bool _rotateOnTap = false;
  bool _scaleOnTap = false;

  // Animation 1: Scale
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  // Animation 2: Rotation
  late AnimationController _rotateController;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    // Scale Animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    )..addListener(() {
      setState(() {});
    });

    _scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _scaleController.reverse();
        setState(() {});
      }
    });

    // Rotation Animation
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    )..addListener(() {
      setState(() {});
    });

    _rotateController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _rotateController.reset();
        _isRotating = false;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  void rollDice() {
    setState(() {
      diceNumber = Random().nextInt(6) + 1;
    });
  }

  void _startScaleAnimation() {
    _scaleOnTap = true;
    _rotateOnTap = false;
  }

  void _startRotateAnimation() {
    _rotateOnTap = true;
    _scaleOnTap = false;
  }

  void _rotateDice() {
    if (_rotateOnTap && !_isRotating) {
      rollDice();
      _isRotating = true;
      _rotateController.forward(from: 0.0);
      setState(() {});
    } else if (_scaleOnTap && !_scaleController.isAnimating) {
      rollDice();
      _scaleController.forward(from: 0.0);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Dice Roller'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _startScaleAnimation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _scaleOnTap
                        ? Colors.green
                        : Colors.blue, // Highlight active button
                  ),
                  child: const Text('Scale on Tap'),
                ),
                ElevatedButton(
                  onPressed: _startRotateAnimation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _rotateOnTap
                        ? Colors.green
                        : Colors.blue, // Highlight active button
                  ),
                  child: const Text('Rotate on Tap'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () {
                  _rotateDice();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    RotationTransition(
                      turns: _rotateAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Image.asset(
                          'images/dice$diceNumber.png',
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}