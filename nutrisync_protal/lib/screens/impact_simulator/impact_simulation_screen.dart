import 'dart:async';
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
    // Removed the blocking LoadingIndicator.show(context)

    try {
      final prefs = await SharedPreferences.getInstance();
      final int? userId = prefs.getInt("userId");

      if (userId == null) {
        setState(() => _isLoading = false);
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
        // Removed the blocking LoadingIndicator.hide(context)
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
              // Display the engaging AI loader while fetching
                  ? AILoadingState(bmiValue: widget.bmiValue)
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
    double afterBmi = (_simulationData?['projectedBmi'] ?? 0).toDouble();
    double projBf = (_simulationData?['projectedBodyFatPercent'] ?? 0).toDouble();
    double bfChange = (_simulationData?['bodyFatChangePercent'] ?? 0).toDouble();

    double nowBfPercent = (projBf - bfChange) / 100.0;
    if (nowBfPercent <= 0) nowBfPercent = projBf / 100.0;

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
            color: const Color(0xFFEE3638).withOpacity(0.8), // Updated to withOpacity
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

  Widget _buildChangeRow(String label, dynamic changeValue, {String unit = ''}) {
    if (changeValue == null) return _buildTextRow(label, '-');

    double val = (changeValue as num).toDouble();
    bool isNegative = val < 0;

    IconData icon = isNegative ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;
    Color iconColor = isNegative ? const Color(0xFF4CAF50) : const Color(0xFFEE3638);

    return _buildBaseRow(
      label,
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(': ', style: TextStyle(color: Color(0xFF616161), fontSize: 15, fontWeight: FontWeight.w500)),
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 4),
          Text(
            '${val.abs().toStringAsFixed(1)}$unit',
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
    final arrowCenter = size.width * 0.75;

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

// ---------------------------------------------------------
// AI Loading Widget
// ---------------------------------------------------------
class AILoadingState extends StatefulWidget {
  final double bmiValue;
  const AILoadingState({super.key, required this.bmiValue});

  @override
  State<AILoadingState> createState() => _AILoadingStateState();
}

class _AILoadingStateState extends State<AILoadingState> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _textTimer;
  int _textIndex = 0;

  final List<String> _loadingPhrases = [
    "Analyzing your current metrics...",
    "Evaluating NutriSync diet plan...",
    "Simulating metabolic changes...",
    "Projecting 6 months into the future...",
    "Finalizing health predictions...",
  ];

  @override
  void initState() {
    super.initState();
    // Creates a continuous pulsing effect
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Cycles the text every 2.5 seconds
    _textTimer = Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (mounted) {
        setState(() {
          _textIndex = (_textIndex + 1) % _loadingPhrases.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _textTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pulsing Silhouette
          FadeTransition(
            opacity: Tween<double>(begin: 0.4, end: 1.0).animate(_pulseController),
            child: DynamicBodySilhouette(
              bmi: widget.bmiValue,
              bodyFatPercentage: 0.5, // Generic middle-ground loading state
              height: 180,
            ),
          ),
          const SizedBox(height: 40),

          // Custom Styled Progress Indicator
          const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEE3638)),
            ),
          ),
          const SizedBox(height: 24),

          // Animated Text Switcher for AI Phrases
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              _loadingPhrases[_textIndex],
              key: ValueKey<int>(_textIndex),
              style: GoogleFonts.workSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF616161),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// Dynamic silhouette widget that changes based on BMI and body fat percentage, used for both loading and final display states
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
            Color(0xFFFFA726),
            Color(0xFFEE3638),
            Color(0xFF333333),
            Color(0xFF333333),
          ],
          stops: [
            0.0,
            bodyFatPercentage * 3 + 0.02,
            bodyFatPercentage,
            bodyFatPercentage + 0.1
          ],
        ).createShader(bounds);
      },
      child: Image.asset(
        _getSilhouettePath(bmi),
        height: height,
        fit: BoxFit.contain,
        color: Colors.white,
      ),
    );
  }
}