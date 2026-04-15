import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const TopicSpinnerApp());
}

class TopicSpinnerApp extends StatelessWidget {
  const TopicSpinnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    const paper = Color(0xFFF3F0E7);
    const ink = Color(0xFF134E4A);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Off The Cuff',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ink,
          brightness: Brightness.light,
          surface: paper,
        ),
        scaffoldBackgroundColor: paper,
        textTheme: GoogleFonts.baloo2TextTheme(),
        useMaterial3: true,
      ),
      home: const TopicSpinnerScreen(),
    );
  }
}

class TopicSpinnerScreen extends StatefulWidget {
  const TopicSpinnerScreen({super.key});

  @override
  State<TopicSpinnerScreen> createState() => _TopicSpinnerScreenState();
}

class _TopicSpinnerScreenState extends State<TopicSpinnerScreen> {
  final Random _random = Random();
  late final FixedExtentScrollController _wheelController;

  static const int _wheelCycles = 200;

  final List<String> _topics = const [
    "اقنعنا إن النوم أهم إنجاز في حياة الإنسان",
    " قدم نشرة أخبار عن ضياع شبشبك",
    " لو بقيت وزير ليوم… هتعمل إيه؟",
    "اشرح إزاي ناكل كشري كأنك دكتور في المحاضرة",
    "أعلن عن نفسك للبيع",
    "احكي يومك بدون كلمة \"أنا\"",
    "الفرق بين قداس القديس باسيليوس وقداس القديس غريغوريوس",
    "ليه بنقول “قدوس قدوس قدوس” في القداس؟",
    "أنواع الفتة",
    "	أفضل طريقة تاكل بيها الملوخية",
    "أنواع الناس في الميكروباص",
    "أنواع الناس في الفرح",
    "أنواع الناس في الامتحانات",
    "أنواع الناس في الجيم",
    "لو معاك فلوس كتير فجأة",
    "لو لقيت شنطة فيها مليون جنيه في الشارع",
    "اعمل نفسك خبير اقتصادي وفسر لنا ليه البنزين غالي",
    "اقنعنا إن \"البيتزا بالاناناس\" هي أعظم اختراع في التاريخ",
    "احكيلنا قصة خيالية عن \"ليه الشرابات بتضيع في الغسالة؟\" ",
    "الذكاء الاصطناعي هيخلي البشر أذكى ولا أكسل؟",
    "لو الأكل بيتكلم.. تفتكر \"البيتزا\" هتقول إيه للي بيعمل دايت؟",
    "إيه الحاجة اللي الناس شيفاها \"تافهة\" بس أنت شايف إنها مهمة جداً؟",
    "دافع عن فكرة إن \"المذاكرة ليلة الامتحان\" أفيد بكتير من المذاكرة طول السنة.",
    "اقنعنا إنك \"مسافر عبر الزمن\" من سنة 1920 وفجأة لقيت نفسك في وسطنا دلوقتي",
    "احكيلنا قصة بطولة وهمية ليك، بس لازم تبدأ بجملة: \"وأنا بحارب التنين في المعادي..\".",
    "لو بقيت مسؤول عن \"رحلات الكنيسة\" لمدة صيف كامل، إيه المكان اللي مستحيل تفوّته؟",
    "يعني إيه تكون \"خادم\" حتى وأنت مش لابس التونة ولا واقف بتدي درس؟",
    "لو صحيت لقيت نفسك \"أمين خدمة\" الشباب ليوم واحد، إيه أول قرار \"مطرقع\" هتاخده عشان تجذب الشباب للكنيسة؟",
    "لو الموبايل بتاعك دخل \"اعتراف\"، تفتكر أكتر حاجة هيشتكي منها لأبونا هي إيه؟",
    "احكيلنا قصة خيالية عن \"أول واحد اخترع القلقاس\" في عيد الغطاس، كان بيفكر في إيه؟",
    "كلمة \"كنيسة\" بالنسبة لك هي \"مبنى\" ولا \"أشخاص\" ولا \"ذكريات\"؟",
    "إيه هي أول علامة (Red Flag)\n بتخليك تقرر تبعد عن الشخص اللي قدامك فوراً؟",
  ];

  int _selectedIndex = 0;
  bool _isSpinning = false;
  final List<int> _remainingTopicIndices = <int>[];

