import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrisync_protal/core/theme/app_theme.dart';

class ImpactSimulationScreen extends StatefulWidget {
  const ImpactSimulationScreen({super.key});

  @override
  State<ImpactSimulationScreen> createState() => _ImpactSimulationScreenState();
}

class _ImpactSimulationScreenState extends State<ImpactSimulationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    children: [
                      const SizedBox(height: 32),
                      _buildBodyComparison(),
                      const SizedBox(height: 32),
                      _buildDetailsPanel(),
                      const SizedBox(height: 48),
                      _buildActionButton(),
                      const SizedBox(height: 40),
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
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
          Expanded(
            child: Text(
              'Impact Simulation',
              style: GoogleFonts.workSans(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9C4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_rounded,
                  color: Color(0xFFFFD600),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Attention!',
                  style: GoogleFonts.workSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFFFD600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyComparison() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Now Column
        Expanded(
          child: Column(
            children: [
              Text(
                'Now',
                style: GoogleFonts.workSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/now image.png',
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                'BMI',
                style: GoogleFonts.workSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF757575),
                ),
              ),
              Text(
                '32.1',
                style: GoogleFonts.workSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFEE3638),
                ),
              ),
            ],
          ),
        ),
        // Arrow
        Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Icon(
            Icons.chevron_right_rounded,
            size: 48,
            color: const Color(0xFFEE3638).withValues(alpha: 0.8),
          ),
        ),
        // After Column
        Expanded(
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'After',
                    style: GoogleFonts.workSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF757575),
                    ),
                  ),
                  Text(
                    '6 Months',
                    style: GoogleFonts.workSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Image.asset(
                'assets/images/after image.png',
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                'BMI',
                style: GoogleFonts.workSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF757575),
                ),
              ),
              Text(
                '24.0',
                style: GoogleFonts.workSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          _buildDetailRow('Average body fat', '21%'),
          _buildDetailRow('Waist-to-hip ratio', '0.8'),
          _buildDetailRow('Body weight', '65kg'),
          _buildDetailRow('Expected consistency level', 'High'),
          const SizedBox(height: 16),
          _buildDetailRow('BMI Change', '8.1'),
          _buildDetailRow('Body weight change', '16kg'),
          _buildDetailRow('Average body fat change', '6%'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: GoogleFonts.workSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF424242),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              ': $value',
              style: GoogleFonts.workSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF616161),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFEE3638),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFEE3638).withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Impact Overview',
            style: GoogleFonts.workSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white,
            size: 24,
          ),
        ],
      ),
    );
  }
}
