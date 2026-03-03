import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisync_protal/core/theme/app_theme.dart';

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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                    const SizedBox(height: 24),
                    if (_selectedTab == 0) ...[
                      _buildGaugeCard(),
                      const SizedBox(height: 16),
                      _buildFootnote(),
                      const SizedBox(height: 24),
                      _buildCategoryCard(),
                      const SizedBox(height: 24),
                      _buildBannerCard(),
                    ] else ...[
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 22,
              color: AppTheme.textPrimary,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.statusCriticalBg,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Critical!',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.statusCriticalText,
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
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildTab(index: 0, label: 'Analouge Meter'),
          _buildTab(index: 1, label: 'Histogram'),
        ],
      ),
    );
  }

  Widget _buildTab({required int index, required String label}) {
    final bool isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.30),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // ─── Gauge Card ──────────────────────────────────────
  Widget _buildGaugeCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Column(children: [BmiGauge(bmiValue: _bmiValue)]),
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
                  'Obese Class I',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Attention Required!',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Right side: sad face emoji in pale red rounded square
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppTheme.statusCriticalBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('😞', style: TextStyle(fontSize: 28)),
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
                'assets/images/overview image.png',
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
                    'Shed the weight,\nTake Less\nBreaks!',
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

// ─── Reusable BMI Gauge Widget ──────────────────────────
class BmiGauge extends StatefulWidget {
  final double bmiValue;

  const BmiGauge({super.key, required this.bmiValue});

  @override
  State<BmiGauge> createState() => _BmiGaugeState();
}

