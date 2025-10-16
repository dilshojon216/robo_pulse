// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../services/robot_service.dart';
import '../../services/settings_service.dart';
import '../../models/robot_models.dart';

class SettingsPanel extends StatefulWidget {
  final RobotService robotService;
  final SettingsService settingsService;

  const SettingsPanel({
    super.key,
    required this.robotService,
    required this.settingsService,
  });

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _robotIpController;
  late TextEditingController _cameraIpController;
  late TextEditingController _cameraPortController;
  late TextEditingController _apiKeyController;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    final config = widget.settingsService.config;
    _robotIpController = TextEditingController(text: config.robotIP);
    _cameraIpController = TextEditingController(text: config.cameraIP);
    _cameraPortController = TextEditingController(text: config.cameraPort);
    _apiKeyController = TextEditingController(text: config.apiKey);
  }

  @override
  void dispose() {
    _robotIpController.dispose();
    _cameraIpController.dispose();
    _cameraPortController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Quick Presets
        _buildPresets(),

        const SizedBox(height: AppSizes.padding),

        // Manual Configuration
        _buildManualConfig(),
      ],
    );
  }

  Widget _buildPresets() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: AppColors.primaryBlue,
                  size: AppSizes.iconMedium,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tezkor Sozlamalar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),

            const SizedBox(height: AppSizes.padding),

            ...SettingsService.getPresetConfigs().map(
              (config) => _PresetTile(
                config: config,
                onSelected: _applyPreset,
                isSelected: _isCurrentConfig(config),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualConfig() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Row(
                children: [
                  Icon(
                    Icons.settings,
                    color: AppColors.primaryBlue,
                    size: AppSizes.iconMedium,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Qo\'lda Sozlash',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.darkGray,
                  ),
                ],
              ),
            ),

            if (_isExpanded) ...[
              const SizedBox(height: AppSizes.padding),
              _buildConfigForm(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Robot IP
          TextFormField(
            controller: _robotIpController,
            decoration: const InputDecoration(
              labelText: 'Robot IP Manzili',
              hintText: '192.168.100.208',
              prefixIcon: Icon(Icons.router),
            ),
            validator: _validateIP,
          ),

          const SizedBox(height: AppSizes.padding),

          // Camera IP
          TextFormField(
            controller: _cameraIpController,
            decoration: const InputDecoration(
              labelText: 'Kamera IP Manzili',
              hintText: '192.168.100.208',
              prefixIcon: Icon(Icons.videocam),
            ),
            validator: _validateIP,
          ),

          const SizedBox(height: AppSizes.padding),

          // Camera Port
          TextFormField(
            controller: _cameraPortController,
            decoration: const InputDecoration(
              labelText: 'Kamera Port',
              hintText: '8080',
              prefixIcon: Icon(Icons.settings_ethernet),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _validatePort,
          ),

          const SizedBox(height: AppSizes.padding),

          // API Key
          TextFormField(
            controller: _apiKeyController,
            decoration: const InputDecoration(
              labelText: 'API Kaliti',
              hintText: 'robo-bridge-default-key-change-me',
              prefixIcon: Icon(Icons.key),
            ),
            validator: _validateApiKey,
          ),

          const SizedBox(height: AppSizes.paddingLarge),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveConfig,
                  icon: const Icon(Icons.save),
                  label: const Text('Saqlash'),
                ),
              ),

              const SizedBox(width: AppSizes.paddingSmall),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetConfig,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Qayta tiklash'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.signalRed,
                    side: const BorderSide(color: AppColors.signalRed),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String? _validateIP(String? value) {
    if (value == null || value.isEmpty) {
      return 'IP manzili kiriting';
    }

    final ipRegex = RegExp(r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$');
    if (!ipRegex.hasMatch(value)) {
      return 'To\'g\'ri IP manzili kiriting';
    }

    return null;
  }

  String? _validatePort(String? value) {
    if (value == null || value.isEmpty) {
      return 'Port raqamini kiriting';
    }

    final port = int.tryParse(value);
    if (port == null || port < 1 || port > 65535) {
      return 'To\'g\'ri port raqami kiriting (1-65535)';
    }

    return null;
  }

  String? _validateApiKey(String? value) {
    if (value == null || value.isEmpty) {
      return 'API kalitini kiriting';
    }

    if (value.length < 8) {
      return 'API kaliti kamida 8 ta belgidan iborat bo\'lishi kerak';
    }

    return null;
  }

  void _applyPreset(RobotConfig config) async {
    setState(() {
      _robotIpController.text = config.robotIP;
      _cameraIpController.text = config.cameraIP;
      _cameraPortController.text = config.cameraPort;
      _apiKeyController.text = config.apiKey;
    });

    await _saveConfig();
  }

  Future<void> _saveConfig() async {
    if (_formKey.currentState?.validate() ?? false) {
      final config = RobotConfig(
        robotIP: _robotIpController.text.trim(),
        cameraIP: _cameraIpController.text.trim(),
        cameraPort: _cameraPortController.text.trim(),
        apiKey: _apiKeyController.text.trim(),
      );

      try {
        // Sozlamalarni saqlash
        await widget.settingsService.saveConfig(config);

        // Robot service ni yangilash
        widget.robotService.updateConfig(config);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Sozlamalar muvaffaqiyatli saqlandi'),
              backgroundColor: AppColors.primaryBlue,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Saqlashda xato: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  void _resetConfig() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sozlamalarni qayta tiklash'),
        content: const Text(
          'Barcha sozlamalar standart holatga qaytariladi. Davom etasizmi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                await widget.settingsService.resetToDefaults();
                final config = widget.settingsService.config;

                setState(() {
                  _robotIpController.text = config.robotIP;
                  _cameraIpController.text = config.cameraIP;
                  _cameraPortController.text = config.cameraPort;
                  _apiKeyController.text = config.apiKey;
                });

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Sozlamalar standart holatga qaytarildi'),
                      backgroundColor: AppColors.primaryBlue,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Reset qilishda xato: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Qayta tiklash'),
          ),
        ],
      ),
    );
  }

  bool _isCurrentConfig(RobotConfig config) {
    final current = widget.settingsService.config;
    return current.robotIP == config.robotIP &&
        current.cameraIP == config.cameraIP &&
        current.cameraPort == config.cameraPort;
  }
}

class _PresetTile extends StatelessWidget {
  final RobotConfig config;
  final Function(RobotConfig) onSelected;
  final bool isSelected;

  const _PresetTile({
    required this.config,
    required this.onSelected,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onSelected(config),
        borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBlue.withOpacity(0.1)
                : AppColors.lightGray,
            borderRadius: BorderRadius.circular(AppSizes.borderRadius),
            border: isSelected
                ? Border.all(color: AppColors.primaryBlue, width: 2)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? AppColors.primaryBlue : AppColors.darkGray,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Robot: ${config.robotIP}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Kamera: ${config.cameraIP}:${config.cameraPort}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
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
