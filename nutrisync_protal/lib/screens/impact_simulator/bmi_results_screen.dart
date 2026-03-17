import 'dart:math' as math;
import 'package:NutriSync/screens/impact_simulator/impact_simulation_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:NutriSync/core/theme.dart';
import 'package:NutriSync/widgets/common_widgets.dart';

class BmiResultsScreen extends StatefulWidget {
  const BmiResultsScreen({super.key});

  @override
  State<BmiResultsScreen> createState() => _BmiResultsScreenState();
}

class _BmiResultsScreenState extends State<BmiResultsScreen>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  static const double _bmiValue = 32.1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildTabSwitcher(),
                    if (_selectedTab == 0) ...[
                      _buildGaugeCard(),
                      const SizedBox(height: 16),
                      _buildFootnote(),
                      const SizedBox(height: 24),
                      _buildCategoryCard(),
                      const SizedBox(height: 24),
                      _buildBannerCard(),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: PrimaryButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ImpactSimulationScreen(),
                              ),
                            );
                          },
                          text: "Impact Simulation",
                          isRed: true,
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 24),
                      _buildHistogramPlaceholder(),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── App Bar ─────────────────────────────────────────
  Widget _buildAppBar() {
    String badgeText;
    Color badgeColor;

    if (_bmiValue < 18.5) {
      badgeText = 'Low';
      badgeColor = const Color(0xFF00B0FF); // Light Blue
    } else if (_bmiValue >= 18.5 && _bmiValue <= 24.9) {
      badgeText = 'Healthy';
      badgeColor = const Color(0xFF4CAF50); // Green
    } else if (_bmiValue >= 25.0 && _bmiValue <= 29.9) {
      badgeText = 'Warning';
      badgeColor = const Color(0xFFFF9800); // Orange
    } else if (_bmiValue >= 30.0 && _bmiValue <= 34.9) {
      badgeText = 'High Risk';
      badgeColor = const Color(0xFFF44336); // Red
    } else {
      badgeText = 'Critical!';
      badgeColor = const Color(0xFFB71C1C); // Dark Red
    }

    // Create a soft background color using 15% opacity of the main color
    Color badgeBgColor = badgeColor.withValues(alpha: 0.15);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 22,
              color: AppTheme.textPrimary, // Assuming you have this in your theme
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'BMI Overview',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),

          // 2. Dynamic Badge Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: badgeBgColor, // Dynamic Background
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Glowing Dot
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: badgeColor, // Dynamic Dot Color
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                // Badge Text
                Text(
                  badgeText, // Dynamic Text
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: badgeColor, // Dynamic Text Color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tab Switcher ────────────────────────────────────
  Widget _buildTabSwitcher() {
    return Center(
      child: UnitSwitch(
        isLeftSelected: _selectedTab == 0,
        leftLabel: 'Analouge Meter',
        rightLabel: 'Histogram',
        onLeftTap: () => setState(() => _selectedTab = 0),
        onRightTap: () => setState(() => _selectedTab = 1),
      ),
    );
  }

  // ─── Gauge Card ──────────────────────────────────────
  Widget _buildGaugeCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      // Maintain aspect ratio around 1.2 height for 1.0 width
      child: const AspectRatio(
        aspectRatio: 1 / 0.85,
        child: BmiGauge(value: _bmiValue),
      ),
    );
  }

  // ─── Footnote ────────────────────────────────────────
  Widget _buildFootnote() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 7),
          decoration: const BoxDecoration(
            color: Color(0xFF4FC3F7),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'The values are calculated Based on your current eating patterns.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Category Card ───────────────────────────────────
  Widget _buildCategoryCard() {
    String category;
    String message;
    IconData icon;
    Color themeColor;
    String emoji;

    if (_bmiValue < 18.5) {
      category = 'Underweight';
      message = 'Needs Attention!';
      icon = Icons.info_outline_rounded;
      themeColor = const Color(0xFF00B0FF); // Light Blue
      emoji = '😕';
    } else if (_bmiValue >= 18.5 && _bmiValue <= 24.9) {
      category = 'Normal Weight';
      message = 'Great Job!';
      icon = Icons.check_circle_outline_rounded;
      themeColor = const Color(0xFF4CAF50); // Green
      emoji = '😊';
    } else if (_bmiValue >= 25.0 && _bmiValue <= 29.9) {
      category = 'Overweight';
      message = 'Take Care!';
      icon = Icons.warning_amber_rounded;
      themeColor = const Color(0xFFFF9800); // Orange
      emoji = '😐';
    } else if (_bmiValue >= 30.0 && _bmiValue <= 34.9) {
      category = 'Obese';
      message = 'Attention Required!';
      icon = Icons.warning_amber_rounded;
      themeColor = const Color(0xFFF44336); // Red
      emoji = '😞';
    } else {
      category = 'Extremely Obese';
      message = 'Critical Action Needed!';
      icon = Icons.error_outline_rounded;
      themeColor = const Color(0xFFB71C1C); // Dark Red
      emoji = '😫';
    }

    // 2. Build the UI using the dynamic properties
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Left side: text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  category, // Dynamic Category
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      icon, // Dynamic Icon
                      size: 18,
                      color: themeColor, // Dynamic Color
                    ),
                    const SizedBox(width: 6),
                    Text(
                      message, // Dynamic Message
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: themeColor, // Dynamic Color
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Right side: dynamic face emoji in tinted rounded square
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              // Use a light 15% opacity of the theme color for the background
              color: themeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)), // Dynamic Emoji
            ),
          ),
        ],
      ),
    );
  }

  // ─── Banner Card with Image ──────────────────────────
  Widget _buildBannerCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/impact_simulator/overview image.png',
                fit: BoxFit.cover,
              ),
            ),
            // Dark gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.75),
                      Colors.black.withValues(alpha: 0.20),
                    ],
                  ),
                ),
              ),
            ),
            // Text content
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Heading
                  Text(
                    'Change your diet,\nChange your \nlife!',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Bottom row: subtitle + Dive In button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Subtitle
                      Expanded(
                        child: Text(
                          'You can Reshape your life\nwith NutriSync Diet plan',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.4,
                          ),
                        ),
                      ),
                      // Dive In button
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Dive In',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Histogram Placeholder ───────────────────────────
  Widget _buildHistogramPlaceholder() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bar_chart_rounded, size: 56, color: AppTheme.textLight),
            const SizedBox(height: 12),
            Text(
              'Histogram View',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Semi-circular BMI gauge using CustomPaint.
///
/// Two concentric arc-bands display category names (outer) and BMI ranges
/// (inner), each label rotated so it follows the arc direction exactly.
/// A black needle points to the current [value] and a large red number
/// is drawn at the centre of the gauge.
///
/// Design: two concentric arc-bands (outer = categories, inner = ranges),
/// with labels centered inside each band, a large red BMI value at center,
/// and a thick black needle pointing to the current BMI position.
class BmiGauge extends StatelessWidget {
  final double value;

  const BmiGauge({super.key, this.value = 32.1});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BmiGaugePainter(bmi: value));
  }
}

