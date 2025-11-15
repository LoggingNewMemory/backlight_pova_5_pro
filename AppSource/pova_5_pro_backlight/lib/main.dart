import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const BacklightApp());
}

class BacklightApp extends StatelessWidget {
  const BacklightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Backlight Control',
      theme: ThemeData(brightness: Brightness.dark, primarySwatch: Colors.blue),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late File _scriptFile;
  bool _isScriptReady = false;
  String _debugOutput = "Initializing...";

  @override
  void initState() {
    super.initState();
    _setupScript();
  }

  Future<void> _setupScript() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      _scriptFile = File('${dir.path}/Backlight.sh');

      final data = await rootBundle.load('assets/Backlight.sh');
      final bytes = data.buffer.asUint8List();
      await _scriptFile.writeAsBytes(bytes, flush: true);

      final chmodResult = await Process.run('chmod', ['+x', _scriptFile.path]);

      if (chmodResult.exitCode != 0) {
        throw Exception(
          'Failed to make script executable: ${chmodResult.stderr}',
        );
      }

      setState(() {
        _isScriptReady = true;
        _debugOutput = 'Script ready. Press a button.';
      });
    } catch (e) {
      setState(() {
        _debugOutput = 'Error setting up script:\n$e';
      });
    }
  }

  Future<void> _runScript(String arg) async {
    if (!_isScriptReady) {
      setState(() {
        _debugOutput = 'Script is not ready. Please restart the app.';
      });
      return;
    }

    try {
      final result = await Process.run('sh', [_scriptFile.path, arg]);

      setState(() {
        if (result.stdout.toString().isEmpty &&
            result.stderr.toString().isEmpty) {
          _debugOutput = 'Script executed with arg $arg (No output).';
        } else {
          _debugOutput =
              'STDOUT:\n${result.stdout}\n\nSTDERR:\n${result.stderr}';
        }
      });
    } catch (e) {
      setState(() {
        _debugOutput = 'Error running script:\n$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/Banner.png'),
              const SizedBox(height: 50),
              AppButton(
                label: 'FLOW',
                onPressed: () => _runScript('1'),
                borderColor: const Color(0xFF6A1B9A),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'BREATHING',
                onPressed: () => _runScript('2'),
                borderColor: const Color(0xFFD32F2F),
              ),
              const SizedBox(height: 24),
              AppButton(
                label: 'TURN OFF LED',
                onPressed: () => _runScript('3'),
                borderColor: const Color(0xFF00ACC1),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8.0),
                height: 100,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Text(
                    _debugOutput,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color borderColor;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: borderColor, width: 2.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