  int get _wheelItemCount => _topics.length * _wheelCycles;
  int get _middleBase => (_wheelCycles ~/ 2) * _topics.length;

  @override
  void initState() {
    super.initState();
    _wheelController = FixedExtentScrollController(
      initialItem: _middleBase + _selectedIndex,
    );
    _refillTopicPool(excluding: _selectedIndex);
  }

  @override
  void dispose() {
    _wheelController.dispose();
    super.dispose();
  }

  void _recenterWheel(int topicIndex) {
    if (!_wheelController.hasClients) {
      return;
    }
    _wheelController.jumpToItem(_middleBase + topicIndex);
  }

  void _refillTopicPool({required int excluding}) {
    _remainingTopicIndices
      ..clear()
      ..addAll(
        List<int>.generate(
          _topics.length,
          (index) => index,
        ).where((index) => index != excluding),
      )
      ..shuffle(_random);
  }

  int _pickNextTopic({required int currentTopic}) {
    if (_topics.length <= 1) {
      return currentTopic;
    }

    if (_remainingTopicIndices.isEmpty) {
      _refillTopicPool(excluding: currentTopic);
    }

    return _remainingTopicIndices.removeLast();
  }

  Future<void> _spinTopics() async {
    if (_isSpinning || !_wheelController.hasClients) {
      return;
    }

    setState(() {
      _isSpinning = true;
    });

    final topicCount = _topics.length;
    var currentWheel = _wheelController.selectedItem;
    var currentTopic = currentWheel % topicCount;

    // Keep wheel in the middle range to avoid hitting edges after many spins.
    if (currentWheel > _wheelItemCount - (topicCount * 8)) {
      _recenterWheel(currentTopic);
      currentWheel = _wheelController.selectedItem;
      currentTopic = currentWheel % topicCount;
    }

    final targetTopic = _pickNextTopic(currentTopic: currentTopic);

    final delta = (targetTopic - currentTopic + topicCount) % topicCount;
    final extraTurns = 3 + _random.nextInt(3);
    final targetWheel = currentWheel + (extraTurns * topicCount) + delta;

    await _wheelController.animateToItem(
      targetWheel,
      duration: Duration(milliseconds: 1900 + _random.nextInt(600)),
      curve: Curves.easeOutCubic,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSpinning = false;
      _selectedIndex = targetTopic;
    });