// ─── Custom Painter ───────────────────────────────────────────────────────────

class _BmiGaugePainter extends CustomPainter {
  final double bmi;

  static const double _minBmi = 10.0;
  static const double _maxBmi = 45.0;

  /// Each tuple: (startBmi, endBmi, color, categoryLabel, rangeLabel)
  /// Small 0.3-unit gaps between each segment for visual separation.
  static const _segments = [
    (10.0, 18.2, Color(0xFF00B0FF), 'Under\nWeight', '<18.5'),
    (18.8, 24.7, Color(0xFF4CAF50), 'Normal\nWeight', '18.5-24.9'),
    (25.3, 29.7, Color(0xFFFFEB3B), 'Over\nweight', '25-29.9'),
    (30.3, 34.7, Color(0xFFFF9800), 'Obese', '30-34.9'),
    (35.3, 45.0, Color(0xFFF44336), 'Extremely\nObese', '>35.0'),
  ];

  _BmiGaugePainter({required this.bmi});

  /// Maps a BMI value to a canvas angle in radians.
  /// Flutter's Y-axis points downwards.
  /// 0 is -> (right, 3 o'clock).
  /// pi/2 is v (down, 6 o'clock).
  /// pi is <- (left, 9 o'clock).
  /// 3pi/2 is ^ (up, 12 o'clock).
  /// We want the gauge to sweep from left, UP over the top, to right.
  /// So it must start at pi and go to 2pi (or 0).
  double _bmiToAngle(double v) {
    final fraction = (v - _minBmi) / (_maxBmi - _minBmi);
    return math.pi + fraction * math.pi;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Bottom-centre of the semi-circle sits at 85% of widget height
    final center = Offset(size.width / 2, size.height * 0.85);
    final maxR = (size.width / 2) * 0.95; // Expanded to utilize container width

    // ── Radial boundaries (as fraction of maxR) tightened gaps ──────
    final outerOuter = maxR; // 1.00 outer edge
    final outerInner = maxR * 0.76; // 0.76 Inner edge outer band (width 0.24)
    final innerOuter = maxR * 0.74; // 0.74 Outer edge inner band (2% gap)
    final innerInner = maxR * 0.50; // 0.50 Inner edge inner band (width 0.24)

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    for (final seg in _segments) {
      final startA = _bmiToAngle(seg.$1);
      final endA = _bmiToAngle(seg.$2);
      final sweep = endA - startA; // positive (clockwise)
      final midA = (startA + endA) / 2;
      final color = seg.$3;

      // ── Draw outer band (category colours) ─────────────────────────
      final outerR = (outerOuter + outerInner) / 2;
      final outerThick = outerOuter - outerInner;
      arcPaint
        ..color = color
        ..strokeWidth = outerThick;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerR),
        startA,
        sweep,
        false,
        arcPaint,
      );

