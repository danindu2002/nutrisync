import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisync_protal/core/theme/app_theme.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
                      color: AppTheme.primary.withOpacity(0.30),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                      Colors.black.withOpacity(0.75),
                      Colors.black.withOpacity(0.20),
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
                            color: Colors.white.withOpacity(0.85),
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

/// A beautiful, accurate semi-circular BMI gauge using syncfusion_flutter_gauges.
///
/// Design: two concentric arc-bands (outer = categories, inner = ranges),
/// with labels centered inside each band, a large red BMI value at center,
/// and a thick black needle pointing to the current BMI position.
class BmiGauge extends StatelessWidget {
  final double value;

  const BmiGauge({super.key, this.value = 32.1});

  // Segment definitions: [startBmi, endBmi, color, categoryLabel, rangeLabel]
  // Small gaps (0.3 units) are added between segments for visual separation.
  static const _segments = [
    // startBmi, endBmi, color, categoryLabel, rangeLabel
    (10.0, 18.2, Color(0xFF00B0FF), 'Under\nWeight', '<18.5'),
    (18.8, 24.7, Color(0xFF4CAF50), 'Normal\nWeight', '18.5-24.9'),
    (25.3, 29.7, Color(0xFFFFEB3B), 'Over\nweight', '25-29.9'),
    (30.3, 34.7, Color(0xFFFF9800), 'Obese', '30-34.9'),
    (35.3, 45.0, Color(0xFFF44336), 'Extremely\nObese', '>35.0'),
  ];

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        // ── Outer axis: category name blocks ───────────────────────────
        RadialAxis(
          minimum: 10,
          maximum: 45,
          startAngle: 180,
          endAngle: 0,
          showLabels: false,
          showTicks: false,
          radiusFactor: 1.0,
          axisLineStyle: const AxisLineStyle(thickness: 0),
          ranges: [
            for (final s in _segments)
              _band(s.$1, s.$2, s.$3, outerStart: 0.70, outerEnd: 0.96),
          ],
          annotations: [
            for (final s in _segments)
              // positionFactor 0.83 = midpoint of the 0.70→0.96 band
              _label(
                s.$4,
                _midBmi(s.$1, s.$2),
                positionFactor: 0.83,
                fontSize: 9.5,
              ),
          ],
        ),

        // ── Inner axis: range labels blocks + needle + BMI number ──────
        RadialAxis(
          minimum: 10,
          maximum: 45,
          startAngle: 180,
          endAngle: 0,
          showLabels: false,
          showTicks: false,
          radiusFactor: 1.0,
          axisLineStyle: const AxisLineStyle(thickness: 0),
          ranges: [
            for (final s in _segments)
              _band(s.$1, s.$2, s.$3, outerStart: 0.42, outerEnd: 0.67),
          ],
          pointers: [
            NeedlePointer(
              value: value,
              needleColor: const Color(0xFF212121),
              needleStartWidth: 1,
              needleEndWidth: 7,
              needleLength: 0.65,
              knobStyle: const KnobStyle(
                color: Color(0xFF212121),
                knobRadius: 0.09,
                sizeUnit: GaugeSizeUnit.factor,
              ),
              tailStyle: const TailStyle(
                width: 7,
                length: 0.18,
                lengthUnit: GaugeSizeUnit.factor,
                color: Color(0xFF212121),
              ),
              enableAnimation: true,
              animationDuration: 1200,
              animationType: AnimationType.ease,
            ),
          ],
          annotations: [
            // Large red BMI value centered below the gauge arc
            GaugeAnnotation(
              angle: 90, // points straight up from bottom-center
              positionFactor: 0.18,
              widget: Text(
                value.toStringAsFixed(1),
                style: GoogleFonts.poppins(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFF44336),
                  height: 1.0,
                ),
              ),
            ),
            // Range labels inside inner band
            for (final s in _segments)
              // positionFactor 0.545 = midpoint of the 0.42→0.67 band
              _label(
                s.$5,
                _midBmi(s.$1, s.$2),
                positionFactor: 0.545,
                fontSize: 8,
              ),
          ],
        ),
      ],
    );
  }

  /// Builds a colored arc band with specified radial extent.
  GaugeRange _band(
    double start,
    double end,
    Color color, {
    required double outerStart,
    required double outerEnd,
  }) {
    final thickness = outerEnd - outerStart;
    return GaugeRange(
      startValue: start,
      endValue: end,
      color: color,
      startWidth: thickness,
      endWidth: thickness,
      sizeUnit: GaugeSizeUnit.factor,
      rangeOffset: outerStart,
    );
  }

  /// Builds a GaugeAnnotation with text centered at the midpoint BMI of a segment.
  ///
  /// [bmiMid] – the midpoint BMI value of the segment.
  /// [positionFactor] – 0 = gauge center, 1 = outer radius edge.
  GaugeAnnotation _label(
    String text,
    double bmiMid, {
    required double positionFactor,
    required double fontSize,
  }) {
    return GaugeAnnotation(
      angle: _angle(bmiMid),
      positionFactor: positionFactor,
      widget: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A1A1A),
          height: 1.15,
        ),
      ),
    );
  }

  /// Returns the midpoint BMI of a segment.
  double _midBmi(double start, double end) => (start + end) / 2;

  /// Maps a BMI value (10–45) to a GaugeAnnotation angle (degrees).
  ///
  /// SfRadialGauge annotation angles:
  ///   • 0° = 3 o'clock (right)
  ///   • 90° = 6 o'clock (bottom)
  ///   • 180° = 9 o'clock (left)
  ///   • 270° = 12 o'clock (top)
  ///
  /// The axis startAngle=180 is bottom-left, endAngle=0 is bottom-right.
  /// BMI 10 → bottom-left (annotation angle 180°)
  /// BMI 45 → bottom-right (annotation angle 0°)
  double _angle(double bmi) {
    // Fraction along the 180° sweep (0 = start, 1 = end)
    final fraction = (bmi - 10) / 35;
    // Map fraction to annotation angle: 180° (left) → 0° (right)
    return 180 - (fraction * 180);
  }
}
