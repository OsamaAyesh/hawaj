import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
import '../../data/request/send_data_request.dart';
import '../../domain/models/send_data_model.dart';
import '../../domain/use_cases/send_data_to_hawaj_use_case.dart';

enum HawajState { idle, listening, processing, loadingAudio, speaking, error }

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
  final _isLoadingAudio = false.obs;
  final _hasError = false.obs;
  final _isInitialized = false.obs;

  // === Messages & Text ===
  final _currentMessage = 'مرحباً! كيف يمكنني مساعدتك؟'.obs;
  final _voiceText = ''.obs;
  final _partialText = ''.obs;
  final _errorMessage = ''.obs;
  final _confidenceLevel = 0.0.obs;

  // === Context (Current Section & Screen) ===
  String _currentSection = '';
  String _currentScreen = '';

  // === Location ===
  double? _latitude;
  double? _longitude;

  // === Duplicate Request Prevention ===
  bool _isProcessingRequest = false;
  String? _lastProcessedText;
  DateTime? _lastProcessTime;

  // === Public Getters ===
  bool get isVisible => _isVisible.value;

  bool get isExpanded => _isExpanded.value;

  bool get isListening => _isListening.value;

  bool get isSpeaking => _isSpeaking.value;

  bool get isProcessing => _isProcessing.value;

  bool get isLoadingAudio => _isLoadingAudio.value;

  bool get hasError => _hasError.value;

  bool get isInitialized => _isInitialized.value;

  String get currentMessage => _currentMessage.value;

  String get voiceText => _voiceText.value;

  String get partialText => _partialText.value;

  String get errorMessage => _errorMessage.value;

  double get confidenceLevel => _confidenceLevel.value;

  String get currentSection => _currentSection;

  String get currentScreen => _currentScreen;

  HawajState get currentState {
    if (_hasError.value) return HawajState.error;
    if (_isProcessing.value) return HawajState.processing;
    if (_isLoadingAudio.value) return HawajState.loadingAudio;
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
      case HawajState.loadingAudio:
        return Colors.orange;
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
      case HawajState.loadingAudio:
        return Icons.cloud_download;
      case HawajState.speaking:
        return Icons.volume_up;
      case HawajState.error:
        return Icons.error;
      default:
        return Icons.assistant;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initializeSystem();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isSpeaking.value = (state == PlayerState.playing);

      if (state == PlayerState.completed) {
        _isLoadingAudio.value = false;
      }
    });
  }

  @override
  void onClose() {
    _speechToText.stop();
    _flutterTts.stop();
    _audioPlayer.dispose();
    super.onClose();
  }

  Future<void> _initializeSystem() async {
    try {
      final micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) {
        _setError('يجب منح إذن الميكروفون.');
        return;
      }

      final locStatus = await Permission.location.request();
      if (!locStatus.isGranted) {
        _setError('يجب منح إذن الموقع.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _latitude = pos.latitude;
      _longitude = pos.longitude;

      final speechAvailable = await _speechToText.initialize(
        debugLogging: true,
      );

      if (!speechAvailable) {
        _setError('خدمة التعرف على الكلام غير متاحة.');
        return;
      }

      await _flutterTts.setLanguage("ar-SA");
      await _flutterTts.setSpeechRate(0.85);
      await _flutterTts.setVolume(1.0);

      _flutterTts.setStartHandler(() {
        _isSpeaking.value = true;
        _isLoadingAudio.value = false;
        debugPrint('🔊 بدأ النطق');
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking.value = false;
        _isLoadingAudio.value = false;
        debugPrint('✅ انتهى النطق');
      });

      _flutterTts.setErrorHandler((msg) {
        _isSpeaking.value = false;
        _isLoadingAudio.value = false;
        _setError('خطأ في النطق: $msg');
      });

      _isInitialized.value = true;
      debugPrint('✅ تمت تهيئة النظام بنجاح');
    } catch (e) {
      _setError('فشل التهيئة: $e');
    }
  }

  /// ═══════════════════════════════════════════════════════════
  /// 📍 Update Current Context
  /// ═══════════════════════════════════════════════════════════
  void updateContext(String section, String screen, {String? message}) {
    _currentSection = section;
    _currentScreen = screen;
    if (message != null) _currentMessage.value = message;

    debugPrint('📍 Context Updated: Section=$section, Screen=$screen');
  }

  void show({String? message}) {
    _isVisible.value = true;
    if (message != null) _currentMessage.value = message;
  }

  void hide() {
    _isVisible.value = false;
    _isExpanded.value = false;
  }

  void toggleExpansion() => _isExpanded.value = !_isExpanded.value;

  /// ═══════════════════════════════════════════════════════════
  /// 🎤 Process Voice Input
  /// ═══════════════════════════════════════════════════════════
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

    // منع الطلبات المكررة خلال 3 ثواني
    final now = DateTime.now();
    if (_isProcessingRequest &&
        _lastProcessedText == trimmedText &&
        _lastProcessTime != null &&
        now.difference(_lastProcessTime!).inSeconds < 3) {
      debugPrint('⚠️ Controller - طلب مكرر تم منعه!');
      debugPrint('⚠️ النص: "$trimmedText"');
      return;
    }

    debugPrint('📥 استقبال نص من Widget: "$trimmedText"');

    _isProcessingRequest = true;
    _lastProcessedText = trimmedText;
    _lastProcessTime = now;

    _voiceText.value = trimmedText;
    _confidenceLevel.value = confidence;
    updateContext(section, screen);

    await _processVoiceInput();

    // إعادة تعيين بعد 3 ثواني
    Future.delayed(const Duration(seconds: 3), () {
      _isProcessingRequest = false;
    });
  }

  /// ═══════════════════════════════════════════════════════════
  /// ⚙️ Process Voice Input (Send to API)
  /// ═══════════════════════════════════════════════════════════
  Future<void> _processVoiceInput() async {
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
        lat: "24.7321",
        lng: "46.74321",
        language: "ar",
        q: _currentSection,
        s: _currentScreen,
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

  /// ═══════════════════════════════════════════════════════════
  /// 🎯 Handle Success Response + ROUTING LOGIC
  /// ═══════════════════════════════════════════════════════════
  void _handleSuccessResponse(SendDataModel response) {
    final data = response.data;
    final destination = data.d;

    _currentMessage.value = destination.message;
    debugPrint('💬 رسالة الرد: ${destination.message}');

    // ═══════════════════════════════════════════════════════════
    // 🔊 تشغيل الصوت أولاً
    // ═══════════════════════════════════════════════════════════
    if (destination.mp3.isNotEmpty) {
      _isLoadingAudio.value = true;
      _currentMessage.value = 'جاري تحميل الرد الصوتي...';
      debugPrint('🎵 تحميل MP3: ${destination.mp3}');
      _playAudioFromUrl(destination.mp3);
    } else if (destination.message.isNotEmpty) {
      _isLoadingAudio.value = true;
      _currentMessage.value = 'جاري تحضير الرد...';
      debugPrint('🔊 تحضير النطق');
      speak(destination.message);
    }

    _isExpanded.value = true;

    // ═══════════════════════════════════════════════════════════
    // 🧭 ROUTING COMPARISON & NAVIGATION
    // ═══════════════════════════════════════════════════════════
    debugPrint('🧭 ════════════════════════════════════');
    debugPrint('🧭 ROUTING COMPARISON:');
    debugPrint('📍 Current: q=${data.q}, s=${data.s}');
    debugPrint(
        '🎯 Target:  section=${destination.section}, screen=${destination.screen}');

    // ✅ فحص إذا كانت section و screen null - لا تنقل
    if (destination.section == "" || destination.screen == "") {
      debugPrint(
          'ℹ️ No navigation target (section/screen is null) - Staying on current screen');
      return;
    }

    final needsNavigation =
        data.q != destination.section || data.s != destination.screen;

    if (needsNavigation) {
      debugPrint(
          '✅ Navigation required - Moving to ${destination.section}-${destination.screen}');

      // الانتقال بعد انتهاء الصوت (بعد ثانية)
      Future.delayed(const Duration(seconds: 3), () {
        HawajRoutes.navigateTo(
          section: destination.section!,
          screen: destination.screen!,
          parameters: {},
          replace: false,
        );
      });
    } else {
      debugPrint('ℹ️ Already on target screen - No navigation needed');
    }
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🎵 Play Audio from URL
  /// ═══════════════════════════════════════════════════════════
  Future<void> _playAudioFromUrl(String url) async {
    try {
      await _audioPlayer.stop();
      await _flutterTts.stop();

      debugPrint('⏳ بدء تحميل الصوت...');

      await _audioPlayer.play(UrlSource(url));

      debugPrint('✅ بدأ تشغيل الصوت من URL');
    } catch (e) {
      debugPrint('❌ فشل تشغيل MP3: $e');
      _isLoadingAudio.value = false;

      if (_currentMessage.value.isNotEmpty) {
        speak(_currentMessage.value);
      } else {
        _resetToIdle();
      }
    }
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🔊 Text-to-Speech
  /// ═══════════════════════════════════════════════════════════
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    debugPrint('🔊 بدء النطق: "$text"');
    await _flutterTts.stop();
    await _audioPlayer.stop();

    await Future.delayed(const Duration(milliseconds: 300));

    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    debugPrint('🛑 إيقاف النطق');
    await _flutterTts.stop();
    await _audioPlayer.stop();
    _isSpeaking.value = false;
    _isLoadingAudio.value = false;
  }

  void clearResponse() {
    _voiceText.value = '';
    _partialText.value = '';
    _confidenceLevel.value = 0.0;
    _clearError();
  }

  void _resetToIdle() {
    debugPrint('🔄 إعادة التعيين للوضع الخامل');
    _isListening.value = false;
    _isProcessing.value = false;
    _isSpeaking.value = false;
    _isLoadingAudio.value = false;
    _currentMessage.value = 'انقر للتحدث';
  }

  void _setError(String message) {
    debugPrint('⚠️ خطأ: $message');
    _hasError.value = true;
    _errorMessage.value = message;
    _currentMessage.value = message;
    _isListening.value = false;
    _isProcessing.value = false;
    _isSpeaking.value = false;
    _isLoadingAudio.value = false;

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
// enum HawajState { idle, listening, processing, loadingAudio, speaking, error }
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
//   final _isLoadingAudio = false.obs; // ✅ جديد: حالة تحميل الصوت
//   final _hasError = false.obs;
//   final _isInitialized = false.obs;
//
//   // === Messages & Text ===
//   final _currentMessage = 'مرحباً! كيف يمكنني مساعدتك؟'.obs;
//   final _voiceText = ''.obs;
//   final _partialText = ''.obs;
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
//   bool get isLoadingAudio => _isLoadingAudio.value; // ✅ جديد
//   bool get hasError => _hasError.value;
//
//   bool get isInitialized => _isInitialized.value;
//
//   String get currentMessage => _currentMessage.value;
//
//   String get voiceText => _voiceText.value;
//
//   String get partialText => _partialText.value;
//
//   String get errorMessage => _errorMessage.value;
//
//   double get confidenceLevel => _confidenceLevel.value;
//
//   String get currentSection => _section;
//
//   String get currentScreen => _screen;
//   bool _isProcessingRequest = false;
//   String? _lastProcessedText;
//   DateTime? _lastProcessTime;
//
//   HawajState get currentState {
//     if (_hasError.value) return HawajState.error;
//     if (_isProcessing.value) return HawajState.processing;
//     if (_isLoadingAudio.value) return HawajState.loadingAudio; // ✅ جديد
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
//       case HawajState.loadingAudio: // ✅ جديد
//         return Colors.orange;
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
//       case HawajState.loadingAudio: // ✅ جديد
//         return Icons.cloud_download;
//       case HawajState.speaking:
//         return Icons.volume_up;
//       case HawajState.error:
//         return Icons.error;
//       default:
//         return Icons.assistant;
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     _initializeSystem();
//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       _isSpeaking.value = (state == PlayerState.playing);
//
//       // ✅ عند اكتمال التشغيل، إيقاف حالة التحميل
//       if (state == PlayerState.completed) {
//         _isLoadingAudio.value = false;
//       }
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
//   Future<void> _initializeSystem() async {
//     try {
//       final micStatus = await Permission.microphone.request();
//       if (!micStatus.isGranted) {
//         _setError('يجب منح إذن الميكروفون.');
//         return;
//       }
//
//       final locStatus = await Permission.location.request();
//       if (!locStatus.isGranted) {
//         _setError('يجب منح إذن الموقع.');
//         return;
//       }
//
//       final pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       _latitude = pos.latitude;
//       _longitude = pos.longitude;
//
//       final speechAvailable = await _speechToText.initialize(
//         debugLogging: true,
//       );
//
//       if (!speechAvailable) {
//         _setError('خدمة التعرف على الكلام غير متاحة.');
//         return;
//       }
//
//       await _flutterTts.setLanguage("ar-SA");
//       await _flutterTts.setSpeechRate(0.85);
//       await _flutterTts.setVolume(1.0);
//
//       _flutterTts.setStartHandler(() {
//         _isSpeaking.value = true;
//         _isLoadingAudio.value = false; // ✅ بدأ النطق، أوقف التحميل
//         debugPrint('🔊 بدأ النطق');
//       });
//
//       _flutterTts.setCompletionHandler(() {
//         _isSpeaking.value = false;
//         _isLoadingAudio.value = false;
//         debugPrint('✅ انتهى النطق');
//       });
//
//       _flutterTts.setErrorHandler((msg) {
//         _isSpeaking.value = false;
//         _isLoadingAudio.value = false;
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
//   void updateContext(String section, String screen, {String? message}) {
//     _section = section;
//     _screen = screen;
//     if (message != null) _currentMessage.value = message;
//   }
//
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
//     // منع الطلبات المكررة خلال 3 ثواني
//     final now = DateTime.now();
//     if (_isProcessingRequest &&
//         _lastProcessedText == trimmedText &&
//         _lastProcessTime != null &&
//         now.difference(_lastProcessTime!).inSeconds < 3) {
//       debugPrint('⚠️ Controller - طلب مكرر تم منعه!');
//       debugPrint('⚠️ النص: "$trimmedText"');
//       return;
//     }
//
//     debugPrint('📥 استقبال نص من Widget: "$trimmedText"');
//
//     _isProcessingRequest = true;
//     _lastProcessedText = trimmedText;
//     _lastProcessTime = now;
//
//     _voiceText.value = trimmedText;
//     _confidenceLevel.value = confidence;
//     updateContext(section, screen);
//
//     await _processVoiceInput();
//
//     // إعادة تعيين بعد 3 ثواني
//     Future.delayed(const Duration(seconds: 3), () {
//       _isProcessingRequest = false;
//     });
//   }
//
//   // Future<void> processVoiceInputFromWidget(
//   //   String voiceText,
//   //   double confidence, {
//   //   required String section,
//   //   required String screen,
//   // }) async {
//   //   final trimmedText = voiceText.trim();
//   //
//   //   if (trimmedText.isEmpty) {
//   //     debugPrint('⚠️ نص فارغ، لن تتم المعالجة');
//   //     return;
//   //   }
//   //
//   //   debugPrint('📥 استقبال نص من Widget: "$trimmedText"');
//   //
//   //   _voiceText.value = trimmedText;
//   //   _confidenceLevel.value = confidence;
//   //   updateContext(section, screen);
//   //
//   //   await _processVoiceInput();
//   // }
//
//   Future<void> _processVoiceInput() async {
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
//         strl: "حواج بدي اتعشى رتب الموضوع شو في عندكم اكل",
//         // strl: textToProcess,
//         lat: (_latitude ?? 0).toString(),
//         lng: (_longitude ?? 0).toString(),
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
//     // ✅ تفعيل حالة "جاري تحضير الصوت"
//     if (destination.mp3.isNotEmpty) {
//       _isLoadingAudio.value = true;
//       _currentMessage.value = 'جاري تحميل الرد الصوتي...';
//       debugPrint('🎵 تحميل MP3: ${destination.mp3}');
//       _playAudioFromUrl(destination.mp3);
//     } else if (destination.message.isNotEmpty) {
//       _isLoadingAudio.value = true;
//       _currentMessage.value = 'جاري تحضير الرد...';
//       debugPrint('🔊 تحضير النطق');
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
//
//       // ✅ إضافة مؤشر تحميل
//       debugPrint('⏳ بدء تحميل الصوت...');
//
//       await _audioPlayer.play(UrlSource(url));
//
//       debugPrint('✅ بدأ تشغيل الصوت من URL');
//     } catch (e) {
//       debugPrint('❌ فشل تشغيل MP3: $e');
//       _isLoadingAudio.value = false;
//
//       if (_currentMessage.value.isNotEmpty) {
//         speak(_currentMessage.value);
//       } else {
//         _resetToIdle();
//       }
//     }
//   }
//
//   Future<void> speak(String text) async {
//     if (text.isEmpty) return;
//
//     debugPrint('🔊 بدء النطق: "$text"');
//     await _flutterTts.stop();
//     await _audioPlayer.stop();
//
//     // ✅ TTS سريع، لكن نترك حالة التحميل تظهر لمدة قصيرة
//     await Future.delayed(const Duration(milliseconds: 300));
//
//     await _flutterTts.speak(text);
//   }
//
//   Future<void> stopSpeaking() async {
//     debugPrint('🛑 إيقاف النطق');
//     await _flutterTts.stop();
//     await _audioPlayer.stop();
//     _isSpeaking.value = false;
//     _isLoadingAudio.value = false;
//   }
//
//   void clearResponse() {
//     _voiceText.value = '';
//     _partialText.value = '';
//     _confidenceLevel.value = 0.0;
//     _clearError();
//   }
//
//   void _resetToIdle() {
//     debugPrint('🔄 إعادة التعيين للوضع الخامل');
//     _isListening.value = false;
//     _isProcessing.value = false;
//     _isSpeaking.value = false;
//     _isLoadingAudio.value = false;
//     _currentMessage.value = 'انقر للتحدث';
//   }
//
//   void _setError(String message) {
//     debugPrint('⚠️ خطأ: $message');
//     _hasError.value = true;
//     _errorMessage.value = message;
//     _currentMessage.value = message;
//     _isListening.value = false;
//     _isProcessing.value = false;
//     _isSpeaking.value = false;
//     _isLoadingAudio.value = false;
//
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
