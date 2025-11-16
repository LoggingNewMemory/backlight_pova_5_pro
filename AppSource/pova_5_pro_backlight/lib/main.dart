import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool? _hasRoot;
  String _debugOutput = "Initializing...";

  @override
  void initState() {
    super.initState();
    _setupScript();
  }

  Future<void> _setupScript() async {
    try {
      setState(() {
        _debugOutput = 'Checking for root access...';
      });

      final rootCheck = await Process.run('su', ['-c', 'id']);

      if (rootCheck.exitCode != 0) {
        setState(() {
          _hasRoot = false;
          _debugOutput =
              'Root access denied. Please grant root permissions.\n\n${rootCheck.stderr}';
        });
        return;
      }

      setState(() {
        _hasRoot = true;
        _debugOutput = 'Root access granted. Setting up script...';
      });

      final dir = await getApplicationDocumentsDirectory();
      _scriptFile = File('${dir.path}/Backlight.sh');

      final data = await rootBundle.load('assets/Backlight.sh');
      final bytes = data.buffer.asUint8List();
      await _scriptFile.writeAsBytes(bytes, flush: true);

      final chmodResult = await Process.run('su', [
        '-c',
        'chmod +x ${_scriptFile.path}',
      ]);

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
        _hasRoot = false;
        _debugOutput = 'Error setting up script:\n$e';
      });
    }
  }

  Future<void> _runScript(String arg) async {
    if (!_isScriptReady || _hasRoot != true) {
      setState(() {
        _debugOutput =
            'Script is not ready or root is not granted. Please restart the app.';
      });
      return;
    }

    try {
      final result = await Process.run('su', [
        '-c',
        'sh "${_scriptFile.path}" "$arg"',
      ]);

      setState(() {
        if (result.stdout.toString().isEmpty &&
            result.stdout.toString().isEmpty) {
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

  Future<void> _launchDonateLink() async {
    final Uri url = Uri.parse('https://t.me/KanagawaYamadaCH/2543');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }

  // --- ADDED THIS FUNCTION ---
  Future<void> _launchReleasesLink() async {
    final Uri url = Uri.parse(
      'https://github.com/LoggingNewMemory/backlight_pova_5_pro/releases',
    );
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }

  List<Widget> _buildContentWidgets() {
    if (_hasRoot == null) {
      return [
        const Expanded(child: Center(child: CircularProgressIndicator())),
      ];
    }

    if (_hasRoot == false) {
      return [
        const SizedBox(height: 50),
        Expanded(
          child: Center(
            child: Text(
              'Please Grant Root',
              style: TextStyle(
                color: Colors.red.shade400,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ];
    }

    return [
      const SizedBox(height: 50),
      AppButton(
        label: 'FLOW',
        onPressed: () => _runScript('1'),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A1B9A), Color(0xFFD32F2F)],
        ),
      ),
      const SizedBox(height: 24),
      AppButton(
        label: 'BREATHING',
        onPressed: () => _runScript('2'),
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFF00ACC1)],
        ),
      ),
      const SizedBox(height: 24),
      AppButton(
        label: 'TURN OFF LED',
        onPressed: () => _runScript('3'),
        gradient: const LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF00ACC1)],
        ),
      ),
    ];
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
              if (_hasRoot != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(9.5),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9.5),
                      child: Image.asset('assets/Banner.png'),
                    ),
                  ),
                ),
              ..._buildContentWidgets(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: _launchDonateLink,
                      icon: const Icon(
                        FontAwesomeIcons.moneyBillWave,
                        size: 16,
                        color: Colors.white70,
                      ),
                      label: const Text(
                        'Donate',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    // --- MODIFIED THIS WIDGET ---
                    TextButton(
                      onPressed: _launchReleasesLink,
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.infoCircle,
                            size: 16,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Version: 1.0',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Gradient gradient;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.gradient,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _slashPosition;
  Animation<double>? _slashOpacity;
  Animation<double>? _breathOpacity;
  Animation<double>? _pixelOpacity;

  @override
  void initState() {
    super.initState();

    if (widget.label == 'FLOW') {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
      _slashPosition = Tween<double>(
        begin: -0.5,
        end: 1.5,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
      _slashOpacity = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.7), weight: 40),
        TweenSequenceItem(tween: Tween(begin: 0.7, end: 0.0), weight: 60),
      ]).animate(_controller);
    } else if (widget.label == 'BREATHING') {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      );
      _breathOpacity = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.4), weight: 50),
        TweenSequenceItem(tween: Tween(begin: 0.4, end: 0.0), weight: 50),
      ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    } else if (widget.label == 'TURN OFF LED') {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
      _pixelOpacity = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.2), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.0), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.5), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.0), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      ]).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
    } else {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 100),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _controller.forward(from: 0.0);
            widget.onPressed();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(9.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9.5),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return AnimatedBuilder(
                    animation: _controller,
                    child: Center(
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    builder: (context, child) {
                      Widget content = child!;

                      if (widget.label == 'TURN OFF LED' &&
                          _pixelOpacity != null) {
                        content = Opacity(
                          opacity: _pixelOpacity!.value,
                          child: child,
                        );
                      }

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          content,
                          if (widget.label == 'FLOW' && _slashPosition != null)
                            Positioned(
                              left:
                                  constraints.maxWidth * _slashPosition!.value,
                              top: 0,
                              bottom: 0,
                              width: constraints.maxWidth * 0.4,
                              child: Container(
                                transform: Matrix4.skewX(-0.3),
                                color: Colors.white.withOpacity(
                                  _slashOpacity!.value,
                                ),
                              ),
                            ),
                          if (widget.label == 'BREATHING' &&
                              _breathOpacity != null)
                            Container(
                              color: Colors.white.withOpacity(
                                _breathOpacity!.value,
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
