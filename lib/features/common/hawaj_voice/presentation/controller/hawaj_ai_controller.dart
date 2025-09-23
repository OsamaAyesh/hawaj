import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum AssistantState { idle, listening, processing, speaking, error }

class HawajAIController extends GetxController
    with GetTickerProviderStateMixin {
  // ==================== Services ====================
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  Timer? _listeningTimer;

  // ==================== Animation Controllers ====================
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  // ==================== Observables ====================
  final RxBool _isListening = false.obs;
  final RxBool _isSpeaking = false.obs;
  final RxBool _isProcessing = false.obs;
  final RxBool _isVisible = false.obs;
  final RxBool _isExpanded = false.obs;
  final RxBool _hasError = false.obs;
  final RxBool _permissionGranted = false.obs;
  final RxBool _speechEnabled = false.obs;
  final RxBool _ttsEnabled = false.obs;

  final RxString _currentMessage = 'مرحباً! كيف يمكنني مساعدتك؟ 🤖'.obs;
  final RxString _voiceText = ''.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _currentSection = '1'.obs;
  final RxString _currentScreen = '1'.obs;

  final RxInt _conversationCount = 0.obs;
  final RxInt _responseTime = 0.obs;
  final RxDouble _confidenceLevel = 0.0.obs;
  final RxDouble _audioLevel = 0.0.obs;
  final RxList<double> _audioLevels = <double>[].obs;

  // Position for floating widget
  final RxDouble _positionX = 20.0.obs;
  final RxDouble _positionY = 100.0.obs;

  // ==================== Getters ====================
  bool get isListening => _isListening.value;

  bool get isSpeaking => _isSpeaking.value;

  bool get isProcessing => _isProcessing.value;

  bool get isVisible => _isVisible.value;

  bool get isExpanded => _isExpanded.value;

  bool get hasError => _hasError.value;

  bool get permissionGranted => _permissionGranted.value;

  bool get speechEnabled => _speechEnabled.value;

  bool get ttsEnabled => _ttsEnabled.value;

  String get currentMessage => _currentMessage.value;

  String get voiceText => _voiceText.value;

  String get errorMessage => _errorMessage.value;

  String get currentSection => _currentSection.value;

  String get currentScreen => _currentScreen.value;

  int get conversationCount => _conversationCount.value;

  int get responseTime => _responseTime.value;

  double get confidenceLevel => _confidenceLevel.value;

  double get audioLevel => _audioLevel.value;

  List<double> get audioLevels => _audioLevels.toList();

  double get positionX => _positionX.value;

  double get positionY => _positionY.value;

  // ==================== Current State ====================
  AssistantState get currentState {
    if (hasError) return AssistantState.error;
    if (isProcessing) return AssistantState.processing;
    if (isSpeaking) return AssistantState.speaking;
    if (isListening) return AssistantState.listening;
    return AssistantState.idle;
  }

  Color get stateColor {
    switch (currentState) {
      case AssistantState.listening:
        return const Color(0xFF4CAF50); // Green
      case AssistantState.processing:
        return const Color(0xFF2196F3); // Blue
      case AssistantState.speaking:
        return const Color(0xFF9C27B0); // Purple
      case AssistantState.error:
        return const Color(0xFFF44336); // Red
      case AssistantState.idle:
      default:
        return const Color(0xFF607D8B); // Blue Grey
    }
  }

  IconData get stateIcon {
    switch (currentState) {
      case AssistantState.listening:
        return Icons.mic;
      case AssistantState.processing:
        return Icons.psychology;
      case AssistantState.speaking:
        return Icons.volume_up;
      case AssistantState.error:
        return Icons.error;
      case AssistantState.idle:
      default:
        return Icons.smart_toy;
    }
  }

  String get stateText {
    switch (currentState) {
      case AssistantState.listening:
        return 'أستمع إليك...';
      case AssistantState.processing:
        return 'أفكر في إجابتك...';
      case AssistantState.speaking:
        return 'أتحدث معك...';
      case AssistantState.error:
        return 'حدث خطأ!';
      case AssistantState.idle:
      default:
        return 'مساعدك الذكي جاهز';
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _initializeSpeech();
    _initializeTTS();
    _initializeAudioLevels();
  }

  @override
  void onClose() {
    _pulseController.dispose();
    _listeningTimer?.cancel();
    _speechToText.stop();
    _flutterTts.stop();
    super.onClose();
  }

  // ==================== Initialization ====================
  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticInOut,
    ));
  }

  void _initializeAudioLevels() {
    _audioLevels.value = List.generate(20, (index) => 0.0);
  }

  Future<void> _initializeSpeech() async {
    try {
      final status = await Permission.microphone.request();
      if (status.isGranted) {
        _permissionGranted.value = true;

        final isAvailable = await _speechToText.initialize(
          onStatus: _onSpeechStatus,
          onError: _onSpeechError,
        );

        _speechEnabled.value = isAvailable;

        if (!isAvailable) {
          _setError('فشل في تهيئة التعرف على الكلام');
        }
      } else {
        _setError('مطلوب إذن الميكروفون');
      }
    } catch (e) {
      _setError('خطأ في تهيئة الكلام: $e');
    }
  }

  Future<void> _initializeTTS() async {
    try {
      await _flutterTts.setLanguage("ar-SA");
      await _flutterTts.setSpeechRate(0.8);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        _isSpeaking.value = true;
        _startPulseAnimation();
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking.value = false;
        _stopPulseAnimation();
      });

      _flutterTts.setErrorHandler((msg) {
        _isSpeaking.value = false;
        _stopPulseAnimation();
        _setError('خطأ في تشغيل الصوت: $msg');
      });

      _ttsEnabled.value = true;
    } catch (e) {
      _setError('فشل في تهيئة تحويل النص لصوت: $e');
    }
  }

  // ==================== Speech Recognition ====================
  void _onSpeechStatus(String status) {
    print('Speech Status: $status');

    if (status == 'notListening' && isListening) {
      _isListening.value = false;
      _stopPulseAnimation();

      if (voiceText.isNotEmpty) {
        _processVoiceInput();
      }
    } else if (status == 'listening') {
      _isListening.value = true;
      _startPulseAnimation();
    }
  }

  void _onSpeechError(dynamic error) {
    print('Speech Error: $error');
    _isListening.value = false;
    _stopPulseAnimation();
    _setError('خطأ في التعرف على الكلام');
  }

  void _onSpeechResult(result) {
    _voiceText.value = result.recognizedWords;
    _confidenceLevel.value = result.confidence;

    // Auto-stop listening after 3 seconds of good recognition
    if (_confidenceLevel.value > 0.7 && _voiceText.value.length > 5) {
      _listeningTimer?.cancel();
      _listeningTimer = Timer(const Duration(seconds: 2), () {
        if (isListening) {
          stopListening();
        }
      });
    }
  }

  // ==================== Public Methods ====================
  Future<void> startListening() async {
    if (!permissionGranted) {
      await _requestPermission();
      return;
    }

    if (!speechEnabled) {
      await _initializeSpeech();
      if (!speechEnabled) return;
    }

    try {
      _clearError();
      _voiceText.value = '';
      _confidenceLevel.value = 0.0;

      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: "ar-SA",
        listenMode: ListenMode.confirmation,
        onSoundLevelChange: _onSoundLevelChange,
      );

      _isListening.value = true;
      _startPulseAnimation();

      // Auto-stop after 10 seconds
      _listeningTimer?.cancel();
      _listeningTimer = Timer(const Duration(seconds: 10), () {
        if (isListening) {
          stopListening();
        }
      });
    } catch (e) {
      _setError('فشل في بدء الاستماع: $e');
    }
  }

  Future<void> stopListening() async {
    try {
      _listeningTimer?.cancel();
      await _speechToText.stop();
      _isListening.value = false;
      _stopPulseAnimation();

      if (voiceText.isNotEmpty) {
        _processVoiceInput();
      }
    } catch (e) {
      _setError('فشل في إيقاف الاستماع: $e');
    }
  }

  Future<void> speak(String text) async {
    if (!ttsEnabled) {
      await _initializeTTS();
      if (!ttsEnabled) return;
    }

    try {
      await _flutterTts.stop();
      await _flutterTts.speak(text);
    } catch (e) {
      _setError('فشل في تشغيل الصوت: $e');
    }
  }

  Future<void> stopSpeaking() async {
    try {
      await _flutterTts.stop();
      _isSpeaking.value = false;
      _stopPulseAnimation();
    } catch (e) {
      _setError('فشل في إيقاف الصوت: $e');
    }
  }

  void toggleListening() {
    if (isListening) {
      stopListening();
    } else {
      startListening();
    }
  }

  void show() {
    _isVisible.value = true;
  }

  void hide() {
    _isVisible.value = false;
  }

  void toggleVisibility() {
    _isVisible.value = !_isVisible.value;
  }

  void expand() {
    _isExpanded.value = true;
  }

  void collapse() {
    _isExpanded.value = false;
  }

  void toggleExpansion() {
    _isExpanded.value = !_isExpanded.value;
  }

  void updatePosition(double x, double y) {
    _positionX.value = x;
    _positionY.value = y;
  }

  void setMessage(String message) {
    _currentMessage.value = message;
  }

  void updateContext(String section, String screen, {String? message}) {
    _currentSection.value = section;
    _currentScreen.value = screen;
    if (message != null) {
      setMessage(message);
    }
  }

  void clearResponse() {
    _voiceText.value = '';
    _confidenceLevel.value = 0.0;
    _clearError();
  }

  void resetStats() {
    _conversationCount.value = 0;
    _responseTime.value = 0;
    _confidenceLevel.value = 0.0;
  }

  // ==================== Private Methods ====================
  Future<void> _requestPermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      _permissionGranted.value = true;
      await _initializeSpeech();
    } else {
      _setError('مطلوب إذن الميكروفون');
    }
  }

  void _onSoundLevelChange(double level) {
    _audioLevel.value = level;

    // Update audio levels array for wave animation
    final levels = _audioLevels.toList();
    levels.removeAt(0);
    levels.add(level);
    _audioLevels.value = levels;
  }

  Future<void> _processVoiceInput() async {
    if (voiceText.isEmpty) return;

    try {
      _isProcessing.value = true;
      _startPulseAnimation();

      final startTime = DateTime.now();

      // Simulate API call
      final response = await _sendToHawajAPI(voiceText);

      final endTime = DateTime.now();
      _responseTime.value = endTime.difference(startTime).inMilliseconds;
      _conversationCount.value++;

      if (response != null) {
        await _handleAPIResponse(response);
      }
    } catch (e) {
      _setError('فشل في معالجة الطلب: $e');
    } finally {
      _isProcessing.value = false;
      _stopPulseAnimation();
    }
  }

  Future<Map<String, dynamic>?> _sendToHawajAPI(String query) async {
    try {
      final url = Uri.parse('https://your-api-endpoint.com/hawaj');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'query': query,
          'section': currentSection,
          'screen': currentScreen,
          'confidence': confidenceLevel,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      return null;
    }
  }

  Future<void> _handleAPIResponse(Map<String, dynamic> response) async {
    try {
      if (response['error'] == false && response['data'] != null) {
        final data = response['data']['d'];
        final newSection = data['section'];
        final newScreen = data['screen'];
        final message = data['message'];
        final mp3Url = data['mp3'];

        // Update message
        setMessage(message);

        // Speak the response
        if (mp3Url != null && mp3Url.isNotEmpty) {
          // TODO: Play MP3 from URL
          await speak(message);
        } else {
          await speak(message);
        }

        // Handle navigation if section/screen changed
        if (newSection != currentSection || newScreen != currentScreen) {
          updateContext(newSection, newScreen);
          _navigateToScreen(newSection, newScreen);
        }
      } else {
        _setError(response['message'] ?? 'خطأ في الاستجابة');
      }
    } catch (e) {
      _setError('فشل في معالجة الاستجابة: $e');
    }
  }

  void _navigateToScreen(String section, String screen) {
    // TODO: Implement navigation logic based on section and screen
    print('Navigate to Section: $section, Screen: $screen');
  }

  void _startPulseAnimation() {
    if (!_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _stopPulseAnimation() {
    _pulseController.stop();
    _pulseController.reset();
  }

  void _setError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
    _isListening.value = false;
    _isProcessing.value = false;
    _isSpeaking.value = false;
    _stopPulseAnimation();
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }
}
