import 'package:flutter/material.dart';
import '../core/constants.dart';

// main button
class PrimaryButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool isRed;

  const PrimaryButton({super.key, required this.onTap, this.text = "Continue", required this.isRed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isRed ? AppColors.primary : AppColors.secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text, style: AppTextStyles.buttonText,),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// Selectable Option Card - Old Design
class OptionCardOld extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  const OptionCardOld({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.activeColor = const Color(0xFFFF4B4B), // Your Primary Red
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          // Selected: Light Red BG. Unselected: Light Gray BG.
          color: isSelected
              ? activeColor.withOpacity(0.15)
              : Colors.grey.shade100,
          border: Border.all(
            // Selected: Red Border. Unselected: Transparent.
            color: isSelected ? activeColor : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20), // More rounded corners
        ),
        child: Row(
          children: [
            // Icon
            if (icon != null) ...[
              Icon(
                icon,
                // Selected: Red Icon. Unselected: Grey Icon.
                color: isSelected ? activeColor : AppColors.cardBg,
                size: 26,
              ),
              const SizedBox(width: 16),
            ],

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // Text color stays darkish for readability, or use Primary if preferred
                      color: isSelected ? Colors.black87 : Colors.black54,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Custom Radio/Checkbox Indicator
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  // Shape: Rounded Rectangle (Squircle) like in the design
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? activeColor : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extracted Widget for the Red Dot Indicator
class SelectionIndicator extends StatelessWidget {
  final bool isSelected;
  final Color activeColor;

  const SelectionIndicator({
    super.key,
    required this.isSelected,
    required this.activeColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? activeColor : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      )
          : null,
    );
  }
}

// Selectable Option Card (Redesigned)
class OptionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  const OptionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.activeColor = AppColors.primary, // Your Primary Red
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          // Selected: Solid Red. Unselected: Light Gray.
          color: isSelected ? activeColor : AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: activeColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            // Icon
            if (icon != null) ...[
              Icon(
                icon,
                // Selected: White. Unselected: Dark Grey.
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 28,
              ),
              const SizedBox(width: 16),
            ],

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Hug content
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      // Selected: White. Unselected: Black.
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        // Selected: Slightly transparent White. Unselected: Grey.
                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),

            // Checkbox removed as requested
          ],
        ),
      ),
    );
  }
}

// Header for each page
class OnboardingHeader extends StatelessWidget {
  final String title;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  const OnboardingHeader({
    super.key,
    required this.title,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 18),
                onPressed: onBack,
              ),
              Text(
                "Assessment",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$currentStep of $totalSteps",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.header,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom floating button
class WideFloatingButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final double borderRadius;

  const WideFloatingButton({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onPressed,
    this.width = 100,
    this.height = 56,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: FloatingActionButton(
        heroTag: null, // Prevent hero collision
        elevation: 3,
        backgroundColor: backgroundColor,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(icon, color: iconColor, size: 25),
      ),
    );
  }
}

// Slider switch
class UnitSwitch extends StatelessWidget {
  final bool isLeftSelected;
  final String leftLabel;
  final String rightLabel;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;
  final Color activeColor;
  final Color inactiveColor;

