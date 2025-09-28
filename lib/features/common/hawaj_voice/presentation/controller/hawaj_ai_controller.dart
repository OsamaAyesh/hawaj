import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../data/request/send_data_request.dart';
import '../../domain/models/send_data_model.dart';
import '../../domain/use_cases/send_data_to_hawaj_use_case.dart';

enum HawajState { idle, listening, processing, speaking, error }

class HawajController extends GetxController {
  final SendDataToHawajUseCase _sendDataUseCase;
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

  HawajController(this._sendDataUseCase);

  // حالات الويدجت
  final RxBool _isVisible = false.obs;
  final RxBool _isExpanded = false.obs;
  final RxBool _isListening = false.obs;
  final RxBool _isSpeaking = false.obs;
  final RxBool _isProcessing = false.obs;
  final RxBool _hasError = false.obs;
  final RxBool _isInitialized = false.obs;

  // النصوص والرسائل
  final RxString _currentMessage = 'مرحباً! كيف يمكنني مساعدتك؟'.obs;
  final RxString _voiceText = ''.obs;
  final RxString _errorMessage = ''.obs;

  // معلومات الشاشة الحالية
  final RxString _currentSection = '1'.obs;
  final RxString _currentScreen = '1'.obs;

  final RxDouble _confidenceLevel = 0.0.obs;

  // Getters
  bool get isVisible => _isVisible.value;

  bool get isExpanded => _isExpanded.value;

  bool get isListening => _isListening.value;

  bool get isSpeaking => _isSpeaking.value;

  bool get isProcessing => _isProcessing.value;

  bool get hasError => _hasError.value;

  bool get isInitialized => _isInitialized.value;

  String get currentMessage => _currentMessage.value;

  String get voiceText => _voiceText.value;

  String get errorMessage => _errorMessage.value;

  String get currentSection => _currentSection.value;

  String get currentScreen => _currentScreen.value;

  double get confidenceLevel => _confidenceLevel.value;

  HawajState get currentState {
    if (_hasError.value) return HawajState.error;
    if (_isProcessing.value) return HawajState.processing;
    if (_isSpeaking.value) return HawajState.speaking;
    if (_isListening.value) return HawajState.listening;
    return HawajState.idle;
  }

