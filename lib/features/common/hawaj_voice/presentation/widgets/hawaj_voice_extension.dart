import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/hawaj_ai_controller.dart';
import 'elite_floating_voice_assistant.dart';

/// Extension سهل للاستخدام مع أي Widget
extension HawajVoiceExtension on Widget {
  /// الطريقة الأسهل - سطر واحد فقط!
  Widget withHawajVoice({
    String? welcomeMessage,
    double? left,
    double? bottom,
    double? right,
    double? top,
    bool autoShow = true,
  }) {
    return _HawajWrapper(
      child: this,
      welcomeMessage: welcomeMessage,
      left: left,
      bottom: bottom,
      right: right,
      top: top,
      autoShow: autoShow,
    );
  }

  /// استخدام متقدم مع إعدادات إضافية
  Widget withHawajVoiceAdvanced({
    String? section,
    String? screen,
    String? welcomeMessage,
    double? x,
    double? y,
    bool autoShow = true,
    bool expandOnShow = false,
  }) {
    return _HawajAdvancedWrapper(
      child: this,
      section: section,
      screen: screen,
      welcomeMessage: welcomeMessage,
      x: x,
      y: y,
      autoShow: autoShow,
      expandOnShow: expandOnShow,
    );
  }

  /// استخدام ذكي - يتكيف مع السياق تلقائياً
  Widget withHawajVoiceSmart({
    String? customMessage,
    bool autoExpand = false,
  }) {
    return _HawajSmartWrapper(
      child: this,
      customMessage: customMessage,
      autoExpand: autoExpand,
    );
  }
}

// ==================== Helper Classes ====================

/// Helper رئيسي للتحكم في المساعد الصوتي
class HawajVoiceHelper {
  static HawajAIController? _getController() {
    try {
      return Get.find<HawajAIController>();
    } catch (e) {
      print('HawajAIController not found. Make sure it\'s registered in DI.');
      return null;
    }
  }

  // ==================== Basic Controls ====================

  /// إظهار المساعد الصوتي
  static void show({String? message}) {
    final controller = _getController();
    controller?.show();
    if (message != null) {
      controller?.setMessage(message);
    }
  }

  /// إخفاء المساعد الصوتي
  static void hide() => _getController()?.hide();

  /// تبديل الرؤية
  static void toggleVisibility() => _getController()?.toggleExpansion();

  /// توسيع الواجهة
  static void expand() => _getController()?.expand();

  /// طي الواجهة
  static void collapse() => _getController()?.collapse();

  // ==================== Voice Controls ====================

  /// بدء الاستماع
  static Future<void> startListening() async {
    await _getController()?.startListening();
  }

  /// إيقاف الاستماع
  static Future<void> stopListening() async {
    await _getController()?.stopListening();
  }

  /// تبديل حالة الاستماع
  static void toggleListening() => _getController()?.toggleListening();

  /// نطق نص
  static Future<void> speak(String text) async {
    await _getController()?.speak(text);
  }

  /// إيقاف النطق
  static Future<void> stopSpeaking() async {
    await _getController()?.stopSpeaking();
  }

  // ==================== Context Management ====================

  /// تحديث السياق (القسم والشاشة)
  static void updateContext(String section, String screen, {String? message}) {
    _getController()?.updateContext(section, screen, message: message);
  }

  /// تعيين رسالة مخصصة
  static void setMessage(String message) {
    _getController()?.setMessage(message);
  }

  /// مسح الاستجابة الحالية
  static void clearResponse() => _getController()?.clearResponse();

  /// إعادة تعيين الإحصائيات
  static void resetStats() => _getController()?.resetStats();

  // ==================== Getters ====================

  /// هل المساعد مرئي؟
  static bool get isVisible => _getController()?.isVisible ?? false;

  /// هل يستمع؟
  static bool get isListening => _getController()?.isListening ?? false;

  /// هل يتحدث؟
  static bool get isSpeaking => _getController()?.isSpeaking ?? false;

  /// هل يعالج؟
  static bool get isProcessing => _getController()?.isProcessing ?? false;

  /// الرسالة الحالية
  static String get currentMessage => _getController()?.currentMessage ?? '';

  /// النص المسموع
  static String get voiceText => _getController()?.voiceText ?? '';

  /// عدد المحادثات
  static int get conversationCount => _getController()?.conversationCount ?? 0;

  /// وقت الاستجابة
  static int get responseTime => _getController()?.responseTime ?? 0;

  /// مستوى الثقة
  static double get confidenceLevel => _getController()?.confidenceLevel ?? 0.0;

