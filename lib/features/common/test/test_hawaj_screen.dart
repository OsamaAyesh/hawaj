// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter_audio_capture/flutter_audio_capture.dart';
// import 'package:google_speech/generated/google/cloud/speech/v1/cloud_speech.pb.dart';
// import 'package:google_speech/google_speech.dart' hide StreamingRecognitionConfig;
// import 'package:google_speech/config/streaming_recognition_config.dart' as speech_config;
//
// import '../../../core/service/google_speech_service.dart';
//
// class SpeechScreen extends StatefulWidget {
//   const SpeechScreen({super.key});
//
//   @override
//   State<SpeechScreen> createState() => _SpeechScreenState();
// }
//
// class _SpeechScreenState extends State<SpeechScreen> {
//   final FlutterAudioCapture _audioCapture = FlutterAudioCapture();
//   bool _isListening = false;
//   String _recognizedText = '';
//   String _selectedLanguage = 'en-US';
//
//   Stream<StreamingRecognizeResponse>? _responseStream;
//
//   /// بدء الاستماع
//   Future<void> _startListening() async {
//     final speechToText = await GoogleSpeechService.init();
//
//     final streamingConfig = speech_config.StreamingRecognitionConfig(
//       config: GoogleSpeechService.config(languageCode: _selectedLanguage),
//       interimResults: true,
//     );
//
//     // 🎙️ نحول الـ callback إلى StreamController
//     final controller = StreamController<List<int>>();
//
//     await _audioCapture.start(
//           (Uint8List data) {
//         controller.add(data); // نرسل البيانات مباشرة للـ Stream
//       },
//       sampleRate: 16000,
//       bufferSize: 3000,
//     );
//
//     _responseStream = speechToText.streamingRecognize(
//       streamingConfig,
//       controller.stream,
//     );
//
//     _responseStream!.listen((response) {
//       for (var result in response.results) {
//         if (result.alternatives.isNotEmpty) {
//           setState(() {
//             _recognizedText = result.alternatives.first.transcript;
//           });
//         }
//       }
//     }, onError: (e) {
//       debugPrint("❌ Error: $e");
//     }, onDone: () {
//       setState(() => _isListening = false);
//     });
//
//     setState(() => _isListening = true);
//   }
//
//   /// إيقاف الاستماع
//   Future<void> _stopListening() async {
//     await _audioCapture.stop();
//     setState(() => _isListening = false);
//   }
//
//   @override
//   void dispose() {
//     _stopListening();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text("🎤 Smart Speech Assistant"),
//         centerTitle: true,
//         backgroundColor: Colors.teal,
//         foregroundColor: Colors.white,
//         elevation: 2,
//         actions: [
//           DropdownButton<String>(
//             value: _selectedLanguage,
//             dropdownColor: Colors.white,
//             underline: const SizedBox(),
//             icon: const Icon(Icons.language, color: Colors.white),
//             items: const [
//               DropdownMenuItem(
//                 value: 'en-US',
//                 child: Text('English (US)'),
//               ),
//               DropdownMenuItem(
//                 value: 'ar-SA',
//                 child: Text('العربية (السعودية)'),
//               ),
//               DropdownMenuItem(
//                 value: 'ar-EG',
//                 child: Text('العربية (مصر)'),
//               ),
//             ],
//             onChanged: (value) {
//               setState(() {
//                 _selectedLanguage = value!;
//               });
//               if (_isListening) {
//                 _stopListening().then((_) => _startListening());
//               }
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 24),
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 8,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: SingleChildScrollView(
//                     reverse: true,
//                     child: Text(
//                       _recognizedText.isEmpty
//                           ? 'اختر لغة وتحدث...'
//                           : _recognizedText,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         height: 1.4,
//                       ),
//                       textAlign: _selectedLanguage.startsWith('ar')
//                           ? TextAlign.right
//                           : TextAlign.left,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 32),
//               GestureDetector(
//                 onTap: _isListening ? _stopListening : _startListening,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   width: 80,
//                   height: 80,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: _isListening ? Colors.redAccent : Colors.teal,
//                     boxShadow: [
//                       BoxShadow(
//                         color: (_isListening ? Colors.redAccent : Colors.teal)
//                             .withOpacity(0.4),
//                         blurRadius: 16,
//                         spreadRadius: 4,
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     _isListening ? Icons.stop : Icons.mic,
//                     color: Colors.white,
//                     size: 40,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