  Color get stateColor {
    switch (currentState) {
      case HawajState.listening:
        return Colors.green;
      case HawajState.processing:
        return Colors.blue;
      case HawajState.speaking:
        return Colors.purple;
      case HawajState.error:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData get stateIcon {
    switch (currentState) {
      case HawajState.listening:
        return Icons.mic;
      case HawajState.processing:
        return Icons.psychology;
      case HawajState.speaking:
        return Icons.volume_up;
      case HawajState.error:
        return Icons.error;
      default:
        return Icons.smart_toy;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initializeSystem();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isSpeaking.value = (state == PlayerState.playing);
    });
  }

  @override
  void onClose() {
    _speechToText.stop();
    _flutterTts.stop();
    _audioPlayer.dispose();
    super.onClose();
  }

  // تهيئة النظام
  Future<void> _initializeSystem() async {
    try {
      // طلب إذن الميكروفون
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        _setError('مطلوب إذن الميكروفون');
        return;
      }

      // تهيئة التعرف على الكلام
      final speechAvailable = await _speechToText.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
      );

      if (!speechAvailable) {
        _setError('التعرف على الكلام غير متوفر');
        return;
      }

      // تهيئة تحويل النص للكلام
      await _flutterTts.setLanguage("ar-SA");
      await _flutterTts.setSpeechRate(0.85);

      _flutterTts.setStartHandler(() => _isSpeaking.value = true);
      _flutterTts.setCompletionHandler(() => _isSpeaking.value = false);
      _flutterTts.setErrorHandler((msg) {
        _isSpeaking.value = false;
        _setError('خطأ في النطق');
      });

      _isInitialized.value = true;
    } catch (e) {
      _setError('فشل في التهيئة: $e');
    }
  }

  // تحديث معلومات الشاشة الحالية
  void updateContext(String section, String screen, {String? message}) {
    _currentSection.value = section;
    _currentScreen.value = screen;
    if (message != null) _currentMessage.value = message;
  }

  // إظهار/إخفاء الويدجت
  void show({String? message}) {
    _isVisible.value = true;
    if (message != null) _currentMessage.value = message;
  }

  void hide() {
    _isVisible.value = false;
    _isExpanded.value = false;
  }

  void toggleExpansion() => _isExpanded.value = !_isExpanded.value;

  // بدء/إيقاف الاستماع
  Future<void> startListening() async {
    if (!_isInitialized.value || _isListening.value) return;

    _voiceText.value = '';
    _confidenceLevel.value = 0.0;
    _clearError();

    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: "ar-SA",
      listenMode: ListenMode.confirmation,
      partialResults: true,
    );
    _isListening.value = true;
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    _isListening.value = false;
  }

  void toggleListening() =>
      _isListening.value ? stopListening() : startListening();

  // التحدث
  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    await _flutterTts.stop();
    await _audioPlayer.stop();
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
    await _audioPlayer.stop();
    _isSpeaking.value = false;
  }

  // مسح الاستجابة
  void clearResponse() {
    _voiceText.value = '';
    _confidenceLevel.value = 0.0;
    _clearError();
  }

  // معالجة الصوت من الويدجت
  Future<void> processVoiceInputFromWidget(
      String voiceText, double confidence) async {
    if (voiceText.isEmpty) return;
    _voiceText.value = voiceText;
    _confidenceLevel.value = confidence;
    await _processVoiceInput();
  }

  // معالج أحداث الكلام
  void _onSpeechStatus(String status) {
    if (status == 'notListening' && _voiceText.isNotEmpty) {
      _processVoiceInput();
      _isListening.value = false;
    }
    if (status == 'listening') _isListening.value = true;
  }

  void _onSpeechError(dynamic error) {
    _isListening.value = false;
    _setError('خطأ في التعرف على الكلام');
  }

  void _onSpeechResult(result) {
    _voiceText.value = result.recognizedWords;
    _confidenceLevel.value = result.confidence;
  }

  // معالجة النص المحول من الصوت
  Future<void> _processVoiceInput() async {
    if (_voiceText.value.isEmpty) return;

    _isProcessing.value = true;
    try {
      // إنشاء طلب API
      final request = SendDataRequest(
        strl: _voiceText.value,
        lat: '24.72533',
        // يمكن تحديثها لاحقاً
        lng: '46.68992',
        // يمكن تحديثها لاحقاً
        language: 'ar',
        q: "5",
        s: "2",
      );

      // إرسال الطلب
      final result = await _sendDataUseCase.execute(request);

      result.fold(
        (failure) => _setError(failure.message),
        (response) => _handleSuccessResponse(response),
      );
    } catch (e) {
      _setError('فشل في معالجة الطلب: $e');
    } finally {
      _isProcessing.value = false;
    }
  }

  // معالجة الاستجابة الناجحة
  void _handleSuccessResponse(SendDataModel response) {
    final data = response.data;
    final destination = data.d;

    // تحديث الرسالة
    _currentMessage.value = destination.message;

    // تشغيل الصوت (MP3 أولاً، ثم النطق العادي)
    if (destination.mp3.isNotEmpty) {
      _playAudioFromUrl(destination.mp3);
    } else if (destination.message.isNotEmpty) {
      speak(destination.message);
    }

    // فحص إذا كان يجب التنقل لشاشة جديدة
    if (_shouldNavigate(
        data.q, data.s, destination.section, destination.screen)) {
      _navigateToNewScreen(
          destination.section, destination.screen, destination.parameters);
    }

    // تحديث السياق الحالي
    updateContext(destination.section, destination.screen);

    // توسيع الويدجت لإظهار الاستجابة
    _isExpanded.value = true;
  }

  // فحص إذا كان يجب التنقل
  bool _shouldNavigate(
      String responseQ, String responseS, String newSection, String newScreen) {
    // مقارنة القيم كما هو مطلوب
    // q = Section, s = Screen في الاستجابة
    // نقارن مع الشاشة الحالية
    return responseQ != _currentSection.value ||
        responseS != _currentScreen.value;
  }

  // التنقل لشاشة جديدة
  void _navigateToNewScreen(
      String section, String screen, List<dynamic> parameters) {
    // تحويل المعاملات
    final params = <String, String>{};
    for (int i = 0; i < parameters.length; i += 2) {
      if (i + 1 < parameters.length) {
        params[parameters[i].toString()] = parameters[i + 1].toString();
      }
    }

    // تنفيذ التنقل باستخدام خريطة المسارات
    final route = _getRoute(section, screen);
    if (route != null) {
      Get.toNamed(route, parameters: params);
    }

    print('التنقل إلى: Section $section, Screen $screen');
  }

  // خريطة المسارات (يمكن نقلها لملف منفصل)
  String? _getRoute(String section, String screen) {
    final routes = {
      '1': {
        '1': '/home',
        '2': '/profile',
        '3': '/settings',
      },
      '2': {
        '1': '/products',
        '2': '/products/search',
        '3': '/products/categories',
      },
      '3': {
        '1': '/orders',
        '2': '/orders/create',
        '3': '/orders/history',
      },
    };

    return routes[section]?[screen];
  }

  // تشغيل ملف MP3 من URL
  Future<void> _playAudioFromUrl(String url) async {
    try {
      await _audioPlayer.stop();
      await _flutterTts.stop();
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      print('خطأ في تشغيل MP3: $e');
      // في حالة فشل تشغيل MP3، استخدم النطق العادي
      if (_currentMessage.value.isNotEmpty) {
        speak(_currentMessage.value);
      }
    }
  }

  void _setError(String message) {
    _hasError.value = true;
    _errorMessage.value = message;
    _isListening.value = false;
    _isProcessing.value = false;
    _isSpeaking.value = false;
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }
}