  const UnitSwitch({
    super.key,
    required this.isLeftSelected,
    required this.leftLabel,
    required this.rightLabel,
    required this.onLeftTap,
    required this.onRightTap,
    this.activeColor = const Color(0xFFFF4B4B), // Your AppColors.primary
    this.inactiveColor = const Color(0xFFF5F5F5),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: inactiveColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // The sliding background
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: isLeftSelected ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: 150, // Half of the container width
              height: 50,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withOpacity(0.3),
                    blurRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          // The Text Labels
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onLeftTap,
                  behavior: HitTestBehavior.translucent,
                  child: Center(
                    child: Text(
                      leftLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isLeftSelected ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onRightTap,
                  behavior: HitTestBehavior.translucent,
                  child: Center(
                    child: Text(
                      rightLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: !isLeftSelected ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// image option card
class ImageOptionCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  const ImageOptionCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.activeColor = const Color(0xFFFF4B4B),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: activeColor.withOpacity(0.3),
              blurRadius: 3,
              offset: const Offset(0, 5),
            ),
          ]
              : [],
        ),
        // ClipRRect ensures image respects the rounded corners
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withOpacity(0.7), // Darker on left for text
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              ),

              // --- Layer 3: Content ---
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Row
                    Row(
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            size: 22,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Checkbox Indicator
                    Row(
                      children: [
                        Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // Selected: Red Border. Unselected: White Border.
                            border: Border.all(
                              color: isSelected ? activeColor : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                            child: Container(
                              height: 14,
                              width: 14,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: activeColor, // Red Fill
                              ),
                            ),
                          )
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Weight ruler
class WeightRuler extends StatefulWidget {
  final double initialWeight;
  final double minWeight;
  final double maxWeight;
  final ValueChanged<double> onChanged;

  const WeightRuler({
    super.key,
    required this.initialWeight,
    required this.minWeight,
    required this.maxWeight,
    required this.onChanged,
  });

  @override
  State<WeightRuler> createState() => _WeightRulerState();
}

class _WeightRulerState extends State<WeightRuler> {
  late ScrollController _scrollController;
  final double tickWidth = 12.0;

  @override
  void initState() {
    super.initState();
    double offset = (widget.initialWeight - widget.minWeight) * 10 * tickWidth;
    _scrollController = ScrollController(initialScrollOffset: offset);
  }

  @override
  Widget build(BuildContext context) {
    int totalTicks = ((widget.maxWeight - widget.minWeight) * 10).round();
    double paddingOffset = MediaQuery.of(context).size.width / 2 - (tickWidth / 2);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // --- Layer 1: Ruler Content ---
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white,
                Colors.white,
                Colors.white.withOpacity(0.0),
              ],
              stops: const [0.0, 0.2, 0.8, 1.0],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                double offset = _scrollController.offset;
                double index = offset / tickWidth;
                double value = widget.minWeight + (index / 10);

                value = double.parse(value.clamp(widget.minWeight, widget.maxWeight).toStringAsFixed(1));

                if (value != widget.initialWeight) {
                  widget.onChanged(value);
                }
              }
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemExtent: tickWidth,
              itemCount: totalTicks + 10,

              padding: EdgeInsets.symmetric(horizontal: paddingOffset),
              physics: _SnapScrollPhysics(itemSize: tickWidth),
              itemBuilder: (context, index) {
                double value = widget.minWeight + (index / 10);
                bool isInteger = (value % 1).abs() < 0.05;
                bool isHalf = (value % 0.5).abs() < 0.05 && !isInteger;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 70,
                      child: Center(
                        child: Container(
                          width: isInteger ? 3.5 : 2.5,
                          height: isInteger ? 60 : (isHalf ? 45 : 35),
                          decoration: BoxDecoration(
                            color: isInteger
                                ? Colors.grey.shade400
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 20,
                      child: isInteger
                          ? OverflowBox(
                        maxWidth: 60,
                        minWidth: 40,
                        child: Text(
                          value.toInt().toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      )
                          : null,
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // --- Layer 2: Red Center Indicator ---
        Positioned(
          top: 0,
          child: Container(
            width: 10,
            height: 90,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFF4B4B), Color(0xFFFF6B6B)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF4B4B).withOpacity(0.4),
                  blurRadius: 3,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Physics Class to snap the indicator to nearest value
class _SnapScrollPhysics extends ScrollPhysics {
  final double itemSize;

  const _SnapScrollPhysics({required this.itemSize, super.parent});

  @override
  _SnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SnapScrollPhysics(itemSize: itemSize, parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final Tolerance tolerance = this.tolerance;
    final double target = _getTargetPixels(position, tolerance, velocity);

    if (target != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        target,
        velocity,
        tolerance: tolerance,
      );
    }
    return null;
  }

  double _getTargetPixels(
      ScrollMetrics position, Tolerance tolerance, double velocity) {
    double page = position.pixels / itemSize;
    if (velocity < -tolerance.velocity) {
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    return page.roundToDouble() * itemSize;
  }

  @override
  bool get allowImplicitScrolling => false;
}

// TODO : height ruler
class HeightRuler extends StatefulWidget {
  final double initialHeight;
  final double minHeight;
  final double maxHeight;
  final bool isCm;
  final ValueChanged<double> onChanged;

  const HeightRuler({
    super.key,
    required this.initialHeight,
    required this.minHeight,
    required this.maxHeight,
    required this.isCm,
    required this.onChanged,
  });

  @override
  State<HeightRuler> createState() => _HeightRulerState();
}

class _HeightRulerState extends State<HeightRuler> {
  late ScrollController _scrollController;
  final double tickHeight = 15.0; // Pixel distance between values

  @override
  void initState() {
    super.initState();
    double offset = (widget.initialHeight - widget.minHeight) * tickHeight;
    _scrollController = ScrollController(initialScrollOffset: offset);
  }

  @override
  void didUpdateWidget(HeightRuler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialHeight != widget.initialHeight || oldWidget.isCm != widget.isCm) {
      double offset = (widget.initialHeight - widget.minHeight) * tickHeight;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(offset);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalTicks = (widget.maxHeight - widget.minHeight).round();

    return LayoutBuilder(
        builder: (context, constraints) {
          // Fix: Use exact half-height padding to ensure the selected value is in the center
          double paddingOffset = constraints.maxHeight / 2;

          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              // --- Layer 1: The Scrolling Ruler ---
              Padding(
                padding: const EdgeInsets.only(left: 40), // Move ruler away from left edge
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white,
                        Colors.white,
                        Colors.white.withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.2, 0.8, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification) {
                        double offset = _scrollController.offset;
                        double value = widget.minHeight + (offset / tickHeight);
                        value = value.clamp(widget.minHeight, widget.maxHeight);

                        if ((value - widget.initialHeight).abs() > 0.05) {
                          widget.onChanged(value);
                        }
                      }
                      return true;
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      reverse: true, // Lower numbers at bottom
                      itemExtent: tickHeight,
                      itemCount: totalTicks + 1,
                      padding: EdgeInsets.symmetric(vertical: paddingOffset),
                      physics: _SnapScrollPhysics(itemSize: tickHeight),
                      itemBuilder: (context, index) {
                        double value = widget.minHeight + index;

                        bool isMajor;
                        if (widget.isCm) {
                          isMajor = value % 10 == 0;
                        } else {
                          isMajor = value % 12 == 0;
                        }
                        bool isMedium = value % 5 == 0;

                        return Row(
                          children: [
                            Container(
                              height: isMajor ? 3 : 2,
                              width: isMajor ? 50 : (isMedium ? 35 : 20),
                              color: isMajor ? Colors.grey.shade600 : Colors.grey.shade300,
                              margin: const EdgeInsets.only(right: 10),
                            ),
                            if (isMajor)
                              Text(
                                widget.isCm
                                    ? "${value.toInt()}"
                                    : "${(value/12).round()}'",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              // --- Layer 2: Red Indicator Line ---
              Positioned(
                left: 40, // Aligned with the ruler padding
                child: Container(
                  width: 70,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF4B4B),
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF4B4B).withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}