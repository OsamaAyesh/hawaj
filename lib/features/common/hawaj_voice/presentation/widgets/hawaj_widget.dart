import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../controller/hawaj_ai_controller.dart';

class HawajWidget extends StatefulWidget {
  final String? welcomeMessage;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool showOnInit;
  final String? section;
  final String? screen;

  const HawajWidget({
    Key? key,
    this.welcomeMessage,
    this.margin,
    this.padding,
    this.showOnInit = true,
    this.section,
    this.screen,
  }) : super(key: key);

  @override
  State<HawajWidget> createState() => _HawajWidgetState();
}

class _HawajWidgetState extends State<HawajWidget> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;
  String _wordsSpoken = '';
  double _confidence = 0;
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _updateControllerContext();
  }

  // تحديث سياق الـ Controller
  void _updateControllerContext() {
    if (widget.section != null && widget.screen != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = Get.find<HawajController>();
        controller.updateContext(
          widget.section!,
          widget.screen!,
          message: widget.welcomeMessage,
        );
      });
    }
  }

  Future<void> _initSpeech() async {
    await _ensureMicPermission();
    if (!_permissionGranted) return;

    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'notListening' && _isListening) {
          setState(() => _isListening = false);
          // إرسال النص للـ Controller عند انتهاء التحدث
          if (_wordsSpoken.isNotEmpty) {
            final controller = Get.find<HawajController>();
            controller.processVoiceInputFromWidget(_wordsSpoken, _confidence);
          }
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        print('خطأ في التعرف على الكلام: $error');
      },
    );
    setState(() {});
  }

  Future<void> _ensureMicPermission() async {
    if (_permissionGranted) return;

    final status = await Permission.microphone.status;
    if (status.isGranted) {
      _permissionGranted = true;
    } else {
      final result = await Permission.microphone.request();
      _permissionGranted = result.isGranted;
    }
  }

  Future<void> _startListening() async {
    await _ensureMicPermission();
    if (!_permissionGranted || !_speechEnabled) {
      _showPermissionDialog();
      return;
    }

    setState(() {
      _wordsSpoken = '';
      _confidence = 0;
    });

    await _speechToText.listen(
      onResult: (result) {
        setState(() {
          _wordsSpoken = result.recognizedWords;
          _confidence = result.confidence;
        });
      },
      localeId: 'ar-SA',
      listenMode: ListenMode.confirmation,
      partialResults: true,
    );

    setState(() => _isListening = true);
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  void _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('إذن مطلوب'),
        content: const Text('يحتاج التطبيق إلى إذن الميكروفون للعمل'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('الإعدادات'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // إظهار الويدجت عند التهيئة
    if (widget.showOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final controller = Get.find<HawajController>();
        controller.show(message: widget.welcomeMessage);
      });
    }

    return GetX<HawajController>(
      builder: (controller) {
        if (!controller.isVisible) return const SizedBox.shrink();

        return Container(
          margin: widget.margin ?? const EdgeInsets.all(16),
          child: controller.isExpanded
              ? _buildExpandedView(controller)
              : _buildCompactView(controller),
        );
      },
    );
  }

  // العرض المدمج (الأيقونة فقط)
  Widget _buildCompactView(HawajController controller) {
    return FloatingActionButton(
      onPressed: () => _handleCompactTap(controller),
      backgroundColor: _getButtonColor(controller),
      child: Icon(
        _getButtonIcon(controller),
        color: Colors.white,
      ),
    );
  }

  // العرض الموسع (الواجهة الكاملة)
  Widget _buildExpandedView(HawajController controller) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
        padding: widget.padding ?? const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(controller),
            const SizedBox(height: 12),
            _buildMessageArea(controller),
            if (_wordsSpoken.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildVoiceText(),
            ],
            const SizedBox(height: 12),
            _buildActionButtons(controller),
          ],
        ),
      ),
    );
  }

  // رأس الويدجت
  Widget _buildHeader(HawajController controller) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: _getButtonColor(controller),
          radius: 20,
          child: Icon(
            _getButtonIcon(controller),
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'حواج المساعد الذكي',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _getStateText(controller),
                style: TextStyle(
                  fontSize: 12,
                  color: controller.stateColor,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => controller.toggleExpansion(),
          icon: const Icon(Icons.close, size: 18),
        ),
      ],
    );
  }

  // منطقة الرسالة
  Widget _buildMessageArea(HawajController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        controller.currentMessage,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  // عرض النص المسموع
  Widget _buildVoiceText() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.format_quote, color: Colors.blue, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '"$_wordsSpoken"',
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.blue,
              ),
            ),
          ),
          if (_confidence > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _confidence >= 0.8 ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${(_confidence * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // أزرار الإجراءات
  Widget _buildActionButtons(HawajController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: _isListening ? Icons.mic_off : Icons.mic,
          color: _isListening ? Colors.red : Colors.blue,
          onPressed: () => _isListening ? _stopListening() : _startListening(),
          tooltip: _isListening ? 'إيقاف الاستماع' : 'بدء الاستماع',
        ),
        if (controller.isSpeaking)
          _buildActionButton(
            icon: Icons.stop,
            color: Colors.red,
            onPressed: controller.stopSpeaking,
            tooltip: 'إيقاف التحدث',
          ),
        _buildActionButton(
          icon: Icons.refresh,
          color: Colors.grey,
          onPressed: () => _clearAll(controller),
          tooltip: 'مسح',
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: onPressed,
        iconSize: 24,
      ),
    );
  }

  // معالجة النقر على الويدجت المدمج
  void _handleCompactTap(HawajController controller) {
    if (controller.hasError) {
      controller.clearResponse();
      _clearAll(controller);
    } else {
      controller.toggleExpansion();
    }
  }

  // مسح جميع البيانات
  void _clearAll(HawajController controller) {
    controller.clearResponse();
    setState(() {
      _wordsSpoken = '';
      _confidence = 0;
    });
  }

  // الحصول على لون الزر
  Color _getButtonColor(HawajController controller) {
    if (_isListening) return Colors.red;
    return controller.stateColor;
  }

  // الحصول على أيقونة الزر
  IconData _getButtonIcon(HawajController controller) {
    if (_isListening) return Icons.mic;
    return controller.stateIcon;
  }

  // الحصول على نص الحالة
  String _getStateText(HawajController controller) {
    if (_isListening) return 'أستمع إليك...';

    switch (controller.currentState) {
      case HawajState.processing:
        return 'أعالج طلبك...';
      case HawajState.speaking:
        return 'أتحدث معك...';
      case HawajState.error:
        return 'حدث خطأ';
      default:
        return 'جاهز للمساعدة';
    }
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }
}

// Extension للإضافة السهلة للويدجت في أي شاشة
extension HawajExtension on Widget {
  Widget withHawaj({
    String? section,
    String? screen,
    String? message,
    bool show = true,
  }) {
    return Stack(
      children: [
        this,
        Positioned(
          bottom: 20,
          right: 20,
          child: HawajWidget(
            section: section,
            screen: screen,
            welcomeMessage: message,
            showOnInit: show,
          ),
        ),
      ],
    );
  }
}
