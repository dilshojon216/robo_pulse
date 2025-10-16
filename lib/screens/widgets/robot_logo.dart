import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class RobotLogo extends StatefulWidget {
  final double size;
  final Color? color;
  final bool animated;

  const RobotLogo({
    super.key,
    this.size = 48,
    this.color,
    this.animated = true,
  });

  @override
  State<RobotLogo> createState() => _RobotLogoState();
}

class _RobotLogoState extends State<RobotLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.animated) {
      _animationController = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this,
      );

      // Pulse animation (scaling effect)
      _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

      // Subtle rotation animation
      _rotationAnimation = Tween<double>(begin: 0, end: 0.02).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      );

      _animationController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    if (widget.animated) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget logo = _buildLogo();

    if (widget.animated) {
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: logo,
            ),
          );
        },
      );
    }

    return logo;
  }

  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect background
        if (widget.animated)
          Container(
            width: widget.size * 1.2,
            height: widget.size * 1.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (widget.color ?? AppColors.primaryBlue).withOpacity(0.3),
                  (widget.color ?? AppColors.primaryBlue).withOpacity(0.1),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),

        // Main logo image
        Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (widget.color ?? AppColors.primaryBlue).withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.size / 2),
            child: Image.asset(
              'assets/images/image-removebg-preview.png',
              width: widget.size,
              height: widget.size,
              fit: BoxFit.cover,
              color: widget.color,
              colorBlendMode: widget.color != null ? BlendMode.srcIn : null,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to a modern robot icon if image fails to load
                return Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.color ?? AppColors.primaryBlue,
                        (widget.color ?? AppColors.primaryBlue).withOpacity(
                          0.8,
                        ),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.smart_toy_outlined,
                    size: widget.size * 0.6,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),

        // Pulse ring effect (only if animated)
        if (widget.animated)
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Container(
                width: widget.size * (1.0 + _pulseAnimation.value * 0.3),
                height: widget.size * (1.0 + _pulseAnimation.value * 0.3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: (widget.color ?? AppColors.primaryBlue).withOpacity(
                      0.6 - _pulseAnimation.value * 0.3,
                    ),
                    width: 2,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
