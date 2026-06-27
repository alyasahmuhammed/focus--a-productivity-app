import 'dart:async';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:focus/treePainter.dart';
// ignore: duplicate_import

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key, required int durationMinutes});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int selectedHours = 0;
  int selectedMinutes = 25;

  int totalSeconds = 0;
  int remainingSeconds = 0;

  Timer? timer;
  bool isRunning = false;

  double progress = 0.0;

  void startTimer() {
    if (isRunning) return;

    totalSeconds = (selectedHours * 3600) + (selectedMinutes * 60);
    if (totalSeconds == 0) return;

    setState(() {
      remainingSeconds = totalSeconds;
      isRunning = true;
      progress = 0.0;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds <= 0) {
        t.cancel();
        setState(() {
          isRunning = false;
          progress = 1.0;
        });
        return;
      }

      setState(() {
        remainingSeconds--;
        progress = 1 - (remainingSeconds / totalSeconds);
      });
    });
  }

  void pauseTimer() {
    timer?.cancel();
    setState(() => isRunning = false);
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
      remainingSeconds = 0;
      progress = 0.0;
    });
  }

  String formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;

    return "${h.toString().padLeft(2, '0')}:"
        "${m.toString().padLeft(2, '0')}:"
        "${s.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF06130A), // deep forest black
      appBar: AppBar(
        title: const Text("FOCUS"),
        backgroundColor: const Color(0xFF0B2F1A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 🌳 TREE AREA
            Expanded(
              child: Center(
                child: CustomPaint(
                  size: const Size(250, 250),
                  painter: treePainter(progress),
                ),
              ),
            ),

            // ⏱ TIMER TEXT
            Text(
              formatTime(isRunning ? remainingSeconds : totalSeconds),
              style: const TextStyle(
                fontSize: 42,
                color: Color(0xFF7CFFB2),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // PICKERS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPicker("Hours", selectedHours, 13, (val) {
                  setState(() => selectedHours = val);
                }),
                const SizedBox(width: 20),
                _buildPicker("Minutes", selectedMinutes, 60, (val) {
                  setState(() => selectedMinutes = val);
                }),
              ],
            ),

            const SizedBox(height: 25),

            // BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _btn("Start", const Color(0xFF00E676), startTimer),
                const SizedBox(width: 10),
                _btn("Pause", const Color(0xFF1DE9B6), pauseTimer),
                const SizedBox(width: 10),
                _btn("Reset", const Color(0xFFFF5252), resetTimer),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _btn(String text, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text),
    );
  }

  Widget _buildPicker(
    String label,
    int value,
    int max,
    Function(int) onChanged,
  ) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        DropdownButton<int>(
          value: value,
          dropdownColor: const Color(0xFF0B2F1A),
          style: const TextStyle(color: Colors.white),
          items: List.generate(
            max,
            (i) => DropdownMenuItem(value: i, child: Text("$i")),
          ),
          onChanged: (val) => onChanged(val!),
        ),
      ],
    );
  }

  CustomPainter? treePainter(double progress) {
    return OrganicTreePainter(progress);
  }
}
