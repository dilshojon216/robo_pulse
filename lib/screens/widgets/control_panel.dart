// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../services/robot_service.dart';
import '../../models/robot_models.dart';

class ControlPanel extends StatefulWidget {
  final RobotService robotService;
  final bool enabled;

  const ControlPanel({
    super.key,
    required this.robotService,
    required this.enabled,
  });

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Row(
              children: [
                Icon(
                  Icons.gamepad,
                  color: AppColors.primaryBlue,
                  size: AppSizes.iconMedium,
                ),
                const SizedBox(width: 8),
                Text(
                  'Robot Boshqaruvi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),

            const SizedBox(height: AppSizes.padding),

            // Direction Pad
            _buildDirectionPad(),

            const SizedBox(height: AppSizes.padding),

            // Speed Control
            _buildSpeedControl(),

            const SizedBox(height: AppSizes.padding),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionPad() {
    const double directionButtonSize = 95.0;
    const double directionButtonGap = 1.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Direction buttons (left side)
        SizedBox(
          width: directionButtonSize * 3 + directionButtonGap * 2,
          height: directionButtonSize * 3 + directionButtonGap * 2,
          child: Stack(
            children: [
              // Forward
              Positioned(
                top: 0,
                left: directionButtonSize + directionButtonGap,
                child: _DirectionButton(
                  direction: RobotDirection.forward,
                  enabled: widget.enabled,
                  onPressed: () =>
                      widget.robotService.move(RobotDirection.forward),
                  onReleased: widget.robotService.stop,
                  size: directionButtonSize,
                ),
              ),

              // Left
              Positioned(
                top: directionButtonSize + directionButtonGap,
                left: 0,
                child: _DirectionButton(
                  direction: RobotDirection.left,
                  enabled: widget.enabled,
                  onPressed: () =>
                      widget.robotService.move(RobotDirection.left),
                  onReleased: widget.robotService.stop,
                  size: directionButtonSize,
                ),
              ),

              // Right
              Positioned(
                top: directionButtonSize + directionButtonGap,
                right: 0,
                child: _DirectionButton(
                  direction: RobotDirection.right,
                  enabled: widget.enabled,
                  onPressed: () =>
                      widget.robotService.move(RobotDirection.right),
                  onReleased: widget.robotService.stop,
                  size: directionButtonSize,
                ),
              ),

              // Backward
              Positioned(
                bottom: 0,
                left: directionButtonSize + directionButtonGap,
                child: _DirectionButton(
                  direction: RobotDirection.backward,
                  enabled: widget.enabled,
                  onPressed: () =>
                      widget.robotService.move(RobotDirection.backward),
                  onReleased: widget.robotService.stop,
                  size: directionButtonSize,
                ),
              ),
            ],
          ),
        ),

        // Action buttons (right side)
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildSpeedControl() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tezlik',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,

                fontSize: 20,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                '${widget.robotService.currentSpeed}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Slider(
          value: widget.robotService.currentSpeed.toDouble(),
          min: 0,
          max: 255,
          divisions: 17,
          onChanged: widget.enabled
              ? (value) => widget.robotService.updateSpeed(value.toInt())
              : null,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: widget.enabled ? Colors.black : Colors.grey,
              ),
            ),
            Text(
              '255',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: widget.enabled ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    const double buttonSize = 100.0;
    const double buttonGap = 25.0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row: STOP, SIGNAL, CHIROQ
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                icon: Icons.stop,
                label: 'STOP',
                color: AppColors.signalRed,
                size: buttonSize,
                enabled: widget.enabled,
                onTap: _handleStopPress,
              ),
              const SizedBox(width: buttonGap),
              _ActionButton(
                icon: Icons.volume_up,
                label: 'SIGNAL',
                color: Colors.orange,
                size: buttonSize,
                enabled: widget.enabled,
                onTap: _handleSignalPress,
              ),
              const SizedBox(width: buttonGap),
              _ActionButton(
                icon: Icons.flashlight_on,
                label: 'CHIROQ',
                color: Colors.amber,
                size: buttonSize,
                enabled: widget.enabled,
                onTap: _handleLightPress,
              ),
            ],
          ),

          const SizedBox(height: buttonGap),

