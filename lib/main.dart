import 'package:codegen/util/util.dart';
import 'package:flutter/material.dart';
import 'package:codegen/util/codegen.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeGen',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FL Codegen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String code = "";
  String sharedSecret = "";
  int remaining = 1;
  Timer? _timer;

  void updateCode() {
    setState(() {
      if (sharedSecret.trim() == "") {
        code = "";
        return;
      }
      code = generateFlCode(sharedSecret, DateTime.now().millisecondsSinceEpoch ~/ 1000);
      updateRemaining();
    });
  }

  void updateRemaining() {
    setState(() {
      if (sharedSecret.trim() == "") {
        remaining = 0;
        return;
      }
      remaining = remainingTime(DateTime.now().millisecondsSinceEpoch ~/ 1000);
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateRemaining();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 2,
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                  Text(
                    "Enter Shared Secret",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onSubmitted: (value) {
                      sharedSecret = value;
                      updateCode();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      labelText: "Shared Secret",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        
                    Center(
                      child: Text(
                        code.isEmpty ? "No code generated" : code,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (code.isNotEmpty)
                      Chip(
                        label: Text(
                          formatDuration(remaining),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.deepPurple,
                      ),
                    ],
                                    ),
                  )
              ],
            ),
          ),
        ),
    );
  }
}