    _recenterWheel(_selectedIndex);
  }

  void _onWheelChanged(int itemIndex) {
    final index = itemIndex % _topics.length;
    if (index == _selectedIndex) {
      return;
    }
    setState(() {
      _selectedIndex = index;
    });

    // Treat manual wheel picks as already-used topics in the current cycle.
    _remainingTopicIndices.remove(index);
  }

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF134E4A);
    const card = Color(0xFFF9F7F0);
    const accent = Color(0xFFE3A54D);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 960;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: compact
                  ? Column(
                      children: [
                        const _HeroTitle(),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _TopicCard(
                            cardColor: card,
                            inkColor: ink,
                            accent: accent,
                            topics: _topics,
                            selectedIndex: _selectedIndex,
                            wheelController: _wheelController,
                            isSpinning: _isSpinning,
                            onWheelChanged: _onWheelChanged,
                            onSpin: _spinTopics,
                            onStartTimer: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => TimerScreen(
                                    topic: _topics[_selectedIndex],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        const Expanded(flex: 3, child: _HeroTitle()),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 5,
                          child: _TopicCard(
                            cardColor: card,
                            inkColor: ink,
                            accent: accent,
                            topics: _topics,
                            selectedIndex: _selectedIndex,
                            wheelController: _wheelController,
                            isSpinning: _isSpinning,
                            onWheelChanged: _onWheelChanged,
                            onSpin: _spinTopics,
                            onStartTimer: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => TimerScreen(
                                    topic: _topics[_selectedIndex],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle();

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF134E4A);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x00FFFFFF), Color(0x66E8DFC8)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Off the\nCuff',
            style: GoogleFonts.fredoka(
              fontSize: 100,
              height: 0.9,
              color: ink,
              fontWeight: FontWeight.w700,
              shadows: const [
                Shadow(
                  color: Color(0x5594B3AD),
                  offset: Offset(0, 8),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Text(
            '1) Spin to get a random topic\n2) Start a 30-second timer\n3) Speak and record your answer',
            style: GoogleFonts.baloo2(
              fontSize: 33,
              color: const Color(0xFF2A6660),
              height: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.cardColor,
    required this.inkColor,
    required this.accent,
    required this.topics,
    required this.selectedIndex,
    required this.wheelController,
    required this.isSpinning,
    required this.onWheelChanged,
    required this.onSpin,
    required this.onStartTimer,
  });

  final Color cardColor;
  final Color inkColor;
  final Color accent;
  final List<String> topics;
  final int selectedIndex;
  final FixedExtentScrollController wheelController;
  final bool isSpinning;
  final ValueChanged<int> onWheelChanged;
  final VoidCallback onSpin;
  final VoidCallback onStartTimer;

  @override
  Widget build(BuildContext context) {
    const wheelItemExtent = 80.0;
    const wheelVisibleItems = 4;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33253937),
            offset: Offset(0, 16),
            blurRadius: 36,
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(34, 92, 34, 34),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Text(
                  'هتتكلم عن إيه؟',
                  style: GoogleFonts.fredoka(
                    fontSize: 34,
                    color: const Color(0xFF5D7F79),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Center(
                    child: SizedBox(
                      height: wheelItemExtent * wheelVisibleItems,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 36),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: const Color(0xFFBBD1CA),
                                width: 2,
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0x66FFFFFF), Color(0x22FFFFFF)],
                              ),
                            ),
                            child: ListWheelScrollView.useDelegate(
                              controller: wheelController,
                              itemExtent: wheelItemExtent,
                              diameterRatio: 1.5,
                              perspective: 0.0025,
                              physics: isSpinning
                                  ? const NeverScrollableScrollPhysics()
                                  : const FixedExtentScrollPhysics(),
                              overAndUnderCenterOpacity: 0.45,
                              useMagnifier: true,
                              magnification: 1.08,
                              onSelectedItemChanged: onWheelChanged,
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: topics.length * 200,
                                builder: (context, index) {
                                  final topic = topics[index % topics.length];
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: Text(
                                        topic,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.cairo(
                                          fontSize: 22,
                                          height: 1.2,
                                          color: inkColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          IgnorePointer(
                            child: Container(
                              height: wheelItemExtent,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 30,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: inkColor, width: 2.3),
                                color: const Color(0x1A134E4A),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: inkColor,
                              size: 40,
                            ),
                          ),
                          Positioned(
                            right: 8,
                            child: Transform.flip(
                              flipX: true,
                              child: Icon(
                                Icons.play_arrow_rounded,
                                color: inkColor,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: isSpinning ? null : onSpin,
                      style: FilledButton.styleFrom(
                        backgroundColor: inkColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        minimumSize: const Size(160, 64),
                        textStyle: GoogleFonts.fredoka(
                          fontSize: 33,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: Text(isSpinning ? 'Spinning...' : 'Spin!'),
                    ),
                    const SizedBox(width: 18),
                    OutlinedButton(
                      onPressed: onStartTimer,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: inkColor,
                        side: BorderSide(color: inkColor, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        minimumSize: const Size(220, 64),
                        textStyle: GoogleFonts.fredoka(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Start Timer ->'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          '30-Second Timer',
          style: GoogleFonts.fredoka(
            fontSize: 34,
            color: ink,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(28),
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
                      fontSize: 29,
                      color: const Color(0xFF547572),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.topic,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 37,
                      color: ink,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 210,
                    height: 210,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_secondsLeft',
                          style: GoogleFonts.fredoka(
                            fontSize: 72,
                            color: ink,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 20),
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 14,
                          backgroundColor: const Color(0xFFCAD8D2),
                          color: ink,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FilledButton(
                        onPressed: _secondsLeft == 0 ? _reset : _startPause,
                        style: FilledButton.styleFrom(
                          backgroundColor: ink,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(160, 58),
                          textStyle: GoogleFonts.fredoka(
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Text(
                          _secondsLeft == 0
                              ? 'Again'
                              : (_running ? 'Pause' : 'Start'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: _newTopic,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ink,
                          side: const BorderSide(color: ink, width: 2),
                          minimumSize: const Size(160, 58),
                          textStyle: GoogleFonts.fredoka(
                            fontSize: 30,
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
      ),
    );
  }
}
