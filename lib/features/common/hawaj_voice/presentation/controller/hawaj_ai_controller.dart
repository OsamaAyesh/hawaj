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
  /// 📲 إرسال طلب مباشر من الـ Drawer (بدون صوت)
  /// ═══════════════════════════════════════════════════════════
  Future<void> sendDirectRequest({
    required String command,
    String? section,
    String? screen,
  }) async {
    if (command.isEmpty) {
      debugPrint('⚠️ [Hawaj] لا يمكن إرسال طلب فارغ');
      return;
    }

    // استخدام الـ section والـ screen الحاليين إذا لم يتم تمريرهم
    final requestSection = section ?? _currentSection;
    final requestScreen = screen ?? _currentScreen;

    debugPrint('📲 [Hawaj] إرسال طلب مباشر: "$command"');
    debugPrint(
        '📍 [Hawaj] Context: Section=$requestSection, Screen=$requestScreen');

    _isProcessing.value = true;
    _currentMessage.value = 'جارٍ معالجة طلبك...';
    clearHawajData();

    try {
      final request = SendDataRequest(
        strl: command,
        lat: (_latitude ?? 0).toString(),
        lng: (_longitude ?? 0).toString(),
        language: "ar",
        q: requestSection,
        s: requestScreen,
      );

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
  void _handleSuccessResponse(SendDataModel response) async {
    final data = response.data;
    final results = data.d;

    // ═══════════════════════════════════════════════════════════
    // 📊 استخراج البيانات من الـ Response
    // ═══════════════════════════════════════════════════════════
    final currentSection = data.q; // القسم الحالي (للاستخدام في التنقل فقط)
    final currentScreen = data.s; // الشاشة الحالية (المرسلة) - s
    final targetScreen = results.screen; // الشاشة المستهدفة من الـ Response

    // ✅ تحديد الـ Section الصحيح بناءً على الـ targetScreen
    String targetSection = currentSection; // افتراضياً نفس الـ section

    // ✅ إذا الـ targetScreen هي شاشة خريطة، نحدد الـ section الصحيح
    final correctMapSection = _getCorrectSectionForMapScreen(targetScreen);
    if (correctMapSection != null) {
      targetSection = correctMapSection;
      debugPrint('🗺️ [Routing] تم تحديد Section الخريطة: $targetSection');
    }

    // ✅ المقارنة فقط بين s و screen
    final needsNavigation = _shouldNavigateToNewScreen(
      currentScreen: currentScreen,
      targetScreen: targetScreen,
    );

    debugPrint('🧭 [AI Routing] Current Screen (s): $currentScreen');
    debugPrint('🎯 [AI Routing] Target Screen: $targetScreen');
    debugPrint('🎯 [AI Routing] Target Section: $targetSection');
    debugPrint('🚦 [AI Routing] Needs Navigation: $needsNavigation');

    // ═══════════════════════════════════════════════════════════
    // 📍 التعامل الذكي مع الإحداثيات
    // ═══════════════════════════════════════════════════════════
    final responseLat = double.tryParse(results.lat) ?? 0.0;
    final responseLng = double.tryParse(results.lng) ?? 0.0;
    final userLat = _latitude ?? 0.0;
    final userLng = _longitude ?? 0.0;

    // ✅ إذا الإحداثيات مختلفة، استخدم من الـ Response
    final targetLat =
        _isLocationDifferent(responseLat, userLat) ? responseLat : userLat;
    final targetLng =
        _isLocationDifferent(responseLng, userLng) ? responseLng : userLng;

    debugPrint('📍 [Location] User: ($userLat, $userLng)');
    debugPrint('📍 [Location] Response: ($responseLat, $responseLng)');
    debugPrint('📍 [Location] Target: ($targetLat, $targetLng)');

    // ═══════════════════════════════════════════════════════════
    // 🗺️ تحديد نوع الوجهة (باستخدام targetSection و targetScreen)
    // ═══════════════════════════════════════════════════════════
    final isMapDestination = _isMapScreen(targetSection, targetScreen);
    final isCurrentlyMap = _isMapScreen(currentSection, currentScreen);

    debugPrint('🗺️ [Routing] Is Map Destination: $isMapDestination');
    debugPrint('🗺️ [Routing] Currently on Map: $isCurrentlyMap');

    // ═══════════════════════════════════════════════════════════
    // 📦 تحضير البيانات للإرسال
    // ═══════════════════════════════════════════════════════════
    final payload = {
      'offers': results.offers ?? [],
      'jobs': results.jobs ?? [],
      'properties': results.properties ?? [],
      'hawajData': true,
      'targetLat': targetLat,
      'targetLng': targetLng,
    };

    // ═══════════════════════════════════════════════════════════
    // 🎧 تشغيل الصوت أولاً (وانتظار انتهائه)
    // ═══════════════════════════════════════════════════════════
    await _playResponseAudio(
      mp3Url: results.mp3,
      message: results.message,
    );

    // ═══════════════════════════════════════════════════════════
    // 🧠 منطق التوجيه بعد انتهاء الصوت
    // ═══════════════════════════════════════════════════════════
    if (isMapDestination) {
      debugPrint('🗺️ [Routing] الوجهة خريطة → تجهيز البيانات');

      onDataClear?.call();
      _currentMessage.value = results.message;

      // تحميل البيانات حسب النوع
      if (results.jobs?.isNotEmpty == true) {
        _hawajJobs.value = results.jobs!;
        _currentDataType.value = 'jobs';
        debugPrint('✅ [Data] تم تحميل ${_hawajJobs.length} وظيفة');
      } else if (results.offers?.isNotEmpty == true) {
        _hawajOffers.value = results.offers!;
        _currentDataType.value = 'offers';
        debugPrint('✅ [Data] تم تحميل ${_hawajOffers.length} عرض');
      } else if (results.properties?.isNotEmpty == true) {
        _hawajProperties.value = results.properties!;
        _currentDataType.value = 'properties';
        debugPrint('✅ [Data] تم تحميل ${_hawajProperties.length} عقار');
      }

      if (isCurrentlyMap && !needsNavigation) {
        // ✅ نفس الشاشة على الخريطة → تحديث النتائج فقط
        debugPrint(
            '🧩 [Routing] نفس الشاشة (s=$currentScreen) → تحديث النتائج فقط');
        Future.delayed(
            const Duration(milliseconds: 600), () => onDataReady?.call());
        Future.delayed(
            const Duration(milliseconds: 1500), () => onAnimateCamera?.call());
      } else {
        // ✅ الشاشة مختلفة → انتقل
        debugPrint(
            '🚀 [Routing] الانتقال لشاشة جديدة: Section=$targetSection, Screen=$targetScreen');
        await Future.delayed(const Duration(milliseconds: 300));
        await HawajRoutes.navigateTo(
          section: targetSection, // ← استخدام targetSection المحدد
          screen: targetScreen,
          parameters: payload,
        );
      }
    } else {
      // ✅ الوجهة ليست خريطة
      debugPrint('📦 [Routing] الوجهة شاشة عادية → الانتقال');
      await Future.delayed(const Duration(milliseconds: 300));
      await HawajRoutes.navigateTo(
        section: targetSection, // ← استخدام targetSection المحدد
        screen: targetScreen,
        parameters: payload,
      );
    }

    _isExpanded.value = true;
    _isLoadingAudio.value = false;
    _isSpeaking.value = false;
    hasHawajDataRx.value = hasHawajData;
    debugPrint('✅ [Hawaj] اكتمل التوجيه بنجاح');
  }

  /// ✅ الحصول على الـ Section الصحيح بناءً على الـ screen فقط
  String? _getCorrectSectionForMapScreen(String screen) {
    const mapScreenToSection = {
      '1': '1', // Daily Offers Map → Section 1
      '17': '3', // Real Estates Map → Section 3
      '22': '5', // Jobs Map → Section 5
    };
    return mapScreenToSection[screen];
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🎧 تشغيل الصوت والانتظار حتى انتهائه
  /// ═══════════════════════════════════════════════════════════
  Future<void> _playResponseAudio({
    required String mp3Url,
    required String message,
  }) async {
    try {
      if (mp3Url.isNotEmpty) {
        _isLoadingAudio.value = true;
        _currentMessage.value = '🎧 جاري تشغيل الرد الصوتي...';
        debugPrint('🎧 [Audio] تشغيل MP3: $mp3Url');

        await _playAudioFromUrl(mp3Url);
        await _audioPlayer.onPlayerComplete.first;

        debugPrint('✅ [Audio] انتهى الصوت بنجاح');
      } else if (message.isNotEmpty) {
        _isLoadingAudio.value = true;
        _currentMessage.value = '🗣️ جاري تحضير الرد...';
        debugPrint('🗣️ [TTS] نطق الرسالة: $message');

        await speak(message);
        await Future.delayed(const Duration(seconds: 2));

        debugPrint('✅ [TTS] انتهى النطق بنجاح');
      } else {
        debugPrint('ℹ️ [Audio] لا يوجد صوت أو نص للنطق');
      }
    } catch (e) {
      debugPrint('❌ [Audio] فشل تشغيل الصوت: $e');
      _isLoadingAudio.value = false;
    }
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🔍 Helper Functions
  /// ═══════════════════════════════════════════════════════════

  /// ✅ تحديد ما إذا كانت الشاشة خريطة أم لا
  bool _isMapScreen(String section, String screen) {
    const mapScreens = [
      {'section': '1', 'screen': '1'}, // Daily Offers Map
      {'section': '3', 'screen': '1'}, // Real Estates Map
      {'section': '5', 'screen': '1'}, // Jobs Map
    ];
    return mapScreens.any(
      (e) => e['section'] == section && e['screen'] == screen,
    );
  }

  /// ✅ تحديد ما إذا كان يجب الانتقال لشاشة جديدة (بناءً على s و screen فقط)
  bool _shouldNavigateToNewScreen({
    required String currentScreen,
    required String targetScreen,
  }) {
    // ✅ المقارنة فقط بين s (currentScreen) و screen (targetScreen)
    if (currentScreen != targetScreen) {
      debugPrint(
          '🔄 [Navigation] Screen changed: s=$currentScreen → screen=$targetScreen');
      return true;
    }

    debugPrint(
        '⏸️ [Navigation] Same screen (s=$currentScreen), no navigation needed');
    return false;
  }

  /// ✅ تحديد ما إذا كانت الإحداثيات مختلفة بشكل معتبر
  bool _isLocationDifferent(double loc1, double loc2,
      {double threshold = 0.001}) {
    final difference = (loc1 - loc2).abs();
    final isDifferent = difference > threshold;

    if (isDifferent) {
      debugPrint(
          '📍 [Location] اختلاف كبير في الإحداثيات: ${difference.toStringAsFixed(6)}');
    }

    return isDifferent;
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
    hasHawajDataRx.value = false;
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
// import '../../domain/models/job_item_hawaj_details_model.dart';
// import '../../domain/models/organization_item_hawaj_details_model.dart';
// import '../../domain/models/property_item_hawaj_details_model.dart';
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
//   void Function()? onDataClear;
//   void Function()? onDataReady;
//   void Function()? onAnimateCamera;
//
//   // ═══════════════════════════════════════════════════════════
//   // 🎯 Hawaj Data (للبيانات القادمة من الـ API)
//   // ═══════════════════════════════════════════════════════════
//   final _hawajJobs = <JobItemHawajDetailsModel>[].obs;
//   final _hawajOffers = <OrganizationItemHawajDetailsModel>[].obs;
//   final _hawajProperties = <PropertyItemHawajDetailsModel>[].obs;
//   final _currentDataType = Rxn<String>(); // 'jobs', 'offers', 'properties'
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
//   // 🎯 Getters للبيانات
//   List<JobItemHawajDetailsModel> get hawajJobs => _hawajJobs;
//
//   List<OrganizationItemHawajDetailsModel> get hawajOffers => _hawajOffers;
//
//   List<PropertyItemHawajDetailsModel> get hawajProperties => _hawajProperties;
//
//   String? get currentDataType => _currentDataType.value;
//
//   bool get hasHawajData =>
//       _hawajJobs.isNotEmpty ||
//       _hawajOffers.isNotEmpty ||
//       _hawajProperties.isNotEmpty;
//   final RxBool hasHawajDataRx = false.obs;
//
//   int get hawajDataCount {
//     if (_currentDataType.value == 'jobs') return _hawajJobs.length;
//     if (_currentDataType.value == 'offers') return _hawajOffers.length;
//     if (_currentDataType.value == 'properties') return _hawajProperties.length;
//     return 0;
//   }
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
//       debugPrint('✅ [Hawaj] System initialized successfully');
//     } catch (e) {
//       _setError('فشل التهيئة: $e');
//     }
//   }
//
//   void updateContext(String section, String screen, {String? message}) {
//     _currentSection = section;
//     _currentScreen = screen;
//     if (message != null) _currentMessage.value = message;
//     debugPrint('📍 [Hawaj] Context: Section=$section, Screen=$screen');
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
//       debugPrint('⚠️ [Hawaj] طلب مكرر تم منعه!');
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
//   /// 📲 إرسال طلب مباشر من الـ Drawer (بدون صوت)
//   /// ═══════════════════════════════════════════════════════════
//   Future<void> sendDirectRequest({
//     required String command,
//     String? section,
//     String? screen,
//   }) async {
//     if (command.isEmpty) {
//       debugPrint('⚠️ [Hawaj] لا يمكن إرسال طلب فارغ');
//       return;
//     }
//
//     // استخدام الـ section والـ screen الحاليين إذا لم يتم تمريرهم
//     final requestSection = section ?? _currentSection;
//     final requestScreen = screen ?? _currentScreen;
//
//     debugPrint('📲 [Hawaj] إرسال طلب مباشر: "$command"');
//     debugPrint(
//         '📍 [Hawaj] Context: Section=$requestSection, Screen=$requestScreen');
//
//     _isProcessing.value = true;
//     _currentMessage.value = 'جارٍ معالجة طلبك...';
//     clearHawajData();
//
//     try {
//       final request = SendDataRequest(
//         strl: command,
//         lat: (_latitude ?? 0).toString(),
//         lng: (_longitude ?? 0).toString(),
//         language: "ar",
//         q: requestSection,
//         s: requestScreen,
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
//     // 🧹 مسح البيانات القديمة
//     clearHawajData();
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
//       debugPrint('📤 [Hawaj] Sending: "$textToProcess"');
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
//   void _handleSuccessResponse(SendDataModel response) async {
//     final data = response.data;
//     final results = data.d;
//
//     // ═══════════════════════════════════════════════════════════
//     // 📊 استخراج البيانات من الـ Response
//     // ═══════════════════════════════════════════════════════════
//     final currentSection = data.q; // القسم الحالي (للاستخدام في التنقل فقط)
//     final currentScreen = data.s; // الشاشة الحالية (المرسلة) - s
//     final targetScreen = results.screen; // الشاشة المستهدفة من الـ Response
//
//     // ✅ المقارنة فقط بين s و screen
//     final needsNavigation = _shouldNavigateToNewScreen(
//       currentScreen: currentScreen,
//       targetScreen: targetScreen,
//     );
//
//     debugPrint('🧭 [AI Routing] Current Screen (s): $currentScreen');
//     debugPrint('🎯 [AI Routing] Target Screen: $targetScreen');
//     debugPrint('🚦 [AI Routing] Needs Navigation: $needsNavigation');
//
//     // ═══════════════════════════════════════════════════════════
//     // 📍 التعامل الذكي مع الإحداثيات
//     // ═══════════════════════════════════════════════════════════
//     final responseLat = double.tryParse(results.lat) ?? 0.0;
//     final responseLng = double.tryParse(results.lng) ?? 0.0;
//     final userLat = _latitude ?? 0.0;
//     final userLng = _longitude ?? 0.0;
//
//     // ✅ إذا الإحداثيات مختلفة، استخدم من الـ Response
//     final targetLat =
//         _isLocationDifferent(responseLat, userLat) ? responseLat : userLat;
//     final targetLng =
//         _isLocationDifferent(responseLng, userLng) ? responseLng : userLng;
//
//     debugPrint('📍 [Location] User: ($userLat, $userLng)');
//     debugPrint('📍 [Location] Response: ($responseLat, $responseLng)');
//     debugPrint('📍 [Location] Target: ($targetLat, $targetLng)');
//
//     // ═══════════════════════════════════════════════════════════
//     // 🗺️ تحديد نوع الوجهة (باستخدام currentSection للـ q)
//     // ═══════════════════════════════════════════════════════════
//     final isMapDestination = _isMapScreen(currentSection, targetScreen);
//     final isCurrentlyMap = _isMapScreen(currentSection, currentScreen);
//
//     debugPrint('🗺️ [Routing] Is Map Destination: $isMapDestination');
//     debugPrint('🗺️ [Routing] Currently on Map: $isCurrentlyMap');
//
//     // ═══════════════════════════════════════════════════════════
//     // 📦 تحضير البيانات للإرسال
//     // ═══════════════════════════════════════════════════════════
//     final payload = {
//       'offers': results.offers ?? [],
//       'jobs': results.jobs ?? [],
//       'properties': results.properties ?? [],
//       'hawajData': true,
//       'targetLat': targetLat,
//       'targetLng': targetLng,
//     };
//
//     // ═══════════════════════════════════════════════════════════
//     // 🎧 تشغيل الصوت أولاً (وانتظار انتهائه)
//     // ═══════════════════════════════════════════════════════════
//     await _playResponseAudio(
//       mp3Url: results.mp3,
//       message: results.message,
//     );
//
//     // ═══════════════════════════════════════════════════════════
//     // 🧠 منطق التوجيه بعد انتهاء الصوت
//     // ═══════════════════════════════════════════════════════════
//     if (isMapDestination) {
//       debugPrint('🗺️ [Routing] الوجهة خريطة → تجهيز البيانات');
//
//       onDataClear?.call();
//       _currentMessage.value = results.message;
//
//       // تحميل البيانات حسب النوع
//       if (results.jobs?.isNotEmpty == true) {
//         _hawajJobs.value = results.jobs!;
//         _currentDataType.value = 'jobs';
//         debugPrint('✅ [Data] تم تحميل ${_hawajJobs.length} وظيفة');
//       } else if (results.offers?.isNotEmpty == true) {
//         _hawajOffers.value = results.offers!;
//         _currentDataType.value = 'offers';
//         debugPrint('✅ [Data] تم تحميل ${_hawajOffers.length} عرض');
//       } else if (results.properties?.isNotEmpty == true) {
//         _hawajProperties.value = results.properties!;
//         _currentDataType.value = 'properties';
//         debugPrint('✅ [Data] تم تحميل ${_hawajProperties.length} عقار');
//       }
//
//       if (isCurrentlyMap && !needsNavigation) {
//         // ✅ نفس الشاشة على الخريطة → تحديث النتائج فقط
//         debugPrint(
//             '🧩 [Routing] نفس الشاشة (s=$currentScreen) → تحديث النتائج فقط');
//         Future.delayed(
//             const Duration(milliseconds: 600), () => onDataReady?.call());
//         Future.delayed(
//             const Duration(milliseconds: 1500), () => onAnimateCamera?.call());
//       } else {
//         // ✅ الشاشة مختلفة → انتقل
//         debugPrint(
//             '🚀 [Routing] الانتقال لشاشة جديدة: Section=$currentSection, Screen=$targetScreen');
//         await Future.delayed(const Duration(milliseconds: 300));
//         await HawajRoutes.navigateTo(
//           section: currentSection,
//           screen: targetScreen,
//           parameters: payload,
//         );
//       }
//     } else {
//       // ✅ الوجهة ليست خريطة
//       debugPrint('📦 [Routing] الوجهة شاشة عادية → الانتقال');
//       await Future.delayed(const Duration(milliseconds: 300));
//       await HawajRoutes.navigateTo(
//         section: currentSection,
//         screen: targetScreen,
//         parameters: payload,
//       );
//     }
//
//     _isExpanded.value = true;
//     _isLoadingAudio.value = false;
//     _isSpeaking.value = false;
//     hasHawajDataRx.value = hasHawajData;
//     debugPrint('✅ [Hawaj] اكتمل التوجيه بنجاح');
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎧 تشغيل الصوت والانتظار حتى انتهائه
//   /// ═══════════════════════════════════════════════════════════
//   Future<void> _playResponseAudio({
//     required String mp3Url,
//     required String message,
//   }) async {
//     try {
//       if (mp3Url.isNotEmpty) {
//         _isLoadingAudio.value = true;
//         _currentMessage.value = '🎧 جاري تشغيل الرد الصوتي...';
//         debugPrint('🎧 [Audio] تشغيل MP3: $mp3Url');
//
//         await _playAudioFromUrl(mp3Url);
//         await _audioPlayer.onPlayerComplete.first;
//
//         debugPrint('✅ [Audio] انتهى الصوت بنجاح');
//       } else if (message.isNotEmpty) {
//         _isLoadingAudio.value = true;
//         _currentMessage.value = '🗣️ جاري تحضير الرد...';
//         debugPrint('🗣️ [TTS] نطق الرسالة: $message');
//
//         await speak(message);
//         await Future.delayed(const Duration(seconds: 2));
//
//         debugPrint('✅ [TTS] انتهى النطق بنجاح');
//       } else {
//         debugPrint('ℹ️ [Audio] لا يوجد صوت أو نص للنطق');
//       }
//     } catch (e) {
//       debugPrint('❌ [Audio] فشل تشغيل الصوت: $e');
//       _isLoadingAudio.value = false;
//     }
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🔍 Helper Functions
//   /// ═══════════════════════════════════════════════════════════
//
//   /// ✅ تحديد ما إذا كانت الشاشة خريطة أم لا
//   bool _isMapScreen(String section, String screen) {
//     const mapScreens = [
//       {'section': '1', 'screen': '1'}, // Daily Offers Map
//       {'section': '3', 'screen': '1'}, // Real Estates Map
//       {'section': '5', 'screen': '1'}, // Jobs Map
//     ];
//     return mapScreens.any(
//       (e) => e['section'] == section && e['screen'] == screen,
//     );
//   }
//
//   /// ✅ تحديد ما إذا كان يجب الانتقال لشاشة جديدة (بناءً على s و screen فقط)
//   bool _shouldNavigateToNewScreen({
//     required String currentScreen,
//     required String targetScreen,
//   }) {
//     // ✅ المقارنة فقط بين s (currentScreen) و screen (targetScreen)
//     if (currentScreen != targetScreen) {
//       debugPrint(
//           '🔄 [Navigation] Screen changed: s=$currentScreen → screen=$targetScreen');
//       return true;
//     }
//
//     debugPrint(
//         '⏸️ [Navigation] Same screen (s=$currentScreen), no navigation needed');
//     return false;
//   }
//
//   /// ✅ تحديد ما إذا كانت الإحداثيات مختلفة بشكل معتبر
//   bool _isLocationDifferent(double loc1, double loc2,
//       {double threshold = 0.001}) {
//     final difference = (loc1 - loc2).abs();
//     final isDifferent = difference > threshold;
//
//     if (isDifferent) {
//       debugPrint(
//           '📍 [Location] اختلاف كبير في الإحداثيات: ${difference.toStringAsFixed(6)}');
//     }
//
//     return isDifferent;
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎵 Play Audio from URL
//   /// ═══════════════════════════════════════════════════════════
//   Future<void> _playAudioFromUrl(String url) async {
//     try {
//       await _flutterTts.stop();
//       await _audioPlayer.stop();
//
//       debugPrint('🎧 [Hawaj] تشغيل الصوت: $url');
//       await _audioPlayer.play(UrlSource(url));
//
//       _isSpeaking.value = true;
//       _isLoadingAudio.value = false;
//     } catch (e) {
//       debugPrint('❌ [Hawaj] خطأ في الصوت: $e');
//       _isLoadingAudio.value = false;
//
//       if (_currentMessage.value.isNotEmpty) {
//         speak(_currentMessage.value);
//       }
//     }
//   }
//
//   Future<void> speak(String text) async {
//     if (text.isEmpty) return;
//     await _flutterTts.stop();
//     await _audioPlayer.stop();
//     await Future.delayed(const Duration(milliseconds: 300));
//     await _flutterTts.speak(text);
//   }
//
//   Future<void> stopSpeaking() async {
//     debugPrint('🛑 [Hawaj] إيقاف النطق');
//     await _flutterTts.stop();
//     await _audioPlayer.stop();
//     _isSpeaking.value = false;
//     _isLoadingAudio.value = false;
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🧹 Clear Hawaj Data
//   /// ═══════════════════════════════════════════════════════════
//   void clearHawajData() {
//     _hawajJobs.clear();
//     _hawajOffers.clear();
//     _hawajProperties.clear();
//     _currentDataType.value = null;
//     hasHawajDataRx.value = false;
//     debugPrint('🧹 [Hawaj] تم مسح البيانات');
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
// import '../../domain/models/job_item_hawaj_details_model.dart';
// import '../../domain/models/organization_item_hawaj_details_model.dart';
// import '../../domain/models/property_item_hawaj_details_model.dart';
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
//   void Function()? onDataClear;
//   void Function()? onDataReady;
//   void Function()? onAnimateCamera;
//
//   // ═══════════════════════════════════════════════════════════
//   // 🎯 Hawaj Data (للبيانات القادمة من الـ API)
//   // ═══════════════════════════════════════════════════════════
//   final _hawajJobs = <JobItemHawajDetailsModel>[].obs;
//   final _hawajOffers = <OrganizationItemHawajDetailsModel>[].obs;
//   final _hawajProperties = <PropertyItemHawajDetailsModel>[].obs;
//   final _currentDataType = Rxn<String>(); // 'jobs', 'offers', 'properties'
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
//   // 🎯 Getters للبيانات
//   List<JobItemHawajDetailsModel> get hawajJobs => _hawajJobs;
//
//   List<OrganizationItemHawajDetailsModel> get hawajOffers => _hawajOffers;
//
//   List<PropertyItemHawajDetailsModel> get hawajProperties => _hawajProperties;
//
//   String? get currentDataType => _currentDataType.value;
//
//   bool get hasHawajData =>
//       _hawajJobs.isNotEmpty ||
//       _hawajOffers.isNotEmpty ||
//       _hawajProperties.isNotEmpty;
//   final RxBool hasHawajDataRx = false.obs;
//
//   int get hawajDataCount {
//     if (_currentDataType.value == 'jobs') return _hawajJobs.length;
//     if (_currentDataType.value == 'offers') return _hawajOffers.length;
//     if (_currentDataType.value == 'properties') return _hawajProperties.length;
//     return 0;
//   }
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
//       debugPrint('✅ [Hawaj] System initialized successfully');
//     } catch (e) {
//       _setError('فشل التهيئة: $e');
//     }
//   }
//
//   void updateContext(String section, String screen, {String? message}) {
//     _currentSection = section;
//     _currentScreen = screen;
//     if (message != null) _currentMessage.value = message;
//     debugPrint('📍 [Hawaj] Context: Section=$section, Screen=$screen');
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
//       debugPrint('⚠️ [Hawaj] طلب مكرر تم منعه!');
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
//   /// 📲 إرسال طلب مباشر من الـ Drawer (بدون صوت)
//   /// ═══════════════════════════════════════════════════════════
//   Future<void> sendDirectRequest({
//     required String command,
//     String? section,
//     String? screen,
//   }) async {
//     if (command.isEmpty) {
//       debugPrint('⚠️ [Hawaj] لا يمكن إرسال طلب فارغ');
//       return;
//     }
//
//     // استخدام الـ section والـ screen الحاليين إذا لم يتم تمريرهم
//     final requestSection = section ?? _currentSection;
//     final requestScreen = screen ?? _currentScreen;
//
//     debugPrint('📲 [Hawaj] إرسال طلب مباشر: "$command"');
//     debugPrint(
//         '📍 [Hawaj] Context: Section=$requestSection, Screen=$requestScreen');
//
//     _isProcessing.value = true;
//     _currentMessage.value = 'جارٍ معالجة طلبك...';
//     clearHawajData();
//
//     try {
//       final request = SendDataRequest(
//         strl: command,
//         lat: (_latitude ?? 0).toString(),
//         lng: (_longitude ?? 0).toString(),
//         language: "ar",
//         q: requestSection,
//         s: requestScreen,
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
//     // 🧹 مسح البيانات القديمة
//     clearHawajData();
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
//       debugPrint('📤 [Hawaj] Sending: "$textToProcess"');
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
//   /// 🎯 التعامل مع الرد الكامل من السيرفر (محدث)
//   /// ═══════════════════════════════════════════════════════════
//   void _handleSuccessResponse(SendDataModel response) async {
//     final data = response.data;
//     final results = data.d;
//
//     // ═══════════════════════════════════════════════════════════
//     // 📊 استخراج البيانات من الـ Response
//     // ═══════════════════════════════════════════════════════════
//     final currentSection = data.q; // Section الحالي (المرسل)
//     final currentScreen = data.s; // Screen الحالي (المرسل)
//     final responseScreen = results.screen; // Screen المستهدف من الـ Response
//
//     // ✅ مقارنة احترافية بين الشاشات
//     final needsNavigation = _shouldNavigateToNewScreen(
//       currentScreen: currentScreen,
//       targetScreen: responseScreen,
//     );
//
//     debugPrint(
//         '🧭 [AI Routing] Current: Section=$currentSection, Screen=$currentScreen');
//     debugPrint('🎯 [AI Routing] Target: Screen=$responseScreen');
//     debugPrint('🚦 [AI Routing] Needs Navigation: $needsNavigation');
//
//     // ═══════════════════════════════════════════════════════════
//     // 📍 التعامل الذكي مع الإحداثيات
//     // ═══════════════════════════════════════════════════════════
//     final responseLat = double.tryParse(results.lat) ?? 0.0;
//     final responseLng = double.tryParse(results.lng) ?? 0.0;
//     final userLat = _latitude ?? 0.0;
//     final userLng = _longitude ?? 0.0;
//
//     // ✅ إذا الإحداثيات مختلفة، استخدم من الـ Response
//     final targetLat =
//         _isLocationDifferent(responseLat, userLat) ? responseLat : userLat;
//     final targetLng =
//         _isLocationDifferent(responseLng, userLng) ? responseLng : userLng;
//
//     debugPrint('📍 [Location] User: ($userLat, $userLng)');
//     debugPrint('📍 [Location] Response: ($responseLat, $responseLng)');
//     debugPrint('📍 [Location] Target: ($targetLat, $targetLng)');
//
//     // ═══════════════════════════════════════════════════════════
//     // 🗺️ تحديد نوع الوجهة
//     // ═══════════════════════════════════════════════════════════
//     final isMapDestination = _isMapScreen(currentSection, responseScreen);
//     final isCurrentlyMap = _isMapScreen(currentSection, currentScreen);
//
//     debugPrint('🗺️ [Routing] Is Map Destination: $isMapDestination');
//     debugPrint('🗺️ [Routing] Currently on Map: $isCurrentlyMap');
//
//     // ═══════════════════════════════════════════════════════════
//     // 📦 تحضير البيانات للإرسال
//     // ═══════════════════════════════════════════════════════════
//     final payload = {
//       'offers': results.offers ?? [],
//       'jobs': results.jobs ?? [],
//       'properties': results.properties ?? [],
//       'hawajData': true,
//       'targetLat': targetLat,
//       'targetLng': targetLng,
//     };
//
//     // ═══════════════════════════════════════════════════════════
//     // 🎧 تشغيل الصوت أولاً (وانتظار انتهائه)
//     // ═══════════════════════════════════════════════════════════
//     await _playResponseAudio(
//       mp3Url: results.mp3,
//       message: results.message,
//     );
//
//     // ═══════════════════════════════════════════════════════════
//     // 🧠 منطق التوجيه بعد انتهاء الصوت
//     // ═══════════════════════════════════════════════════════════
//     if (isMapDestination) {
//       debugPrint('🗺️ [Routing] الوجهة خريطة → تجهيز البيانات');
//
//       onDataClear?.call();
//       _currentMessage.value = results.message;
//
//       // تحميل البيانات حسب النوع
//       if (results.jobs?.isNotEmpty == true) {
//         _hawajJobs.value = results.jobs!;
//         _currentDataType.value = 'jobs';
//         debugPrint('✅ [Data] تم تحميل ${_hawajJobs.length} وظيفة');
//       } else if (results.offers?.isNotEmpty == true) {
//         _hawajOffers.value = results.offers!;
//         _currentDataType.value = 'offers';
//         debugPrint('✅ [Data] تم تحميل ${_hawajOffers.length} عرض');
//       } else if (results.properties?.isNotEmpty == true) {
//         _hawajProperties.value = results.properties!;
//         _currentDataType.value = 'properties';
//         debugPrint('✅ [Data] تم تحميل ${_hawajProperties.length} عقار');
//       }
//
//       if (isCurrentlyMap && !needsNavigation) {
//         // ✅ المستخدم بالفعل على الخريطة ونفس الشاشة → تحديث النتائج فقط
//         debugPrint('🧩 [Routing] تحديث النتائج على الخريطة الحالية');
//         Future.delayed(
//             const Duration(milliseconds: 600), () => onDataReady?.call());
//         Future.delayed(
//             const Duration(milliseconds: 1500), () => onAnimateCamera?.call());
//       } else {
//         // ✅ الانتقال إلى خريطة مختلفة
//         debugPrint(
//             '🚀 [Routing] الانتقال إلى خريطة جديدة: Section=$currentSection, Screen=$responseScreen');
//         await Future.delayed(const Duration(milliseconds: 300));
//         await HawajRoutes.navigateTo(
//           section: currentSection,
//           screen: responseScreen,
//           parameters: payload,
//         );
//       }
//     } else {
//       // ✅ الوجهة ليست خريطة
//       debugPrint('📦 [Routing] الوجهة شاشة عادية → الانتقال');
//       await Future.delayed(const Duration(milliseconds: 300));
//       await HawajRoutes.navigateTo(
//         section: currentSection,
//         screen: responseScreen,
//         parameters: payload,
//       );
//     }
//
//     _isExpanded.value = true;
//     _isLoadingAudio.value = false;
//     _isSpeaking.value = false;
//     hasHawajDataRx.value = hasHawajData;
//     debugPrint('✅ [Hawaj] اكتمل التوجيه بنجاح');
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎧 تشغيل الصوت والانتظار حتى انتهائه
//   /// ═══════════════════════════════════════════════════════════
//   Future<void> _playResponseAudio({
//     required String mp3Url,
//     required String message,
//   }) async {
//     try {
//       if (mp3Url.isNotEmpty) {
//         _isLoadingAudio.value = true;
//         _currentMessage.value = '🎧 جاري تشغيل الرد الصوتي...';
//         debugPrint('🎧 [Audio] تشغيل MP3: $mp3Url');
//
//         await _playAudioFromUrl(mp3Url);
//         await _audioPlayer.onPlayerComplete.first;
//
//         debugPrint('✅ [Audio] انتهى الصوت بنجاح');
//       } else if (message.isNotEmpty) {
//         _isLoadingAudio.value = true;
//         _currentMessage.value = '🗣️ جاري تحضير الرد...';
//         debugPrint('🗣️ [TTS] نطق الرسالة: $message');
//
//         await speak(message);
//         await Future.delayed(const Duration(seconds: 2));
//
//         debugPrint('✅ [TTS] انتهى النطق بنجاح');
//       } else {
//         debugPrint('ℹ️ [Audio] لا يوجد صوت أو نص للنطق');
//       }
//     } catch (e) {
//       debugPrint('❌ [Audio] فشل تشغيل الصوت: $e');
//       _isLoadingAudio.value = false;
//     }
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🔍 Helper Functions
//   /// ═══════════════════════════════════════════════════════════
//
//   /// ✅ تحديد ما إذا كانت الشاشة خريطة أم لا
//   bool _isMapScreen(String section, String screen) {
//     const mapScreens = [
//       {'section': '1', 'screen': '1'}, // Daily Offers Map
//       {'section': '3', 'screen': '1'}, // Real Estates Map
//       {'section': '5', 'screen': '1'}, // Jobs Map
//     ];
//     return mapScreens.any(
//       (e) => e['section'] == section && e['screen'] == screen,
//     );
//   }
//
//   /// ✅ تحديد ما إذا كان يجب الانتقال لشاشة جديدة
//   bool _shouldNavigateToNewScreen({
//     required String currentScreen,
//     required String targetScreen,
//   }) {
//     // إذا الشاشات مختلفة → يجب الانتقال
//     if (currentScreen != targetScreen) {
//       debugPrint(
//           '🔄 [Navigation] Screen changed: $currentScreen → $targetScreen');
//       return true;
//     }
//
//     debugPrint('⏸️ [Navigation] Same screen, no navigation needed');
//     return false;
//   }
//
//   /// ✅ تحديد ما إذا كانت الإحداثيات مختلفة بشكل معتبر
//   bool _isLocationDifferent(double loc1, double loc2,
//       {double threshold = 0.001}) {
//     final difference = (loc1 - loc2).abs();
//     final isDifferent = difference > threshold;
//
//     if (isDifferent) {
//       debugPrint(
//           '📍 [Location] اختلاف كبير في الإحداثيات: ${difference.toStringAsFixed(6)}');
//     }
//
//     return isDifferent;
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎵 Play Audio from URL
//   /// ═══════════════════════════════════════════════════════════
//   Future<void> _playAudioFromUrl(String url) async {
//     try {
//       await _flutterTts.stop();
//       await _audioPlayer.stop();
//
//       debugPrint('🎧 [Hawaj] تشغيل الصوت: $url');
//       await _audioPlayer.play(UrlSource(url));
//
//       _isSpeaking.value = true;
//       _isLoadingAudio.value = false;
//     } catch (e) {
//       debugPrint('❌ [Hawaj] خطأ في الصوت: $e');
//       _isLoadingAudio.value = false;
//
//       if (_currentMessage.value.isNotEmpty) {
//         speak(_currentMessage.value);
//       }
//     }
//   }
//
//   Future<void> speak(String text) async {
//     if (text.isEmpty) return;
//     await _flutterTts.stop();
//     await _audioPlayer.stop();
//     await Future.delayed(const Duration(milliseconds: 300));
//     await _flutterTts.speak(text);
//   }
//
//   Future<void> stopSpeaking() async {
//     debugPrint('🛑 [Hawaj] إيقاف النطق');
//     await _flutterTts.stop();
//     await _audioPlayer.stop();
//     _isSpeaking.value = false;
//     _isLoadingAudio.value = false;
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🧹 Clear Hawaj Data
//   /// ═══════════════════════════════════════════════════════════
//   void clearHawajData() {
//     _hawajJobs.clear();
//     _hawajOffers.clear();
//     _hawajProperties.clear();
//     _currentDataType.value = null;
//     hasHawajDataRx.value = false;
//     debugPrint('🧹 [Hawaj] تم مسح البيانات');
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
// import '../../domain/models/job_item_hawaj_details_model.dart';
// import '../../domain/models/organization_item_hawaj_details_model.dart';
// import '../../domain/models/property_item_hawaj_details_model.dart';
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
//   void Function()? onDataClear;
//   void Function()? onDataReady;
//   void Function()? onAnimateCamera;
//
//   // ═══════════════════════════════════════════════════════════
//   // 🎯 Hawaj Data (للبيانات القادمة من الـ API)
//   // ═══════════════════════════════════════════════════════════
//   final _hawajJobs = <JobItemHawajDetailsModel>[].obs;
//   final _hawajOffers = <OrganizationItemHawajDetailsModel>[].obs;
//   final _hawajProperties = <PropertyItemHawajDetailsModel>[].obs;
//   final _currentDataType = Rxn<String>(); // 'jobs', 'offers', 'properties'
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
//   // 🎯 Getters للبيانات
//   List<JobItemHawajDetailsModel> get hawajJobs => _hawajJobs;
//
//   List<OrganizationItemHawajDetailsModel> get hawajOffers => _hawajOffers;
//
//   List<PropertyItemHawajDetailsModel> get hawajProperties => _hawajProperties;
//
//   String? get currentDataType => _currentDataType.value;
//
//   //
//   bool get hasHawajData =>
//       _hawajJobs.isNotEmpty ||
//       _hawajOffers.isNotEmpty ||
//       _hawajProperties.isNotEmpty;
//   final RxBool hasHawajDataRx = false.obs;
//
//   int get hawajDataCount {
//     if (_currentDataType.value == 'jobs') return _hawajJobs.length;
//     if (_currentDataType.value == 'offers') return _hawajOffers.length;
//     if (_currentDataType.value == 'properties') return _hawajProperties.length;
//     return 0;
//   }
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
//       debugPrint('✅ [Hawaj] System initialized successfully');
//     } catch (e) {
//       _setError('فشل التهيئة: $e');
//     }
//   }
//
//   void updateContext(String section, String screen, {String? message}) {
//     _currentSection = section;
//     _currentScreen = screen;
//     if (message != null) _currentMessage.value = message;
//     debugPrint('📍 [Hawaj] Context: Section=$section, Screen=$screen');
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
//       debugPrint('⚠️ [Hawaj] طلب مكرر تم منعه!');
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
//     // 🧹 مسح البيانات القديمة
//     clearHawajData();
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
//       debugPrint('📤 [Hawaj] Sending: "$textToProcess"');
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
//   //   final destination = data.aiResponse;
//   //   final results = data.d;
//   //   // 🧹 امسح البيانات القديمة وأخبر الخريطة تبدأ Overlay
//   //   onDataClear?.call();
//   //
//   //   _currentMessage.value = destination.message;
//   //   debugPrint('💬 [Hawaj] Response: ${destination.message}');
//   //
//   //   // 📦 تحميل البيانات الجديدة
//   //   if (results.jobs?.isNotEmpty == true) {
//   //     _hawajJobs.value = results.jobs!;
//   //     _currentDataType.value = 'jobs';
//   //   } else if (results.offers?.isNotEmpty == true) {
//   //     _hawajOffers.value = results.offers!;
//   //     _currentDataType.value = 'offers';
//   //   } else if (results.properties?.isNotEmpty == true) {
//   //     _hawajProperties.value = results.properties!;
//   //     _currentDataType.value = 'properties';
//   //   }
//   //
//   //   // ✅ إشعار الخريطة بأن البيانات الجديدة جاهزة
//   //   Future.delayed(const Duration(milliseconds: 600), () {
//   //     onDataReady?.call();
//   //   });
//   //
//   //   // ✅ تحريك الكاميرا بعد قليل
//   //   Future.delayed(const Duration(milliseconds: 1600), () {
//   //     onAnimateCamera?.call();
//   //   });
//   //
//   //   _currentMessage.value = destination.message;
//   //   debugPrint('💬 [Hawaj] Response: ${destination.message}');
//   //
//   //   // ═══════════════════════════════════════════════════════════
//   //   // 📦 تخزين البيانات القادمة
//   //   // ═══════════════════════════════════════════════════════════
//   //   if (results.jobs?.isNotEmpty == true) {
//   //     _hawajJobs.value = results.jobs!;
//   //     _currentDataType.value = 'jobs';
//   //     debugPrint('✅ [Hawaj] ${_hawajJobs.length} وظيفة محملة');
//   //   } else if (results.offers?.isNotEmpty == true) {
//   //     _hawajOffers.value = results.offers!;
//   //     _currentDataType.value = 'offers';
//   //     debugPrint('✅ [Hawaj] ${_hawajOffers.length} عرض محمل');
//   //   } else if (results.properties?.isNotEmpty == true) {
//   //     _hawajProperties.value = results.properties!;
//   //     _currentDataType.value = 'properties';
//   //     debugPrint('✅ [Hawaj] ${_hawajProperties.length} عقار محمل');
//   //   }
//   //
//   //   // ═══════════════════════════════════════════════════════════
//   //   // 🔊 تشغيل الصوت
//   //   // ═══════════════════════════════════════════════════════════
//   //   if (destination.mp3.isNotEmpty) {
//   //     _isLoadingAudio.value = true;
//   //     _currentMessage.value = 'جاري تشغيل الرد الصوتي...';
//   //     _playAudioFromUrl(destination.mp3);
//   //   } else if (destination.message.isNotEmpty) {
//   //     _isLoadingAudio.value = true;
//   //     _currentMessage.value = 'جاري تحضير الرد...';
//   //     speak(destination.message);
//   //   } else {
//   //     _resetToIdle();
//   //   }
//   //
//   //   _isExpanded.value = true;
//   //
//   //   // ═══════════════════════════════════════════════════════════
//   //   // 🧭 التنقل (إذا لزم الأمر)
//   //   // ═══════════════════════════════════════════════════════════
//   //   if (destination.section.isEmpty || destination.screen.isEmpty) {
//   //     debugPrint('ℹ️ [Hawaj] لا يوجد وجهة تنقل');
//   //     return;
//   //   }
//   //
//   //   final needsNavigation =
//   //       data.q != destination.section || data.s != destination.screen;
//   //
//   //   if (needsNavigation) {
//   //     debugPrint(
//   //         '✈️ [Hawaj] الانتقال إلى ${destination.section}-${destination.screen}');
//   //     Future.delayed(const Duration(seconds: 3), () {
//   //       HawajRoutes.navigateTo(
//   //         section: destination.section,
//   //         screen: destination.screen,
//   //         parameters: {
//   //           'hawajData': true,
//   //         },
//   //         replace: false,
//   //       );
//   //     });
//   //     hasHawajDataRx.value = _hawajJobs.isNotEmpty ||
//   //         _hawajOffers.isNotEmpty ||
//   //         _hawajProperties.isNotEmpty;
//   //   } else {
//   //     debugPrint('ℹ️ [Hawaj] البقاء في الشاشة الحالية');
//   //   }
//   // }
//   // void _handleSuccessResponse(SendDataModel response) {
//   //   final data = response.data;
//   //   final destination = data.aiResponse;
//   //   final results = data.d;
//   //
//   //   // 🧹 مسح البيانات القديمة + إشعار الخريطة
//   //   onDataClear?.call();
//   //
//   //   _currentMessage.value = destination.message;
//   //   debugPrint('💬 [Hawaj] Response: ${destination.message}');
//   //
//   //   // 📦 تحميل البيانات الجديدة
//   //   if (results.jobs?.isNotEmpty == true) {
//   //     _hawajJobs.value = results.jobs!;
//   //     _currentDataType.value = 'jobs';
//   //   } else if (results.offers?.isNotEmpty == true) {
//   //     _hawajOffers.value = results.offers!;
//   //     _currentDataType.value = 'offers';
//   //   } else if (results.properties?.isNotEmpty == true) {
//   //     _hawajProperties.value = results.properties!;
//   //     _currentDataType.value = 'properties';
//   //   }
//   //
//   //   // ✅ إشعار الخريطة بأن البيانات الجديدة جاهزة
//   //   Future.delayed(const Duration(milliseconds: 600), () {
//   //     onDataReady?.call();
//   //   });
//   //
//   //   // ✅ تحريك الكاميرا بعد قليل
//   //   Future.delayed(const Duration(milliseconds: 1600), () {
//   //     onAnimateCamera?.call();
//   //   });
//   //
//   //   // 🔊 تشغيل الصوت
//   //   if (destination.mp3.isNotEmpty) {
//   //     _isLoadingAudio.value = true;
//   //     _currentMessage.value = 'جاري تشغيل الرد الصوتي...';
//   //     _playAudioFromUrl(destination.mp3);
//   //   } else if (destination.message.isNotEmpty) {
//   //     _isLoadingAudio.value = true;
//   //     _currentMessage.value = 'جاري تحضير الرد...';
//   //     speak(destination.message);
//   //   } else {
//   //     _resetToIdle();
//   //   }
//   //
//   //   _isExpanded.value = true;
//   //
//   //   // ═══════════════════════════════════════════════════════════
//   //   // 🧭 منطق التنقل الجديد (المحسّن)
//   //   // ═══════════════════════════════════════════════════════════
//   //
//   //   final currentSection = data.q;
//   //   final currentScreen = data.s;
//   //   final nextSection = destination.section;
//   //   final nextScreen = destination.screen;
//   //
//   //   // 🧩 الشاشات التي تحتوي على خريطة فقط
//   //   const mapScreens = [
//   //     {'section': '1', 'screen': '1'},
//   //     {'section': '3', 'screen': '1'},
//   //     {'section': '5', 'screen': '1'},
//   //   ];
//   //
//   //   final isCurrentMapScreen = mapScreens.any(
//   //       (e) => e['section'] == currentSection && e['screen'] == currentScreen);
//   //
//   //   if (isCurrentMapScreen) {
//   //     debugPrint('🗺️ [Hawaj] شاشة خريطة - سيتم البقاء في نفس الشاشة.');
//   //     hasHawajDataRx.value = _hawajJobs.isNotEmpty ||
//   //         _hawajOffers.isNotEmpty ||
//   //         _hawajProperties.isNotEmpty;
//   //     return; // لا يتم الانتقال
//   //   }
//   //
//   //   // ✅ إذا الوجهة مختلفة → انتقل
//   //   final needsNavigation =
//   //       currentSection != nextSection || currentScreen != nextScreen;
//   //
//   //   if (needsNavigation) {
//   //     debugPrint(
//   //         '✈️ [Hawaj] الانتقال إلى Section=$nextSection , Screen=$nextScreen');
//   //
//   //     Future.delayed(const Duration(seconds: 3), () {
//   //       HawajRoutes.navigateTo(
//   //         section: nextSection,
//   //         screen: nextScreen,
//   //         parameters: {
//   //           'hawajData': true,
//   //         },
//   //         replace: false,
//   //       );
//   //     });
//   //   } else {
//   //     debugPrint('ℹ️ [Hawaj] البقاء في نفس الشاشة الحالية.');
//   //   }
//   // }
//   // void _handleSuccessResponse(SendDataModel response) async {
//   //   final data = response.data;
//   //   final destination = data.aiResponse;
//   //   final results = data.d;
//   //
//   //   final currentSection = data.q;
//   //   final currentScreen = data.s;
//   //   final nextSection = destination.section;
//   //   final nextScreen = destination.screen;
//   //
//   //   debugPrint(
//   //       '🧭 [AI Routing] from $currentSection-$currentScreen → $nextSection-$nextScreen');
//   //
//   //   bool _isMapDestination(String section, String screen) {
//   //     const mapScreens = [
//   //       {'section': '1', 'screen': '1'}, // Daily Offers Map
//   //       {'section': '3', 'screen': '1'}, // Real Estates Map
//   //       {'section': '5', 'screen': '1'}, // Jobs Map
//   //     ];
//   //     return mapScreens
//   //         .any((e) => e['section'] == section && e['screen'] == screen);
//   //   }
//   //
//   //   final isMapDestination = _isMapDestination(nextSection, nextScreen);
//   //   final isCurrentlyMap = _isMapDestination(currentSection, currentScreen);
//   //
//   //   final payload = {
//   //     'offers': results.offers ?? [],
//   //     'jobs': results.jobs ?? [],
//   //     'properties': results.properties ?? [],
//   //     'hawajData': true,
//   //   };
//   //
//   //   // ════════════════════════════════════════════════
//   //   // 🎧 تشغيل الصوت أولًا (وانتظار انتهائه)
//   //   // ════════════════════════════════════════════════
//   //   Future<void> _playAndWait() async {
//   //     try {
//   //       if (destination.mp3.isNotEmpty) {
//   //         _isLoadingAudio.value = true;
//   //         _currentMessage.value = '🎧 جاري تشغيل الرد الصوتي...';
//   //         debugPrint('🎧 [Hawaj] تشغيل الصوت من URL: ${destination.mp3}');
//   //         await _playAudioFromUrl(destination.mp3);
//   //
//   //         // ⏳ انتظار انتهاء الصوت بالكامل
//   //         await _audioPlayer.onPlayerComplete.first;
//   //         debugPrint('✅ [Hawaj] انتهى الصوت بنجاح');
//   //       } else if (destination.message.isNotEmpty) {
//   //         _isLoadingAudio.value = true;
//   //         _currentMessage.value = '🗣️ جاري تحضير الرد...';
//   //         await speak(destination.message);
//   //
//   //         await Future.delayed(const Duration(seconds: 2)); // انتظار بعد النطق
//   //       } else {
//   //         debugPrint('ℹ️ [Hawaj] لا يوجد صوت أو نص للنطق');
//   //       }
//   //     } catch (e) {
//   //       debugPrint('❌ [Hawaj] فشل في تشغيل الصوت أو الانتظار: $e');
//   //     }
//   //   }
//   //
//   //   await _playAndWait(); // ← يشغل الصوت وينتظر الانتهاء فعليًا قبل التنقل
//   //
//   //   // ════════════════════════════════════════════════
//   //   // 🧠 منطق التوجيه بعد انتهاء الصوت
//   //   // ════════════════════════════════════════════════
//   //   if (isMapDestination) {
//   //     debugPrint('🗺️ [Routing] الوجهة خريطة → تجهيز البيانات');
//   //
//   //     onDataClear?.call();
//   //     _currentMessage.value = destination.message;
//   //
//   //     if (results.jobs?.isNotEmpty == true) {
//   //       _hawajJobs.value = results.jobs!;
//   //       _currentDataType.value = 'jobs';
//   //     } else if (results.offers?.isNotEmpty == true) {
//   //       _hawajOffers.value = results.offers!;
//   //       _currentDataType.value = 'offers';
//   //     } else if (results.properties?.isNotEmpty == true) {
//   //       _hawajProperties.value = results.properties!;
//   //       _currentDataType.value = 'properties';
//   //     }
//   //
//   //     if (isCurrentlyMap) {
//   //       debugPrint('🧩 [Routing] المستخدم داخل الخريطة → تحديث النتائج فقط');
//   //       Future.delayed(
//   //           const Duration(milliseconds: 600), () => onDataReady?.call());
//   //       Future.delayed(
//   //           const Duration(milliseconds: 1500), () => onAnimateCamera?.call());
//   //     } else {
//   //       debugPrint(
//   //           '🚀 [Routing] الانتقال الآن إلى الخريطة Section=$nextSection, Screen=$nextScreen بعد انتهاء الصوت');
//   //       await Future.delayed(const Duration(milliseconds: 300));
//   //       await HawajRoutes.navigateTo(
//   //         section: nextSection,
//   //         screen: nextScreen,
//   //         parameters: payload,
//   //       );
//   //     }
//   //   } else {
//   //     debugPrint('📦 [Routing] الوجهة ليست خريطة → الانتقال بعد انتهاء الصوت');
//   //     await Future.delayed(const Duration(milliseconds: 300));
//   //     await HawajRoutes.navigateTo(
//   //       section: nextSection,
//   //       screen: nextScreen,
//   //       parameters: payload,
//   //     );
//   //   }
//   //
//   //   _isExpanded.value = true;
//   //   _isLoadingAudio.value = false;
//   //   _isSpeaking.value = false;
//   //   debugPrint('✅ [Hawaj] الرد الصوتي اكتمل، وتم التوجيه بنجاح');
//   // }
//   void _handleSuccessResponse(SendDataModel response) async {
//     final data = response.data;
//     final results = data.d; // ✅ الآن d يحتوي على message و mp3 و screen مباشرة
//
//     final currentSection = data.q;
//     final currentScreen = data.s;
//     final nextSection = results.screen;
//     final nextScreen = results.screen; // ✅ نفس القيمة
//
//     debugPrint(
//         '🧭 [AI Routing] from $currentSection-$currentScreen → $nextSection-$nextScreen');
//
//     bool _isMapDestination(String section, String screen) {
//       const mapScreens = [
//         {'section': '1', 'screen': '1'}, // Daily Offers Map
//         {'section': '3', 'screen': '1'}, // Real Estates Map
//         {'section': '5', 'screen': '1'}, // Jobs Map
//       ];
//       return mapScreens
//           .any((e) => e['section'] == section && e['screen'] == screen);
//     }
//
//     final isMapDestination = _isMapDestination(nextSection, nextScreen);
//     final isCurrentlyMap = _isMapDestination(currentSection, currentScreen);
//
//     final payload = {
//       'offers': results.offers ?? [],
//       'jobs': results.jobs ?? [],
//       'properties': results.properties ?? [],
//       'hawajData': true,
//     };
//
//     // ════════════════════════════════════════════════
//     // 🎧 تشغيل الصوت أولًا (وانتظار انتهائه)
//     // ════════════════════════════════════════════════
//     Future<void> _playAndWait() async {
//       try {
//         if (results.mp3.isNotEmpty) {
//           _isLoadingAudio.value = true;
//           _currentMessage.value = '🎧 جاري تشغيل الرد الصوتي...';
//           debugPrint('🎧 [Hawaj] تشغيل الصوت من URL: ${results.mp3}');
//           await _playAudioFromUrl(results.mp3);
//
//           await _audioPlayer.onPlayerComplete.first;
//           debugPrint('✅ [Hawaj] انتهى الصوت بنجاح');
//         } else if (results.message.isNotEmpty) {
//           _isLoadingAudio.value = true;
//           _currentMessage.value = '🗣️ جاري تحضير الرد...';
//           await speak(results.message);
//
//           await Future.delayed(const Duration(seconds: 2));
//         } else {
//           debugPrint('ℹ️ [Hawaj] لا يوجد صوت أو نص للنطق');
//         }
//       } catch (e) {
//         debugPrint('❌ [Hawaj] فشل في تشغيل الصوت أو الانتظار: $e');
//       }
//     }
//
//     await _playAndWait();
//
//     // ════════════════════════════════════════════════
//     // 🧠 منطق التوجيه بعد انتهاء الصوت
//     // ════════════════════════════════════════════════
//     if (isMapDestination) {
//       debugPrint('🗺️ [Routing] الوجهة خريطة → تجهيز البيانات');
//
//       onDataClear?.call();
//       _currentMessage.value = results.message; // ✅ تغيير
//
//       if (results.jobs?.isNotEmpty == true) {
//         _hawajJobs.value = results.jobs!;
//         _currentDataType.value = 'jobs';
//       } else if (results.offers?.isNotEmpty == true) {
//         _hawajOffers.value = results.offers!;
//         _currentDataType.value = 'offers';
//       } else if (results.properties?.isNotEmpty == true) {
//         _hawajProperties.value = results.properties!;
//         _currentDataType.value = 'properties';
//       }
//
//       if (isCurrentlyMap) {
//         debugPrint('🧩 [Routing] المستخدم داخل الخريطة → تحديث النتائج فقط');
//         Future.delayed(
//             const Duration(milliseconds: 600), () => onDataReady?.call());
//         Future.delayed(
//             const Duration(milliseconds: 1500), () => onAnimateCamera?.call());
//       } else {
//         debugPrint(
//             '🚀 [Routing] الانتقال الآن إلى الخريطة Section=$nextSection, Screen=$nextScreen بعد انتهاء الصوت');
//         await Future.delayed(const Duration(milliseconds: 300));
//         await HawajRoutes.navigateTo(
//           section: nextSection,
//           screen: nextScreen,
//           parameters: payload,
//         );
//       }
//     } else {
//       debugPrint('📦 [Routing] الوجهة ليست خريطة → الانتقال بعد انتهاء الصوت');
//       await Future.delayed(const Duration(milliseconds: 300));
//       await HawajRoutes.navigateTo(
//         section: nextSection,
//         screen: nextScreen,
//         parameters: payload,
//       );
//     }
//
//     _isExpanded.value = true;
//     _isLoadingAudio.value = false;
//     _isSpeaking.value = false;
//     debugPrint('✅ [Hawaj] الرد الصوتي اكتمل، وتم التوجيه بنجاح');
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🎵 Play Audio from URL
//   /// ═══════════════════════════════════════════════════════════
//   Future<void> _playAudioFromUrl(String url) async {
//     try {
//       await _flutterTts.stop();
//       await _audioPlayer.stop();
//
//       debugPrint('🎧 [Hawaj] تشغيل الصوت: $url');
//       await _audioPlayer.play(UrlSource(url));
//
//       _isSpeaking.value = true;
//       _isLoadingAudio.value = false;
//     } catch (e) {
//       debugPrint('❌ [Hawaj] خطأ في الصوت: $e');
//       _isLoadingAudio.value = false;
//
//       if (_currentMessage.value.isNotEmpty) {
//         speak(_currentMessage.value);
//       }
//     }
//   }
//
//   Future<void> speak(String text) async {
//     if (text.isEmpty) return;
//     await _flutterTts.stop();
//     await _audioPlayer.stop();
//     await Future.delayed(const Duration(milliseconds: 300));
//     await _flutterTts.speak(text);
//   }
//
//   Future<void> stopSpeaking() async {
//     debugPrint('🛑 [Hawaj] إيقاف النطق');
//     await _flutterTts.stop();
//     await _audioPlayer.stop();
//     _isSpeaking.value = false;
//     _isLoadingAudio.value = false;
//   }
//
//   /// ═══════════════════════════════════════════════════════════
//   /// 🧹 Clear Hawaj Data
//   /// ═══════════════════════════════════════════════════════════
//   void clearHawajData() {
//     _hawajJobs.clear();
//     _hawajOffers.clear();
//     _hawajProperties.clear();
//     _currentDataType.value = null;
//     debugPrint('🧹 [Hawaj] تم مسح البيانات');
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