  // ==================== Quick Actions ====================

  /// إجراء سريع: تشغيل المساعد مع رسالة
  static void quickStart(String message) {
    show(message: message);
    expand();
  }

  /// إجراء سريع: استماع فوري
  static Future<void> quickListen() async {
    show();
    await Future.delayed(const Duration(milliseconds: 300));
    await startListening();
  }

  /// إجراء سريع: رسالة ونطق
  static Future<void> quickSpeak(String message) async {
    setMessage(message);
    show();
    await speak(message);
  }

  /// إخفاء تلقائي
  static void autoHide({Duration delay = const Duration(seconds: 10)}) {
    _getController()?.autoHide(delay: delay);
  }
}

/// Manager متقدم لإدارة النظام كاملاً
class HawajVoiceManager {
  static bool _isInitialized = false;

  /// تهيئة النظام (يتم استدعاؤها تلقائياً)
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // التأكد من وجود Controller
      if (!Get.isRegistered<HawajAIController>()) {
        print('HawajAIController not registered. Please add it to your DI.');
        return;
      }

      final controller = Get.find<HawajAIController>();
      await controller.initialize();

      _isInitialized = true;
      print('Hawaj Voice System initialized successfully');
    } catch (e) {
      print('Failed to initialize Hawaj Voice System: $e');
    }
  }

  /// إعداد سريع للشاشة
  static Widget setupForScreen({
    required Widget child,
    required String section,
    required String screen,
    String? welcomeMessage,
    bool autoShow = true,
    bool expandOnShow = false,
  }) {
    return _HawajScreenWrapper(
      child: child,
      section: section,
      screen: screen,
      welcomeMessage: welcomeMessage,
      autoShow: autoShow,
      expandOnShow: expandOnShow,
    );
  }

  /// تنظيف الموارد
  static void dispose() {
    try {
      if (Get.isRegistered<HawajAIController>()) {
        Get.delete<HawajAIController>();
      }
      _isInitialized = false;
      print('Hawaj Voice System disposed');
    } catch (e) {
      print('Error disposing Hawaj Voice System: $e');
    }
  }

  /// فحص صحة النظام
  static bool get isHealthy {
    return _isInitialized &&
        Get.isRegistered<HawajAIController>() &&
        Get.find<HawajAIController>().isInitialized;
  }

  /// معلومات النظام للتشخيص
  static Map<String, dynamic> get systemInfo {
    try {
      final controller = Get.find<HawajAIController>();
      return {
        'initialized': _isInitialized,
        'controller_registered': Get.isRegistered<HawajAIController>(),
        'controller_initialized': controller.isInitialized,
        'permission_granted': controller.permissionGranted,
        'current_state': controller.currentState.toString(),
        'conversation_count': controller.conversationCount,
        'is_visible': controller.isVisible,
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}

// ==================== Wrapper Widgets ====================

class _HawajWrapper extends StatelessWidget {
  final Widget child;
  final String? welcomeMessage;
  final double? left, bottom, right, top;
  final bool autoShow;

  const _HawajWrapper({
    required this.child,
    this.welcomeMessage,
    this.left,
    this.bottom,
    this.right,
    this.top,
    this.autoShow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        HawajFloatingAssistant(
          initialMessage: welcomeMessage,
          left: left,
          bottom: bottom,
          right: right,
          top: top,
          autoShow: autoShow,
        ),
      ],
    );
  }
}

class _HawajAdvancedWrapper extends StatelessWidget {
  final Widget child;
  final String? section, screen, welcomeMessage;
  final double? x, y;
  final bool autoShow, expandOnShow;

  const _HawajAdvancedWrapper({
    required this.child,
    this.section,
    this.screen,
    this.welcomeMessage,
    this.x,
    this.y,
    this.autoShow = true,
    this.expandOnShow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Builder(
          builder: (context) {
            // تحديث السياق عند البناء
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _setupContext();
            });

            return HawajFloatingAssistant(
              initialMessage: welcomeMessage,
              left: x,
              top: y,
              autoShow: autoShow,
            );
          },
        ),
      ],
    );
  }

  void _setupContext() async {
    await HawajVoiceManager.initialize();

    if (section != null && screen != null) {
      HawajVoiceHelper.updateContext(section!, screen!,
          message: welcomeMessage);
    }

    if (expandOnShow && autoShow) {
      await Future.delayed(const Duration(milliseconds: 500));
      HawajVoiceHelper.expand();
    }
  }
}

