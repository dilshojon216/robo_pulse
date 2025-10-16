import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../theme/app_theme.dart';

class CameraControlPanel extends StatelessWidget {
  final String streamUrl;
  final bool isConnected;

  const CameraControlPanel({
    super.key,
    required this.streamUrl,
    required this.isConnected,
  });

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
                  Icons.camera_alt,
                  color: AppColors.primaryBlue,
                  size: AppSizes.iconMedium,
                ),
                const SizedBox(width: 8),
                Text(
                  'Kamera Boshqaruvi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),

            const SizedBox(height: AppSizes.padding),

            // Camera Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Take Photo
                _CameraControlButton(
                  icon: Icons.camera_alt,
                  label: 'Rasm Olish',
                  color: AppColors.primaryBlue,
                  onPressed: () => _takePhoto(context),
                  size: 70.0,
                ),

                // Zoom Out
                _CameraControlButton(
                  icon: Icons.zoom_out,
                  label: 'Zoom -',
                  color: Colors.orange,
                  onPressed: () => _zoomOut(context),
                ),

                // Zoom In
                _CameraControlButton(
                  icon: Icons.zoom_in,
                  label: 'Zoom +',
                  color: Colors.green,
                  onPressed: () => _zoomIn(context),
                ),

                // Orientation
                _CameraControlButton(
                  icon: Icons.screen_rotation,
                  label: 'Aylantirish',
                  color: Colors.purple,
                  onPressed: () => _toggleOrientation(context),
                ),

                // Settings
                _CameraControlButton(
                  icon: Icons.tune,
                  label: 'Sozlamalar',
                  color: Colors.amber,
                  onPressed: () => _openCameraSettings(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _takePhoto(BuildContext context) async {
    if (!isConnected) return;

    try {
      await _sendCameraCommand('/photo.jpg');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📸 Rasm olindi!'),
            duration: Duration(seconds: 2),
            backgroundColor: AppColors.primaryBlue,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Xatolik: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _zoomOut(BuildContext context) async {
    try {
      await _sendCameraCommand('/settings/zoom?set=-1');
      _showSnackBar(context, '🔍 Zoom kamaytirildi');
    } catch (e) {
      _showErrorSnackBar(context, e.toString());
    }
  }

  void _zoomIn(BuildContext context) async {
    try {
      await _sendCameraCommand('/settings/zoom?set=1');
      _showSnackBar(context, '🔍 Zoom oshirildi');
    } catch (e) {
      _showErrorSnackBar(context, e.toString());
    }
  }

  void _toggleOrientation(BuildContext context) async {
    try {
      await _sendCameraCommand('/settings/orientation?set=toggle');
      _showSnackBar(context, '🔄 Orientatsiya o\'zgartirildi');
    } catch (e) {
      _showErrorSnackBar(context, e.toString());
    }
  }

  void _openCameraSettings(BuildContext context) async {
    try {
      await _sendCameraCommand('/settings/preview_size?set=640x480');
      _showSnackBar(context, '⚙️ Kamera sozlamalari yangilandi');
    } catch (e) {
      _showErrorSnackBar(context, e.toString());
    }
  }

  Future<void> _sendCameraCommand(String command) async {
    if (!isConnected) return;

    final baseUrl = streamUrl.replaceAll('/shot.jpg', '');
    final commandUrl = '$baseUrl$command';

    final response = await http.get(Uri.parse(commandUrl));
    if (response.statusCode != 200) {
      throw Exception('Kamera komandasi bajarilmadi: ${response.statusCode}');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.primaryBlue,
        ),
      );
    }
  }

  void _showErrorSnackBar(BuildContext context, String error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Xatolik: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _CameraControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final double size;

  const _CameraControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.size = 55.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: size == 70.0 ? 28 : 20, color: AppColors.white),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.white,
                fontSize: size == 70.0 ? 10 : 8,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
