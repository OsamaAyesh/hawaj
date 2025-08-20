import 'package:flutter/services.dart' show rootBundle;
import 'package:google_speech/google_speech.dart';

class GoogleSpeechService {
  static Future<SpeechToText> init() async {
    final serviceAccount = ServiceAccount.fromString(
      await rootBundle.loadString('assets/credentials/credentials.json'),
    );
    return SpeechToText.viaServiceAccount(serviceAccount);
  }

  static RecognitionConfig config({String languageCode = 'en-US'}) {
    return RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      sampleRateHertz: 16000,
      languageCode: languageCode,
      enableAutomaticPunctuation: true,
      model: RecognitionModel.basic,
    );
  }
}
