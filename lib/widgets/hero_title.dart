import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroTitle extends StatelessWidget {
  const HeroTitle({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF134E4A);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isPhone = constraints.maxWidth < 520;
        final titleSize = isPhone ? 60.0 : 100.0;
        final stepsSize = isPhone ? 22.0 : 33.0;

        return Container(
          padding: EdgeInsets.all(isPhone ? 12 : 16),
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
                  fontSize: titleSize,
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
              SizedBox(height: isPhone ? 20 : 40),
              Text(
                '1) Spin to get a random topic\n2) Start a 30-second timer\n3) Speak and record your answer',
                style: GoogleFonts.baloo2(
                  fontSize: stepsSize,
                  color: const Color(0xFF2A6660),
                  height: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
