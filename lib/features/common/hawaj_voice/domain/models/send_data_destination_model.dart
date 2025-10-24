class SendDataDestinationModel {
  final String section;
  final String screen;

  final String message;
  final String mp3;

  SendDataDestinationModel({
    required this.section,
    required this.screen,
    // required this.parameters,
    required this.message,
    required this.mp3,
  });

  // Helper getters
  bool get shouldNavigate => section.isNotEmpty && screen.isNotEmpty;

  bool get hasAudio => mp3.isNotEmpty;

  bool get hasMessage => message.isNotEmpty;
}
