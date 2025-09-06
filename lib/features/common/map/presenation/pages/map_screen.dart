import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_icons.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:confetti/confetti.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../controller/map_controller.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/location_error_widget.dart';
import '../widgets/manager_drawer_items.dart';
import '../widgets/menu_icon_button.dart';
import '../widgets/notfication_icon_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final controller = Get.find<MapController>();
  final GlobalKey<SliderDrawerState> _sliderKey = GlobalKey<SliderDrawerState>();
  final SpeechToText _speechToText = SpeechToText();
  final ConfettiController _confettiController =
  ConfettiController(duration: const Duration(seconds: 2));

  Set<Marker> customMarkers = {};
  bool _isListening = false;
  bool _speechEnabled = false;
  bool _permissionGranted = false;
  String _recognizedText = "";
  double _audioLevel = 0.0;
  List<double> _audioLevels = List.generate(20, (index) => 0.0);
  late AnimationController _waveController;
  bool _showVoiceAssistant = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
    _checkAndLoadLocation();
    _initSpeech();
  }

  /// ====== Check permissions and request them if necessary
  Future<void> _checkAndLoadLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (hasPermission) {
      await controller.loadCurrentLocation();
      _initMarkers();
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppSnackbar.warning("رجاءً قم بتفعيل خدمة الموقع من الإعدادات.",
          englishMessage: "Please enable location services from settings.");
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AppSnackbar.error("لا يمكن استخدام الخريطة بدون إذن الموقع.",
            englishMessage:
            "The map cannot be used without location permission.");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppSnackbar.error("رجاءً فعّل إذن الموقع يدويًا من إعدادات الهاتف.",
          englishMessage:
          "Please enable location permission manually from the phone settings.");
      return false;
    }

    return true;
  }

  /// Initialize Speech Recognition
  Future<void> _initSpeech() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
      });

      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) {
          if (status == 'notListening' && _isListening) {
            setState(() {
              _isListening = false;
              if (_recognizedText.isNotEmpty) {
                _confettiController.play();
              }
            });
          }
        },
        onError: (error) {
          print('Speech recognition error: $error');
        },
      );
      setState(() {});
    } else {
      print('Microphone permission denied');
    }
  }

  Future<void> _startListening() async {
    if (!_permissionGranted) {
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يجب منح إذن استخدام الميكروفون للتمكن من التحدث'),
            ),
          );
        }
        return;
      } else {
        setState(() {
          _permissionGranted = true;
        });
        await _initSpeech();
      }
    }

    setState(() {
      _recognizedText = "";
      _showVoiceAssistant = true;
    });

    if (_speechEnabled) {
      await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _recognizedText = result.recognizedWords;
          });
        },
        localeId: "ar-SA",
        listenMode: ListenMode.confirmation,
        onSoundLevelChange: (level) {
          setState(() {
            _audioLevel = level;
            _audioLevels.removeAt(0);
            _audioLevels.add(level);
          });
        },
      );
      setState(() {
        _isListening = true;
      });
    } else {
      await _initSpeech();
      if (_speechEnabled) {
        await _startListening();
      }
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
      if (_recognizedText.isNotEmpty) {
        _confettiController.play();
      }
    });
  }

  void _closeVoiceAssistant() {
    setState(() {
      _showVoiceAssistant = false;
    });
    _stopListening();
  }

  Future<void> _initMarkers() async {
    final location = controller.currentLocation.value;
    if (location == null) return;

    final restaurantIcon =
    await _createCustomMarker(Icons.restaurant, Colors.deepPurple);
    final cafeIcon =
    await _createCustomMarker(Icons.local_cafe, Colors.deepPurple);
    final storeIcon =
    await _createCustomMarker(Icons.store, Colors.deepPurple);

    setState(() {
      customMarkers = {
        Marker(
          markerId: const MarkerId("restaurant"),
          position:
          LatLng(location.latitude + 0.001, location.longitude + 0.001),
          icon: restaurantIcon,
          infoWindow: const InfoWindow(title: "مطعم شرقي"),
        ),
        Marker(
          markerId: const MarkerId("cafe"),
          position:
          LatLng(location.latitude - 0.001, location.longitude - 0.001),
          icon: cafeIcon,
          infoWindow: const InfoWindow(title: "مقهى"),
        ),
        Marker(
          markerId: const MarkerId("store"),
          position:
          LatLng(location.latitude + 0.002, location.longitude - 0.001),
          icon: storeIcon,
          infoWindow: const InfoWindow(title: "سوبر ماركت"),
        ),
      };
    });
  }

  Future<BitmapDescriptor> _createCustomMarker(
      IconData icon, Color background) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    const double size = 120;

    final Paint paint = Paint()..color = background;
    final Path path = Path();
    path.moveTo(size / 2, size);
    path.quadraticBezierTo(size, size * 0.6, size / 2, 0);
    path.quadraticBezierTo(0, size * 0.6, size / 2, size);
    canvas.drawPath(path, paint);

    final Paint whiteCircle = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(size / 2, size * 0.45), size * 0.18, whiteCircle);

    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: size * 0.25,
          fontFamily: icon.fontFamily,
          color: background,
          package: icon.fontPackage,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset((size - textPainter.width) / 2,
            (size * 0.45 - textPainter.height / 2)));

    final img =
    await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(pngBytes);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _confettiController.dispose();
    _speechToText.stop();
    super.dispose();
  }

  final visibilityManager = DrawerVisibilityManager(enabled: {
    DrawerFeatures.userProfile,
    DrawerFeatures.userDailyOffers,
    DrawerFeatures.userDelivery,
    DrawerFeatures.providerManageOffers,
    DrawerFeatures.providerManageContracts,
  });

  @override
  Widget build(BuildContext context) {
    final userItems = visibilityManager.buildUserItems();
    final providerItems = visibilityManager.buildProviderItems();

    return SliderDrawer(
      key: _sliderKey,
      sliderOpenSize: 250,
      appBar: null,
      backgroundColor: ManagerColors.white,
      slideDirection: SlideDirection.rightToLeft,
      slider: AppDrawer(
        sliderKey: _sliderKey,
        userName: "عبدالله الدحو/اني",
        role: "مستخدم جديد",
        phone: "0599999999",
        userItems: userItems,
        providerItems: providerItems,
      ),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        final location = controller.currentLocation.value;
        if (location == null) {
          return LocationErrorWidget(onRetry: _checkAndLoadLocation);
        }

        final LatLng currentLatLng =
        LatLng(location.latitude, location.longitude);

        return SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLatLng,
                  zoom: 14,
                ),
                myLocationEnabled: true,
                markers: customMarkers,
                trafficEnabled: false,
                compassEnabled: false,
                buildingsEnabled: false,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                onMapCreated: (GoogleMapController mapController) async {
                  String style = await DefaultAssetBundle.of(context)
                      .loadString('assets/json/style_map.json');
                  mapController.setMapStyle(style);
                },
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: ManagerWidth.w16,
                  right: ManagerWidth.w16,
                  top: ManagerHeight.h24,
                ),
                child: Row(
                  children: [
                    MenuIconButton(
                      onPressed: () {
                        _sliderKey.currentState?.toggle();
                      },
                    ),
                    const Spacer(),
                    NotificationIconButton(
                      onPressed: () {},
                      showDot: true,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: _startListening,
                    child: VoiceAssistantButton(
                      isListening: _isListening,
                      audioLevels: _audioLevels,
                      waveController: _waveController,
                      onTap: _startListening,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ],
                ),
              ),
              if (_showVoiceAssistant)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _closeVoiceAssistant,
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.7,
                        minChildSize: 0.5,
                        maxChildSize: 0.9,
                        builder: (context, scrollController) {
                          return VoiceAssistantPanel(
                            isListening: _isListening,
                            recognizedText: _recognizedText,
                            audioLevels: _audioLevels,
                            waveController: _waveController,
                            onStartListening: _startListening,
                            onStopListening: _stopListening,
                            onClose: _closeVoiceAssistant,
                            scrollController: scrollController,
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}


// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_icons.dart';
// import 'package:app_mobile/core/resources/manager_width.dart';
// import 'package:app_mobile/core/util/snack_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:confetti/confetti.dart';
//
// import '../../../../../core/resources/manager_colors.dart';
// import '../../../../../core/resources/manager_font_size.dart';
// import '../../../../../core/resources/manager_styles.dart';
// import '../../../../../core/widgets/loading_widget.dart';
// import '../controller/map_controller.dart';
// import '../widgets/drawer_widget.dart';
// import '../widgets/location_error_widget.dart';
// import '../widgets/manager_drawer_items.dart';
// import '../widgets/menu_icon_button.dart';
// import '../widgets/notfication_icon_button.dart';
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
//   final controller = Get.find<MapController>();
//   final GlobalKey<SliderDrawerState> _sliderKey = GlobalKey<SliderDrawerState>();
//   final SpeechToText _speechToText = SpeechToText();
//   final ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 2));
//
//   Set<Marker> customMarkers = {};
//   bool _isListening = false;
//   bool _speechEnabled = false;
//   bool _permissionGranted = false;
//   String _recognizedText = "";
//   double _audioLevel = 0.0;
//   List<double> _audioLevels = List.generate(20, (index) => 0.0);
//   late AnimationController _waveController;
//   bool _showVoiceAssistant = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _waveController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     )..repeat();
//     _checkAndLoadLocation();
//     _initSpeech();
//   }
//
//   /// ====== Check permissions and request them if necessary
//   Future<void> _checkAndLoadLocation() async {
//     final hasPermission = await _handleLocationPermission();
//     if (hasPermission) {
//       await controller.loadCurrentLocation();
//       _initMarkers();
//     }
//   }
//
//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     /// ====== Make sure GPS is enabled
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       AppSnackbar.warning("رجاءً قم بتفعيل خدمة الموقع من الإعدادات.",
//           englishMessage: "Please enable location services from settings.");
//       return false;
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         AppSnackbar.error("لا يمكن استخدام الخريطة بدون إذن الموقع.",
//             englishMessage:
//             "The map cannot be used without location permission.");
//         return false;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       AppSnackbar.error("رجاءً فعّل إذن الموقع يدويًا من إعدادات الهاتف.",
//           englishMessage:
//           "Please enable location permission manually from the phone settings.");
//       return false;
//     }
//
//     return true;
//   }
//
//   /// Initialize Speech Recognition
//   Future<void> _initSpeech() async {
//     final status = await Permission.microphone.request();
//     if (status.isGranted) {
//       setState(() {
//         _permissionGranted = true;
//       });
//
//       _speechEnabled = await _speechToText.initialize(
//         onStatus: (status) {
//           print('Speech recognition status: $status');
//           if (status == 'notListening' && _isListening) {
//             setState(() {
//               _isListening = false;
//               if (_recognizedText.isNotEmpty) {
//                 _confettiController.play();
//               }
//             });
//           }
//         },
//         onError: (error) {
//           print('Speech recognition error: $error');
//         },
//       );
//       setState(() {});
//     } else {
//       print('Microphone permission denied');
//     }
//   }
//
//   Future<void> _startListening() async {
//     if (!_permissionGranted) {
//       final status = await Permission.microphone.request();
//       if (!status.isGranted) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('يجب منح إذن استخدام الميكروفون للتمكن من التحدث'),
//             ),
//           );
//         }
//         return;
//       } else {
//         setState(() {
//           _permissionGranted = true;
//         });
//         await _initSpeech();
//       }
//     }
//
//     setState(() {
//       _recognizedText = "";
//       _showVoiceAssistant = true;
//     });
//
//     if (_speechEnabled) {
//       await _speechToText.listen(
//         onResult: (result) {
//           setState(() {
//             _recognizedText = result.recognizedWords;
//           });
//         },
//         localeId: "ar-SA",
//         listenMode: ListenMode.confirmation,
//         onSoundLevelChange: (level) {
//           setState(() {
//             _audioLevel = level;
//             _audioLevels.removeAt(0);
//             _audioLevels.add(level);
//           });
//         },
//       );
//       setState(() {
//         _isListening = true;
//       });
//     } else {
//       await _initSpeech();
//       if (_speechEnabled) {
//         await _startListening();
//       }
//     }
//   }
//
//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {
//       _isListening = false;
//       if (_recognizedText.isNotEmpty) {
//         _confettiController.play();
//       }
//     });
//   }
//
//   void _closeVoiceAssistant() {
//     setState(() {
//       _showVoiceAssistant = false;
//     });
//     _stopListening();
//   }
//
//   Future<void> _initMarkers() async {
//     final location = controller.currentLocation.value;
//     if (location == null) return;
//
//     final restaurantIcon =
//     await _createCustomMarker(Icons.restaurant, Colors.deepPurple);
//     final cafeIcon =
//     await _createCustomMarker(Icons.local_cafe, Colors.deepPurple);
//     final storeIcon = await _createCustomMarker(Icons.store, Colors.deepPurple);
//
//     setState(() {
//       customMarkers = {
//         Marker(
//           markerId: const MarkerId("restaurant"),
//           position:
//           LatLng(location.latitude + 0.001, location.longitude + 0.001),
//           icon: restaurantIcon,
//           infoWindow: const InfoWindow(title: "مطعم شرقي"),
//         ),
//         Marker(
//           markerId: const MarkerId("cafe"),
//           position:
//           LatLng(location.latitude - 0.001, location.longitude - 0.001),
//           icon: cafeIcon,
//           infoWindow: const InfoWindow(title: "مقهى"),
//         ),
//         Marker(
//           markerId: const MarkerId("store"),
//           position:
//           LatLng(location.latitude + 0.002, location.longitude - 0.001),
//           icon: storeIcon,
//           infoWindow: const InfoWindow(title: "سوبر ماركت"),
//         ),
//       };
//     });
//   }
//
//   /// Create a custom marker
//   Future<BitmapDescriptor> _createCustomMarker(
//       IconData icon, Color background) async {
//     final ui.PictureRecorder recorder = ui.PictureRecorder();
//     final Canvas canvas = Canvas(recorder);
//     const double size = 120;
//
//     final Paint paint = Paint()..color = background;
//     final Path path = Path();
//     path.moveTo(size / 2, size);
//     path.quadraticBezierTo(size, size * 0.6, size / 2, 0);
//     path.quadraticBezierTo(0, size * 0.6, size / 2, size);
//     canvas.drawPath(path, paint);
//
//     final Paint whiteCircle = Paint()..color = Colors.white;
//     canvas.drawCircle(Offset(size / 2, size * 0.45), size * 0.18, whiteCircle);
//
//     final textPainter = TextPainter(
//       text: TextSpan(
//         text: String.fromCharCode(icon.codePoint),
//         style: TextStyle(
//           fontSize: size * 0.25,
//           fontFamily: icon.fontFamily,
//           color: background,
//           package: icon.fontPackage,
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//     );
//     textPainter.layout();
//     textPainter.paint(
//         canvas,
//         Offset((size - textPainter.width) / 2,
//             (size * 0.45 - textPainter.height / 2)));
//
//     final img =
//     await recorder.endRecording().toImage(size.toInt(), size.toInt());
//     final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
//     final Uint8List pngBytes = byteData!.buffer.asUint8List();
//
//     return BitmapDescriptor.fromBytes(pngBytes);
//   }
//
//   @override
//   void dispose() {
//     _waveController.dispose();
//     _confettiController.dispose();
//     _speechToText.stop();
//     super.dispose();
//   }
//   final visibilityManager = DrawerVisibilityManager(enabled: {
//     // User features enabled
//     DrawerFeatures.userProfile,
//     DrawerFeatures.userDailyOffers,
//     DrawerFeatures.userDelivery,
//
//     // Provider features enabled
//     DrawerFeatures.providerManageOffers,
//     DrawerFeatures.providerManageContracts,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final userItems = visibilityManager.buildUserItems();
//     final providerItems = visibilityManager.buildProviderItems();
//
//    return Obx((){
//       if (controller.isLoading.value) {
//         return Scaffold(
//           body:  Center(child: LoadingWidget()),
//         );
//       }
//
//       final location = controller.currentLocation.value;
//       if (location == null) {
//         return LocationErrorWidget(
//           onRetry: _checkAndLoadLocation,
//         );
//       }
//
//       return SliderDrawer(
//         key: _sliderKey,
//         sliderOpenSize: 250,
//         // appBar: null,
//         backgroundColor: ManagerColors.white,
//         slideDirection: SlideDirection.rightToLeft,
//         slider: AppDrawer(
//           sliderKey: _sliderKey,
//           userName: "عبدالله الدحو/اني",
//           role: "مستخدم جديد",
//           phone: "0599999999",
//           userItems: userItems,
//           providerItems: providerItems,
//         ),
//         child: Scaffold(
//           body: Obx(() {
//             // if (controller.isLoading.value) {
//             //   return const LoadingWidget();
//             // }
//             //
//             // final location = controller.currentLocation.value;
//             // if (location == null) {
//             //   return LocationErrorWidget(
//             //     onRetry: _checkAndLoadLocation,
//             //   );
//             // }
//
//             final LatLng currentLatLng =
//             LatLng(location.latitude, location.longitude);
//
//             return SafeArea(
//               child: Stack(
//                 children: [
//                   GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: currentLatLng,
//                       zoom: 14,
//                     ),
//                     myLocationEnabled: true,
//                     markers: customMarkers,
//                     trafficEnabled: false,
//                     compassEnabled: false,
//                     buildingsEnabled: false,
//                     mapToolbarEnabled: false,
//                     myLocationButtonEnabled: false,
//                     onMapCreated: (GoogleMapController mapController) async {
//                       String style = await DefaultAssetBundle.of(context)
//                           .loadString('assets/json/style_map.json');
//                       mapController.setMapStyle(style);
//                     },
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                       left: ManagerWidth.w16,
//                       right: ManagerWidth.w16,
//                       top: ManagerHeight.h24,
//                     ),
//                     child: Row(
//                       children: [
//                         MenuIconButton(
//                           onPressed: () {
//                             _sliderKey.currentState?.toggle();
//                           },
//                         ),
//                         const Spacer(),
//                         NotificationIconButton(
//                           onPressed: () {},
//                           showDot: true,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 24,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: GestureDetector(
//                         onTap: _startListening,
//                         child: VoiceAssistantButton(
//                           isListening: _isListening,
//                           audioLevels: _audioLevels,
//                           waveController: _waveController,
//                           onTap: _startListening,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.topCenter,
//                     child: ConfettiWidget(
//                       confettiController: _confettiController,
//                       blastDirectionality: BlastDirectionality.explosive,
//                       shouldLoop: false,
//                       colors: const [
//                         Colors.green,
//                         Colors.blue,
//                         Colors.pink,
//                         Colors.orange,
//                         Colors.purple
//                       ],
//                     ),
//                   ),
//
//                   // Voice Assistant Panel that appears when mic is pressed
//                   if (_showVoiceAssistant)
//                     Positioned.fill(
//                       child: GestureDetector(
//                         onTap: _closeVoiceAssistant,
//                         child: Container(
//                           color: Colors.black.withOpacity(0.4),
//                           child: DraggableScrollableSheet(
//                             initialChildSize: 0.7,
//                             minChildSize: 0.5,
//                             maxChildSize: 0.9,
//                             builder: (context, scrollController) {
//                               return VoiceAssistantPanel(
//                                 isListening: _isListening,
//                                 recognizedText: _recognizedText,
//                                 audioLevels: _audioLevels,
//                                 waveController: _waveController,
//                                 onStartListening: _startListening,
//                                 onStopListening: _stopListening,
//                                 onClose: _closeVoiceAssistant,
//                                 scrollController: scrollController,
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             );
//           }),
//         ),
//       );
//     });
//
//
//   }
// }
//
class VoiceAssistantButton extends StatelessWidget {
  final bool isListening;
  final List<double> audioLevels;
  final AnimationController waveController;
  final VoidCallback onTap;

  const VoiceAssistantButton({
    super.key,
    required this.isListening,
    required this.audioLevels,
    required this.waveController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: waveController,
      builder: (context, child) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ManagerColors.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: ManagerColors.primaryColor.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: isListening ? 5 : 0,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Waves based on audio level
                ...List.generate(3, (index) {
                  final progress = ((waveController.value + (index * 0.3)) % 1.0);
                  final waveSize = 80 + (progress * 40) + (isListening ? audioLevels.isNotEmpty ? audioLevels.last * 0.5 : 0 : 0);

                  return Container(
                    width: waveSize,
                    height: waveSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ManagerColors.primaryColor.withOpacity((1 - progress) * 0.3),
                        width: 2,
                      ),
                    ),
                  );
                }),

                // Main icon
                Icon(
                  isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                  size: 36,
                ),

                // Pulsating circle when listening
                if (isListening)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ManagerColors.primaryColor.withOpacity(0.2),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
//
class VoiceAssistantPanel extends StatefulWidget {
  final bool isListening;
  final String recognizedText;
  final List<double> audioLevels;
  final AnimationController waveController;
  final VoidCallback onStartListening;
  final VoidCallback onStopListening;
  final VoidCallback onClose;
  final ScrollController scrollController;

  const VoiceAssistantPanel({
    super.key,
    required this.isListening,
    required this.recognizedText,
    required this.audioLevels,
    required this.waveController,
    required this.onStartListening,
    required this.onStopListening,
    required this.onClose,
    required this.scrollController,
  });

  @override
  State<VoiceAssistantPanel> createState() => _VoiceAssistantPanelState();
}

class _VoiceAssistantPanelState extends State<VoiceAssistantPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ManagerColors.primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: widget.onClose,
              ),
              Text(
                "المساعد الصوتي",
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s18,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.open_in_full, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  if (widget.recognizedText.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        controller: widget.scrollController,
                        child: Text(
                          widget.recognizedText,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        controller: widget.scrollController,
                        child: Text(
                          "تمام، خليني أضبطلك الأطيب.. بس قبل هيك بتحب تختار من الجري والسلطات، ولا نفسك بالأكل الشرقي المشبع؟",
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Visual audio level indicator
                  if (widget.isListening)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(10, (index) {
                        final level = widget.audioLevels.isNotEmpty
                            ? widget.audioLevels[widget.audioLevels.length - 1 - (index % widget.audioLevels.length)]
                            : 0.0;
                        final height = 10 + (level * 0.5);

                        return Container(
                          width: 4,
                          height: height,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      }),
                    ),

                  const SizedBox(height: 20),

                  // Animated mic button
                  GestureDetector(
                    onTap: widget.isListening ? widget.onStopListening : widget.onStartListening,
                    child: AnimatedBuilder(
                      animation: widget.waveController,
                      builder: (context, child) {
                        return Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: widget.isListening ? 8 : 0,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Waves based on audio level
                              if (widget.isListening)
                                ...List.generate(3, (index) {
                                  final progress = ((widget.waveController.value + (index * 0.3)) % 1.0);
                                  final waveSize = 80 + (progress * 60) + (widget.audioLevels.isNotEmpty ? widget.audioLevels.last * 0.8 : 0);

                                  return Container(
                                    width: waveSize,
                                    height: waveSize,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity((1 - progress) * 0.2),
                                        width: 2,
                                      ),
                                    ),
                                  );
                                }),

                              Icon(
                                widget.isListening ? Icons.mic : Icons.mic_none,
                                color: ManagerColors.primaryColor,
                                size: 36,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    widget.isListening ? "جاري الاستماع..." : "انقر للتحدث",
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s14,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
