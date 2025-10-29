import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CogniSimple',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const StroopTest(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StroopTest extends StatefulWidget {
  const StroopTest({super.key});
  @override
  State<StroopTest> createState() => _StroopTestState();
}

class _StroopTestState extends State<StroopTest> {
  final List<String> words = ['قرمز', 'آبی', 'سبز', 'زرد'];
  final List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
  late String currentWord;
  late Color currentColor;
  int score = 0;
  int total = 0;
  double avgTime = 0.0;
  final List<double> responseTimes = [];
  late Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    nextQuestion();
  }

  void nextQuestion() {
    setState(() {
      final rand = Random();
      currentWord = words[rand.nextInt(words.length)];
      currentColor = colors[rand.nextInt(colors.length)];
      total++;
      stopwatch = Stopwatch()..start();
    });
  }

  void checkAnswer(Color selectedColor) {
    stopwatch.stop();
    final time = stopwatch.elapsedMilliseconds / 1000.0;
    responseTimes.add(time);
    avgTime = responseTimes.reduce((a, b) => a + b) / responseTimes.length;

    if (selectedColor == currentColor) score++;

    if (total >= 10) {
      showResult();
    } else {
      nextQuestion();
    }
  }

  void showResult() {
    final accuracy = score / total;
    String level;
    if (accuracy >= 0.8 && avgTime <= 1.2) {
      level = "خوب";
    } else if (accuracy >= 0.6) {
      level = "متوسط";
    } else {
      level = "ضعیف";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('گزارش ارزیابی توجه'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('دقت: ${(accuracy * 100).toStringAsFixed(0)}%'),
            Text('زمان متوسط: ${avgTime.toStringAsFixed(2)} ثانیه'),
            Text('سطح توجه: $level', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                score = 0; total = 0; responseTimes.clear(); avgTime = 0.0;
              });
              nextQuestion();
            },
            child: const Text('شروع مجدد'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('آزمون Stroop - CogniSimple')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentWord,
              style: TextStyle(fontSize: 60, color: currentColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            Wrap(
              spacing: 12,
              children: colors.map((color) {
                final name = words[colors.indexOf(color)];
                return ElevatedButton(
                  onPressed: () => checkAnswer(color),
                  style: ElevatedButton.styleFrom(backgroundColor: color, padding: const EdgeInsets.all(16)),
                  child: Text(name, style: const TextStyle(fontSize: 18, color: Colors.white)),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            Text('سؤال $total از ۱۰', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
