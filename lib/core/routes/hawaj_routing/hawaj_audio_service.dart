import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class HawajAudioService {
  final AudioPlayer _player = AudioPlayer();
  String? _currentUrl;

  String? get currentUrl => _currentUrl;

  bool get isPlaying => _player.state == PlayerState.playing;

  Future<void> playUrl(String url) async {
    try {
      _currentUrl = url;
      await _player.play(UrlSource(url));
      debugPrint('🎧 [AudioService] Playing → $url');
    } catch (e) {
      debugPrint('❌ [AudioService] Failed to play audio: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _currentUrl = null;
      debugPrint('🛑 [AudioService] Stopped');
    } catch (e) {
      debugPrint('❌ [AudioService] Stop error: $e');
    }
  }
}