          // Bottom row: BTN1, BTN2, BTN3
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionButton(
                icon: Icons.smart_toy,
                label: 'BTN1',
                color: Colors.blue,
                size: buttonSize,
                enabled: widget.enabled,
                onTap: _handleButton1Press,
              ),
              const SizedBox(width: buttonGap),
              _ActionButton(
                icon: Icons.settings,
                label: 'BTN2',
                color: Colors.green,
                size: buttonSize,
                enabled: widget.enabled,
                onTap: _handleButton2Press,
              ),
              const SizedBox(width: buttonGap),
              _ActionButton(
                icon: Icons.star,
                label: 'BTN3',
                color: Colors.purple,
                size: buttonSize,
                enabled: widget.enabled,
                onTap: _handleButton3Press,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleStopPress() {
    HapticFeedback.mediumImpact();
    widget.robotService.stop();
  }

  void _handleSignalPress() {
    HapticFeedback.lightImpact();
    widget.robotService.signal(SignalType.beep);
  }

  void _handleLightPress() {
    HapticFeedback.lightImpact();
    widget.robotService.signal(SignalType.light);
  }

  void _handleButton1Press() {
    HapticFeedback.lightImpact();
    // TODO: Add button 1 functionality
  }

  void _handleButton2Press() {
    HapticFeedback.lightImpact();
    // TODO: Add button 2 functionality
  }

  void _handleButton3Press() {
    HapticFeedback.lightImpact();
    // TODO: Add button 3 functionality
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double size;
  final bool enabled;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.size,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => _handleTapDown() : null,
      onTapUp: widget.enabled ? (_) => _handleTapUp() : null,
      onTapCancel: widget.enabled ? _handleTapUp : null,
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          gradient: widget.enabled
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isPressed
                      ? [
                          widget.color.withOpacity(0.8),
                          widget.color.withOpacity(0.6),
                        ]
                      : [widget.color, widget.color.withOpacity(0.8)],
                )
              : null,
          color: widget.enabled ? null : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
          border: _isPressed && widget.enabled
              ? Border.all(color: AppColors.white.withOpacity(0.9), width: 3)
              : Border.all(color: widget.color.withOpacity(0.3), width: 1),
          boxShadow: widget.enabled
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(_isPressed ? 0.6 : 0.4),
                    blurRadius: _isPressed ? 2 : 8,
                    offset: Offset(0, _isPressed ? 1 : 4),
                    spreadRadius: _isPressed ? 1 : 0,
                  ),
                ]
              : null,
        ),
        child: AnimatedScale(
          scale: _isPressed ? 0.90 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                transform: Matrix4.translationValues(0, _isPressed ? 2 : 0, 0),
                child: Icon(
                  widget.icon,
                  size: _isPressed ? 26 : 24,
                  color: widget.enabled
                      ? (_isPressed
                            ? AppColors.white.withOpacity(0.9)
                            : AppColors.white)
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                transform: Matrix4.translationValues(0, _isPressed ? 1 : 0, 0),
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.enabled
                        ? (_isPressed
                              ? AppColors.white.withOpacity(0.9)
                              : AppColors.white)
                        : Colors.grey[600],
                    fontSize: _isPressed ? 9 : 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: _isPressed ? 0.5 : 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTapDown() {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp() {
    setState(() {
      _isPressed = false;
    });
  }
}

class _DirectionButton extends StatefulWidget {
  final RobotDirection direction;
  final bool enabled;
  final VoidCallback onPressed;
  final VoidCallback onReleased;
  final double? size;

  const _DirectionButton({
    required this.direction,
    required this.enabled,
    required this.onPressed,
    required this.onReleased,
    this.size,
  });

  @override
  State<_DirectionButton> createState() => _DirectionButtonState();
}

class _DirectionButtonState extends State<_DirectionButton> {
  bool _isPressed = false;
  Timer? _continuousTimer;

  @override
  void dispose() {
    _stopContinuous();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => _handleTapDown() : null,
      onTapUp: widget.enabled ? (_) => _handleTapUp() : null,
      onTapCancel: widget.enabled ? _handleTapUp : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: widget.size ?? AppSizes.controlButtonSize,
        height: widget.size ?? AppSizes.controlButtonSize,
        decoration: BoxDecoration(
          gradient: widget.enabled
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _isPressed
                      ? [
                          AppColors.primaryBlue.withOpacity(0.85),
                          AppColors.primaryBlue.withOpacity(0.65),
                        ]
                      : [
                          AppColors.primaryBlue,
                          AppColors.primaryBlue.withOpacity(0.8),
                        ],
                )
              : null,
          color: widget.enabled ? null : Colors.grey[300],
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
          border: _isPressed && widget.enabled
              ? Border.all(color: AppColors.white.withOpacity(0.9), width: 3)
              : Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.3),
                  width: 1,
                ),
          boxShadow: widget.enabled
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(
                      _isPressed ? 0.7 : 0.4,
                    ),
                    blurRadius: _isPressed ? 3 : 8,
                    offset: Offset(0, _isPressed ? 1 : 4),
                    spreadRadius: _isPressed ? 2 : 0,
                  ),
                ]
              : null,
        ),
        child: AnimatedScale(
          scale: _isPressed ? 0.88 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            transform: Matrix4.translationValues(0, _isPressed ? 3 : 0, 0),
            child: Icon(
              widget.direction.icon,
              size:
                  ((widget.size != null)
                      ? widget.size! * 0.4
                      : AppSizes.iconLarge) *
                  (_isPressed ? 1.1 : 1.0),
              color: widget.enabled
                  ? (_isPressed
                        ? AppColors.white.withOpacity(0.95)
                        : AppColors.white)
                  : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTapDown() {
    if (!mounted) return;

    setState(() {
      _isPressed = true;
    });

    HapticFeedback.lightImpact();

    // Darhol birinchi commandani jo'natamiz
    widget.onPressed();

    // Continuous sending uchun timer boshlash
    _startContinuous();
  }

  void _handleTapUp() {
    if (!mounted) return;

    setState(() {
      _isPressed = false;
    });

    _stopContinuous();
    widget.onReleased();
  }

  void _startContinuous() {
    _continuousTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (mounted && _isPressed) {
        widget.onPressed();
      }
    });
  }

  void _stopContinuous() {
    _continuousTimer?.cancel();
    _continuousTimer = null;
  }
}
