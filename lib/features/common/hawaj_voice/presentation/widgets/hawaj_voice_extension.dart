import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/hawaj_ai_controller.dart';
import 'elite_floating_voice_assistant.dart';

// Extension for easy integration with any Widget
extension HawajVoiceExtension on Widget {
  /// Add Hawaj Voice Assistant with default settings
  Widget withHawajVoice({
    double? bottom,
    double? top,
    double? left,
    double? right,
    bool autoShow = true,
    String? initialMessage,
  }) {
    return Stack(
      children: [
        this,
        Positioned(
          bottom: bottom,
          top: top,
          left: left ?? 20,
          right: right,
          child: EliteFloatingVoiceAssistant(
            autoShow: autoShow,
            initialMessage: initialMessage,
          ),
        ),
      ],
    );
  }

  /// Add Hawaj Voice Assistant with advanced settings
  Widget withHawajVoiceAdvanced({
    String? section,
    String? screen,
    String? initialMessage,
    double? x,
    double? y,
    bool autoShow = true,
    VoidCallback? onDragEnd,
  }) {
    return Stack(
      children: [
        this,
        Builder(
          builder: (context) {
            // Update controller context when widget builds
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                final controller = Get.find<HawajAIController>();
                if (section != null && screen != null) {
                  controller.updateContext(section, screen,
                      message: initialMessage);
                }
              } catch (e) {
                // Controller not found, will be handled by the assistant widget
              }
            });

            return EliteFloatingVoiceAssistant(
              initialX: x,
              initialY: y,
              autoShow: autoShow,
              initialMessage: initialMessage,
              onDragEnd: onDragEnd,
            );
          },
        ),
      ],
    );
  }

  /// Add Hawaj Voice Assistant as overlay
  Widget withHawajVoiceOverlay({
    String? section,
    String? screen,
    String? initialMessage,
    bool autoShow = true,
  }) {
    return Scaffold(
      body: this,
      floatingActionButton: EliteFloatingVoiceAssistant(
        autoShow: autoShow,
        initialMessage: initialMessage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

// Helper class for controlling Hawaj Voice Assistant
class HawajVoiceHelper {
  static HawajAIController? _getController() {
    try {
      return Get.find<HawajAIController>();
    } catch (e) {
      print('HawajAIController not found. Make sure it\'s registered in DI.');
      return null;
    }
  }

  /// Show the voice assistant
  static void show() {
    _getController()?.show();
  }

  /// Hide the voice assistant
  static void hide() {
    _getController()?.hide();
  }

  /// Toggle visibility
  static void toggleVisibility() {
    _getController()?.toggleVisibility();
  }

  /// Expand the assistant interface
  static void expand() {
    final controller = _getController();
    controller?.show();
    controller?.expand();
  }

  /// Collapse the assistant interface
  static void collapse() {
    _getController()?.collapse();
  }

  /// Start listening for voice input
  static Future<void> startListening() async {
    await _getController()?.startListening();
  }

  /// Stop listening for voice input
  static Future<void> stopListening() async {
    await _getController()?.stopListening();
  }

  /// Toggle listening state
  static void toggleListening() {
    _getController()?.toggleListening();
  }

  /// Speak a message
  static Future<void> speak(String text) async {
    await _getController()?.speak(text);
  }

  /// Stop speaking
  static Future<void> stopSpeaking() async {
    await _getController()?.stopSpeaking();
  }

  /// Update the current section and screen context
  static void updateContext(String section, String screen, {String? message}) {
    _getController()?.updateContext(section, screen, message: message);
  }

  /// Set a custom message
  static void setMessage(String message) {
    _getController()?.setMessage(message);
  }

  /// Clear the current response and reset
  static void clearResponse() {
    _getController()?.clearResponse();
  }

  /// Update the assistant position
  static void updatePosition(double x, double y) {
    _getController()?.updatePosition(x, y);
  }

  /// Get current state
  static AssistantState? getCurrentState() {
    return _getController()?.currentState;
  }

  /// Check if assistant is visible
  static bool get isVisible {
    return _getController()?.isVisible ?? false;
  }

  /// Check if assistant is listening
  static bool get isListening {
    return _getController()?.isListening ?? false;
  }

  /// Check if assistant is speaking
  static bool get isSpeaking {
    return _getController()?.isSpeaking ?? false;
  }

  /// Get current message
  static String get currentMessage {
    return _getController()?.currentMessage ?? '';
  }

  /// Get voice text
  static String get voiceText {
    return _getController()?.voiceText ?? '';
  }

  /// Get conversation count
  static int get conversationCount {
    return _getController()?.conversationCount ?? 0;
  }

  /// Get response time
  static int get responseTime {
    return _getController()?.responseTime ?? 0;
  }

  /// Reset all stats
  static void resetStats() {
    _getController()?.resetStats();
  }
}

// Utility class for managing Hawaj Voice Assistant globally
class HawajVoiceManager {
  static HawajAIController? _controller;
  static bool _isInitialized = false;

  /// Initialize the Hawaj Voice system
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Register controller if not already registered
      if (!Get.isRegistered<HawajAIController>()) {
        Get.put(HawajAIController(), permanent: true);
      }

      _controller = Get.find<HawajAIController>();
      _isInitialized = true;

      print('✅ Hawaj Voice Assistant initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize Hawaj Voice Assistant: $e');
    }
  }

  /// Quick setup for common use cases
  static Widget setupForScreen({
    required Widget child,
    required String section,
    required String screen,
    String? welcomeMessage,
    bool autoShow = true,
  }) {
    return Builder(
      builder: (context) {
        // Initialize on first build
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await initialize();
          HawajVoiceHelper.updateContext(
            section,
            screen,
            message:
                welcomeMessage ?? 'مرحباً بك في القسم $section، الشاشة $screen',
          );
          if (autoShow) {
            HawajVoiceHelper.show();
          }
        });

        return child.withHawajVoiceAdvanced(
          section: section,
          screen: screen,
          initialMessage: welcomeMessage,
          autoShow: autoShow,
        );
      },
    );
  }

  /// Setup for navigation-aware screens
  static Widget setupWithNavigation({
    required Widget child,
    required String section,
    required String screen,
    String? welcomeMessage,
    bool autoShow = true,
    Map<String, VoidCallback>? navigationActions,
  }) {
    return Builder(
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await initialize();

          // Set up navigation context
          final controller = Get.find<HawajAIController>();
          controller.updateContext(section, screen, message: welcomeMessage);

          if (autoShow) {
            controller.show();
          }
        });

        return child.withHawajVoiceAdvanced(
          section: section,
          screen: screen,
          initialMessage: welcomeMessage,
          autoShow: autoShow,
        );
      },
    );
  }

  /// Dispose resources
  static void dispose() {
    try {
      if (Get.isRegistered<HawajAIController>()) {
        Get.delete<HawajAIController>();
      }
      _controller = null;
      _isInitialized = false;
    } catch (e) {
      print('Error disposing Hawaj Voice Assistant: $e');
    }
  }
}

