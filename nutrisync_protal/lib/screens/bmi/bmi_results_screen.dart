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
      alignment: Alignment.center,
      child: Container(
        width: 340,
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC), // Subtle light background for gauge
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              width: 360,
              height: 300, // Expanded height for clearance
              child: AnimatedBuilder(
                animation: _needleAnimation,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _BmiDualArcPillPainter(
                      bmiValue: _bmiValue,
                      animationValue: _needleAnimation.value,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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

// ─── Dual-Arc Colored Pill BMI Gauge Painter ──────────
class _BmiDualArcPillPainter extends CustomPainter {
  final double bmiValue;
  final double animationValue;

  _BmiDualArcPillPainter({
    required this.bmiValue,
    required this.animationValue,
  });

  static const List<Map<String, dynamic>> _zones = [
    {'category': 'Under\nWeight', 'range': '<18.5', 'color': Color(0xFF00B0F0)},
    {
      'category': 'Normal\nWeight',
      'range': '18.5-24.9',
      'color': Color(0xFF32CD32),
    },
    {
      'category': 'Over\nweight',
      'range': '25-29.9',
      'color': Color(0xFFFFD700),
    },
    {'category': 'Obese', 'range': '30-34.9', 'color': Color(0xFFFFA500)},
    {
      'category': 'Extremely\nObese',
      'range': '>35.0',
      'color': Color(0xFFFF0000),
    },
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 70);
    const outerRadius = 130.0; // Pivot for outer pills
    const innerRadius = 80.0; // Pivot for inner pills
    const outerThickness = 50.0;
    const innerThickness = 35.0;
    const segmentSweep = math.pi / 5;
    const gap = 0.08;

    for (int i = 0; i < _zones.length; i++) {
      final zone = _zones[i];
      final startAngle = math.pi + (i * segmentSweep);
      final midAngle = startAngle + (segmentSweep / 2);

      // --- Outer Arc Pills (Categories) ---
      final outerPaint = Paint()
        ..color = zone['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = outerThickness
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerRadius),
        startAngle + gap,
        segmentSweep - (gap * 2),
        false,
        outerPaint,
      );

      // Category Text
      _drawTextOnArc(
        canvas,
        center,
        outerRadius - 15, // Slightly tighter radius for category text
        midAngle,
        zone['category'] as String,
        13,
        FontWeight.w600,
        Colors.black.withValues(alpha: 0.8),
      );

      // --- Inner Arc Pills (Ranges) ---
      final innerPaint = Paint()
        ..color = zone['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = innerThickness
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle + gap,
        segmentSweep - (gap * 2),
        false,
        innerPaint,
      );

      // Range Text
      _drawTextOnArc(
        canvas,
        center,
        innerRadius,
        midAngle,
        zone['range'] as String,
        11,
        FontWeight.w500,
        Colors.black.withValues(alpha: 0.7),
      );
    }

    // --- Center Value (32.1 in Red with White Box) ---
    final valTP = TextPainter(
      text: TextSpan(
        text: bmiValue.toStringAsFixed(1),
        style: GoogleFonts.workSans(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFEE3638),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    valTP.layout();

    final boxRect = Rect.fromCenter(
      center: center + const Offset(0, 40),
      width: valTP.width + 32,
      height: valTP.height + 12,
    );
    final boxRRect = RRect.fromRectAndRadius(
      boxRect,
      const Radius.circular(12),
    );

    // Draw box shadow
    canvas.drawRRect(
      boxRRect.shift(const Offset(0, 4)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.05)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Draw white box
    canvas.drawRRect(boxRRect, Paint()..color = Colors.white);

    valTP.paint(
      canvas,
      center + Offset(-valTP.width / 2, 40 - valTP.height / 2),
    );

    // --- Black Needle Pointer ---
    final clampedBmiValue = bmiValue.clamp(0.0, 40.0);
    final targetAngle = math.pi + (clampedBmiValue / 40.0) * math.pi;
    final animatedAngle = math.pi + (targetAngle - math.pi) * animationValue;

    _drawNeedle(
      canvas,
      center,
      outerRadius + (outerThickness / 2) - 5,
      animatedAngle,
    );
  }

  void _drawTextOnArc(
    Canvas canvas,
    Offset center,
    double radius,
    double angle,
    String text,
    double size,
    FontWeight weight,
    Color color,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.roboto(
          fontSize: size,
          fontWeight: weight,
          color: color,
          height: 1.1,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    final offset = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    // Rotate text to follow the curve as in the original image
    // Adding 90 degrees (pi/2) because 0 degrees is horizontal-right
    canvas.rotate(angle + math.pi / 2);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  void _drawNeedle(Canvas canvas, Offset center, double length, double angle) {
    final tip = Offset(
      center.dx + length * math.cos(angle),
      center.dy + length * math.sin(angle),
    );

    final needlePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Needle body (thin triangle)
    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(
        center.dx + 2 * math.cos(angle + math.pi / 2),
        center.dy + 2 * math.sin(angle + math.pi / 2),
      )
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(
        center.dx + 2 * math.cos(angle - math.pi / 2),
        center.dy + 2 * math.sin(angle - math.pi / 2),
      )
      ..close();

    canvas.drawPath(path, needlePaint);

    // Bulbous base as in the image
    canvas.drawCircle(center, 12, needlePaint);
  }

  @override
  bool shouldRepaint(_BmiDualArcPillPainter old) =>
      old.bmiValue != bmiValue || old.animationValue != animationValue;
}
