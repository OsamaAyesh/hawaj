import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
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

  // === UI States ===
  final _isVisible = false.obs;
  final _isExpanded = false.obs;
  final _isListening = false.obs;
  final _isSpeaking = false.obs;
  final _isProcessing = false.obs;
  final _hasError = false.obs;
  final _isInitialized = false.obs;

  // === Messages & Text ===
  final _currentMessage = 'مرحباً! كيف يمكنني مساعدتك؟'.obs;
  final _voiceText = ''.obs;
  final _partialText = ''.obs; // ✅ جديد: لتخزين النتائج الجزئية
  final _errorMessage = ''.obs;
  final _confidenceLevel = 0.0.obs;

  // === Context ===
  String _section = '';
  String _screen = '';

  // === Location ===
  double? _latitude;
  double? _longitude;

  // === Speech Recognition Control ===
  bool _isWaitingForFinalResult =
      false; // ✅ جديد: للتأكد من استلام النتيجة النهائية
  String _lastRecognizedText = ''; // ✅ جديد: لتتبع آخر نص تم التعرف عليه

  // === Public Getters ===
  bool get isVisible => _isVisible.value;

  bool get isExpanded => _isExpanded.value;

  bool get isListening => _isListening.value;

  bool get isSpeaking => _isSpeaking.value;

  bool get isProcessing => _isProcessing.value;

  bool get hasError => _hasError.value;

  bool get isInitialized => _isInitialized.value;

  String get currentMessage => _currentMessage.value;

  String get voiceText => _voiceText.value;

  String get partialText => _partialText.value; // ✅ جديد
  String get errorMessage => _errorMessage.value;

  double get confidenceLevel => _confidenceLevel.value;

  String get currentSection => _section;

  String get currentScreen => _screen;

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

  /// تهيئة النظام
  Future<void> _initializeSystem() async {
    try {
      // إذن الميكروفون
      final micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) {
        _setError('يجب منح إذن الميكروفون.');
        return;
      }

      // إذن الموقع
      final locStatus = await Permission.location.request();
      if (!locStatus.isGranted) {
        _setError('يجب منح إذن الموقع.');
        return;
      }

      // جلب إحداثيات الموقع
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _latitude = pos.latitude;
      _longitude = pos.longitude;

      // تهيئة التعرف على الكلام مع معالج محسّن
      final speechAvailable = await _speechToText.initialize(
        onStatus: _onSpeechStatus,
        onError: _onSpeechError,
        debugLogging: true, // ✅ للمساعدة في تتبع المشاكل
      );

      if (!speechAvailable) {
        _setError('خدمة التعرف على الكلام غير متاحة.');
        return;
      }

      // تهيئة TTS
      await _flutterTts.setLanguage("ar-SA");
      await _flutterTts.setSpeechRate(0.85);
      await _flutterTts.setVolume(1.0);

      _flutterTts.setStartHandler(() {
        _isSpeaking.value = true;
        debugPrint('🔊 بدأ النطق');
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking.value = false;
        debugPrint('✅ انتهى النطق');
      });

      _flutterTts.setErrorHandler((msg) {
        _isSpeaking.value = false;
        _setError('خطأ في النطق: $msg');
      });

      _isInitialized.value = true;
      debugPrint('✅ تمت تهيئة النظام بنجاح');
    } catch (e) {
      _setError('فشل التهيئة: $e');
    }
  }

  /// تحديث معلومات القسم والشاشة
  void updateContext(String section, String screen, {String? message}) {
    _section = section;
    _screen = screen;
    if (message != null) _currentMessage.value = message;
  }

  // === واجهة التحكم ===
  void show({String? message}) {
    _isVisible.value = true;
    if (message != null) _currentMessage.value = message;
  }

  void hide() {
    _isVisible.value = false;
    _isExpanded.value = false;
  }

  void toggleExpansion() => _isExpanded.value = !_isExpanded.value;

  // === استماع محسّن ===
  Future<void> startListening() async {
    if (!_isInitialized.value || _isListening.value) {
      debugPrint('⚠️ لا يمكن بدء الاستماع: النظام غير جاهز أو الاستماع نشط');
      return;
    }

    // إيقاف أي نطق جاري
    if (_isSpeaking.value) {
      await stopSpeaking();
    }

    // إعادة تعيين الحالة
    _voiceText.value = '';
    _partialText.value = '';
    _lastRecognizedText = '';
    _confidenceLevel.value = 0.0;
    _isWaitingForFinalResult = false;
    _clearError();

    debugPrint('🎤 بدء الاستماع...');

    try {
      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: "ar-SA",
        listenMode: ListenMode.confirmation,
        partialResults: true,
        // ✅ تفعيل النتائج الجزئية
        cancelOnError: false,
        // ✅ عدم الإلغاء عند الخطأ
        listenFor: const Duration(seconds: 30),
        // ✅ مدة استماع أطول
        pauseFor: const Duration(seconds: 5), // ✅ وقت توقف أطول قبل الإنهاء
      );

      _isListening.value = true;
      _currentMessage.value = 'يتم الاستماع... تحدث الآن';

      // ✅ تشغيل صوت بداية الاستماع
      _playStartSound();
    } catch (e) {
      debugPrint('❌ خطأ عند بدء الاستماع: $e');
      _setError('فشل بدء الاستماع: $e');
    }
  }

  Future<void> stopListening() async {
    if (!_isListening.value) return;

    debugPrint('🛑 إيقاف الاستماع...');

    // ✅ تعيين علامة الانتظار للنتيجة النهائية
    _isWaitingForFinalResult = true;

    await _speechToText.stop();

    // ✅ الانتظار قليلاً للحصول على النتيجة النهائية
    await Future.delayed(const Duration(milliseconds: 300));

    _isListening.value = false;
    _isWaitingForFinalResult = false;

    // ✅ تشغيل صوت نهاية الاستماع
    _playStopSound();

    // ✅ التحقق من وجود نص للمعالجة
    final finalText = _voiceText.value.trim().isEmpty
        ? _partialText.value.trim()
        : _voiceText.value.trim();

    if (finalText.isNotEmpty) {
      debugPrint('✅ تم التقاط النص: "$finalText"');
      _currentMessage.value = 'جارٍ معالجة الكلام...';
      await _processVoiceInput();
    } else {
      debugPrint('⚠️ لم يتم التقاط أي نص');
      _currentMessage.value = 'لم يتم التقاط أي صوت. حاول مرة أخرى';
      _resetToIdle();
    }
  }

  void toggleListening() {
    if (_isListening.value) {
      stopListening();
    } else {
      startListening();
    }
  }

  // === Callbacks محسّنة ===
  void _onSpeechStatus(String status) {
    debugPrint('📊 حالة الكلام: $status');

    switch (status) {
      case 'listening':
        _isListening.value = true;
        _currentMessage.value = 'يتم الاستماع... تحدث الآن';
        break;

      case 'notListening':
        if (!_isWaitingForFinalResult && _isListening.value) {
          // ✅ انتهى الاستماع بشكل طبيعي
          debugPrint('✅ انتهى الاستماع تلقائياً');
          _isListening.value = false;

          // معالجة النص إن وُجد
          final textToProcess = _voiceText.value.trim().isEmpty
              ? _partialText.value.trim()
              : _voiceText.value.trim();

          if (textToProcess.isNotEmpty) {
            _playStopSound();
            _currentMessage.value = 'جارٍ معالجة الكلام...';
            _processVoiceInput();
          } else {
            _currentMessage.value = 'لم يتم التقاط أي صوت';
            _resetToIdle();
          }
        }
        break;

      case 'done':
        debugPrint('✅ اكتمل التعرف على الكلام');
        break;
    }
  }

  void _onSpeechError(dynamic error) {
    debugPrint('❌ خطأ في التعرف على الكلام: $error');
    _isListening.value = false;
    _isWaitingForFinalResult = false;

    // ✅ إذا كان هناك نص جزئي، استخدمه
    if (_partialText.value.trim().isNotEmpty) {
      _voiceText.value = _partialText.value;
      _processVoiceInput();
    } else {
      _setError('خطأ في التعرف على الكلام. حاول مرة أخرى');
      _resetToIdle();
    }
  }

  void _onSpeechResult(result) {
    final recognizedText = result.recognizedWords as String;
    final isFinal = result.finalResult as bool;
    final confidence = result.confidence as double;

    debugPrint(
        '📝 نص ${isFinal ? "نهائي" : "جزئي"}: "$recognizedText" (ثقة: ${(confidence * 100).toStringAsFixed(1)}%)');

    // ✅ تحديث النص الجزئي دائماً
    _partialText.value = recognizedText;
    _lastRecognizedText = recognizedText;

    if (isFinal) {
      // ✅ نتيجة نهائية - تخزينها
      _voiceText.value = recognizedText;
      _confidenceLevel.value = confidence;
      debugPrint('✅ تم حفظ النص النهائي: "$recognizedText"');
    } else {
      // ✅ نتيجة جزئية - تحديث مؤشر الثقة
      _confidenceLevel.value = confidence;
    }
  }

  /// استقبال نص الصوت من الـ Widget
  Future<void> processVoiceInputFromWidget(
    String voiceText,
    double confidence, {
    required String section,
    required String screen,
  }) async {
    final trimmedText = voiceText.trim();

    if (trimmedText.isEmpty) {
      debugPrint('⚠️ نص فارغ، لن تتم المعالجة');
      return;
    }

    debugPrint(
        '📥 استقبال نص من Widget: "$trimmedText" (ثقة: ${(confidence * 100).toStringAsFixed(1)}%)');

    _voiceText.value = trimmedText;
    _confidenceLevel.value = confidence;
    updateContext(section, screen);

    await _processVoiceInput();
  }

  /// معالجة النص المُلتقط وإرساله للخادم
  Future<void> _processVoiceInput() async {
    // ✅ استخدام آخر نص متاح (نهائي أو جزئي)
    final textToProcess = _voiceText.value.trim().isEmpty
        ? _partialText.value.trim()
        : _voiceText.value.trim();

    if (textToProcess.isEmpty) {
      debugPrint('⚠️ لا يوجد نص للمعالجة');
      _resetToIdle();
      return;
    }

    debugPrint('⚙️ بدء معالجة النص: "$textToProcess"');

    _isProcessing.value = true;
    _currentMessage.value = 'جارٍ معالجة طلبك...';

    try {
      final request = SendDataRequest(
        strl: textToProcess,
        lat: (_latitude ?? 0).toString(),
        lng: (_longitude ?? 0).toString(),
        language: "ar",
        q: _section,
        s: _screen,
      );

      final result = await _sendDataUseCase.execute(request);

      result.fold(
        (failure) {
          debugPrint('❌ فشل الطلب: ${failure.message}');
          _setError(failure.message);
          _resetToIdle();
        },
        (response) {
          debugPrint('✅ استلام الرد من الخادم');
          _handleSuccessResponse(response);
        },
      );
    } catch (e) {
      debugPrint('❌ خطأ غير متوقع: $e');
      _setError('فشل الطلب: $e');
      _resetToIdle();
    } finally {
      _isProcessing.value = false;
    }
  }

  void _handleSuccessResponse(SendDataModel response) {
    final data = response.data;
    final destination = data.d;

    _currentMessage.value = destination.message;
    debugPrint('💬 رسالة الرد: ${destination.message}');

    if (destination.mp3.isNotEmpty) {
      debugPrint('🎵 تشغيل MP3: ${destination.mp3}');
      _playAudioFromUrl(destination.mp3);
    } else if (destination.message.isNotEmpty) {
      debugPrint('🔊 نطق الرسالة');
      speak(destination.message);
    } else {
      _resetToIdle();
    }

    _isExpanded.value = true;
  }

  Future<void> _playAudioFromUrl(String url) async {
    try {
      await _audioPlayer.stop();
      await _flutterTts.stop();
      await _audioPlayer.play(UrlSource(url));
      debugPrint('✅ بدأ تشغيل الصوت من URL');
    } catch (e) {
      debugPrint('❌ فشل تشغيل MP3: $e');
      if (_currentMessage.value.isNotEmpty) {
        speak(_currentMessage.value);
      } else {
        _resetToIdle();
      }
    }
  }

  // === نطق ===
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    debugPrint('🔊 بدء النطق: "$text"');
    await _flutterTts.stop();
    await _audioPlayer.stop();
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    debugPrint('🛑 إيقاف النطق');
    await _flutterTts.stop();
    await _audioPlayer.stop();
    _isSpeaking.value = false;
  }

  void clearResponse() {
    _voiceText.value = '';
    _partialText.value = '';
    _lastRecognizedText = '';
    _confidenceLevel.value = 0.0;
    _clearError();
  }

  // === إعادة التعيين للوضع الخامل ===
  void _resetToIdle() {
    debugPrint('🔄 إعادة التعيين للوضع الخامل');
    _isListening.value = false;
    _isProcessing.value = false;
    _isSpeaking.value = false;
    _isWaitingForFinalResult = false;
    _currentMessage.value = 'انقر للتحدث';
  }

  // === أصوات التغذية الراجعة ===
  void _playStartSound() {
    // ✅ يمكن استبدالها بملف صوتي قصير
    debugPrint('🔔 صوت بداية الاستماع');
    // مثال: _audioPlayer.play(AssetSource('sounds/start_listening.mp3'));
  }

  void _playStopSound() {
    // ✅ يمكن استبدالها بملف صوتي قصير
    debugPrint('🔔 صوت نهاية الاستماع');
    // مثال: _audioPlayer.play(AssetSource('sounds/stop_listening.mp3'));
  }

  // === إدارة الأخطاء ===
  void _setError(String message) {
    debugPrint('⚠️ خطأ: $message');
    _hasError.value = true;
    _errorMessage.value = message;
    _currentMessage.value = message;
    _isListening.value = false;
    _isProcessing.value = false;
    _isSpeaking.value = false;

    // ✅ إخفاء الخطأ بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      if (_hasError.value) {
        _clearError();
        _resetToIdle();
      }
    });
  }

  void _clearError() {
    _hasError.value = false;
    _errorMessage.value = '';
  }
}
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:speech_to_text/speech_to_text.dart';
//
// import '../../data/request/send_data_request.dart';
// import '../../domain/models/send_data_model.dart';
// import '../../domain/use_cases/send_data_to_hawaj_use_case.dart';
//
// enum HawajState { idle, listening, processing, speaking, error }
//
// class HawajController extends GetxController {
//   final SendDataToHawajUseCase _sendDataUseCase;
//
//   final SpeechToText _speechToText = SpeechToText();
//   final FlutterTts _flutterTts = FlutterTts();
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   HawajController(this._sendDataUseCase);
//
//   // === UI States ===
//   final _isVisible = false.obs;
//   final _isExpanded = false.obs;
//   final _isListening = false.obs;
//   final _isSpeaking = false.obs;
//   final _isProcessing = false.obs;
//   final _hasError = false.obs;
//   final _isInitialized = false.obs;
//
//   // === Messages & Text ===
//   final _currentMessage = 'مرحباً! كيف يمكنني مساعدتك؟'.obs;
//   final _voiceText = ''.obs;
//   final _partialText = ''.obs; // ✅ جديد: لتخزين النتائج الجزئية
//   final _errorMessage = ''.obs;
//   final _confidenceLevel = 0.0.obs;
//
//   // === Context ===
//   String _section = '';
//   String _screen = '';
//
//   // === Location ===
//   double? _latitude;
//   double? _longitude;
//
//   // === Speech Recognition Control ===
//   bool _isWaitingForFinalResult =
//       false; // ✅ جديد: للتأكد من استلام النتيجة النهائية
//   String _lastRecognizedText = ''; // ✅ جديد: لتتبع آخر نص تم التعرف عليه
//
//   // === Public Getters ===
//   bool get isVisible => _isVisible.value;
//
//   bool get isExpanded => _isExpanded.value;
//
//   bool get isListening => _isListening.value;
//
//   bool get isSpeaking => _isSpeaking.value;
//
//   bool get isProcessing => _isProcessing.value;
//
//   bool get hasError => _hasError.value;
//
//   bool get isInitialized => _isInitialized.value;
//
//   String get currentMessage => _currentMessage.value;
//
//   String get voiceText => _voiceText.value;
//
//   String get partialText => _partialText.value; // ✅ جديد
//   String get errorMessage => _errorMessage.value;
//
//   double get confidenceLevel => _confidenceLevel.value;
//
//   String get currentSection => _section;
//
//   String get currentScreen => _screen;
//
//   HawajState get currentState {
//     if (_hasError.value) return HawajState.error;
//     if (_isProcessing.value) return HawajState.processing;
//     if (_isSpeaking.value) return HawajState.speaking;
//     if (_isListening.value) return HawajState.listening;
//     return HawajState.idle;
//   }
//
//   Color get stateColor {
//     switch (currentState) {
//       case HawajState.listening:
//         return Colors.green;
//       case HawajState.processing:
//         return Colors.blue;
//       case HawajState.speaking:
//         return Colors.purple;
//       case HawajState.error:
//         return Colors.red;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   IconData get stateIcon {
//     switch (currentState) {
//       case HawajState.listening:
//         return Icons.mic;
//       case HawajState.processing:
//         return Icons.psychology;
//       case HawajState.speaking:
//         return Icons.volume_up;
//       case HawajState.error:
//         return Icons.error;
//       default:
//         return Icons.smart_toy;
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeSystem();
//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       _isSpeaking.value = (state == PlayerState.playing);
//     });
//   }
//
//   @override
//   void onClose() {
//     _speechToText.stop();
//     _flutterTts.stop();
//     _audioPlayer.dispose();
//     super.onClose();
//   }
//
//   /// تهيئة النظام
//   Future<void> _initializeSystem() async {
//     try {
//       // إذن الميكروفون
//       final micStatus = await Permission.microphone.request();
//       if (!micStatus.isGranted) {
//         _setError('يجب منح إذن الميكروفون.');
//         return;
//       }
//
//       // إذن الموقع
//       final locStatus = await Permission.location.request();
//       if (!locStatus.isGranted) {
//         _setError('يجب منح إذن الموقع.');
//         return;
//       }
//
//       // جلب إحداثيات الموقع
//       final pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       _latitude = pos.latitude;
//       _longitude = pos.longitude;
//
//       // تهيئة التعرف على الكلام مع معالج محسّن
//       final speechAvailable = await _speechToText.initialize(
//         onStatus: _onSpeechStatus,
//         onError: _onSpeechError,
//         debugLogging: true, // ✅ للمساعدة في تتبع المشاكل
//       );
//
//       if (!speechAvailable) {
//         _setError('خدمة التعرف على الكلام غير متاحة.');
//         return;
//       }
//
//       // تهيئة TTS
//       await _flutterTts.setLanguage("ar-SA");
//       await _flutterTts.setSpeechRate(0.85);
//       await _flutterTts.setVolume(1.0);
//
//       _flutterTts.setStartHandler(() {
//         _isSpeaking.value = true;
//         debugPrint('🔊 بدأ النطق');
//       });
//
//       _flutterTts.setCompletionHandler(() {
//         _isSpeaking.value = false;
//         debugPrint('✅ انتهى النطق');
//       });
//
//       _flutterTts.setErrorHandler((msg) {
//         _isSpeaking.value = false;
//         _setError('خطأ في النطق: $msg');
//       });
//
//       _isInitialized.value = true;
//       debugPrint('✅ تمت تهيئة النظام بنجاح');
//     } catch (e) {
//       _setError('فشل التهيئة: $e');
//     }
//   }
//
//   /// تحديث معلومات القسم والشاشة
//   void updateContext(String section, String screen, {String? message}) {
//     _section = section;
//     _screen = screen;
//     if (message != null) _currentMessage.value = message;
//   }
//
//   // === واجهة التحكم ===
//   void show({String? message}) {
//     _isVisible.value = true;
//     if (message != null) _currentMessage.value = message;
//   }
//
//   void hide() {
//     _isVisible.value = false;
//     _isExpanded.value = false;
//   }
//
//   void toggleExpansion() => _isExpanded.value = !_isExpanded.value;
//
//   // === استماع محسّن ===
//   Future<void> startListening() async {
//     if (!_isInitialized.value || _isListening.value) {
//       debugPrint('⚠️ لا يمكن بدء الاستماع: النظام غير جاهز أو الاستماع نشط');
//       return;
//     }
//
//     // إيقاف أي نطق جاري
//     if (_isSpeaking.value) {
//       await stopSpeaking();
//     }
//
//     // إعادة تعيين الحالة
//     _voiceText.value = '';
//     _partialText.value = '';
//     _lastRecognizedText = '';
//     _confidenceLevel.value = 0.0;
//     _isWaitingForFinalResult = false;
//     _clearError();
//
//     debugPrint('🎤 بدء الاستماع...');
//
//     try {
//       await _speechToText.listen(
//         onResult: _onSpeechResult,
//         localeId: "ar-SA",
//         listenMode: ListenMode.confirmation,
//         partialResults: true,
//         // ✅ تفعيل النتائج الجزئية
//         cancelOnError: false,
//         // ✅ عدم الإلغاء عند الخطأ
//         listenFor: const Duration(seconds: 30),
//         // ✅ مدة استماع أطول
//         pauseFor: const Duration(seconds: 5), // ✅ وقت توقف أطول قبل الإنهاء
//       );
//
//       _isListening.value = true;
//       _currentMessage.value = 'يتم الاستماع... تحدث الآن';
//
//       // ✅ تشغيل صوت بداية الاستماع
//       _playStartSound();
//     } catch (e) {
//       debugPrint('❌ خطأ عند بدء الاستماع: $e');
//       _setError('فشل بدء الاستماع: $e');
//     }
//   }
//
//   Future<void> stopListening() async {
//     if (!_isListening.value) return;
//
//     debugPrint('🛑 إيقاف الاستماع...');
//
//     // ✅ تعيين علامة الانتظار للنتيجة النهائية
//     _isWaitingForFinalResult = true;
//
//     await _speechToText.stop();
//
//     // ✅ الانتظار قليلاً للحصول على النتيجة النهائية
//     await Future.delayed(const Duration(milliseconds: 300));
//
//     _isListening.value = false;
//     _isWaitingForFinalResult = false;
//
//     // ✅ تشغيل صوت نهاية الاستماع
//     _playStopSound();
//
//     // ✅ التحقق من وجود نص للمعالجة
//     final finalText = _voiceText.value.trim().isEmpty
//         ? _partialText.value.trim()
//         : _voiceText.value.trim();
//
//     if (finalText.isNotEmpty) {
//       debugPrint('✅ تم التقاط النص: "$finalText"');
//       _currentMessage.value = 'جارٍ معالجة الكلام...';
//       await _processVoiceInput();
//     } else {
//       debugPrint('⚠️ لم يتم التقاط أي نص');
//       _currentMessage.value = 'لم يتم التقاط أي صوت. حاول مرة أخرى';
//       _resetToIdle();
//     }
//   }
//
//   void toggleListening() {
//     if (_isListening.value) {
//       stopListening();
//     } else {
//       startListening();
//     }
//   }
//
//   // === Callbacks محسّنة ===
//   void _onSpeechStatus(String status) {
//     debugPrint('📊 حالة الكلام: $status');
//
//     switch (status) {
//       case 'listening':
//         _isListening.value = true;
//         _currentMessage.value = 'يتم الاستماع... تحدث الآن';
//         break;
//
//       case 'notListening':
//         if (!_isWaitingForFinalResult && _isListening.value) {
//           // ✅ انتهى الاستماع بشكل طبيعي
//           debugPrint('✅ انتهى الاستماع تلقائياً');
//           _isListening.value = false;
//
//           // معالجة النص إن وُجد
//           final textToProcess = _voiceText.value.trim().isEmpty
//               ? _partialText.value.trim()
//               : _voiceText.value.trim();
//
//           if (textToProcess.isNotEmpty) {
//             _playStopSound();
//             _currentMessage.value = 'جارٍ معالجة الكلام...';
//             _processVoiceInput();
//           } else {
//             _currentMessage.value = 'لم يتم التقاط أي صوت';
//             _resetToIdle();
//           }
//         }
//         break;
//
//       case 'done':
//         debugPrint('✅ اكتمل التعرف على الكلام');
//         break;
//     }
//   }
//
//   void _onSpeechError(dynamic error) {
//     debugPrint('❌ خطأ في التعرف على الكلام: $error');
//     _isListening.value = false;
//     _isWaitingForFinalResult = false;
//
//     // ✅ إذا كان هناك نص جزئي، استخدمه
//     if (_partialText.value.trim().isNotEmpty) {
//       _voiceText.value = _partialText.value;
//       _processVoiceInput();
//     } else {
//       _setError('خطأ في التعرف على الكلام. حاول مرة أخرى');
//       _resetToIdle();
//     }
//   }
//
//   void _onSpeechResult(result) {
//     final recognizedText = result.recognizedWords as String;
//     final isFinal = result.finalResult as bool;
//     final confidence = result.confidence as double;
//
//     debugPrint(
//         '📝 نص ${isFinal ? "نهائي" : "جزئي"}: "$recognizedText" (ثقة: ${(confidence * 100).toStringAsFixed(1)}%)');
//
//     // ✅ تحديث النص الجزئي دائماً
//     _partialText.value = recognizedText;
//     _lastRecognizedText = recognizedText;
//
//     if (isFinal) {
//       // ✅ نتيجة نهائية - تخزينها
//       _voiceText.value = recognizedText;
//       _confidenceLevel.value = confidence;
//       debugPrint('✅ تم حفظ النص النهائي: "$recognizedText"');
//     } else {
//       // ✅ نتيجة جزئية - تحديث مؤشر الثقة
//       _confidenceLevel.value = confidence;
//     }
//   }
//
//   /// استقبال نص الصوت من الـ Widget
//   Future<void> processVoiceInputFromWidget(
//     String voiceText,
//     double confidence, {
//     required String section,
//     required String screen,
//   }) async {
//     final trimmedText = voiceText.trim();
//
//     if (trimmedText.isEmpty) {
//       debugPrint('⚠️ نص فارغ، لن تتم المعالجة');
//       return;
//     }
//
//     debugPrint(
//         '📥 استقبال نص من Widget: "$trimmedText" (ثقة: ${(confidence * 100).toStringAsFixed(1)}%)');
//
//     _voiceText.value = trimmedText;
//     _confidenceLevel.value = confidence;
//     updateContext(section, screen);
//
//     await _processVoiceInput();
//   }
//
//   /// معالجة النص المُلتقط وإرساله للخادم
//   Future<void> _processVoiceInput() async {
//     // ✅ استخدام آخر نص متاح (نهائي أو جزئي)
//     final textToProcess = _voiceText.value.trim().isEmpty
//         ? _partialText.value.trim()
//         : _voiceText.value.trim();
//
//     if (textToProcess.isEmpty) {
//       debugPrint('⚠️ لا يوجد نص للمعالجة');
//       _resetToIdle();
//       return;
//     }
//
//     debugPrint('⚙️ بدء معالجة النص: "$textToProcess"');
//
//     _isProcessing.value = true;
//     _currentMessage.value = 'جارٍ معالجة طلبك...';
//
//     try {
//       final request = SendDataRequest(
//         strl: textToProcess,
//         // lat: (_latitude ?? 0).toString(),
//         // lng: (_longitude ?? 0).toString(),
//         lat: "24.72533",
//         lng: "46.68992",
//         language: "ar",
//         q: _section,
//         s: _screen,
//       );
//
//       final result = await _sendDataUseCase.execute(request);
//
//       result.fold(
//         (failure) {
//           debugPrint('❌ فشل الطلب: ${failure.message}');
//           _setError(failure.message);
//           _resetToIdle();
//         },
//         (response) {
//           debugPrint('✅ استلام الرد من الخادم');
//           _handleSuccessResponse(response);
//         },
//       );
//     } catch (e) {
//       debugPrint('❌ خطأ غير متوقع: $e');
//       _setError('فشل الطلب: $e');
//       _resetToIdle();
//     } finally {
//       _isProcessing.value = false;
//     }
//   }
//
//   void _handleSuccessResponse(SendDataModel response) {
//     final data = response.data;
//     final destination = data.d;
//
//     _currentMessage.value = destination.message;
//     debugPrint('💬 رسالة الرد: ${destination.message}');
//
//     if (destination.mp3.isNotEmpty) {
//       debugPrint('🎵 تشغيل MP3: ${destination.mp3}');
//       _playAudioFromUrl(destination.mp3);
//     } else if (destination.message.isNotEmpty) {
//       debugPrint('🔊 نطق الرسالة');
//       speak(destination.message);
//     } else {
//       _resetToIdle();
//     }
//
//     _isExpanded.value = true;
//   }
//
//   Future<void> _playAudioFromUrl(String url) async {
//     try {
//       await _audioPlayer.stop();
//       await _flutterTts.stop();
//       await _audioPlayer.play(UrlSource(url));
//       debugPrint('✅ بدأ تشغيل الصوت من URL');
//     } catch (e) {
//       debugPrint('❌ فشل تشغيل MP3: $e');
//       if (_currentMessage.value.isNotEmpty) {
//         speak(_currentMessage.value);
//       } else {
//         _resetToIdle();
//       }
//     }
//   }
//
//   // === نطق ===
//   Future<void> speak(String text) async {
//     if (text.isEmpty) return;
//
//     debugPrint('🔊 بدء النطق: "$text"');
//     await _flutterTts.stop();
//     await _audioPlayer.stop();
//     await _flutterTts.speak(text);
//   }
//
//   Future<void> stopSpeaking() async {
//     debugPrint('🛑 إيقاف النطق');
//     await _flutterTts.stop();
//     await _audioPlayer.stop();
//     _isSpeaking.value = false;
//   }
//
//   void clearResponse() {
//     _voiceText.value = '';
//     _partialText.value = '';
//     _lastRecognizedText = '';
//     _confidenceLevel.value = 0.0;
//     _clearError();
//   }
//
//   // === إعادة التعيين للوضع الخامل ===
//   void _resetToIdle() {
//     debugPrint('🔄 إعادة التعيين للوضع الخامل');
//     _isListening.value = false;
//     _isProcessing.value = false;
//     _isSpeaking.value = false;
//     _isWaitingForFinalResult = false;
//     _currentMessage.value = 'انقر للتحدث';
//   }
//
//   // === أصوات التغذية الراجعة ===
//   void _playStartSound() {
//     // ✅ يمكن استبدالها بملف صوتي قصير
//     debugPrint('🔔 صوت بداية الاستماع');
//     // مثال: _audioPlayer.play(AssetSource('sounds/start_listening.mp3'));
//   }
//
//   void _playStopSound() {
//     // ✅ يمكن استبدالها بملف صوتي قصير
//     debugPrint('🔔 صوت نهاية الاستماع');
//     // مثال: _audioPlayer.play(AssetSource('sounds/stop_listening.mp3'));
//   }
//
//   // === إدارة الأخطاء ===
//   void _setError(String message) {
//     debugPrint('⚠️ خطأ: $message');
//     _hasError.value = true;
//     _errorMessage.value = message;
//     _currentMessage.value = message;
//     _isListening.value = false;
//     _isProcessing.value = false;
//     _isSpeaking.value = false;
//
//     // ✅ إخفاء الخطأ بعد 3 ثواني
//     Future.delayed(const Duration(seconds: 3), () {
//       if (_hasError.value) {
//         _clearError();
//         _resetToIdle();
//       }
//     });
//   }
//
//   void _clearError() {
//     _hasError.value = false;
//     _errorMessage.value = '';
//   }
// }
// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_tts/flutter_tts.dart';
// // import 'package:get/get.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:speech_to_text/speech_to_text.dart';
// // import 'package:geolocator/geolocator.dart'; // ✅ جديد
// //
// // import '../../data/request/send_data_request.dart';
// // import '../../domain/models/send_data_model.dart';
// // import '../../domain/use_cases/send_data_to_hawaj_use_case.dart';
// //
// // enum HawajState { idle, listening, processing, speaking, error }
// //
// // class HawajController extends GetxController {
// //   final SendDataToHawajUseCase _sendDataUseCase;
// //
// //   final SpeechToText _speechToText = SpeechToText();
// //   final FlutterTts _flutterTts = FlutterTts();
// //   final AudioPlayer _audioPlayer = AudioPlayer();
// //
// //   HawajController(this._sendDataUseCase);
// //
// //   // === UI States ===
// //   final _isVisible = false.obs;
// //   final _isExpanded = false.obs;
// //   final _isListening = false.obs;
// //   final _isSpeaking = false.obs;
// //   final _isProcessing = false.obs;
// //   final _hasError = false.obs;
// //   final _isInitialized = false.obs;
// //
// //   // === Messages & Text ===
// //   final _currentMessage = 'مرحباً! كيف يمكنني مساعدتك؟'.obs;
// //   final _voiceText = ''.obs;
// //   final _errorMessage = ''.obs;
// //   final _confidenceLevel = 0.0.obs;
// //
// //   // === Context ===
// //   String _section = '';
// //   String _screen = '';
// //
// //   // === Location ===
// //   double? _latitude;
// //   double? _longitude;
// //
// //   // === Public Getters ===
// //   bool get isVisible => _isVisible.value;
// //
// //   bool get isExpanded => _isExpanded.value;
// //
// //   bool get isListening => _isListening.value;
// //
// //   bool get isSpeaking => _isSpeaking.value;
// //
// //   bool get isProcessing => _isProcessing.value;
// //
// //   bool get hasError => _hasError.value;
// //
// //   bool get isInitialized => _isInitialized.value;
// //
// //   String get currentMessage => _currentMessage.value;
// //
// //   String get voiceText => _voiceText.value;
// //
// //   String get errorMessage => _errorMessage.value;
// //
// //   double get confidenceLevel => _confidenceLevel.value;
// //
// //   String get currentSection => _section;
// //
// //   String get currentScreen => _screen;
// //
// //   HawajState get currentState {
// //     if (_hasError.value) return HawajState.error;
// //     if (_isProcessing.value) return HawajState.processing;
// //     if (_isSpeaking.value) return HawajState.speaking;
// //     if (_isListening.value) return HawajState.listening;
// //     return HawajState.idle;
// //   }
// //
// //   Color get stateColor {
// //     switch (currentState) {
// //       case HawajState.listening:
// //         return Colors.green;
// //       case HawajState.processing:
// //         return Colors.blue;
// //       case HawajState.speaking:
// //         return Colors.purple;
// //       case HawajState.error:
// //         return Colors.red;
// //       default:
// //         return Colors.grey;
// //     }
// //   }
// //
// //   IconData get stateIcon {
// //     switch (currentState) {
// //       case HawajState.listening:
// //         return Icons.mic;
// //       case HawajState.processing:
// //         return Icons.psychology;
// //       case HawajState.speaking:
// //         return Icons.volume_up;
// //       case HawajState.error:
// //         return Icons.error;
// //       default:
// //         return Icons.smart_toy;
// //     }
// //   }
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _initializeSystem();
// //     _audioPlayer.onPlayerStateChanged.listen((state) {
// //       _isSpeaking.value = (state == PlayerState.playing);
// //     });
// //   }
// //
// //   @override
// //   void onClose() {
// //     _speechToText.stop();
// //     _flutterTts.stop();
// //     _audioPlayer.dispose();
// //     super.onClose();
// //   }
// //
// //   /// تهيئة الميكروفون، التعرف على الكلام، والنطق، وأخذ موقع المستخدم
// //   Future<void> _initializeSystem() async {
// //     try {
// //       // إذن الميكروفون
// //       final micStatus = await Permission.microphone.request();
// //       if (!micStatus.isGranted) {
// //         _setError('يجب منح إذن الميكروفون.');
// //         return;
// //       }
// //
// //       // إذن الموقع
// //       final locStatus = await Permission.location.request();
// //       if (!locStatus.isGranted) {
// //         _setError('يجب منح إذن الموقع.');
// //         return;
// //       }
// //
// //       // جلب إحداثيات الموقع
// //       final pos = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high,
// //       );
// //       _latitude = pos.latitude;
// //       _longitude = pos.longitude;
// //
// //       // تهيئة التعرف على الكلام
// //       final speechAvailable = await _speechToText.initialize(
// //         onStatus: _onSpeechStatus,
// //         onError: _onSpeechError,
// //       );
// //       if (!speechAvailable) {
// //         _setError('خدمة التعرف على الكلام غير متاحة.');
// //         return;
// //       }
// //
// //       // تهيئة TTS
// //       await _flutterTts.setLanguage("ar-SA");
// //       await _flutterTts.setSpeechRate(0.85);
// //       _flutterTts.setStartHandler(() => _isSpeaking.value = true);
// //       _flutterTts.setCompletionHandler(() => _isSpeaking.value = false);
// //       _flutterTts.setErrorHandler((msg) {
// //         _isSpeaking.value = false;
// //         _setError('خطأ في النطق: $msg');
// //       });
// //
// //       _isInitialized.value = true;
// //     } catch (e) {
// //       _setError('فشل التهيئة: $e');
// //     }
// //   }
// //
// //   /// تحديث معلومات القسم والشاشة
// //   void updateContext(String section, String screen, {String? message}) {
// //     _section = section;
// //     _screen = screen;
// //     if (message != null) _currentMessage.value = message;
// //   }
// //
// //   // === واجهة التحكم ===
// //   void show({String? message}) {
// //     _isVisible.value = true;
// //     if (message != null) _currentMessage.value = message;
// //   }
// //
// //   void hide() {
// //     _isVisible.value = false;
// //     _isExpanded.value = false;
// //   }
// //
// //   void toggleExpansion() => _isExpanded.value = !_isExpanded.value;
// //
// //   // === استماع ===
// //   Future<void> startListening() async {
// //     if (!_isInitialized.value || _isListening.value) return;
// //     _voiceText.value = '';
// //     _confidenceLevel.value = 0.0;
// //     _clearError();
// //
// //     await _speechToText.listen(
// //       onResult: _onSpeechResult,
// //       localeId: "ar-SA",
// //       listenMode: ListenMode.confirmation,
// //       partialResults: true,
// //     );
// //     _isListening.value = true;
// //   }
// //
// //   Future<void> stopListening() async {
// //     await _speechToText.stop();
// //     _isListening.value = false;
// //   }
// //
// //   void toggleListening() =>
// //       _isListening.value ? stopListening() : startListening();
// //
// //   // === نطق / تشغيل صوت ===
// //   Future<void> speak(String text) async {
// //     if (text.isEmpty) return;
// //     await _flutterTts.stop();
// //     await _audioPlayer.stop();
// //     await _flutterTts.speak(text);
// //   }
// //
// //   Future<void> stopSpeaking() async {
// //     await _flutterTts.stop();
// //     await _audioPlayer.stop();
// //     _isSpeaking.value = false;
// //   }
// //
// //   void clearResponse() {
// //     _voiceText.value = '';
// //     _confidenceLevel.value = 0.0;
// //     _clearError();
// //   }
// //
// //   /// استقبال نص الصوت من الـ Widget (لا حاجة لتمرير إحداثيات)
// //   Future<void> processVoiceInputFromWidget(
// //     String voiceText,
// //     double confidence, {
// //     required String section,
// //     required String screen,
// //   }) async {
// //     if (voiceText.isEmpty) return;
// //
// //     _voiceText.value = voiceText;
// //     _confidenceLevel.value = confidence;
// //     updateContext(section, screen);
// //
// //     await _processVoiceInput();
// //   }
// //
// //   // === Callbacks ===
// //   void _onSpeechStatus(String status) {
// //     if (status == 'notListening' && _voiceText.isNotEmpty) {
// //       _processVoiceInput();
// //       _isListening.value = false;
// //     }
// //     if (status == 'listening') _isListening.value = true;
// //   }
// //
// //   void _onSpeechError(dynamic error) {
// //     _isListening.value = false;
// //     _setError('خطأ في التعرف على الكلام: $error');
// //   }
// //
// //   void _onSpeechResult(result) {
// //     _voiceText.value = result.recognizedWords;
// //     _confidenceLevel.value = result.confidence;
// //   }
// //
// //   /// إرسال النص مع الموقع الحالي
// //   Future<void> _processVoiceInput() async {
// //     if (_voiceText.value.trim().isEmpty) return;
// //
// //     _isProcessing.value = true;
// //     try {
// //       final request = SendDataRequest(
// //         strl: _voiceText.value.trim(),
// //         lat: (_latitude ?? 0).toString(),
// //         lng: (_longitude ?? 0).toString(),
// //         language: "ar",
// //         q: _section,
// //         s: _screen,
// //       );
// //
// //       final result = await _sendDataUseCase.execute(request);
// //
// //       result.fold(
// //         (failure) => _setError(failure.message),
// //         (response) => _handleSuccessResponse(response),
// //       );
// //     } catch (e) {
// //       _setError('فشل الطلب: $e');
// //     } finally {
// //       _isProcessing.value = false;
// //     }
// //   }
// //
// //   void _handleSuccessResponse(SendDataModel response) {
// //     final data = response.data;
// //     final destination = data.d;
// //
// //     _currentMessage.value = destination.message;
// //
// //     if (destination.mp3.isNotEmpty) {
// //       _playAudioFromUrl(destination.mp3);
// //     } else if (destination.message.isNotEmpty) {
// //       speak(destination.message);
// //     }
// //
// //     _isExpanded.value = true;
// //   }
// //
// //   Future<void> _playAudioFromUrl(String url) async {
// //     try {
// //       await _audioPlayer.stop();
// //       await _flutterTts.stop();
// //       await _audioPlayer.play(UrlSource(url));
// //     } catch (e) {
// //       debugPrint('MP3 playback failed: $e');
// //       if (_currentMessage.value.isNotEmpty) {
// //         speak(_currentMessage.value);
// //       }
// //     }
// //   }
// //
// //   void _setError(String message) {
// //     _hasError.value = true;
// //     _errorMessage.value = message;
// //     _isListening.value = false;
// //     _isProcessing.value = false;
// //     _isSpeaking.value = false;
// //   }
// //
// //   void _clearError() {
// //     _hasError.value = false;
// //     _errorMessage.value = '';
// //   }
// // }
