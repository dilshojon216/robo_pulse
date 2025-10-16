// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/robot_service.dart';
import '../services/settings_service.dart';
import 'widgets/robot_logo.dart';
import 'widgets/status_bar.dart';
import 'widgets/control_panel.dart';
import 'widgets/camera_view.dart';
import 'widgets/camera_control_panel.dart';
import 'widgets/settings_panel.dart';
import 'widgets/logs_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<RobotService, SettingsService>(
      builder: (context, robotService, settingsService, child) {
        return Scaffold(
          appBar: _buildAppBar(robotService),
          body: Column(
            children: [
              // Status Bar
              Container(
                color: AppColors.white,
                child: StatusBar(status: robotService.status),
              ),

              // Main Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Control & Camera Tab (Combined)
                    _buildControlAndCameraTab(robotService),

                    // Settings Tab
                    _buildSettingsTab(robotService, settingsService),
                  ],
                ),
              ),
            ],
          ),

          // Bottom Navigation
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowColor,
                  offset: Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primaryBlue,
              indicatorWeight: 3,
              labelColor: AppColors.primaryBlue,
              unselectedLabelColor: AppColors.darkGray,
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              tabs: const [
                Tab(icon: Icon(Icons.smart_toy_rounded), text: 'Boshqaruv'),
                Tab(icon: Icon(Icons.settings_rounded), text: 'Sozlamalar'),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(RobotService robotService) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
          ),
        ),
      ),
      title: Row(
        children: [
          const RobotLogo(size: 32, color: AppColors.white),
          const SizedBox(width: 12),
          Text(
            'RoboPulse',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        // Connection status indicator
        Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: robotService.isConnected
                ? Colors.green.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: robotService.isConnected ? Colors.green : Colors.red,
              width: 1,
            ),
          ),
          child: Text(
            robotService.isConnected ? 'Ulandi' : 'Uzilgan',
            style: TextStyle(
              color: robotService.isConnected ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Connection button
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: robotService.isConnected
              ? IconButton(
                  icon: const Icon(Icons.link_off, color: AppColors.white),
                  onPressed: () => robotService.disconnect(),
                  tooltip: 'Ulanishni uzish',
                )
              : IconButton(
                  icon: const Icon(Icons.link, color: AppColors.white),
                  onPressed: () => robotService.connect(),
                  tooltip: 'Ulash',
                ),
        ),
      ],
    );
  }

  Widget _buildControlAndCameraTab(RobotService robotService) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        children: [
          // Camera View (Top section)
          Card(
            elevation: 8,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.grey[900]!, Colors.black],
                ),
              ),
              child: Stack(
                children: [
                  // Main camera view
                  CameraView(
                    streamUrl: robotService.cameraStreamUrl,
                    isConnected: robotService.isConnected,
                  ),

                  // Camera overlay info
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSizes.padding),

          // Control Panel (Bottom section)
          ControlPanel(
            robotService: robotService,
            enabled: robotService.isConnected,
          ),

          const SizedBox(height: AppSizes.padding),

          // // Camera Control Panel
          // CameraControlPanel(
          //   streamUrl: robotService.cameraStreamUrl,
          //   isConnected: robotService.isConnected,
          // ),
          const SizedBox(height: AppSizes.padding),

          // Camera Controls Row
          // Card(
          //   child: Padding(
          //     padding: const EdgeInsets.all(AppSizes.padding),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         Expanded(
          //           child: ElevatedButton.icon(
          //             onPressed: robotService.isConnected
          //                 ? () => robotService.signal(SignalType.light)
          //                 : null,
          //             icon: const Icon(Icons.flashlight_on),
          //             label: const Text('Chiroq'),
          //             style: ElevatedButton.styleFrom(
          //               backgroundColor: Colors.amber,
          //               foregroundColor: Colors.white,
          //             ),
          //           ),
          //         ),

          //         const SizedBox(width: 12),

          //         Expanded(
          //           child: ElevatedButton.icon(
          //             onPressed: robotService.isConnected
          //                 ? () => robotService.signal(SignalType.beep)
          //                 : null,
          //             icon: const Icon(Icons.volume_up),
          //             label: const Text('Signal'),
          //             style: ElevatedButton.styleFrom(
          //               backgroundColor: Colors.orange,
          //               foregroundColor: Colors.white,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(height: AppSizes.padding),

          // Logs Panel
          LogsPanel(logs: robotService.logs),
        ],
      ),
    );
  }

  Widget _buildSettingsTab(
    RobotService robotService,
    SettingsService settingsService,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Column(
        children: [
          // Settings Panel
          SettingsPanel(
            robotService: robotService,
            settingsService: settingsService,
          ),

          const SizedBox(height: AppSizes.padding),

          // Info Card
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryBlue.withOpacity(0.05),
                    AppColors.white,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with icon
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primaryBlue,
                          size: AppSizes.iconLarge,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Dastur Haqida',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlueDark,
                              ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSizes.paddingLarge),

                    // App name and description
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryBlue.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🤖 RoboPulse',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlueDark,
                                  fontSize: 24,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Advanced Robot Control System',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.primaryBlue,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSizes.padding),

                    // Features list
                    Text(
                      '⚡ Asosiy Imkoniyatlar:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _buildFeatureItem(
                      '🔗',
                      'Real-time WebSocket orqali robot boshqaruvi',
                    ),
                    _buildFeatureItem(
                      '📹',
                      'Live kamera stream va video ko\'rish',
                    ),
                    _buildFeatureItem(
                      '🎮',
                      'Intuitiv joystick boshqaruv paneli',
                    ),
                    _buildFeatureItem(
                      '📸',
                      'Kamera boshqaruvi: rasm olish, zoom, aylantirish',
                    ),
                    _buildFeatureItem(
                      '🚨',
                      'Chiroq va ovozli signal boshqaruvi',
                    ),
                    _buildFeatureItem(
                      '⚙️',
                      'Moslashuvchan sozlamalar va presetlar',
                    ),
                    _buildFeatureItem(
                      '📊',
                      'Real-time holat monitoring va loglar',
                    ),

                    const SizedBox(height: AppSizes.paddingLarge),

                    // Technical info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🔧 Texnik Ma\'lumotlar:',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGray,
                                ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow('📱', 'Platform', 'Flutter 3.35.6'),
                          _buildInfoRow('🌐', 'Protokol', 'WebSocket + HTTP'),
                          _buildInfoRow(
                            '📷',
                            'Kamera',
                            'IPWebcam MJPEG Stream',
                          ),
                          _buildInfoRow('🔧', 'Version', '1.0.0'),
                          _buildInfoRow('👨‍💻', 'Developer', 'RoboPulse Team'),
                          _buildInfoRow('📅', 'Sana', '2025'),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSizes.padding),

                    // Copyright
                    Center(
                      child: Text(
                        '© 2025 RoboPulse. Barcha huquqlar himoyalangan.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for feature items
  Widget _buildFeatureItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for info rows
  Widget _buildInfoRow(String icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primaryBlueDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
