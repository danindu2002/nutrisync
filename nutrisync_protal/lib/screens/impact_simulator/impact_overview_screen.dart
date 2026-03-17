import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:NutriSync/core/theme.dart';
import 'package:NutriSync/widgets/common_widgets.dart';

class ImpactOverviewScreen extends StatelessWidget {
  const ImpactOverviewScreen({super.key});

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
                      _buildSummaryCards(),
                      const SizedBox(height: 24),
                      _buildNavigationCard(
                        icon: Icons.speed_rounded,
                        title: 'Body Measurements Overview',
                        onTap: () {},
                      ),
                      const SizedBox(height: 32),
                      _buildPerformanceHeader(),
                      const SizedBox(height: 24),
                      _buildTimeRangeSelector(),
                      const SizedBox(height: 32),
                      _buildCustomChart(),
                      const SizedBox(height: 32),
                      _buildNavigationCard(
                        icon: Icons.monitor_heart_outlined,
                        title: 'Possible Health Conditions',
                        onTap: () {},
                      ),
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
              Text(
                'Impact Overview',
                style: GoogleFonts.workSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF333333),
                ),
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

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.local_fire_department_rounded,
            value: '450 kcal',
            label: 'Daily Goal',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.fitness_center_rounded,
            value: '12',
            label: 'Workouts',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.access_time_filled_rounded,
            value: '3 months',
            label: 'Total Time',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFEE3638), size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.workSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF333333),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.workSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return OptionCard(
      title: title,
      icon: icon,
      isSelected: false,
      onTap: onTap,
    );
  }

  Widget _buildPerformanceHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Current Performance',
          style: GoogleFonts.workSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF333333),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEE3638),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Text(
                'Calories',
                style: GoogleFonts.workSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    final ranges = ['1D', '1W', '1M', '6M', '1Y'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ranges.map((range) {
          final isActive = range == '1W';
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFEE3638) : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFFEE3638).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              range,
              style: GoogleFonts.workSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : const Color(0xFFADB5BD),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCustomChart() {
    final data = [
      {'day': 'Sun', 'value': 0.6},
      {'day': 'Mon', 'value': 0.8},
      {'day': 'Tue', 'value': 0.65},
      {'day': 'Wed', 'value': 0.4},
      {'day': 'Thu', 'value': 0.45},
      {'day': 'Fri', 'value': 0.45},
      {'day': 'Sat', 'value': 0.75},
    ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: ['4k', '3k', '2k', '1k', '0'].map((label) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    label,
                    style: GoogleFonts.workSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFADB5BD),
                    ),
                  ),
                );
              }).toList(),
            ),
            ...data.map((item) {
              final isTarget = item['day'] == 'Tue';
              return Column(
                children: [
                  Container(
                    height: 160,
                    width: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9ECEF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: item['value'] as double,
                      child: Container(
                        width: 14,
                        decoration: BoxDecoration(
                          color: isTarget
                              ? const Color(0xFFEE3638)
                              : const Color(0xFFEE3638).withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['day'] as String,
                    style: GoogleFonts.workSans(
                      fontSize: 12,
                      fontWeight: isTarget ? FontWeight.w700 : FontWeight.w500,
                      color: isTarget
                          ? const Color(0xFFEE3638)
                          : const Color(0xFFADB5BD),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }
}
