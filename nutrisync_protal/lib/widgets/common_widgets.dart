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
                    blurRadius: 8,
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