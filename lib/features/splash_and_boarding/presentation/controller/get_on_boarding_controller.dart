import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../domain/use_case/on_boarding_use_case.dart';
import '../../domain/model/on_boarding_item_model.dart';

class OnBoardingPreloadController extends GetxController {
  final OnBoardingUseCase _useCase;

  OnBoardingPreloadController(this._useCase);

  static const String _baseUrl = "https://hawaj.lezaz.org/storage/";
  static const String _cacheKey = "on_boarding_cache";

  /// List of onboarding items
  var items = <OnBoardingItemModel>[].obs;

  /// Build full image URL
  String getImageUrl(OnBoardingItemModel item) => _baseUrl + item.screenImage;

  /// Load data (from cache or API) + prefetch images
  Future<void> preloadOnBoarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. Check cache first
      final cachedJson = prefs.getString(_cacheKey);
      if (cachedJson != null) {
        final List<dynamic> data = json.decode(cachedJson);

        items.assignAll(
          data.map((e) => OnBoardingItemModel(
            id: e["id"],
            mainTitle: e["mainTitle"],
            screenName: e["screenName"],
            screenOrder: e["screenOrder"],
            screenImage: e["screenImage"],
            screenDescription: e["screenDescription"],
          )),
        );

        // Prefetch all images in parallel
        await Future.wait(
          items.map((item) =>
              DefaultCacheManager().downloadFile(getImageUrl(item))),
        );

        return; // ✅ Done from cache, no need for API
      }

      // 2. If no cache → call API
      final result = await _useCase.execute();
      result.fold(
            (failure) {
          // handle silently or log
        },
            (data) async {
          items.assignAll(data.data.data);

          // Save JSON in cache
          await prefs.setString(
            _cacheKey,
            json.encode(items
                .map((e) => {
              "id": e.id,
              "mainTitle": e.mainTitle,
              "screenName": e.screenName,
              "screenOrder": e.screenOrder,
              "screenImage": e.screenImage,
              "screenDescription": e.screenDescription,
            })
                .toList()),
          );

          // Prefetch all images in parallel
          await Future.wait(
            items.map((item) =>
                DefaultCacheManager().downloadFile(getImageUrl(item))),
          );
        },
      );
    } catch (e) {
      // Prevent app from being stuck
      print("Error in preloadOnBoarding: $e");
    }
  }
}
