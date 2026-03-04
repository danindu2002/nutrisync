import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:NutriSync/core/theme/app_theme.dart';
import 'package:NutriSync/widgets/common_widgets.dart';

class NutritionSummaryScreen extends StatelessWidget {
  const NutritionSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildDailySummaryCard(),
                      const SizedBox(height: 32),
                      _buildAddFoodButton(),
                      const SizedBox(height: 32),
                      _buildMealHistory(),
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

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nutrition',
                    style: GoogleFonts.workSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  Text(
                    'Daily Summary',
                    style: GoogleFonts.workSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFC9F0D1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 14,
                ),
                const SizedBox(width: 6),
                Text(
                  'Excellent',
                  style: GoogleFonts.workSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailySummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // Circular Progress on the left
          Expanded(
            flex: 5,
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(double.infinity, double.infinity),
                    painter: _NutritionCirclePainter(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '1,450',
                        style: GoogleFonts.workSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      Text(
                        'of 2,000 kcal',
                        style: GoogleFonts.workSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 32),
          // Metrics on the right
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetricItem('Consumed', '1,450 kcal'),
                const SizedBox(height: 16),
                _buildMetricItem('Daily Goal', '2,000 kcal'),
                const SizedBox(height: 16),
                _buildMetricItem('Remaining', '550 kcal', isHighlighted: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.workSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFADB5BD),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.workSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isHighlighted
                ? const Color(0xFF333333)
                : const Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildAddFoodButton() {
    return PrimaryButton(text: 'Add Food', isRed: true, onTap: () {});
  }

  Widget _buildMealHistory() {
    return Column(
      children: [
        _buildMealCard(
          icon: Icons.breakfast_dining_rounded,
          title: 'Breakfast (240 kcal)',
          items: 'Oatmeal, Banana, Coffee',
        ),
        const SizedBox(height: 16),
        _buildMealCard(
          icon: Icons.lunch_dining_rounded,
          title: 'Lunch (480 kcal)',
          items: 'Grilled Chicken Breast, Salad',
        ),
        const SizedBox(height: 16),
        _buildMealCard(
          icon: Icons.restaurant_rounded,
          title: 'Dinner (440 kcal)',
          items: 'Baked Salmon, Broccoli',
        ),
      ],
    );
  }

  Widget _buildMealCard({
    required IconData icon,
    required String title,
    required String items,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2D2D4D), size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.workSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  items,
                  style: GoogleFonts.workSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 12.0;
    final rect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    final bgPaint = Paint()
      ..color = const Color(0xFFC9F0D1).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = const Color(0xFFEE3638)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Draw background partial circle
    canvas.drawArc(rect, 2.5 * math.pi / 4, 1.5 * math.pi, false, bgPaint);

    // Draw progress partial circle (1450/2000 = 0.725)
    canvas.drawArc(
      rect,
      2.5 * math.pi / 4,
      1.5 * math.pi * 0.725,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