      // Category label centered inside outer band, rotated along arc
      _drawLabel(
        canvas,
        text: seg.$4,
        position: center + Offset(math.cos(midA), math.sin(midA)) * outerR,
        arcAngle: midA,
        fontSize: 10.5,
        bold: true,
      );

      // ── Draw inner band (range colours) ────────────────────────────
      final innerR = (innerOuter + innerInner) / 2;
      final innerThick = innerOuter - innerInner;
      arcPaint
        ..color = color
        ..strokeWidth = innerThick;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerR),
        startA,
        sweep,
        false,
        arcPaint,
      );

      // Range label centered inside inner band
      _drawLabel(
        canvas,
        text: seg.$5,
        position: center + Offset(math.cos(midA), math.sin(midA)) * innerR,
        arcAngle: midA,
        fontSize: 9.0,
        bold: false,
      );
    }

    // ── Large red BMI value (draw before needle so needle overlays if close)
    final valueTP = TextPainter(
      text: TextSpan(
        text: bmi.toStringAsFixed(1),
        style: GoogleFonts.poppins(
          fontSize: 42,
          fontWeight: FontWeight.w800,
          color: const Color(0xFFF44336),
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    // Position text above the knob, safely within the lower gap area.
    // 50 pixels above center puts it neatly under the inner arcs
    valueTP.paint(
      canvas,
      Offset(center.dx - valueTP.width / 2, center.dy - 60),
    );

    // ── Needle Arrowhead Path ─────────────────────────────────────────
    final needleA = _bmiToAngle(bmi.clamp(_minBmi, _maxBmi));
    final needleLen = innerInner * 0.95; // reaches right near inner arc
    final tailLen = 14.0;

    // directional vectors
    final dir = Offset(math.cos(needleA), math.sin(needleA));
    final ortho = Offset(
      -math.sin(needleA),
      math.cos(needleA),
    ); // orthogonal 90 deg off

    final tip = center + dir * needleLen;
    final tail = center - dir * tailLen;

    final Path needlePath = Path()
      ..moveTo(tip.dx, tip.dy) // Sharp point
      ..lineTo(
        center.dx - ortho.dx * 6,
        center.dy - ortho.dy * 6,
      ) // Widens backwards (left)
      ..lineTo(
        tail.dx - ortho.dx * 1.5,
        tail.dy - ortho.dy * 1.5,
      ) // Reaches tail (left)
      ..lineTo(
        tail.dx + ortho.dx * 1.5,
        tail.dy + ortho.dy * 1.5,
      ) // Reaches tail (right)
      ..lineTo(
        center.dx + ortho.dx * 6,
        center.dy + ortho.dy * 6,
      ) // Widens backwards (right)
      ..close();

    canvas.drawPath(needlePath, Paint()..color = const Color(0xFF1A1A1A));

    // Outer knob ring
    canvas.drawCircle(center, 18, Paint()..color = const Color(0xFF1A1A1A));
    // Inner white dot
    canvas.drawCircle(center, 6, Paint()..color = Colors.white);
  }

  /// Draws [text] centered at [position], rotated so it follows the arc.
  ///
  /// [arcAngle] is the canvas angle (radians) at the label position.
  /// The rotation makes the text tangent to the circle such that the bottom
  /// of the text faces the center.
  ///   at left  (pi)    → text reads bottom-to-top  (rotate -90°)
  ///   at top   (3pi/2) → text reads left-to-right  (rotate 0°)
  ///   at right (2pi)   → text reads top-to-bottom  (rotate +90°)
  void _drawLabel(
    Canvas canvas, {
    required String text,
    required Offset position,
    required double arcAngle,
    required double fontSize,
    required bool bold,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
          color: const Color(0xFF1A1A1A),
          height: 1.1,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(position.dx, position.dy);
    // Rotate so text baseline is tangent to the arc
    canvas.rotate(arcAngle + math.pi / 2);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(_BmiGaugePainter old) => old.bmi != bmi;
}
