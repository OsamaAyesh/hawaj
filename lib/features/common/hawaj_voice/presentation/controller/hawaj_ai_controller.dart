import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
import '../../data/request/send_data_request.dart';
import '../../domain/models/job_item_hawaj_details_model.dart';
import '../../domain/models/organization_item_hawaj_details_model.dart';
import '../../domain/models/property_item_hawaj_details_model.dart';
import '../../domain/models/send_data_model.dart';
import '../../domain/use_cases/send_data_to_hawaj_use_case.dart';

enum HawajState { idle, listening, processing, loadingAudio, speaking, error }

class HawajController extends GetxController {
  final SendDataToHawajUseCase _sendDataUseCase;

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

  HawajController(this._sendDataUseCase);

  // ===== States =====
  final _isVisible = false.obs;
  final _isExpanded = false.obs;
  final _isListening = false.obs;
  final _isSpeaking = false.obs;
  final _isProcessing = false.obs;
  final _isLoadingAudio = false.obs;
  final _hasError = false.obs;
  final _isInitialized = false.obs;

  // ===== Texts =====
  final _currentMessage = 'مرحباً! كيف يمكنني مساعدتك؟'.obs;
  final _voiceText = ''.obs;
  final _partialText = ''.obs;
  final _errorMessage = ''.obs;
  final _confidenceLevel = 0.0.obs;

  // ===== Context =====
  String _currentSection = '';
  String _currentScreen = '';

  // ===== Location =====
  double? _latitude;
  double? _longitude;

  // ===== Duplicate Request Prevention =====
  bool _isProcessingRequest = false;
  String? _lastProcessedText;
  DateTime? _lastProcessTime;
  void Function()? onDataClear;
  void Function()? onDataReady;
  void Function()? onAnimateCamera;

  // ═══════════════════════════════════════════════════════════
  // 🎯 Hawaj Data (للبيانات القادمة من الـ API)
  // ═══════════════════════════════════════════════════════════
  final _hawajJobs = <JobItemHawajDetailsModel>[].obs;
  final _hawajOffers = <OrganizationItemHawajDetailsModel>[].obs;
  final _hawajProperties = <PropertyItemHawajDetailsModel>[].obs;
  final _currentDataType = Rxn<String>(); // 'jobs', 'offers', 'properties'

  // ===== Getters =====
  bool get isVisible => _isVisible.value;

  bool get isExpanded => _isExpanded.value;

  bool get isListening => _isListening.value;

  bool get isSpeaking => _isSpeaking.value;

  bool get isProcessing => _isProcessing.value;

  bool get isLoadingAudio => _isLoadingAudio.value;

  bool get hasError => _hasError.value;

  bool get isInitialized => _isInitialized.value;

  String get currentMessage => _currentMessage.value;

  double get confidenceLevel => _confidenceLevel.value;

  String get currentSection => _currentSection;

  String get currentScreen => _currentScreen;

  // 🎯 Getters للبيانات
  List<JobItemHawajDetailsModel> get hawajJobs => _hawajJobs;

  List<OrganizationItemHawajDetailsModel> get hawajOffers => _hawajOffers;

  List<PropertyItemHawajDetailsModel> get hawajProperties => _hawajProperties;

  String? get currentDataType => _currentDataType.value;

  //
  bool get hasHawajData =>
      _hawajJobs.isNotEmpty ||
      _hawajOffers.isNotEmpty ||
      _hawajProperties.isNotEmpty;
  final RxBool hasHawajDataRx = false.obs;

  int get hawajDataCount {
    if (_currentDataType.value == 'jobs') return _hawajJobs.length;
    if (_currentDataType.value == 'offers') return _hawajOffers.length;
    if (_currentDataType.value == 'properties') return _hawajProperties.length;
    return 0;
  }

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
      if (state == PlayerState.completed) _isLoadingAudio.value = false;
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

