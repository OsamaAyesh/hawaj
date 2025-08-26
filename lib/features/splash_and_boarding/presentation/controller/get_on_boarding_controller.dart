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

  ///=== List of items that will appear in the OnBoarding UI
  var items = <OnBoardingItemModel>[].obs;

  ///=== Return the full image link
  String getImageUrl(OnBoardingItemModel item) => _baseUrl + item.screenImage;

  /// Load data (from cache or API) + Download images from cache
  Future<void> preloadOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();

// 1. Get cash if available
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

      // Prefetch images
      for (var item in items) {
        await DefaultCacheManager().downloadFile(getImageUrl(item));
      }
      return;
    }

// 2. If there is no cash → API call
    final result = await _useCase.execute();
    result.fold(
      (failure) {},
      (data) async {
        items.assignAll(data.data.data);

// Store them as JSON in SharedPreferences
        prefs.setString(
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

// Prefetch images
        for (var item in items) {
          await DefaultCacheManager().downloadFile(getImageUrl(item));
        }
      },
    );
  }
}
