import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopicCard extends StatelessWidget {
  const TopicCard({
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
    super.key,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isPhone = constraints.maxWidth < 560;
        final isTiny = constraints.maxWidth < 420;

        final wheelItemExtent = isTiny ? 64.0 : (isPhone ? 72.0 : 80.0);
        const wheelVisibleItems = 4;
        final headingSize = isTiny ? 25.0 : (isPhone ? 29.0 : 34.0);
        final topicFontSize = isTiny ? 16.0 : (isPhone ? 19.0 : 22.0);
        final buttonFontSize = isTiny ? 23.0 : (isPhone ? 26.0 : 33.0);
        final secondaryButtonFontSize = isTiny ? 22.0 : (isPhone ? 24.0 : 32.0);
        final horizontalMargin = isTiny ? 10.0 : (isPhone ? 18.0 : 36.0);
        final topPadding = isTiny ? 68.0 : (isPhone ? 80.0 : 92.0);
        final sidePadding = isTiny ? 12.0 : (isPhone ? 18.0 : 34.0);
        final arrowSize = isTiny ? 32.0 : 40.0;

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
                padding: EdgeInsets.fromLTRB(
                  sidePadding,
                  topPadding,
                  sidePadding,
                  20,
                ),
                child: Column(
                  children: [
                    SizedBox(height: isPhone ? 4 : 12),
                    Text(
                      'هتتكلم عن إيه؟',
                      style: GoogleFonts.fredoka(
                        fontSize: headingSize,
                        color: const Color(0xFF5D7F79),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: isPhone ? 6 : 8),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          height: wheelItemExtent * wheelVisibleItems,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: horizontalMargin,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: const Color(0xFFBBD1CA),
                                    width: 2,
                                  ),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0x66FFFFFF),
                                      Color(0x22FFFFFF),
                                    ],
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
                                      final topic =
                                          topics[index % topics.length];
                                      return Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isTiny ? 10 : 20,
                                          ),
                                          child: Text(
                                            topic,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.cairo(
                                              fontSize: topicFontSize,
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
                                  margin: EdgeInsets.symmetric(
                                    horizontal: isTiny ? 8 : 30,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: inkColor,
                                      width: 2.3,
                                    ),
                                    color: const Color(0x1A134E4A),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 8,
                                child: Icon(
                                  Icons.play_arrow_rounded,
                                  color: inkColor,
                                  size: arrowSize,
                                ),
                              ),
                              Positioned(
                                right: 8,
                                child: Transform.flip(
                                  flipX: true,
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: inkColor,
                                    size: arrowSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isPhone ? 18 : 30),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        FilledButton(
                          onPressed: isSpinning ? null : onSpin,
                          style: FilledButton.styleFrom(
                            backgroundColor: inkColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            minimumSize: Size(
                              isPhone ? 130 : 160,
                              isPhone ? 54 : 64,
                            ),
                            textStyle: GoogleFonts.fredoka(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: Text(isSpinning ? 'Spinning...' : 'Spin!'),
                        ),
                        OutlinedButton(
                          onPressed: onStartTimer,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: inkColor,
                            side: BorderSide(color: inkColor, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            minimumSize: Size(
                              isPhone ? 190 : 220,
                              isPhone ? 54 : 64,
                            ),
                            textStyle: GoogleFonts.fredoka(
                              fontSize: secondaryButtonFontSize,
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
      },
    );
  }
}