      final speechAvailable =
          await _speechToText.initialize(debugLogging: true);
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
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking.value = false;
        _isLoadingAudio.value = false;
      });

      _flutterTts.setErrorHandler((msg) {
        _setError('خطأ في النطق: $msg');
      });

      _isInitialized.value = true;
      debugPrint('✅ [Hawaj] System initialized successfully');
    } catch (e) {
      _setError('فشل التهيئة: $e');
    }
  }

  void updateContext(String section, String screen, {String? message}) {
    _currentSection = section;
    _currentScreen = screen;
    if (message != null) _currentMessage.value = message;
    debugPrint('📍 [Hawaj] Context: Section=$section, Screen=$screen');
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
  /// 🎤 استقبال النص الصوتي من الـ Widget
  /// ═══════════════════════════════════════════════════════════
  Future<void> processVoiceInputFromWidget(
    String voiceText,
    double confidence, {
    required String section,
    required String screen,
  }) async {
    final trimmedText = voiceText.trim();
    if (trimmedText.isEmpty) return;

    final now = DateTime.now();
    if (_isProcessingRequest &&
        _lastProcessedText == trimmedText &&
        _lastProcessTime != null &&
        now.difference(_lastProcessTime!).inSeconds < 3) {
      debugPrint('⚠️ [Hawaj] طلب مكرر تم منعه!');
      return;
    }

    _isProcessingRequest = true;
    _lastProcessedText = trimmedText;
    _lastProcessTime = now;

    _voiceText.value = trimmedText;
    _confidenceLevel.value = confidence;
    updateContext(section, screen);

    await _processVoiceInput();

    Future.delayed(const Duration(seconds: 3), () {
      _isProcessingRequest = false;
    });
  }

  /// ═══════════════════════════════════════════════════════════
  /// ⚙️ إرسال النص للذكاء الاصطناعي
  /// ═══════════════════════════════════════════════════════════
  Future<void> _processVoiceInput() async {
    final textToProcess = _voiceText.value.trim().isEmpty
        ? _partialText.value.trim()
        : _voiceText.value.trim();

    if (textToProcess.isEmpty) {
      _resetToIdle();
      return;
    }

    _isProcessing.value = true;
    _currentMessage.value = 'جارٍ معالجة طلبك...';

    // 🧹 مسح البيانات القديمة
    clearHawajData();

    try {
      final request = SendDataRequest(
        strl: textToProcess,
        lat: (_latitude ?? 0).toString(),
        lng: (_longitude ?? 0).toString(),
        language: "ar",
        q: _currentSection,
        s: _currentScreen,
      );

      debugPrint('📤 [Hawaj] Sending: "$textToProcess"');
      final result = await _sendDataUseCase.execute(request);

      result.fold(
        (failure) => _setError(failure.message),
        (response) => _handleSuccessResponse(response),
      );
    } catch (e) {
      _setError('فشل الطلب: $e');
    } finally {
      _isProcessing.value = false;
    }
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🎯 التعامل مع الرد الكامل من السيرفر
  /// ═══════════════════════════════════════════════════════════
  void _handleSuccessResponse(SendDataModel response) {
    final data = response.data;
    final destination = data.aiResponse;
    final results = data.d;
    // 🧹 امسح البيانات القديمة وأخبر الخريطة تبدأ Overlay
    onDataClear?.call();

    _currentMessage.value = destination.message;
    debugPrint('💬 [Hawaj] Response: ${destination.message}');

    // 📦 تحميل البيانات الجديدة
    if (results.jobs?.isNotEmpty == true) {
      _hawajJobs.value = results.jobs!;
      _currentDataType.value = 'jobs';
    } else if (results.offers?.isNotEmpty == true) {
      _hawajOffers.value = results.offers!;
      _currentDataType.value = 'offers';
    } else if (results.properties?.isNotEmpty == true) {
      _hawajProperties.value = results.properties!;
      _currentDataType.value = 'properties';
    }

    // ✅ إشعار الخريطة بأن البيانات الجديدة جاهزة
    Future.delayed(const Duration(milliseconds: 600), () {
      onDataReady?.call();
    });

    // ✅ تحريك الكاميرا بعد قليل
    Future.delayed(const Duration(milliseconds: 1600), () {
      onAnimateCamera?.call();
    });

    _currentMessage.value = destination.message;
    debugPrint('💬 [Hawaj] Response: ${destination.message}');

    // ═══════════════════════════════════════════════════════════
    // 📦 تخزين البيانات القادمة
    // ═══════════════════════════════════════════════════════════
    if (results.jobs?.isNotEmpty == true) {
      _hawajJobs.value = results.jobs!;
      _currentDataType.value = 'jobs';
      debugPrint('✅ [Hawaj] ${_hawajJobs.length} وظيفة محملة');
    } else if (results.offers?.isNotEmpty == true) {
      _hawajOffers.value = results.offers!;
      _currentDataType.value = 'offers';
      debugPrint('✅ [Hawaj] ${_hawajOffers.length} عرض محمل');
    } else if (results.properties?.isNotEmpty == true) {
      _hawajProperties.value = results.properties!;
      _currentDataType.value = 'properties';
      debugPrint('✅ [Hawaj] ${_hawajProperties.length} عقار محمل');
    }

    // ═══════════════════════════════════════════════════════════
    // 🔊 تشغيل الصوت
    // ═══════════════════════════════════════════════════════════
    if (destination.mp3.isNotEmpty) {
      _isLoadingAudio.value = true;
      _currentMessage.value = 'جاري تشغيل الرد الصوتي...';
      _playAudioFromUrl(destination.mp3);
    } else if (destination.message.isNotEmpty) {
      _isLoadingAudio.value = true;
      _currentMessage.value = 'جاري تحضير الرد...';
      speak(destination.message);
    } else {
      _resetToIdle();
    }

    _isExpanded.value = true;

    // ═══════════════════════════════════════════════════════════
    // 🧭 التنقل (إذا لزم الأمر)
    // ═══════════════════════════════════════════════════════════
    if (destination.section.isEmpty || destination.screen.isEmpty) {
      debugPrint('ℹ️ [Hawaj] لا يوجد وجهة تنقل');
      return;
    }

    final needsNavigation =
        data.q != destination.section || data.s != destination.screen;

    if (needsNavigation) {
      debugPrint(
          '✈️ [Hawaj] الانتقال إلى ${destination.section}-${destination.screen}');
      Future.delayed(const Duration(seconds: 3), () {
        HawajRoutes.navigateTo(
          section: destination.section,
          screen: destination.screen,
          parameters: {
            'hawajData': true,
          },
          replace: false,
        );
      });
      hasHawajDataRx.value = _hawajJobs.isNotEmpty ||
          _hawajOffers.isNotEmpty ||
          _hawajProperties.isNotEmpty;
    } else {
      debugPrint('ℹ️ [Hawaj] البقاء في الشاشة الحالية');
    }
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🎵 Play Audio from URL
  /// ═══════════════════════════════════════════════════════════
  Future<void> _playAudioFromUrl(String url) async {
    try {
      await _flutterTts.stop();
      await _audioPlayer.stop();

      debugPrint('🎧 [Hawaj] تشغيل الصوت: $url');
      await _audioPlayer.play(UrlSource(url));

      _isSpeaking.value = true;
      _isLoadingAudio.value = false;
    } catch (e) {
      debugPrint('❌ [Hawaj] خطأ في الصوت: $e');
      _isLoadingAudio.value = false;

      if (_currentMessage.value.isNotEmpty) {
        speak(_currentMessage.value);
      }
    }
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    await _flutterTts.stop();
    await _audioPlayer.stop();
    await Future.delayed(const Duration(milliseconds: 300));
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    debugPrint('🛑 [Hawaj] إيقاف النطق');
    await _flutterTts.stop();
    await _audioPlayer.stop();
    _isSpeaking.value = false;
    _isLoadingAudio.value = false;
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🧹 Clear Hawaj Data
  /// ═══════════════════════════════════════════════════════════
  void clearHawajData() {
    _hawajJobs.clear();
    _hawajOffers.clear();
    _hawajProperties.clear();
    _currentDataType.value = null;
    debugPrint('🧹 [Hawaj] تم مسح البيانات');
  }

  void _resetToIdle() {
    _isListening.value = false;
    _isProcessing.value = false;
    _isSpeaking.value = false;
    _isLoadingAudio.value = false;
    _currentMessage.value = 'انقر للتحدث';
  }

  void _setError(String message) {
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
// import '../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
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
//   // ===== States =====
//   final _isVisible = false.obs;
//   final _isExpanded = false.obs;
//   final _isListening = false.obs;
//   final _isSpeaking = false.obs;
//   final _isProcessing = false.obs;
//   final _isLoadingAudio = false.obs;
//   final _hasError = false.obs;
//   final _isInitialized = false.obs;
//
//   // ===== Texts =====
//   final _currentMessage = 'مرحباً! كيف يمكنني مساعدتك؟'.obs;
//   final _voiceText = ''.obs;
//   final _partialText = ''.obs;
//   final _errorMessage = ''.obs;
//   final _confidenceLevel = 0.0.obs;
//
//   // ===== Context =====
//   String _currentSection = '';
//   String _currentScreen = '';
//
//   // ===== Location =====
//   double? _latitude;
//   double? _longitude;
//
//   // ===== Duplicate Request Prevention =====
//   bool _isProcessingRequest = false;
//   String? _lastProcessedText;
//   DateTime? _lastProcessTime;
//
//   // ===== Getters =====
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
//   bool get isLoadingAudio => _isLoadingAudio.value;
//
//   bool get hasError => _hasError.value;
//
//   bool get isInitialized => _isInitialized.value;
//
//   String get currentMessage => _currentMessage.value;
//
//   double get confidenceLevel => _confidenceLevel.value;
//
//   String get currentSection => _currentSection;
//
//   String get currentScreen => _currentScreen;
//
//   HawajState get currentState {
//     if (_hasError.value) return HawajState.error;
//     if (_isProcessing.value) return HawajState.processing;
//     if (_isLoadingAudio.value) return HawajState.loadingAudio;
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
//       case HawajState.loadingAudio:
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
//       case HawajState.loadingAudio:
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
//       if (state == PlayerState.completed) _isLoadingAudio.value = false;
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
//       final speechAvailable =
//           await _speechToText.initialize(debugLogging: true);
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
//         _isLoadingAudio.value = false;
//       });
//
//       _flutterTts.setCompletionHandler(() {
//         _isSpeaking.value = false;
//         _isLoadingAudio.value = false;
//       });
//
//       _flutterTts.setErrorHandler((msg) {
//         _setError('خطأ في النطق: $msg');
//       });
//
//       _isInitialized.value = true;
//       debugPrint('✅ System initialized successfully');
//     } catch (e) {
//       _setError('فشل التهيئة: $e');
//     }
//   }
//
//   void updateContext(String section, String screen, {String? message}) {
//     _currentSection = section;
//     _currentScreen = screen;
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
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎤 استقبال النص الصوتي من الـ Widget
//   /// ═══════════════════════════════════════════════════════════
//   Future<void> processVoiceInputFromWidget(
//     String voiceText,
//     double confidence, {
//     required String section,
//     required String screen,
//   }) async {
//     final trimmedText = voiceText.trim();
//     if (trimmedText.isEmpty) return;
//
//     final now = DateTime.now();
//     if (_isProcessingRequest &&
//         _lastProcessedText == trimmedText &&
//         _lastProcessTime != null &&
//         now.difference(_lastProcessTime!).inSeconds < 3) {
//       debugPrint('⚠️ طلب مكرر تم منعه!');
//       return;
//     }
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
//     Future.delayed(const Duration(seconds: 3), () {
//       _isProcessingRequest = false;
//     });
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// ⚙️ إرسال النص للذكاء الاصطناعي
//   /// ═══════════════════════════════════════════════════════════
//   Future<void> _processVoiceInput() async {
//     final textToProcess = _voiceText.value.trim().isEmpty
//         ? _partialText.value.trim()
//         : _voiceText.value.trim();
//
//     if (textToProcess.isEmpty) {
//       _resetToIdle();
//       return;
//     }
//
//     _isProcessing.value = true;
//     _currentMessage.value = 'جارٍ معالجة طلبك...';
//
//     try {
//       final request = SendDataRequest(
//         strl: textToProcess,
//         lat: (_latitude ?? 0).toString(),
//         lng: (_longitude ?? 0).toString(),
//         language: "ar",
//         q: _currentSection,
//         s: _currentScreen,
//       );
//
//       final result = await _sendDataUseCase.execute(request);
//
//       result.fold(
//         (failure) => _setError(failure.message),
//         (response) => _handleSuccessResponse(response),
//       );
//     } catch (e) {
//       _setError('فشل الطلب: $e');
//     } finally {
//       _isProcessing.value = false;
//     }
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎯 التعامل مع الرد الكامل من السيرفر
//   /// ═══════════════════════════════════════════════════════════
//   // void _handleSuccessResponse(SendDataModel response) {
//   //   final data = response.data;
//   //   final results = data.d; // SendDataResultsModel
//   //   final destination = data.aiResponse; // ✅ SendDataDestinationModel
//   //
//   //   // ✅ الرسالة الصوتية
//   //   _currentMessage.value = destination.message;
//   //   if (destination.mp3.isNotEmpty) {
//   //     _isLoadingAudio.value = true;
//   //     _currentMessage.value = 'جاري تحميل الرد الصوتي...';
//   //     _playAudioFromUrl(destination.mp3);
//   //   } else if (destination.message.isNotEmpty) {
//   //     _isLoadingAudio.value = true;
//   //     _currentMessage.value = 'جاري تحضير الرد...';
//   //     speak(destination.message);
//   //   }
//   //   _isExpanded.value = true;
//   //
//   //   // ✅ الفحص والملاحة
//   //   if (destination.section.isEmpty || destination.screen.isEmpty) return;
//   //
//   //   final needsNavigation =
//   //       data.q != destination.section || data.s != destination.screen;
//   //   final isJobsScreen = destination.section == "5";
//   //
//   //   if (needsNavigation) {
//   //     Future.delayed(const Duration(seconds: 3), () {
//   //       HawajRoutes.navigateTo(
//   //         section: destination.section,
//   //         screen: destination.screen,
//   //         parameters: {
//   //           "offers": results.offers,
//   //           "properties": results.properties,
//   //           "jobs": results.jobs,
//   //         },
//   //         replace: false,
//   //       );
//   //     });
//   //   } else if (isJobsScreen && results.jobs?.isNotEmpty == true) {
//   //     debugPrint("✅ وظائف جاهزة: ${results.jobs?.length}");
//   //   }
//   // }
//   // void _handleSuccessResponse(SendDataModel response) {
//   //   final data = response.data;
//   //
//   //   // ✅ الجديد: استخدم aiResponse و d
//   //   final destination =
//   //       data.aiResponse; // يحتوي على message, mp3, section, screen
//   //   final results = data.d; // يحتوي على offers, properties, jobs
//   //
//   //   _currentMessage.value = destination.message;
//   //   debugPrint('💬 رسالة الرد: ${destination.message}');
//   //
//   //   // ✅ تشغيل الصوت أو النطق
//   //   if (destination.mp3.isNotEmpty) {
//   //     _isLoadingAudio.value = true;
//   //     _currentMessage.value = 'جاري تحميل الرد الصوتي...';
//   //     debugPrint('🎵 تحميل MP3: ${destination.mp3}');
//   //     _playAudioFromUrl(destination.mp3);
//   //   } else if (destination.message.isNotEmpty) {
//   //     _isLoadingAudio.value = true;
//   //     _currentMessage.value = 'جاري تحضير الرد...';
//   //     debugPrint('🔊 تحضير النطق');
//   //     speak(destination.message);
//   //   } else {
//   //     _resetToIdle();
//   //   }
//   //
//   //   _isExpanded.value = true;
//   //
//   //   // ✅ لا تنقل إذا section أو screen فارغين
//   //   if ((destination.section).isEmpty || (destination.screen).isEmpty) {
//   //     debugPrint('ℹ️ لا يوجد وجهة تنقل محددة.');
//   //     return;
//   //   }
//   //
//   //   // ✅ المقارنة بين الشاشات الحالية والجديدة
//   //   final needsNavigation =
//   //       data.q != destination.section || data.s != destination.screen;
//   //
//   //   if (needsNavigation) {
//   //     debugPrint(
//   //         '✅ الانتقال إلى Section=${destination.section}, Screen=${destination.screen}');
//   //     Future.delayed(const Duration(seconds: 3), () {
//   //       HawajRoutes.navigateTo(
//   //         section: destination.section,
//   //         screen: destination.screen,
//   //         parameters: {
//   //           'offers': results.offers,
//   //           'properties': results.properties,
//   //           'jobs': results.jobs,
//   //         },
//   //         replace: false,
//   //       );
//   //     });
//   //   } else {
//   //     debugPrint('ℹ️ أنت بالفعل في الشاشة المطلوبة - لن يتم الانتقال.');
//   //   }
//   // }
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎯 Handle Success Response + ROUTING LOGIC (with fast audio)
//   /// ═══════════════════════════════════════════════════════════
//   void _handleSuccessResponse(SendDataModel response) {
//     final data = response.data;
//
//     // ✅ استخدم aiResponse للوجهة و d للنتائج
//     final destination = data.aiResponse;
//     final results = data.d;
//
//     _currentMessage.value = destination.message;
//     debugPrint('💬 رسالة الرد: ${destination.message}');
//
//     // ✅ تشغيل الصوت فورًا بنفس الآلية القديمة الممتازة
//     if (destination.mp3.isNotEmpty) {
//       _isLoadingAudio.value = true;
//       _currentMessage.value = 'جاري تشغيل الرد الصوتي...';
//       debugPrint('🎵 تشغيل MP3 مباشر: ${destination.mp3}');
//       _playAudioFromUrl(destination.mp3);
//     } else if (destination.message.isNotEmpty) {
//       _isLoadingAudio.value = true;
//       _currentMessage.value = 'جاري تحضير الرد...';
//       speak(destination.message);
//     } else {
//       _resetToIdle();
//     }
//
//     _isExpanded.value = true;
//
//     // ✅ التحقق من التنقل
//     if ((destination.section).isEmpty || (destination.screen).isEmpty) {
//       debugPrint('ℹ️ لا يوجد وجهة تنقل محددة.');
//       return;
//     }
//
//     final needsNavigation =
//         data.q != destination.section || data.s != destination.screen;
//
//     if (needsNavigation) {
//       Future.delayed(const Duration(seconds: 3), () {
//         HawajRoutes.navigateTo(
//           section: destination.section,
//           screen: destination.screen,
//           parameters: {
//             'offers': results.offers,
//             'properties': results.properties,
//             'jobs': results.jobs,
//           },
//           replace: false,
//         );
//       });
//     } else {
//       debugPrint('ℹ️ أنت بالفعل في الشاشة المطلوبة - لن يتم الانتقال.');
//     }
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎵 Play Audio from URL (optimized fast version)
//   /// ═══════════════════════════════════════════════════════════
//   Future<void> _playAudioFromUrl(String url) async {
//     try {
//       await _flutterTts.stop();
//       await _audioPlayer.stop();
//
//       debugPrint('🎧 بدء تشغيل الصوت من الرابط: $url');
//
//       // ✅ تشغيل مباشر بدون تحميل مسبق
//       await _audioPlayer.play(UrlSource(url));
//
//       _isSpeaking.value = true;
//       _isLoadingAudio.value = false;
//       debugPrint('✅ الصوت يعمل الآن بنجاح');
//     } catch (e) {
//       debugPrint('❌ خطأ في تشغيل الصوت: $e');
//       _isLoadingAudio.value = false;
//
//       if (_currentMessage.value.isNotEmpty) {
//         speak(_currentMessage.value);
//       }
//     }
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
//   // Future<void> _playAudioFromUrl(String url) async {
//   //   try {
//   //     await _audioPlayer.stop();
//   //     await _flutterTts.stop();
//   //     await _audioPlayer.play(UrlSource(url));
//   //   } catch (e) {
//   //     _isLoadingAudio.value = false;
//   //     if (_currentMessage.value.isNotEmpty) speak(_currentMessage.value);
//   //   }
//   // }
//
//   Future<void> speak(String text) async {
//     if (text.isEmpty) return;
//     await _flutterTts.stop();
//     await _audioPlayer.stop();
//     await Future.delayed(const Duration(milliseconds: 300));
//     await _flutterTts.speak(text);
//   }
//
//   void _resetToIdle() {
//     _isListening.value = false;
//     _isProcessing.value = false;
//     _isSpeaking.value = false;
//     _isLoadingAudio.value = false;
//     _currentMessage.value = 'انقر للتحدث';
//   }
//
//   void _setError(String message) {
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
//
// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_tts/flutter_tts.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:get/get.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:speech_to_text/speech_to_text.dart';
// //
// // import '../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
// // import '../../../../users/offer_user/list_offers/presentation/controller/get_organizations_controller.dart';
// // import '../../../map/presenation/controller/map_controller.dart';
// // import '../../data/request/send_data_request.dart';
// // import '../../domain/models/send_data_model.dart';
// // import '../../domain/use_cases/send_data_to_hawaj_use_case.dart';
// //
// // enum HawajState { idle, listening, processing, loadingAudio, speaking, error }
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
// //   final _isLoadingAudio = false.obs;
// //   final _hasError = false.obs;
// //   final _isInitialized = false.obs;
// //
// //   // === Messages & Text ===
// //   final _currentMessage = 'مرحباً! كيف يمكنني مساعدتك؟'.obs;
// //   final _voiceText = ''.obs;
// //   final _partialText = ''.obs;
// //   final _errorMessage = ''.obs;
// //   final _confidenceLevel = 0.0.obs;
// //
// //   // === Context (Current Section & Screen) ===
// //   String _currentSection = '';
// //   String _currentScreen = '';
// //
// //   // === Location ===
// //   double? _latitude;
// //   double? _longitude;
// //
// //   // === Duplicate Request Prevention ===
// //   bool _isProcessingRequest = false;
// //   String? _lastProcessedText;
// //   DateTime? _lastProcessTime;
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
// //   bool get isLoadingAudio => _isLoadingAudio.value;
// //
// //   bool get hasError => _hasError.value;
// //
// //   bool get isInitialized => _isInitialized.value;
// //
// //   String get currentMessage => _currentMessage.value;
// //
// //   String get voiceText => _voiceText.value;
// //
// //   String get partialText => _partialText.value;
// //
// //   String get errorMessage => _errorMessage.value;
// //
// //   double get confidenceLevel => _confidenceLevel.value;
// //
// //   String get currentSection => _currentSection;
// //
// //   String get currentScreen => _currentScreen;
// //
// //   HawajState get currentState {
// //     if (_hasError.value) return HawajState.error;
// //     if (_isProcessing.value) return HawajState.processing;
// //     if (_isLoadingAudio.value) return HawajState.loadingAudio;
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
// //       case HawajState.loadingAudio:
// //         return Colors.orange;
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
// //       case HawajState.loadingAudio:
// //         return Icons.cloud_download;
// //       case HawajState.speaking:
// //         return Icons.volume_up;
// //       case HawajState.error:
// //         return Icons.error;
// //       default:
// //         return Icons.assistant;
// //     }
// //   }
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _initializeSystem();
// //     _audioPlayer.onPlayerStateChanged.listen((state) {
// //       _isSpeaking.value = (state == PlayerState.playing);
// //
// //       if (state == PlayerState.completed) {
// //         _isLoadingAudio.value = false;
// //       }
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
// //   Future<void> _initializeSystem() async {
// //     try {
// //       final micStatus = await Permission.microphone.request();
// //       if (!micStatus.isGranted) {
// //         _setError('يجب منح إذن الميكروفون.');
// //         return;
// //       }
// //
// //       final locStatus = await Permission.location.request();
// //       if (!locStatus.isGranted) {
// //         _setError('يجب منح إذن الموقع.');
// //         return;
// //       }
// //
// //       final pos = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high,
// //       );
// //       _latitude = pos.latitude;
// //       _longitude = pos.longitude;
// //
// //       final speechAvailable = await _speechToText.initialize(
// //         debugLogging: true,
// //       );
// //
// //       if (!speechAvailable) {
// //         _setError('خدمة التعرف على الكلام غير متاحة.');
// //         return;
// //       }
// //
// //       await _flutterTts.setLanguage("ar-SA");
// //       await _flutterTts.setSpeechRate(0.85);
// //       await _flutterTts.setVolume(1.0);
// //
// //       _flutterTts.setStartHandler(() {
// //         _isSpeaking.value = true;
// //         _isLoadingAudio.value = false;
// //         debugPrint('🔊 بدأ النطق');
// //       });
// //
// //       _flutterTts.setCompletionHandler(() {
// //         _isSpeaking.value = false;
// //         _isLoadingAudio.value = false;
// //         debugPrint('✅ انتهى النطق');
// //       });
// //
// //       _flutterTts.setErrorHandler((msg) {
// //         _isSpeaking.value = false;
// //         _isLoadingAudio.value = false;
// //         _setError('خطأ في النطق: $msg');
// //       });
// //
// //       _isInitialized.value = true;
// //       debugPrint('✅ تمت تهيئة النظام بنجاح');
// //     } catch (e) {
// //       _setError('فشل التهيئة: $e');
// //     }
// //   }
// //
// //   /// ═══════════════════════════════════════════════════════════
// //   /// 📍 Update Current Context
// //   /// ═══════════════════════════════════════════════════════════
// //   void updateContext(String section, String screen, {String? message}) {
// //     _currentSection = section;
// //     _currentScreen = screen;
// //     if (message != null) _currentMessage.value = message;
// //
// //     debugPrint('📍 Context Updated: Section=$section, Screen=$screen');
// //   }
// //
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
// //   /// ═══════════════════════════════════════════════════════════
// //   /// 🎤 Process Voice Input
// //   /// ═══════════════════════════════════════════════════════════
// //   Future<void> processVoiceInputFromWidget(
// //     String voiceText,
// //     double confidence, {
// //     required String section,
// //     required String screen,
// //   }) async {
// //     final trimmedText = voiceText.trim();
// //
// //     if (trimmedText.isEmpty) {
// //       debugPrint('⚠️ نص فارغ، لن تتم المعالجة');
// //       return;
// //     }
// //
// //     // منع الطلبات المكررة خلال 3 ثواني
// //     final now = DateTime.now();
// //     if (_isProcessingRequest &&
// //         _lastProcessedText == trimmedText &&
// //         _lastProcessTime != null &&
// //         now.difference(_lastProcessTime!).inSeconds < 3) {
// //       debugPrint('⚠️ Controller - طلب مكرر تم منعه!');
// //       debugPrint('⚠️ النص: "$trimmedText"');
// //       return;
// //     }
// //
// //     debugPrint('📥 استقبال نص من Widget: "$trimmedText"');
// //
// //     _isProcessingRequest = true;
// //     _lastProcessedText = trimmedText;
// //     _lastProcessTime = now;
// //
// //     _voiceText.value = trimmedText;
// //     _confidenceLevel.value = confidence;
// //     updateContext(section, screen);
// //
// //     await _processVoiceInput();
// //
// //     // إعادة تعيين بعد 3 ثواني
// //     Future.delayed(const Duration(seconds: 3), () {
// //       _isProcessingRequest = false;
// //     });
// //   }
// //
// //   /// ═══════════════════════════════════════════════════════════
// //   /// ⚙️ Process Voice Input (Send to API)
// //   /// ═══════════════════════════════════════════════════════════
// //   Future<void> _processVoiceInput() async {
// //     final textToProcess = _voiceText.value.trim().isEmpty
// //         ? _partialText.value.trim()
// //         : _voiceText.value.trim();
// //
// //     if (textToProcess.isEmpty) {
// //       debugPrint('⚠️ لا يوجد نص للمعالجة');
// //       _resetToIdle();
// //       return;
// //     }
// //
// //     debugPrint('⚙️ بدء معالجة النص: "$textToProcess"');
// //
// //     _isProcessing.value = true;
// //     _currentMessage.value = 'جارٍ معالجة طلبك...';
// //
// //     try {
// //       final request = SendDataRequest(
// //         strl: textToProcess,
// //         lat: (_latitude ?? 0).toString(),
// //         lng: (_longitude ?? 0).toString(),
// //         language: "ar",
// //         q: _currentSection,
// //         s: _currentScreen,
// //       );
// //
// //       final result = await _sendDataUseCase.execute(request);
// //
// //       result.fold(
// //         (failure) {
// //           debugPrint('❌ فشل الطلب: ${failure.message}');
// //           _setError(failure.message);
// //           _resetToIdle();
// //         },
// //         (response) {
// //           debugPrint('✅ استلام الرد من الخادم');
// //           _handleSuccessResponse(response);
// //         },
// //       );
// //     } catch (e) {
// //       debugPrint('❌ خطأ غير متوقع: $e');
// //       _setError('فشل الطلب: $e');
// //       _resetToIdle();
// //     } finally {
// //       _isProcessing.value = false;
// //     }
// //   }
// //
// //   /// ═══════════════════════════════════════════════════════════
// //   /// 🎯 Handle Success Response + ROUTING LOGIC
// //   /// ═══════════════════════════════════════════════════════════
// //   // void _handleSuccessResponse(SendDataModel response) {
// //   //   final data = response.data;
// //   //   final destination = data.d;
// //   //
// //   //   _currentMessage.value = destination.message;
// //   //   debugPrint('💬 رسالة الرد: ${destination.message}');
// //   //
// //   //   // ═══════════════════════════════════════════════════════════
// //   //   // 🔊 تشغيل الصوت أولاً
// //   //   // ═══════════════════════════════════════════════════════════
// //   //   if (destination.mp3.isNotEmpty) {
// //   //     _isLoadingAudio.value = true;
// //   //     _currentMessage.value = 'جاري تحميل الرد الصوتي...';
// //   //     debugPrint('🎵 تحميل MP3: ${destination.mp3}');
// //   //     _playAudioFromUrl(destination.mp3);
// //   //   } else if (destination.message.isNotEmpty) {
// //   //     _isLoadingAudio.value = true;
// //   //     _currentMessage.value = 'جاري تحضير الرد...';
// //   //     debugPrint('🔊 تحضير النطق');
// //   //     speak(destination.message);
// //   //   }
// //   //
// //   //   _isExpanded.value = true;
// //   //
// //   //   // ═══════════════════════════════════════════════════════════
// //   //   // 🧭 ROUTING COMPARISON & NAVIGATION
// //   //   // ═══════════════════════════════════════════════════════════
// //   //   debugPrint('🧭 ════════════════════════════════════');
// //   //   debugPrint('🧭 ROUTING COMPARISON:');
// //   //   debugPrint('📍 Current: q=${data.q}, s=${data.s}');
// //   //   debugPrint(
// //   //       '🎯 Target:  section=${destination.section}, screen=${destination.screen}');
// //   //
// //   //   // ✅ فحص إذا كانت section و screen null - لا تنقل
// //   //   if (destination.section == "" || destination.screen == "") {
// //   //     debugPrint(
// //   //         'ℹ️ No navigation target (section/screen is null) - Staying on current screen');
// //   //     return;
// //   //   }
// //   //
// //   //   final needsNavigation =
// //   //       data.q != destination.section || data.s != destination.screen;
// //   //
// //   //   if (needsNavigation) {
// //   //     debugPrint(
// //   //         '✅ Navigation required - Moving to ${destination.section}-${destination.screen}');
// //   //
// //   //     // الانتقال بعد انتهاء الصوت (بعد ثانية)
// //   //     Future.delayed(const Duration(seconds: 3), () {
// //   //       HawajRoutes.navigateTo(
// //   //         section: destination.section!,
// //   //         screen: destination.screen!,
// //   //         parameters: {},
// //   //         replace: false,
// //   //       );
// //   //     });
// //   //   } else {
// //   //     debugPrint('ℹ️ Already on target screen - No navigation needed');
// //   //   }
// //   // }
// //   void _handleSuccessResponse(SendDataModel response) {
// //     final data = response.data;
// //     final destination = data.d;
// //
// //     _currentMessage.value = destination.message;
// //     if (destination.mp3.isNotEmpty) {
// //       _isLoadingAudio.value = true;
// //       _currentMessage.value = 'جاري تحميل الرد الصوتي...';
// //       _playAudioFromUrl(destination.mp3);
// //     } else if (destination.message.isNotEmpty) {
// //       _isLoadingAudio.value = true;
// //       _currentMessage.value = 'جاري تحضير الرد...';
// //       speak(destination.message);
// //     }
// //     _isExpanded.value = true;
// //
// //     // 🔎 لا تنقل إذا ما فيه وجهة
// //     if ((destination.section ?? '').isEmpty ||
// //         (destination.screen ?? '').isEmpty) {
// //       return;
// //     }
// //
// //     final needsNavigation =
// //         data.q != destination.section || data.s != destination.screen;
// //     final isMapTarget = destination.section == "1" && destination.screen == "1";
// //
// //     if (needsNavigation) {
// //       // 👇 انتقل ومرّر autoRefresh=true عشان MapScreen تطلب النتائج بنفسها
// //       Future.delayed(const Duration(seconds: 3), () {
// //         HawajRoutes.navigateTo(
// //           section: destination.section!,
// //           screen: destination.screen!,
// //           parameters: {'autoRefresh': isMapTarget}, // 👈 مهم
// //           replace: false,
// //         );
// //       });
// //     } else {
// //       // إحنا فعلاً على الشاشة المطلوبة
// //       if (isMapTarget) {
// //         if (Get.isRegistered<MapController>() &&
// //             Get.isRegistered<OffersController>()) {
// //           final mapC = Get.find<MapController>();
// //           final offersC = Get.find<OffersController>();
// //
// //           Future(() async {
// //             if (mapC.currentLocation.value == null) {
// //               await mapC.loadCurrentLocation();
// //             }
// //             final loc = mapC.currentLocation.value;
// //             if (loc != null) {
// //               offersC.isFirstLoad.value =
// //                   true; // يخلي MapScreen يحرّك الكاميرا عبر ever(...)
// //               await offersC.fetchOffers(loc); // طلب جديد
// //             } else {
// //               debugPrint('⚠️ لم يتمكن من تحديد الموقع لتحديث العروض');
// //             }
// //           });
// //         } else {
// //           // احتياط: لو الكنترولرات مش جاهزة، انتقل وخلّ MapScreen تعمل autoRefresh
// //           Future.delayed(const Duration(seconds: 1), () {
// //             HawajRoutes.navigateTo(
// //               section: "1",
// //               screen: "1",
// //               parameters: {'autoRefresh': true},
// //               replace: false,
// //             );
// //           });
// //         }
// //       }
// //     }
// //   }
// //
// //   /// ═══════════════════════════════════════════════════════════
// //   /// 🎵 Play Audio from URL
// //   /// ═══════════════════════════════════════════════════════════
// //   Future<void> _playAudioFromUrl(String url) async {
// //     try {
// //       await _audioPlayer.stop();
// //       await _flutterTts.stop();
// //
// //       debugPrint('⏳ بدء تحميل الصوت...');
// //
// //       await _audioPlayer.play(UrlSource(url));
// //
// //       debugPrint('✅ بدأ تشغيل الصوت من URL');
// //     } catch (e) {
// //       debugPrint('❌ فشل تشغيل MP3: $e');
// //       _isLoadingAudio.value = false;
// //
// //       if (_currentMessage.value.isNotEmpty) {
// //         speak(_currentMessage.value);
// //       } else {
// //         _resetToIdle();
// //       }
// //     }
// //   }
// //
// //   /// ═══════════════════════════════════════════════════════════
// //   /// 🔊 Text-to-Speech
// //   /// ═══════════════════════════════════════════════════════════
// //   Future<void> speak(String text) async {
// //     if (text.isEmpty) return;
// //
// //     debugPrint('🔊 بدء النطق: "$text"');
// //     await _flutterTts.stop();
// //     await _audioPlayer.stop();
// //
// //     await Future.delayed(const Duration(milliseconds: 300));
// //
// //     await _flutterTts.speak(text);
// //   }
// //
// //   Future<void> stopSpeaking() async {
// //     debugPrint('🛑 إيقاف النطق');
// //     await _flutterTts.stop();
// //     await _audioPlayer.stop();
// //     _isSpeaking.value = false;
// //     _isLoadingAudio.value = false;
// //   }
// //
// //   void clearResponse() {
// //     _voiceText.value = '';
// //     _partialText.value = '';
// //     _confidenceLevel.value = 0.0;
// //     _clearError();
// //   }
// //
// //   void _resetToIdle() {
// //     debugPrint('🔄 إعادة التعيين للوضع الخامل');
// //     _isListening.value = false;
// //     _isProcessing.value = false;
// //     _isSpeaking.value = false;
// //     _isLoadingAudio.value = false;
// //     _currentMessage.value = 'انقر للتحدث';
// //   }
// //
// //   void _setError(String message) {
// //     debugPrint('⚠️ خطأ: $message');
// //     _hasError.value = true;
// //     _errorMessage.value = message;
// //     _currentMessage.value = message;
// //     _isListening.value = false;
// //     _isProcessing.value = false;
// //     _isSpeaking.value = false;
// //     _isLoadingAudio.value = false;
// //
// //     Future.delayed(const Duration(seconds: 3), () {
// //       if (_hasError.value) {
// //         _clearError();
// //         _resetToIdle();
// //       }
// //     });
// //   }
// //
// //   void _clearError() {
// //     _hasError.value = false;
// //     _errorMessage.value = '';
// //   }
// // }
// // // import 'package:audioplayers/audioplayers.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_tts/flutter_tts.dart';
// // // import 'package:geolocator/geolocator.dart';
// // // import 'package:get/get.dart';
// // // import 'package:permission_handler/permission_handler.dart';
// // // import 'package:speech_to_text/speech_to_text.dart';
// // //
// // // import '../../data/request/send_data_request.dart';
// // // import '../../domain/models/send_data_model.dart';
// // // import '../../domain/use_cases/send_data_to_hawaj_use_case.dart';
// // //
// // // enum HawajState { idle, listening, processing, loadingAudio, speaking, error }
// // //
// // // class HawajController extends GetxController {
// // //   final SendDataToHawajUseCase _sendDataUseCase;
// // //
// // //   final SpeechToText _speechToText = SpeechToText();
// // //   final FlutterTts _flutterTts = FlutterTts();
// // //   final AudioPlayer _audioPlayer = AudioPlayer();
// // //
// // //   HawajController(this._sendDataUseCase);
// // //
// // //   // === UI States ===
// // //   final _isVisible = false.obs;
// // //   final _isExpanded = false.obs;
// // //   final _isListening = false.obs;
// // //   final _isSpeaking = false.obs;
// // //   final _isProcessing = false.obs;
// // //   final _isLoadingAudio = false.obs; // ✅ جديد: حالة تحميل الصوت
// // //   final _hasError = false.obs;
// // //   final _isInitialized = false.obs;
// // //
// // //   // === Messages & Text ===
// // //   final _currentMessage = 'مرحباً! كيف يمكنني مساعدتك؟'.obs;
// // //   final _voiceText = ''.obs;
// // //   final _partialText = ''.obs;
// // //   final _errorMessage = ''.obs;
// // //   final _confidenceLevel = 0.0.obs;
// // //
// // //   // === Context ===
// // //   String _section = '';
// // //   String _screen = '';
// // //
// // //   // === Location ===
// // //   double? _latitude;
// // //   double? _longitude;
// // //
// // //   // === Public Getters ===
// // //   bool get isVisible => _isVisible.value;
// // //
// // //   bool get isExpanded => _isExpanded.value;
// // //
// // //   bool get isListening => _isListening.value;
// // //
// // //   bool get isSpeaking => _isSpeaking.value;
// // //
// // //   bool get isProcessing => _isProcessing.value;
// // //
// // //   bool get isLoadingAudio => _isLoadingAudio.value; // ✅ جديد
// // //   bool get hasError => _hasError.value;
// // //
// // //   bool get isInitialized => _isInitialized.value;
// // //
// // //   String get currentMessage => _currentMessage.value;
// // //
// // //   String get voiceText => _voiceText.value;
// // //
// // //   String get partialText => _partialText.value;
// // //
// // //   String get errorMessage => _errorMessage.value;
// // //
// // //   double get confidenceLevel => _confidenceLevel.value;
// // //
// // //   String get currentSection => _section;
// // //
// // //   String get currentScreen => _screen;
// // //   bool _isProcessingRequest = false;
// // //   String? _lastProcessedText;
// // //   DateTime? _lastProcessTime;
// // //
// // //   HawajState get currentState {
// // //     if (_hasError.value) return HawajState.error;
// // //     if (_isProcessing.value) return HawajState.processing;
// // //     if (_isLoadingAudio.value) return HawajState.loadingAudio; // ✅ جديد
// // //     if (_isSpeaking.value) return HawajState.speaking;
// // //     if (_isListening.value) return HawajState.listening;
// // //     return HawajState.idle;
// // //   }
// // //
// // //   Color get stateColor {
// // //     switch (currentState) {
// // //       case HawajState.listening:
// // //         return Colors.green;
// // //       case HawajState.processing:
// // //         return Colors.blue;
// // //       case HawajState.loadingAudio: // ✅ جديد
// // //         return Colors.orange;
// // //       case HawajState.speaking:
// // //         return Colors.purple;
// // //       case HawajState.error:
// // //         return Colors.red;
// // //       default:
// // //         return Colors.grey;
// // //     }
// // //   }
// // //
// // //   IconData get stateIcon {
// // //     switch (currentState) {
// // //       case HawajState.listening:
// // //         return Icons.mic;
// // //       case HawajState.processing:
// // //         return Icons.psychology;
// // //       case HawajState.loadingAudio: // ✅ جديد
// // //         return Icons.cloud_download;
// // //       case HawajState.speaking:
// // //         return Icons.volume_up;
// // //       case HawajState.error:
// // //         return Icons.error;
// // //       default:
// // //         return Icons.assistant;
// // //     }
// // //   }
// // //
// // //   @override
// // //   void onInit() {
// // //     super.onInit();
// // //     _initializeSystem();
// // //     _audioPlayer.onPlayerStateChanged.listen((state) {
// // //       _isSpeaking.value = (state == PlayerState.playing);
// // //
// // //       // ✅ عند اكتمال التشغيل، إيقاف حالة التحميل
// // //       if (state == PlayerState.completed) {
// // //         _isLoadingAudio.value = false;
// // //       }
// // //     });
// // //   }
// // //
// // //   @override
// // //   void onClose() {
// // //     _speechToText.stop();
// // //     _flutterTts.stop();
// // //     _audioPlayer.dispose();
// // //     super.onClose();
// // //   }
// // //
// // //   Future<void> _initializeSystem() async {
// // //     try {
// // //       final micStatus = await Permission.microphone.request();
// // //       if (!micStatus.isGranted) {
// // //         _setError('يجب منح إذن الميكروفون.');
// // //         return;
// // //       }
// // //
// // //       final locStatus = await Permission.location.request();
// // //       if (!locStatus.isGranted) {
// // //         _setError('يجب منح إذن الموقع.');
// // //         return;
// // //       }
// // //
// // //       final pos = await Geolocator.getCurrentPosition(
// // //         desiredAccuracy: LocationAccuracy.high,
// // //       );
// // //       _latitude = pos.latitude;
// // //       _longitude = pos.longitude;
// // //
// // //       final speechAvailable = await _speechToText.initialize(
// // //         debugLogging: true,
// // //       );
// // //
// // //       if (!speechAvailable) {
// // //         _setError('خدمة التعرف على الكلام غير متاحة.');
// // //         return;
// // //       }
// // //
// // //       await _flutterTts.setLanguage("ar-SA");
// // //       await _flutterTts.setSpeechRate(0.85);
// // //       await _flutterTts.setVolume(1.0);
// // //
// // //       _flutterTts.setStartHandler(() {
// // //         _isSpeaking.value = true;
// // //         _isLoadingAudio.value = false; // ✅ بدأ النطق، أوقف التحميل
// // //         debugPrint('🔊 بدأ النطق');
// // //       });
// // //
// // //       _flutterTts.setCompletionHandler(() {
// // //         _isSpeaking.value = false;
// // //         _isLoadingAudio.value = false;
// // //         debugPrint('✅ انتهى النطق');
// // //       });
// // //
// // //       _flutterTts.setErrorHandler((msg) {
// // //         _isSpeaking.value = false;
// // //         _isLoadingAudio.value = false;
// // //         _setError('خطأ في النطق: $msg');
// // //       });
// // //
// // //       _isInitialized.value = true;
// // //       debugPrint('✅ تمت تهيئة النظام بنجاح');
// // //     } catch (e) {
// // //       _setError('فشل التهيئة: $e');
// // //     }
// // //   }
// // //
// // //   void updateContext(String section, String screen, {String? message}) {
// // //     _section = section;
// // //     _screen = screen;
// // //     if (message != null) _currentMessage.value = message;
// // //   }
// // //
// // //   void show({String? message}) {
// // //     _isVisible.value = true;
// // //     if (message != null) _currentMessage.value = message;
// // //   }
// // //
// // //   void hide() {
// // //     _isVisible.value = false;
// // //     _isExpanded.value = false;
// // //   }
// // //
// // //   void toggleExpansion() => _isExpanded.value = !_isExpanded.value;
// // //
// // //   Future<void> processVoiceInputFromWidget(
// // //     String voiceText,
// // //     double confidence, {
// // //     required String section,
// // //     required String screen,
// // //   }) async {
// // //     final trimmedText = voiceText.trim();
// // //
// // //     if (trimmedText.isEmpty) {
// // //       debugPrint('⚠️ نص فارغ، لن تتم المعالجة');
// // //       return;
// // //     }
// // //
// // //     // منع الطلبات المكررة خلال 3 ثواني
// // //     final now = DateTime.now();
// // //     if (_isProcessingRequest &&
// // //         _lastProcessedText == trimmedText &&
// // //         _lastProcessTime != null &&
// // //         now.difference(_lastProcessTime!).inSeconds < 3) {
// // //       debugPrint('⚠️ Controller - طلب مكرر تم منعه!');
// // //       debugPrint('⚠️ النص: "$trimmedText"');
// // //       return;
// // //     }
// // //
// // //     debugPrint('📥 استقبال نص من Widget: "$trimmedText"');
// // //
// // //     _isProcessingRequest = true;
// // //     _lastProcessedText = trimmedText;
// // //     _lastProcessTime = now;
// // //
// // //     _voiceText.value = trimmedText;
// // //     _confidenceLevel.value = confidence;
// // //     updateContext(section, screen);
// // //
// // //     await _processVoiceInput();
// // //
// // //     // إعادة تعيين بعد 3 ثواني
// // //     Future.delayed(const Duration(seconds: 3), () {
// // //       _isProcessingRequest = false;
// // //     });
// // //   }
// // //
// // //   // Future<void> processVoiceInputFromWidget(
// // //   //   String voiceText,
// // //   //   double confidence, {
// // //   //   required String section,
// // //   //   required String screen,
// // //   // }) async {
// // //   //   final trimmedText = voiceText.trim();
// // //   //
// // //   //   if (trimmedText.isEmpty) {
// // //   //     debugPrint('⚠️ نص فارغ، لن تتم المعالجة');
// // //   //     return;
// // //   //   }
// // //   //
// // //   //   debugPrint('📥 استقبال نص من Widget: "$trimmedText"');
// // //   //
// // //   //   _voiceText.value = trimmedText;
// // //   //   _confidenceLevel.value = confidence;
// // //   //   updateContext(section, screen);
// // //   //
// // //   //   await _processVoiceInput();
// // //   // }
// // //
// // //   Future<void> _processVoiceInput() async {
// // //     final textToProcess = _voiceText.value.trim().isEmpty
// // //         ? _partialText.value.trim()
// // //         : _voiceText.value.trim();
// // //
// // //     if (textToProcess.isEmpty) {
// // //       debugPrint('⚠️ لا يوجد نص للمعالجة');
// // //       _resetToIdle();
// // //       return;
// // //     }
// // //
// // //     debugPrint('⚙️ بدء معالجة النص: "$textToProcess"');
// // //
// // //     _isProcessing.value = true;
// // //     _currentMessage.value = 'جارٍ معالجة طلبك...';
// // //
// // //     try {
// // //       final request = SendDataRequest(
// // //         strl: "حواج بدي اتعشى رتب الموضوع شو في عندكم اكل",
// // //         // strl: textToProcess,
// // //         lat: (_latitude ?? 0).toString(),
// // //         lng: (_longitude ?? 0).toString(),
// // //         language: "ar",
// // //         q: _section,
// // //         s: _screen,
// // //       );
// // //
// // //       final result = await _sendDataUseCase.execute(request);
// // //
// // //       result.fold(
// // //         (failure) {
// // //           debugPrint('❌ فشل الطلب: ${failure.message}');
// // //           _setError(failure.message);
// // //           _resetToIdle();
// // //         },
// // //         (response) {
// // //           debugPrint('✅ استلام الرد من الخادم');
// // //           _handleSuccessResponse(response);
// // //         },
// // //       );
// // //     } catch (e) {
// // //       debugPrint('❌ خطأ غير متوقع: $e');
// // //       _setError('فشل الطلب: $e');
// // //       _resetToIdle();
// // //     } finally {
// // //       _isProcessing.value = false;
// // //     }
// // //   }
// // //
// // //   void _handleSuccessResponse(SendDataModel response) {
// // //     final data = response.data;
// // //     final destination = data.d;
// // //
// // //     _currentMessage.value = destination.message;
// // //     debugPrint('💬 رسالة الرد: ${destination.message}');
// // //
// // //     // ✅ تفعيل حالة "جاري تحضير الصوت"
// // //     if (destination.mp3.isNotEmpty) {
// // //       _isLoadingAudio.value = true;
// // //       _currentMessage.value = 'جاري تحميل الرد الصوتي...';
// // //       debugPrint('🎵 تحميل MP3: ${destination.mp3}');
// // //       _playAudioFromUrl(destination.mp3);
// // //     } else if (destination.message.isNotEmpty) {
// // //       _isLoadingAudio.value = true;
// // //       _currentMessage.value = 'جاري تحضير الرد...';
// // //       debugPrint('🔊 تحضير النطق');
// // //       speak(destination.message);
// // //     } else {
// // //       _resetToIdle();
// // //     }
// // //
// // //     _isExpanded.value = true;
// // //   }
// // //
// // //   Future<void> _playAudioFromUrl(String url) async {
// // //     try {
// // //       await _audioPlayer.stop();
// // //       await _flutterTts.stop();
// // //
// // //       // ✅ إضافة مؤشر تحميل
// // //       debugPrint('⏳ بدء تحميل الصوت...');
// // //
// // //       await _audioPlayer.play(UrlSource(url));
// // //
// // //       debugPrint('✅ بدأ تشغيل الصوت من URL');
// // //     } catch (e) {
// // //       debugPrint('❌ فشل تشغيل MP3: $e');
// // //       _isLoadingAudio.value = false;
// // //
// // //       if (_currentMessage.value.isNotEmpty) {
// // //         speak(_currentMessage.value);
// // //       } else {
// // //         _resetToIdle();
// // //       }
// // //     }
// // //   }
// // //
// // //   Future<void> speak(String text) async {
// // //     if (text.isEmpty) return;
// // //
// // //     debugPrint('🔊 بدء النطق: "$text"');
// // //     await _flutterTts.stop();
// // //     await _audioPlayer.stop();
// // //
// // //     // ✅ TTS سريع، لكن نترك حالة التحميل تظهر لمدة قصيرة
// // //     await Future.delayed(const Duration(milliseconds: 300));
// // //
// // //     await _flutterTts.speak(text);
// // //   }
// // //
// // //   Future<void> stopSpeaking() async {
// // //     debugPrint('🛑 إيقاف النطق');
// // //     await _flutterTts.stop();
// // //     await _audioPlayer.stop();
// // //     _isSpeaking.value = false;
// // //     _isLoadingAudio.value = false;
// // //   }
// // //
// // //   void clearResponse() {
// // //     _voiceText.value = '';
// // //     _partialText.value = '';
// // //     _confidenceLevel.value = 0.0;
// // //     _clearError();
// // //   }
// // //
// // //   void _resetToIdle() {
// // //     debugPrint('🔄 إعادة التعيين للوضع الخامل');
// // //     _isListening.value = false;
// // //     _isProcessing.value = false;
// // //     _isSpeaking.value = false;
// // //     _isLoadingAudio.value = false;
// // //     _currentMessage.value = 'انقر للتحدث';
// // //   }
// // //
// // //   void _setError(String message) {
// // //     debugPrint('⚠️ خطأ: $message');
// // //     _hasError.value = true;
// // //     _errorMessage.value = message;
// // //     _currentMessage.value = message;
// // //     _isListening.value = false;
// // //     _isProcessing.value = false;
// // //     _isSpeaking.value = false;
// // //     _isLoadingAudio.value = false;
// // //
// // //     Future.delayed(const Duration(seconds: 3), () {
// // //       if (_hasError.value) {
// // //         _clearError();
// // //         _resetToIdle();
// // //       }
// // //     });
// // //   }
// // //
// // //   void _clearError() {
// // //     _hasError.value = false;
// // //     _errorMessage.value = '';
// // //   }
// // // }
