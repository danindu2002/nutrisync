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
  int _selectedTab = 0; // 0 = Analogue Meter, 1 = Histogram
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
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
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
                        _buildBmiRangeList(),
                      ] else ...[
                        _buildHistogramPlaceholder(),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── App Bar ────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
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
          _buildStatusPill(
            label: 'Critical!',
            dotColor: AppTheme.primary,
            bgColor: AppTheme.statusCriticalBg,
            textColor: AppTheme.statusCriticalText,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill({
    required String label,
    required Color dotColor,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tab Switcher ───────────────────────────────────
  Widget _buildTabSwitcher() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _buildTab(index: 0, label: 'Analogue Meter'),
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

  // ─── Gauge Card ─────────────────────────────────────
  Widget _buildGaugeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 210,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _needleAnimation,
              builder: (context, _) {
                return CustomPaint(
                  painter: _BmiGaugePainter(
                    bmiValue: _bmiValue,
                    animationValue: _needleAnimation.value,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _bmiValue.toString(),
            style: GoogleFonts.poppins(
              fontSize: 52,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Obese Class I',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Footnote ───────────────────────────────────────
  Widget _buildFootnote() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.only(top: 5),
          decoration: const BoxDecoration(
            color: AppTheme.primary,
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
              color: AppTheme.primary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // ─── BMI Range List ─────────────────────────────────
  Widget _buildBmiRangeList() {
    final ranges = [
      _BmiRange('Underweight', '< 18.5', AppTheme.bmiUnderweight),
      _BmiRange('Normal Weight', '18.5 – 24.9', AppTheme.bmiNormal),
      _BmiRange('Overweight', '25 – 29.9', AppTheme.bmiOverweight),
      _BmiRange('Obese', '30 – 34.9', AppTheme.bmiObese, isActive: true),
      _BmiRange('Extremely Obese', '≥ 35.0', AppTheme.bmiExtreme),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BMI Ranges',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...ranges.map((r) => _buildRangeRow(r)),
      ],
    );
  }

  Widget _buildRangeRow(_BmiRange range) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: range.isActive
            ? range.color.withValues(alpha: 0.12)
            : AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: range.isActive
            ? Border.all(color: range.color.withValues(alpha: 0.4), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: range.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              range.label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: range.isActive ? FontWeight.w600 : FontWeight.w500,
                color: range.isActive
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
              ),
            ),
          ),
          Text(
            range.range,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: range.color,
            ),
          ),
          if (range.isActive) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: range.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'You',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: range.color,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Histogram Placeholder ──────────────────────────
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

// ─── BMI Gauge Custom Painter ─────────────────────────────
class _BmiGaugePainter extends CustomPainter {
  final double bmiValue;
  final double animationValue;

  _BmiGaugePainter({required this.bmiValue, required this.animationValue});

  static const _zones = [
    [0.0, 18.5, Color(0xFF4FC3F7), 'Under\nWeight', '<18.5'],
    [18.5, 25.0, Color(0xFF66BB6A), 'Normal\nWeight', '18.5-24.9'],
    [25.0, 30.0, Color(0xFFFFCA28), 'Over\nweight', '25-29.9'],
    [30.0, 35.0, Color(0xFFFF7043), 'Obese', '30-34.9'],
    [35.0, 45.0, Color(0xFFE53935), 'Extremely\nObese', '>35.0'],
  ];

  static const double _minBmi = 0.0;
  static const double _maxBmi = 45.0;
  static const double _startAngle = math.pi;
  static const double _totalSweep = math.pi;

  double _bmiToAngle(double bmi) {
    final fraction = (bmi - _minBmi) / (_maxBmi - _minBmi);
    return _startAngle - fraction * _totalSweep;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 10);
    final outerRadius = size.width * 0.46;
    final strokeWidth = size.width * 0.095;
    final gapAngle = 0.025;

    for (int i = 0; i < _zones.length; i++) {
      final zone = _zones[i];
      final startBmi = zone[0] as double;
      final endBmi = zone[1] as double;
      final color = zone[2] as Color;

      final angleStart = _bmiToAngle(endBmi);
      final angleEnd = _bmiToAngle(startBmi);
      final sweep = angleEnd - angleStart;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      final arcRect = Rect.fromCircle(
        center: center,
        radius: outerRadius - strokeWidth / 2,
      );
      canvas.drawArc(
        arcRect,
        angleStart + gapAngle / 2,
        sweep - gapAngle,
        false,
        paint,
      );

      final midAngle = angleStart + gapAngle / 2 + (sweep - gapAngle) / 2;
      final labelRadius = outerRadius - strokeWidth / 2;
      final labelPos = Offset(
        center.dx + labelRadius * math.cos(midAngle),
        center.dy + labelRadius * math.sin(midAngle),
      );

      final label = zone[3] as String;
      final subLabel = zone[4] as String;

      canvas.save();
      canvas.translate(labelPos.dx, labelPos.dy);
      canvas.rotate(midAngle + math.pi / 2);

      final tp = TextPainter(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label\n',
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.028,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            TextSpan(
              text: subLabel,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: size.width * 0.022,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: strokeWidth + 4);

      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    // Animated needle
    final targetAngle = _bmiToAngle(bmiValue);
    final currentAngle =
        _startAngle + (targetAngle - _startAngle) * animationValue;

    final needleLength = outerRadius - strokeWidth * 0.1;
    final needleTip = Offset(
      center.dx + needleLength * math.cos(currentAngle),
      center.dy + needleLength * math.sin(currentAngle),
    );

    // Shadow
    canvas.drawLine(
      center + const Offset(2, 2),
      needleTip + const Offset(2, 2),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.15)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // Needle
    canvas.drawLine(
      center,
      needleTip,
      Paint()
        ..color = const Color(0xFF1A1A1A)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );

    // Center pivot
    canvas.drawCircle(center, 10, Paint()..color = const Color(0xFF1A1A1A));
    canvas.drawCircle(center, 5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_BmiGaugePainter old) =>
      old.bmiValue != bmiValue || old.animationValue != animationValue;
}

class _BmiRange {
  final String label;
  final String range;
  final Color color;
  final bool isActive;
  const _BmiRange(this.label, this.range, this.color, {this.isActive = false});
}
