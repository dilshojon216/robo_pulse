import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../theme/app_theme.dart';

class CameraView extends StatefulWidget {
  final String streamUrl;
  final bool isConnected;

  const CameraView({
    super.key,
    required this.streamUrl,
    required this.isConnected,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  // Getter to access controller from parent widget
  WebViewController get controller => _controller;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    if (widget.isConnected) {
      _loadCameraStream();
    }
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _hasError = true;
              });
            }
          },
        ),
      );
  }

  @override
  void didUpdateWidget(CameraView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isConnected != oldWidget.isConnected && widget.isConnected) {
      _loadCameraStream();
    }
  }

  void _loadCameraStream() {
    if (!widget.isConnected) return;

    final videoUrl = widget.streamUrl.replaceAll('/shot.jpg', '/video');

    final String htmlContent =
        '''
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            margin: 0;
            padding: 0;
            background-color: black;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
        }
        #stream {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }
        .live-badge {
            position: absolute;
            top: 12px;
            right: 12px;
            background-color: #ff0000;
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            z-index: 10;
        }
        .dot {
            display: inline-block;
            width: 8px;
            height: 8px;
            background-color: white;
            border-radius: 50%;
            margin-right: 6px;
            animation: pulse 1s infinite;
        }
        @keyframes pulse {
            0%, 50% { opacity: 1; }
            51%, 100% { opacity: 0.3; }
        }
    </style>
</head>
<body>
    <div class="live-badge">
        <span class="dot"></span>LIVE
    </div>
    <img id="stream" src="$videoUrl" alt="Live Camera Stream" />
</body>
</html>
    ''';

    _controller.loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.black),
        child: widget.isConnected ? _buildStream() : _buildNoConnection(),
      ),
    );
  }

  Widget _buildStream() {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primaryBlue,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Live stream yuklanmoqda...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        if (_hasError) _buildError(),
      ],
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_off, size: 64, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            'Live stream xatolik',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[400]),
          ),
          const SizedBox(height: 8),
          Text(
            'IPWebcam tekshiring',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _hasError = false;
                _isLoading = true;
              });
              _loadCameraStream();
            },
            child: const Text('Qayta urinish'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoConnection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 64, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            'Robot bilan aloqa yo\'q',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[400]),
          ),
          const SizedBox(height: 8),
          Text(
            'Robotga ulaning',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

class FullScreenCameraView extends StatelessWidget {
  final String streamUrl;

  const FullScreenCameraView({super.key, required this.streamUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Live Stream', style: TextStyle(color: Colors.white)),
      ),
      body: CameraView(streamUrl: streamUrl, isConnected: true),
    );
  }
}