class _HawajSmartWrapper extends StatelessWidget {
  final Widget child;
  final String? customMessage;
  final bool autoExpand;

  const _HawajSmartWrapper({
    required this.child,
    this.customMessage,
    this.autoExpand = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _setupSmart();
            });

            return HawajFloatingAssistant(
              initialMessage: customMessage ?? _generateSmartMessage(),
              autoShow: true,
            );
          },
        ),
      ],
    );
  }

  void _setupSmart() async {
    await HawajVoiceManager.initialize();

    if (autoExpand) {
      await Future.delayed(const Duration(milliseconds: 800));
      HawajVoiceHelper.expand();
    }
  }

  String _generateSmartMessage() {
    final currentRoute = Get.currentRoute;

    if (currentRoute.contains('home') || currentRoute.contains('main')) {
      return 'مرحباً! كيف يمكنني مساعدتك اليوم؟';
    } else if (currentRoute.contains('product')) {
      return 'أهلاً بك في صفحة المنتجات! اسألني عن أي منتج';
    } else if (currentRoute.contains('profile')) {
      return 'مرحباً بك في ملفك الشخصي! كيف يمكنني مساعدتك؟';
    } else if (currentRoute.contains('settings')) {
      return 'أهلاً بك في الإعدادات! اسألني عن أي إعداد';
    } else {
      return 'مساعدك الذكي جاهز لخدمتك!';
    }
  }
}

class _HawajScreenWrapper extends StatelessWidget {
  final Widget child;
  final String section, screen;
  final String? welcomeMessage;
  final bool autoShow, expandOnShow;

  const _HawajScreenWrapper({
    required this.child,
    required this.section,
    required this.screen,
    this.welcomeMessage,
    this.autoShow = true,
    this.expandOnShow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _setupScreen();
            });

            return HawajFloatingAssistant(
              initialMessage: welcomeMessage ?? 'مرحباً بك في القسم $section',
              autoShow: autoShow,
            );
          },
        ),
      ],
    );
  }

  void _setupScreen() async {
    await HawajVoiceManager.initialize();

    HawajVoiceHelper.updateContext(section, screen, message: welcomeMessage);

    if (expandOnShow) {
      await Future.delayed(const Duration(milliseconds: 600));
      HawajVoiceHelper.expand();
    }
  }
}

// ==================== Quick Actions ====================

/// إجراءات سريعة للاستخدام المباشر
class HawajQuickActions {
  /// ترحيب سريع
  static Future<void> welcome([String? customMessage]) async {
    await HawajVoiceHelper.quickSpeak(
        customMessage ?? 'أهلاً وسهلاً بك! كيف يمكنني مساعدتك؟');
  }

  /// استماع سريع مع رسالة
  static Future<void> listenWithPrompt(String prompt) async {
    HawajVoiceHelper.setMessage(prompt);
    HawajVoiceHelper.show();
    HawajVoiceHelper.expand();
    await Future.delayed(const Duration(milliseconds: 500));
    await HawajVoiceHelper.startListening();
  }

  /// إعلان سريع
  static Future<void> announce(String message) async {
    HawajVoiceHelper.show();
    await HawajVoiceHelper.speak(message);
    HawajVoiceHelper.autoHide();
  }

