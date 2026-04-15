import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_topic/topics.dart';

import '../widgets/hero_title.dart';
import '../widgets/topic_card.dart';
import 'timer_screen.dart';

class TopicSpinnerScreen extends StatefulWidget {
  const TopicSpinnerScreen({super.key});

  @override
  State<TopicSpinnerScreen> createState() => TopicSpinnerScreenState();
}

class TopicSpinnerScreenState extends State<TopicSpinnerScreen> {
  final Random _random = Random();
  late final FixedExtentScrollController _wheelController;

  static const int _wheelCycles = 200;

  int _selectedIndex = 0;
  bool _isSpinning = false;
  final List<int> _remainingTopicIndices = <int>[];

  int get _wheelItemCount => topics.length * _wheelCycles;
  int get _middleBase => (_wheelCycles ~/ 2) * topics.length;

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
          topics.length,
          (index) => index,
        ).where((index) => index != excluding),
      )
      ..shuffle(_random);
  }

  int _pickNextTopic({required int currentTopic}) {
    if (topics.length <= 1) {
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

    final topicCount = topics.length;
    var currentWheel = _wheelController.selectedItem;
    var currentTopic = currentWheel % topicCount;

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
    final index = itemIndex % topics.length;
    if (index == _selectedIndex) {
      return;
    }
    setState(() {
      _selectedIndex = index;
    });

    _remainingTopicIndices.remove(index);
  }

  void _openTimer() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TimerScreen(topic: topics[_selectedIndex]),
      ),
    );
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
            final isPhone = constraints.maxWidth < 600;

            return Padding(
              padding: EdgeInsets.all(isPhone ? 12 : 24),
              child: compact
                  ? Column(
                      children: [
                        const HeroTitle(),
                        const SizedBox(height: 16),
                        Expanded(
                          child: TopicCard(
                            cardColor: card,
                            inkColor: ink,
                            accent: accent,
                            topics: topics,
                            selectedIndex: _selectedIndex,
                            wheelController: _wheelController,
                            isSpinning: _isSpinning,
                            onWheelChanged: _onWheelChanged,
                            onSpin: _spinTopics,
                            onStartTimer: _openTimer,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        const Expanded(flex: 3, child: HeroTitle()),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 5,
                          child: TopicCard(
                            cardColor: card,
                            inkColor: ink,
                            accent: accent,
                            topics: topics,
                            selectedIndex: _selectedIndex,
                            wheelController: _wheelController,
                            isSpinning: _isSpinning,
                            onWheelChanged: _onWheelChanged,
                            onSpin: _spinTopics,
                            onStartTimer: _openTimer,
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
