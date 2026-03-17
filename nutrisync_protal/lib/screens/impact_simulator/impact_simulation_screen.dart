import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:NutriSync/core/theme.dart';
import 'package:NutriSync/widgets/common_widgets.dart';

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
                      const SizedBox(height: 20),
                      _buildDetailsPanel(),
                      const SizedBox(height: 20),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.workSans(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF333333),
              ),
            ),
          ),
          const SizedBox(width: 8),
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

              // NEW: Dynamic Widget for "NOW"
              // BMI 32.1 -> Wider body. 35% Body Fat -> Filled 35% up.
              const DynamicBodySilhouette(
                bmi: 32.1,
                bodyFatPercentage: 0.35,
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

              // NEW: Dynamic Widget for "AFTER"
              // BMI 24.0 -> Thinner body. 21% Body Fat -> Filled 21% up.
              const DynamicBodySilhouette(
                bmi: 24.0,
                bodyFatPercentage: 0.21,
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
    return Column(
      children: [
        ClipPath(
          clipper: _BubbleClipper(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
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
          ),
        ),
      ],
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
}

class _BubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    const arrowWidth = 20.0;
    const arrowHeight = 12.0;
    final arrowCenter =
        size.width * 0.75; // Aligned under the target BMI (24.0)

    // Start near top-left
    path.moveTo(0, arrowHeight);

    // Triangle pointer shifted to the right
    path.lineTo(arrowCenter - arrowWidth / 2, arrowHeight);
    path.lineTo(arrowCenter, 0);
    path.lineTo(arrowCenter + arrowWidth / 2, arrowHeight);
    path.lineTo(size.width, arrowHeight);

    // Remaining sides of rounded rect
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DynamicBodySilhouette extends StatelessWidget {
  final double bmi;
  final double bodyFatPercentage; // e.g., 0.35 for 35%
  final double height;

  const DynamicBodySilhouette({
    super.key,
    required this.bmi,
    required this.bodyFatPercentage,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Calculate Width Scale based on BMI
    // Assume BMI 22 is a "normal" 1.0 scale.
    // Every 1 point of BMI adds 3.5% width. You can tweak the 0.035 multiplier!
    double scaleX = 1.0 + ((bmi - 22.0).clamp(0, 50) * 0.035);

    return Transform.scale(
      scaleX: scaleX, // Stretches only the width!
      alignment: Alignment.center,
      child: ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (Rect bounds) {
          // 2. Create a gradient fill based on Body Fat %
          return LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: const [
              Color(0xFFFFA726), // Orange (Feet/Legs)
              Color(0xFFEE3638), // Red (Midsection)
              Color(0xFF333333), // Dark Gray (Empty/Upper body)
              Color(0xFF333333),
            ],
            stops: [
              0.0,
              bodyFatPercentage * 0.5, // Blends orange to red
              bodyFatPercentage,       // The sharp cutoff line
              bodyFatPercentage + 0.01 // Forces a hard edge instead of a smooth gradient fade
            ],
          ).createShader(bounds);
        },
        child: Image.asset(
          'assets/images/impact_simulator/silhouette.png', // Your solid mask image
          height: height,
          fit: BoxFit.contain,
          // Color is required for the mask to correctly apply the gradient over the pixels
          color: Colors.white,
        ),
      ),
    );
  }
}