  /// تنبيه تفاعلي
  static void interactiveAlert(String message, {VoidCallback? onTap}) {
    HawajVoiceHelper.setMessage(message);
    HawajVoiceHelper.show();
    HawajVoiceHelper.expand();
    // يمكن إضافة callback للتفاعل
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../controller/hawaj_ai_controller.dart';
// import 'elite_floating_voice_assistant.dart';
//
// // Extension for easy integration with any Widget
// extension HawajVoiceExtension on Widget {
//   /// Add Hawaj Voice Assistant with default settings
//   Widget withHawajVoice({
//     double? bottom,
//     double? top,
//     double? left,
//     double? right,
//     bool autoShow = true,
//     String? initialMessage,
//   }) {
//     return Stack(
//       children: [
//         this,
//         Positioned(
//           bottom: bottom,
//           top: top,
//           left: left ?? 20,
//           right: right,
//           child: EliteFloatingVoiceAssistant(
//             autoShow: autoShow,
//             initialMessage: initialMessage,
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Add Hawaj Voice Assistant with advanced settings
//   Widget withHawajVoiceAdvanced({
//     String? section,
//     String? screen,
//     String? initialMessage,
//     double? x,
//     double? y,
//     bool autoShow = true,
//     VoidCallback? onDragEnd,
//   }) {
//     return Stack(
//       children: [
//         this,
//         Builder(
//           builder: (context) {
//             // Update controller context when widget builds
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               try {
//                 final controller = Get.find<HawajAIController>();
//                 if (section != null && screen != null) {
//                   controller.updateContext(section, screen,
//                       message: initialMessage);
//                 }
//               } catch (e) {
//                 // Controller not found, will be handled by the assistant widget
//               }
//             });
//
//             return EliteFloatingVoiceAssistant(
//               initialX: x,
//               initialY: y,
//               autoShow: autoShow,
//               initialMessage: initialMessage,
//               onDragEnd: onDragEnd,
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   /// Add Hawaj Voice Assistant as overlay
//   Widget withHawajVoiceOverlay({
//     String? section,
//     String? screen,
//     String? initialMessage,
//     bool autoShow = true,
//   }) {
//     return Scaffold(
//       body: this,
//       floatingActionButton: EliteFloatingVoiceAssistant(
//         autoShow: autoShow,
//         initialMessage: initialMessage,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
//     );
//   }
// }
//
// // Helper class for controlling Hawaj Voice Assistant
// class HawajVoiceHelper {
//   static HawajAIController? _getController() {
//     try {
//       return Get.find<HawajAIController>();
//     } catch (e) {
//       print('HawajAIController not found. Make sure it\'s registered in DI.');
//       return null;
//     }
//   }
//
//   /// Show the voice assistant
//   static void show() {
//     _getController()?.show();
//   }
//
//   /// Hide the voice assistant
//   static void hide() {
//     _getController()?.hide();
//   }
//
//   /// Toggle visibility
//   static void toggleVisibility() {
//     _getController()?.toggleVisibility();
//   }
//
//   /// Expand the assistant interface
//   static void expand() {
//     final controller = _getController();
//     controller?.show();
//     controller?.expand();
//   }
//
//   /// Collapse the assistant interface
//   static void collapse() {
//     _getController()?.collapse();
//   }
//
//   /// Start listening for voice input
//   static Future<void> startListening() async {
//     await _getController()?.startListening();
//   }
//
//   /// Stop listening for voice input
//   static Future<void> stopListening() async {
//     await _getController()?.stopListening();
//   }
//
//   /// Toggle listening state
//   static void toggleListening() {
//     _getController()?.toggleListening();
//   }
//
//   /// Speak a message
//   static Future<void> speak(String text) async {
//     await _getController()?.speak(text);
//   }
//
//   /// Stop speaking
//   static Future<void> stopSpeaking() async {
//     await _getController()?.stopSpeaking();
//   }
//
//   /// Update the current section and screen context
//   static void updateContext(String section, String screen, {String? message}) {
//     _getController()?.updateContext(section, screen, message: message);
//   }
//
//   /// Set a custom message
//   static void setMessage(String message) {
//     _getController()?.setMessage(message);
//   }
//
//   /// Clear the current response and reset
//   static void clearResponse() {
//     _getController()?.clearResponse();
//   }
//
//   /// Update the assistant position
//   static void updatePosition(double x, double y) {
//     _getController()?.updatePosition(x, y);
//   }
//
//   /// Get current state
//   static AssistantState? getCurrentState() {
//     return _getController()?.currentState;
//   }
//
//   /// Check if assistant is visible
//   static bool get isVisible {
//     return _getController()?.isVisible ?? false;
//   }
//
//   /// Check if assistant is listening
//   static bool get isListening {
//     return _getController()?.isListening ?? false;
//   }
//
//   /// Check if assistant is speaking
//   static bool get isSpeaking {
//     return _getController()?.isSpeaking ?? false;
//   }
//
//   /// Get current message
//   static String get currentMessage {
//     return _getController()?.currentMessage ?? '';
//   }
//
//   /// Get voice text
//   static String get voiceText {
//     return _getController()?.voiceText ?? '';
//   }
//
//   /// Get conversation count
//   static int get conversationCount {
//     return _getController()?.conversationCount ?? 0;
//   }
//
//   /// Get response time
//   static int get responseTime {
//     return _getController()?.responseTime ?? 0;
//   }
//
//   /// Reset all stats
//   static void resetStats() {
//     _getController()?.resetStats();
//   }
// }
//
// // Utility class for managing Hawaj Voice Assistant globally
// class HawajVoiceManager {
//   static HawajAIController? _controller;
//   static bool _isInitialized = false;
//
//   /// Initialize the Hawaj Voice system
//   static Future<void> initialize() async {
//     if (_isInitialized) return;
//
//     try {
//       // Register controller if not already registered
//       if (!Get.isRegistered<HawajAIController>()) {
//         Get.put(HawajAIController(), permanent: true);
//       }
//
//       _controller = Get.find<HawajAIController>();
//       _isInitialized = true;
//
//       print('✅ Hawaj Voice Assistant initialized successfully');
//     } catch (e) {
//       print('❌ Failed to initialize Hawaj Voice Assistant: $e');
//     }
//   }
//
//   /// Quick setup for common use cases
//   static Widget setupForScreen({
//     required Widget child,
//     required String section,
//     required String screen,
//     String? welcomeMessage,
//     bool autoShow = true,
//   }) {
//     return Builder(
//       builder: (context) {
//         // Initialize on first build
//         WidgetsBinding.instance.addPostFrameCallback((_) async {
//           await initialize();
//           HawajVoiceHelper.updateContext(
//             section,
//             screen,
//             message:
//                 welcomeMessage ?? 'مرحباً بك في القسم $section، الشاشة $screen',
//           );
//           if (autoShow) {
//             HawajVoiceHelper.show();
//           }
//         });
//
//         return child.withHawajVoiceAdvanced(
//           section: section,
//           screen: screen,
//           initialMessage: welcomeMessage,
//           autoShow: autoShow,
//         );
//       },
//     );
//   }
//
//   /// Setup for navigation-aware screens
//   static Widget setupWithNavigation({
//     required Widget child,
//     required String section,
//     required String screen,
//     String? welcomeMessage,
//     bool autoShow = true,
//     Map<String, VoidCallback>? navigationActions,
//   }) {
//     return Builder(
//       builder: (context) {
//         WidgetsBinding.instance.addPostFrameCallback((_) async {
//           await initialize();
//
//           // Set up navigation context
//           final controller = Get.find<HawajAIController>();
//           controller.updateContext(section, screen, message: welcomeMessage);
//
//           if (autoShow) {
//             controller.show();
//           }
//         });
//
//         return child.withHawajVoiceAdvanced(
//           section: section,
//           screen: screen,
//           initialMessage: welcomeMessage,
//           autoShow: autoShow,
//         );
//       },
//     );
//   }
//
//   /// Dispose resources
//   static void dispose() {
//     try {
//       if (Get.isRegistered<HawajAIController>()) {
//         Get.delete<HawajAIController>();
//       }
//       _controller = null;
//       _isInitialized = false;
//     } catch (e) {
//       print('Error disposing Hawaj Voice Assistant: $e');
//     }
//   }
// }
//
// // Mixin for screens that want to integrate with Hawaj Voice
// mixin HawajVoiceScreenMixin<T extends StatefulWidget> on State<T> {
//   String get screenSection;
//
//   String get screenId;
//
//   String? get welcomeMessage => null;
//
//   bool get autoShowAssistant => true;
//
//   @override
//   void initState() {
//     super.initState();
//     _setupHawajVoice();
//   }
//
//   void _setupHawajVoice() {
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await HawajVoiceManager.initialize();
//       HawajVoiceHelper.updateContext(
//         screenSection,
//         screenId,
//         message: welcomeMessage ?? 'مرحباً بك في $screenSection',
//       );
//
//       if (autoShowAssistant) {
//         HawajVoiceHelper.show();
//       }
//     });
//   }
//
//   /// Override this method to handle voice commands specific to your screen
//   void handleVoiceCommand(String command) {
//     // Default implementation - override in your screen
//     print('Voice command received: $command');
//   }
//
//   /// Override this method to provide screen-specific voice responses
//   String? getScreenSpecificResponse(String userInput) {
//     // Default implementation - override in your screen
//     return null;
//   }
// }
//
// // Example usage in a screen:
// /*
// class MyScreen extends StatefulWidget {
//   @override
//   _MyScreenState createState() => _MyScreenState();
// }
//
// class _MyScreenState extends State<MyScreen> with HawajVoiceScreenMixin {
//   @override
//   String get screenSection => '2';
//
//   @override
//   String get screenId => '1';
//
//   @override
//   String? get welcomeMessage => 'مرحباً بك في شاشة المنتجات';
//
//   @override
//   void handleVoiceCommand(String command) {
//     // Handle screen-specific voice commands
//     if (command.contains('منتج')) {
//       // Navigate to products
//     } else if (command.contains('بحث')) {
//       // Open search
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('My Screen')),
//       body: Column(
//         children: [
//           // Your screen content
//         ],
//       ),
//     ).withHawajVoice(); // Simple integration
//   }
// }
// */
