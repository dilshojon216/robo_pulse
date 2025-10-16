import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/widgets/robot_logo.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
      ),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await _animationController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onComplete();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Robot Logo
                    const RobotLogo(
                      size: 120,
                      color: AppColors.white,
                      animated: true,
                    ),

                    const SizedBox(height: 32),

                    // App Name
                    Text(
                      'RoboPulse',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: AppColors.white,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                    ),

                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      'Advanced Robot Control System',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Loading indicator
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        backgroundColor: AppColors.white.withOpacity(0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Yuklanmoqda...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