class _BmiGaugeState extends State<BmiGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(BmiGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bmiValue != widget.bmiValue) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBmiColor(double bmi) {
    if (bmi < 18.5) return const Color(0xFF2EA7D7); // Underweight - Blue
    if (bmi < 25.0) return const Color(0xFF4CAF50); // Normal - Green
    if (bmi < 30.0) return const Color(0xFFF4D03F); // Overweight - Yellow
    if (bmi < 35.0) return const Color(0xFFF39C12); // Obese - Orange
    return const Color(0xFFE53935); // Extremely Obese - Red
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final double height = width * 0.65;
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: width,
                  height: height,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: BmiGaugePainter(
                          bmiValue: widget.bmiValue,
                          animationValue: _animation.value,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Text(
                    widget.bmiValue.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: _getBmiColor(widget.bmiValue),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class BmiGaugePainter extends CustomPainter {
  final double bmiValue;
  final double animationValue;

  BmiGaugePainter({required this.bmiValue, required this.animationValue});

  static const List<Map<String, dynamic>> segments = [
    {'label': 'Under\nWeight', 'range': '< 18.5', 'color': Color(0xFF2EA7D7)},
    {
      'label': 'Normal\nWeight',
      'range': '18.5-24.9',
      'color': Color(0xFF4CAF50),
    },
    {'label': 'Over\nWeight', 'range': '25-29.9', 'color': Color(0xFFF4D03F)},
    {'label': 'Obese', 'range': '30-34.9', 'color': Color(0xFFF39C12)},
    {
      'label': 'Extremely\nObese',
      'range': '> 35.0',
      'color': Color(0xFFE53935),
    },
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height - 30;
    final Offset center = Offset(centerX, centerY);
    final double radius = size.width * 0.42;
    final double thickness = size.width * 0.14;

    const double startAngle = math.pi; // Start from left (180 degrees)
    const double totalSweepAngle = math.pi; // Half circle (180 degrees)
    final double segmentSweepAngle = totalSweepAngle / segments.length;
    const double gap = 0.04; // Spacing between segments

    // 1. Draw Arcs
    for (int i = 0; i < segments.length; i++) {
      final double segmentStart = startAngle + (i * segmentSweepAngle);
      final segmentColor = segments[i]['color'] as Color;

      final paint = Paint()
        ..color = segmentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        segmentStart + gap,
        segmentSweepAngle - (gap * 2),
        false,
        paint,
      );

      // 2. Draw Text Labels inside segments
      final double midAngle = segmentStart + (segmentSweepAngle / 2);
      _drawSegmentLabels(canvas, center, radius, midAngle, i);
    }

    // 3. Draw Needle
    _drawNeedle(
      canvas,
      center,
      radius + (thickness / 2),
      startAngle,
      totalSweepAngle,
    );
  }

  void _drawSegmentLabels(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    int index,
  ) {
    final segment = segments[index];
    final String label = segment['label'] as String;
    final String range = segment['range'] as String;

    // Determine text color based on background luminance for better contrast
    // (though requirements say black/white depending on contrast)
    final Color bgColor = segment['color'] as Color;
    final Color textColor = bgColor.computeLuminance() > 0.5
        ? Colors.black87
        : Colors.white;

    // Draw Main Category Label
    final labelPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: textColor,
          height: 1.1,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();

    // Draw Range Label
    final rangePainter = TextPainter(
      text: TextSpan(
        text: range,
        style: GoogleFonts.poppins(
          fontSize: 8,
          fontWeight: FontWeight.w500,
          color: textColor.withValues(alpha: 0.8),
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    rangePainter.layout();

    // Position calc: Outer radius - offset
    final double labelRadius = radius;

    canvas.save();
    canvas.translate(
      center.dx + labelRadius * math.cos(angle),
      center.dy + labelRadius * math.sin(angle),
    );
    canvas.rotate(angle + (math.pi / 2));

    labelPainter.paint(
      canvas,
      Offset(-labelPainter.width / 2, -labelPainter.height / 2 - 6),
    );
    rangePainter.paint(
      canvas,
      Offset(-rangePainter.width / 2, rangePainter.height / 2 - 2),
    );

    canvas.restore();
  }

  void _drawNeedle(
    Canvas canvas,
    Offset center,
    double length,
    double startAngle,
    double totalSweep,
  ) {
    // Piecewise Linear Interpolation for BMI to Angle
    // 0% -> 15.0, 100% -> 40.0 (visual clamp)
    // Categories: <18.5 (20%), 18.5-25 (40%), 25-30 (60%), 30-35 (80%), >35 (100%)
    double normalizedValue;
    if (bmiValue <= 18.5) {
      normalizedValue = (bmiValue - 10) / (18.5 - 10) * 0.2;
    } else if (bmiValue <= 24.9) {
      normalizedValue = 0.2 + (bmiValue - 18.5) / (24.9 - 18.5) * 0.2;
    } else if (bmiValue <= 29.9) {
      normalizedValue = 0.4 + (bmiValue - 25.0) / (29.9 - 25.0) * 0.2;
    } else if (bmiValue <= 34.9) {
      normalizedValue = 0.6 + (bmiValue - 30.0) / (34.9 - 30.0) * 0.2;
    } else {
      normalizedValue = 0.8 + (bmiValue - 35.0) / (45.0 - 35.0) * 0.2;
    }
    normalizedValue = normalizedValue.clamp(0.0, 1.0) * animationValue;

    final double needleAngle = startAngle + (normalizedValue * totalSweep);

    final needlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final tip = Offset(
      center.dx + length * 0.85 * math.cos(needleAngle),
      center.dy + length * 0.85 * math.sin(needleAngle),
    );

    // Needle path (Triangle)
    final path = Path()
      ..moveTo(
        center.dx + 6 * math.cos(needleAngle + math.pi / 2),
        center.dy + 6 * math.sin(needleAngle + math.pi / 2),
      )
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(
        center.dx + 6 * math.cos(needleAngle - math.pi / 2),
        center.dy + 6 * math.sin(needleAngle - math.pi / 2),
      )
      ..close();

    canvas.drawPath(path, needlePaint);

    // Center circular base
    canvas.drawCircle(center, 12, needlePaint);
    canvas.drawCircle(center, 5, Paint()..color = Colors.white24);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
