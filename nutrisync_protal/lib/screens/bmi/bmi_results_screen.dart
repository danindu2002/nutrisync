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

  late AnimationController _needleController;
  late Animation<double> _needleAnimation;

  @override
  void initState() {
    super.initState();
    _needleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _needleAnimation = CurvedAnimation(
      parent: _needleController,
      curve: Curves.easeOutBack,
    );
    _needleController.forward();
  }

  @override
  void dispose() {
    _needleController.dispose();
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
                    const SizedBox(height: 20),
                    _buildTabSwitcher(),
                    const SizedBox(height: 20),
                    if (_selectedTab == 0) ...[
                      _buildGaugeCard(),
                      const SizedBox(height: 14),
                      _buildFootnote(),
                      const SizedBox(height: 20),
                      _buildCategoryCard(),
                      const SizedBox(height: 20),
                      _buildBannerCard(),
                    ] else ...[
                      _buildHistogramPlaceholder(),
                    ],
                    const SizedBox(height: 24),
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
      height: 50,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
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
      alignment: Alignment.center,
      child: Container(
        width: 320, // Enough to contain the labels
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 300,
              height: 150, // Arc only area
              child: AnimatedBuilder(
                animation: _needleAnimation,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _BmiDoubleArcPainter(
                      bmiValue: _bmiValue,
                      animationValue: _needleAnimation.value,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Bottom Labels Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBmiLabel('Under Weight', '<18.5', isStart: true),
                  _buildBmiLabel('Normal Weight', '18.5-24.9'),
                  _buildBmiLabel('Over Weight', '25-29.9'),
                  _buildBmiLabel('Obese', '30-34.9'),
                  _buildBmiLabel('Extremely Obese', '>35.0', isEnd: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBmiLabel(
    String title,
    String range, {
    bool isStart = false,
    bool isEnd = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: isStart
            ? CrossAxisAlignment.start
            : (isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.center),
        children: [
          Text(
            title,
            textAlign: isStart
                ? TextAlign.start
                : (isEnd ? TextAlign.end : TextAlign.center),
            style: GoogleFonts.workSans(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF757575),
            ),
          ),
          Text(
            range,
            style: GoogleFonts.workSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF757575),
            ),
          ),
        ],
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
                const SizedBox(height: 4),
                Text(
                  'Obese Class I',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 4),
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.statusCriticalBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('😞', style: TextStyle(fontSize: 26)),
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

// ─── Double Multi-Layer BMI Arc Painter ───────────────────
class _BmiDoubleArcPainter extends CustomPainter {
  final double bmiValue;
  final double animationValue;

  _BmiDoubleArcPainter({required this.bmiValue, required this.animationValue});

  // Color selection based on BMI value
  Color _getActiveColor(double value) {
    if (value < 18.5) return const Color(0xFFEE3638);
    if (value < 25.0) return const Color(0xFF4CAF50);
    if (value < 30.0) return const Color(0xFFFFC107);
    if (value < 35.0) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    const thickness = 20.0;

    // New specs: Outer radius 120, Inner radius 100
    // Paint draws at the center of the stroke, so for a 20px thickness:
    // Outer arc (100 to 120 radius) should be at center radius 110.
    // Inner arc (80 to 100 radius) should be at center radius 90.
    const outerRadius = 110.0;
    const innerRadius = 90.0;

    // 1. Draw First Layer (Background Track) - Outer
    final trackPaint = Paint()
      ..color = const Color(0xFFE0E0E0).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      math.pi,
      math.pi,
      false,
      trackPaint,
    );

    // 2. Draw Second Layer (Colored Progress Arc) - Inner
    // Map BMI 0-40 into 0-180 degrees (PI)
    // Clamp bmiValue to max 40 for calculation to prevent over-sweeping
    final clampedBmiValue = bmiValue.clamp(0.0, 40.0);
    final sweepAngle = (clampedBmiValue / 40.0) * math.pi;
    final progressSweep = sweepAngle * animationValue;

    final progressPaint = Paint()
      ..color = _getActiveColor(bmiValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      math.pi,
      progressSweep,
      false,
      progressPaint,
    );

    // 3. Center Value Text
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: bmiValue.toStringAsFixed(1),
        style: GoogleFonts.workSans(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          color: _getActiveColor(bmiValue),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height * 0.95));
  }

  @override
  bool shouldRepaint(_BmiDoubleArcPainter old) =>
      old.bmiValue != bmiValue || old.animationValue != animationValue;
}
