import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({required this.topic, super.key});

  final String topic;

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  static const int _fullSeconds = 30;
  static const String _startSoundPath =
      'sounds/alexis_gaming_cam-timer-terminer-342934.mp3';

  Timer? _timer;
  final AudioPlayer _startPlayer = AudioPlayer();
  final AudioPlayer _endPlayer = AudioPlayer();
  final Random _soundRandom = Random();
  String? _cachedStartSound;
  List<String>? _cachedEndSounds;
  int _secondsLeft = _fullSeconds;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _startPlayer.setReleaseMode(ReleaseMode.stop);
    _endPlayer.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _startPlayer.dispose();
    _endPlayer.dispose();
    super.dispose();
  }

  Future<void> _playStartSound() async {
    final startSound = await _getStartSoundPath();

    await _startPlayer.stop();
    await _startPlayer.play(AssetSource(startSound), volume: 1);
  }

  Future<void> _playFinishSound() async {
    final endSounds = await _getEndSoundList();
    final randomEndSound = endSounds[_soundRandom.nextInt(endSounds.length)];

    await _endPlayer.stop();
    await _endPlayer.play(AssetSource(randomEndSound), volume: 1);
  }

  Future<List<String>> _getEndSoundList() async {
    if (_cachedEndSounds != null && _cachedEndSounds!.isNotEmpty) {
      return _cachedEndSounds!;
    }

    final soundFiles = await _listSoundAssets();
    final endSounds = soundFiles
        .where((assetPath) => assetPath != _startSoundPath)
        .toList();

    _cachedEndSounds = endSounds.isEmpty
        ? <String>[_startSoundPath]
        : endSounds;
    return _cachedEndSounds!;
  }

  Future<String> _getStartSoundPath() async {
    _cachedStartSound = _startSoundPath;
    return _cachedStartSound!;
  }

  Future<List<String>> _listSoundAssets() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

    return manifest
        .listAssets()
        .where((assetPath) => assetPath.startsWith('assets/sounds/'))
        .where((assetPath) => assetPath.endsWith('.mp3'))
        .map((assetPath) => assetPath.replaceFirst('assets/', ''))
        .toList()
      ..sort();
  }

  void _startPause() {
    if (_running) {
      _timer?.cancel();
      setState(() {
        _running = false;
      });
      return;
    }

    setState(() {
      _running = true;
    });
    unawaited(_playStartSound());

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        unawaited(_playFinishSound());
        if (!mounted) {
          return;
        }
        setState(() {
          _secondsLeft = 0;
          _running = false;
        });
      } else {
        if (!mounted) {
          return;
        }
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _secondsLeft = _fullSeconds;
    });
  }

  void _newTopic() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF134E4A);
    final progress = (_fullSeconds - _secondsLeft) / _fullSeconds;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isPhone = screenWidth < 560;
    final appBarTitle = isPhone ? 24.0 : 34.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          '30-Second Timer',
          style: GoogleFonts.fredoka(
            fontSize: appBarTitle,
            color: ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isPhone = constraints.maxWidth < 560;
          final timerTextSize = isPhone ? 56.0 : 72.0;
          final topicTitleSize = isPhone ? 24.0 : 29.0;
          final topicTextSize = isPhone ? 29.0 : 37.0;
          final buttonTextSize = isPhone ? 24.0 : 30.0;
          final cardPadding = isPhone ? 18.0 : 28.0;
          final ringSize = isPhone ? 170.0 : 210.0;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isPhone ? 12 : 24),
                child: Container(
                  padding: EdgeInsets.all(cardPadding),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F7F0),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x33253937),
                        offset: Offset(0, 14),
                        blurRadius: 34,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'الموضوع اللي هتتكلم عنه',
                        style: GoogleFonts.cairo(
                          fontSize: topicTitleSize,
                          color: const Color(0xFF547572),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.topic,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: topicTextSize,
                          color: ink,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: isPhone ? 18 : 24),
                      SizedBox(
                        width: ringSize,
                        height: ringSize,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$_secondsLeft',
                              style: GoogleFonts.fredoka(
                                fontSize: timerTextSize,
                                color: ink,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: isPhone ? 12 : 20),
                            CircularProgressIndicator(
                              value: progress,
                              strokeWidth: isPhone ? 11 : 14,
                              backgroundColor: const Color(0xFFCAD8D2),
                              color: ink,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isPhone ? 18 : 26),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          FilledButton(
                            onPressed: _secondsLeft == 0 ? _reset : _startPause,
                            style: FilledButton.styleFrom(
                              backgroundColor: ink,
                              foregroundColor: Colors.white,
                              minimumSize: Size(isPhone ? 130 : 160, 58),
                              textStyle: GoogleFonts.fredoka(
                                fontSize: buttonTextSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: Text(
                              _secondsLeft == 0
                                  ? 'Again'
                                  : (_running ? 'Pause' : 'Start'),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: _newTopic,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ink,
                              side: const BorderSide(color: ink, width: 2),
                              minimumSize: Size(isPhone ? 150 : 160, 58),
                              textStyle: GoogleFonts.fredoka(
                                fontSize: buttonTextSize,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('New Topic'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
