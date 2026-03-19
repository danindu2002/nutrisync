import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:NutriSync/core/theme.dart';
import 'package:NutriSync/widgets/common_widgets.dart';

import '../../services/simulation_service.dart';

class ImpactSimulationScreen extends StatefulWidget {
  final double bmiValue;

  const ImpactSimulationScreen({
    super.key,
    this.bmiValue = 0,
  });

  @override
  State<ImpactSimulationScreen> createState() => _ImpactSimulationScreenState();
}

class _ImpactSimulationScreenState extends State<ImpactSimulationScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _simulationData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSimulationData();
    });
  }

  Future<void> _fetchSimulationData() async {
    setState(() => _isLoading = true);
    LoadingIndicator.show(context);

    try {
      final prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt("userId");

      if (userId == null) {
        if (mounted) LoadingIndicator.hide(context);
        return;
      }

      // Fetching simulation for 6 months
      final response = await SimulationService.simulateImpact(userId, 6);

      if (mounted) {
        if (response.success && response.data != null) {
          setState(() {
            _simulationData = response.data;
          });
        } else {
          showModernToast(
            context,
            response.message.isNotEmpty ? response.message : "Failed to load simulation",
            type: 'error',
          );
        }
      }
    } catch (e) {
      debugPrint("API Error fetching simulation: $e");
      if (mounted) showModernToast(context, "An error occurred", type: 'error');
    } finally {
      if (mounted) {
        LoadingIndicator.hide(context);
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _isLoading
                  ? const SizedBox() // Hides content until data arrives
                  : SingleChildScrollView(
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
    // Safely parse projected values
    double afterBmi = (_simulationData?['projectedBmi'] ?? 0).toDouble();
    double projBf = (_simulationData?['projectedBodyFatPercent'] ?? 0).toDouble();
    double bfChange = (_simulationData?['bodyFatChangePercent'] ?? 0).toDouble();

    // Calculate "Now" Body Fat (Projected - Change)
    double nowBfPercent = (projBf - bfChange) / 100.0;
    if (nowBfPercent <= 0) nowBfPercent = projBf / 100.0; // Fallback if math is weird

    double afterBfPercent = projBf / 100.0;

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

              DynamicBodySilhouette(
                bmi: widget.bmiValue,
                bodyFatPercentage: nowBfPercent,
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
                widget.bmiValue.toStringAsFixed(1),
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

              DynamicBodySilhouette(
                bmi: afterBmi,
                bodyFatPercentage: afterBfPercent,
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
                afterBmi.toStringAsFixed(1),
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
                _buildTextRow('Average body fat', '${_simulationData?['projectedBodyFatPercent'] ?? '-'}%'),
                _buildTextRow('Waist-to-hip ratio', '${_simulationData?['waistToHipRatio'] ?? '-'}'),
                _buildTextRow('Body weight', '${_simulationData?['projectedWeightKg'] ?? '-'}kg'),
                _buildTextRow('Expected consistency level', '${_simulationData?['expectedConsistencyLevel'] ?? '-'}'),
                const SizedBox(height: 16),

                // Change Values with Arrows
                _buildChangeRow('BMI Change', _simulationData?['bmiChange']),
                _buildChangeRow('Body weight change', _simulationData?['weightChangeKg'], unit: 'kg'),
                _buildChangeRow('Average body fat change', _simulationData?['bodyFatChangePercent'], unit: '%'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Used for standard text outputs
  Widget _buildTextRow(String label, String value) {
    return _buildBaseRow(
      label,
      Text(
        ': $value',
        style: GoogleFonts.workSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF616161),
        ),
      ),
    );
  }

  // Used for change values (+/- arrows)
  Widget _buildChangeRow(String label, dynamic changeValue, {String unit = ''}) {
    if (changeValue == null) return _buildTextRow(label, '-');

    double val = (changeValue as num).toDouble();
    bool isNegative = val < 0;

    // Choose arrow direction and color
    IconData icon = isNegative ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;
    Color iconColor = isNegative ? const Color(0xFF4CAF50) : const Color(0xFFEE3638); // Green for down, Red for up

    return _buildBaseRow(
      label,
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(': ', style: TextStyle(color: Color(0xFF616161), fontSize: 15, fontWeight: FontWeight.w500)),
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 4),
          Text(
            '${val.abs().toStringAsFixed(1)}$unit', // .abs() removes the minus sign
            style: GoogleFonts.workSans(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF616161),
            ),
          ),
        ],
      ),
    );
  }

  // The base layout structure for all rows
  Widget _buildBaseRow(String label, Widget valueWidget) {
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
            child: valueWidget,
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
    final arrowCenter = size.width * 0.75; // Aligned under the target BMI

    path.moveTo(0, arrowHeight);
    path.lineTo(arrowCenter - arrowWidth / 2, arrowHeight);
    path.lineTo(arrowCenter, 0);
    path.lineTo(arrowCenter + arrowWidth / 2, arrowHeight);
    path.lineTo(size.width, arrowHeight);
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
  final double bodyFatPercentage;
  final double height;

  const DynamicBodySilhouette({
    super.key,
    required this.bmi,
    required this.bodyFatPercentage,
    this.height = 200,
  });

  // Maps the current BMI to the correct silhouette asset
  String _getSilhouettePath(double currentBmi) {
    if (currentBmi < 18.5) {
      return 'assets/images/impact_simulator/silhouette_uw.png';
    } else if (currentBmi < 25.0) {
      return 'assets/images/impact_simulator/silhouette_n.png';
    } else if (currentBmi < 30.0) {
      return 'assets/images/impact_simulator/silhouette_ow.png';
    } else if (currentBmi < 35.0) {
      return 'assets/images/impact_simulator/silhouette_o.png';
    } else {
      return 'assets/images/impact_simulator/silhouette_eo.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) {
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
            bodyFatPercentage * 3 + 0.02,
            bodyFatPercentage,
            bodyFatPercentage + 0.1 // Forces a hard edge
          ],
        ).createShader(bounds);
      },
      child: Image.asset(
        _getSilhouettePath(bmi), // Dynamically loads the correct body shape
        height: height,
        fit: BoxFit.contain,
        color: Colors.white, // Required for the shader mask to apply correctly
      ),
    );
  }
}