// Mixin for screens that want to integrate with Hawaj Voice
mixin HawajVoiceScreenMixin<T extends StatefulWidget> on State<T> {
  String get screenSection;

  String get screenId;

  String? get welcomeMessage => null;

  bool get autoShowAssistant => true;

  @override
  void initState() {
    super.initState();
    _setupHawajVoice();
  }

  void _setupHawajVoice() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await HawajVoiceManager.initialize();
      HawajVoiceHelper.updateContext(
        screenSection,
        screenId,
        message: welcomeMessage ?? 'مرحباً بك في $screenSection',
      );

      if (autoShowAssistant) {
        HawajVoiceHelper.show();
      }
    });
  }

  /// Override this method to handle voice commands specific to your screen
  void handleVoiceCommand(String command) {
    // Default implementation - override in your screen
    print('Voice command received: $command');
  }

  /// Override this method to provide screen-specific voice responses
  String? getScreenSpecificResponse(String userInput) {
    // Default implementation - override in your screen
    return null;
  }
}

// Example usage in a screen:
/*
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> with HawajVoiceScreenMixin {
  @override
  String get screenSection => '2';

  @override
  String get screenId => '1';

  @override
  String? get welcomeMessage => 'مرحباً بك في شاشة المنتجات';

  @override
  void handleVoiceCommand(String command) {
    // Handle screen-specific voice commands
    if (command.contains('منتج')) {
      // Navigate to products
    } else if (command.contains('بحث')) {
      // Open search
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Screen')),
      body: Column(
        children: [
          // Your screen content
        ],
      ),
    ).withHawajVoice(); // Simple integration
  }
}
*/
