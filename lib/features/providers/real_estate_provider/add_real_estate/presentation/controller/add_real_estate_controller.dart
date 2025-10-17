import 'dart:io';

import 'package:app_mobile/core/util/get_app_langauge.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../../../../core/util/snack_bar.dart';
import '../../../../../common/lists/data/request/get_lists_request.dart';
import '../../../../../common/lists/domain/use_cases/get_lists_use_case.dart';
import '../../data/request/add_real_state_request.dart';
import '../../domain/use_cases/add_real_estate_use_case.dart';

class AddRealEstateController extends GetxController {
  final AddRealEstateUseCase _addRealEstateUseCase;
  final GetListsUseCase _getListsUseCase;

  AddRealEstateController(this._addRealEstateUseCase, this._getListsUseCase);

  final isLoading = false.obs;
  final isListsLoaded = false.obs;

  // Dropdown Lists
  final propertyTypes = <Map<String, String>>[].obs;
  final operationTypes = <Map<String, String>>[].obs;
  final advertiserRoles = <Map<String, String>>[].obs;
  final saleTypes = <Map<String, String>>[].obs;
  final usageTypes = <Map<String, String>>[].obs;
  final weekDays = <Map<String, String>>[].obs;
  final features = <Map<String, String>>[].obs;
  final facilities = <Map<String, String>>[].obs;

  // Selected values
  String? selectedPropertyType;
  String? selectedOperationType;
  String? selectedAdvertiserRole;
  String? selectedSaleType;
  String? selectedUsageType;
  String? selectedVisitDays;

  // Inputs
  String? detailedAddress;
  String? price;
  String? area;
  String? commission;
  String? propertyDescription;
  String? propertySubject;
  String? keywords;

  // Files
  List<File> propertyImages = [];
  List<File> propertyVideos = [];
  File? deedDocument;

  // ======================
  // 🔹 Init
  // ======================
  @override
  void onInit() {
    super.onInit();
    _fetchLists();
  }

  // ======================
  // 🔹 Fetch Lists
  // ======================
  Future<void> _fetchLists() async {
    isLoading.value = true;
    final result = await _getListsUseCase
        .execute(GetListsRequest(language: AppLanguage().getCurrentLocale()));
    result.fold((failure) {
      AppSnackbar.error('فشل في تحميل البيانات',
          englishMessage: 'Failed to load lists');
    }, (response) {
      final fieldChoices = response.data.fieldChoices;
      propertyTypes.assignAll(fieldChoices
          .where((e) => e.choice == 'property_type')
          .map((e) => {'id': e.name, 'label': e.label})
          .toList());
      operationTypes.assignAll(fieldChoices
          .where((e) => e.choice == 'operation_type')
          .map((e) => {'id': e.name, 'label': e.label})
          .toList());
      advertiserRoles.assignAll(fieldChoices
          .where((e) => e.choice == 'advertiser_role')
          .map((e) => {'id': e.name, 'label': e.label})
          .toList());
      saleTypes.assignAll(fieldChoices
          .where((e) => e.choice == 'sale_type')
          .map((e) => {'id': e.name, 'label': e.label})
          .toList());
      usageTypes.assignAll(fieldChoices
          .where((e) => e.choice == 'usage_type')
          .map((e) => {'id': e.name, 'label': e.label})
          .toList());
      weekDays.assignAll(fieldChoices
          .where((e) => e.choice == 'week_days')
          .map((e) => {'id': e.name, 'label': e.label})
          .toList());
      features.assignAll(response.data.features
          .map((e) => {'id': e.id, 'label': e.featureName})
          .toList());
      facilities.assignAll(response.data.facilities
          .map((e) => {'id': e.id, 'label': e.facilityName})
          .toList());
      isListsLoaded.value = true;
    });
    isLoading.value = false;
  }

  // ======================
  // 🔹 Validation function
  // ======================
  bool validateAllFields() {
    if (propertySubject == null || propertySubject!.isEmpty) {
      AppSnackbar.warning("يرجى إدخال عنوان الإعلان",
          englishMessage: "Please enter the property subject");
      return false;
    }
    if (selectedPropertyType == null) {
      AppSnackbar.warning("يرجى اختيار نوع العقار",
          englishMessage: "Please select property type");
      return false;
    }
    if (selectedOperationType == null) {
      AppSnackbar.warning("يرجى اختيار نوع العملية (بيع / إيجار)",
          englishMessage: "Please select operation type");
      return false;
    }
    if (selectedAdvertiserRole == null) {
      AppSnackbar.warning("يرجى اختيار صفة المعلن",
          englishMessage: "Please select advertiser role");
      return false;
    }
    if (selectedSaleType == null) {
      AppSnackbar.warning("يرجى اختيار نوع البيع",
          englishMessage: "Please select sale type");
      return false;
    }
    if (detailedAddress == null || detailedAddress!.isEmpty) {
      AppSnackbar.warning("يرجى إدخال العنوان التفصيلي",
          englishMessage: "Please enter property detailed address");
      return false;
    }
    if (price == null || price!.isEmpty) {
      AppSnackbar.warning("يرجى إدخال السعر المطلوب",
          englishMessage: "Please enter property price");
      return false;
    }
    if (area == null || area!.isEmpty) {
      AppSnackbar.warning("يرجى إدخال المساحة",
          englishMessage: "Please enter property area");
      return false;
    }
    if (commission == null || commission!.isEmpty) {
      AppSnackbar.warning("يرجى إدخال نسبة العمولة",
          englishMessage: "Please enter commission percentage");
      return false;
    }
    if (propertyDescription == null || propertyDescription!.isEmpty) {
      AppSnackbar.warning("يرجى كتابة وصف للعقار",
          englishMessage: "Please enter property description");
      return false;
    }
    if (propertyImages.isEmpty) {
      AppSnackbar.warning("يرجى إضافة صور للعقار",
          englishMessage: "Please upload property images");
      return false;
    }
    if (deedDocument == null) {
      AppSnackbar.warning("يرجى رفع صك الملكية",
          englishMessage: "Please upload property deed document");
      return false;
    }
    if (selectedVisitDays == null) {
      AppSnackbar.warning("يرجى تحديد أيام الزيارة",
          englishMessage: "Please select visit days");
      return false;
    }
    return true;
  }

  // ======================
  // 🔹 Get location
  // ======================
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      AppSnackbar.warning('يرجى تفعيل خدمة الموقع',
          englishMessage: 'Enable location service');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      AppSnackbar.error('تم رفض إذن الموقع نهائيًا',
          englishMessage: 'Location permission denied forever');
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  // ======================
  // 🔹 Add Real Estate
  // ======================
  Future<void> addRealEstate() async {
    if (!validateAllFields()) return;

    isLoading.value = true;

    final position = await _getCurrentLocation();
    if (position == null) {
      isLoading.value = false;
      return;
    }

    final request = AddRealStateRequest(
      propertySubject: propertySubject ?? '',
      propertyType: selectedPropertyType ?? '',
      operationType: selectedOperationType ?? '',
      advertiserRole: selectedAdvertiserRole ?? '',
      saleType: selectedSaleType ?? '',
      keywords: keywords ?? '',
      lat: position.latitude.toString(),
      lng: position.longitude.toString(),
      propertyDetailedAddress: detailedAddress ?? '',
      price: price ?? '',
      areaSqm: area ?? '',
      commissionPercentage: commission ?? '',
      usageType: selectedUsageType ?? '',
      propertyDescription: propertyDescription ?? '',
      featureIds: features.map((e) => e['id']).join(','),
      facilityIds: facilities.map((e) => e['id']).join(','),
      visitDays: selectedVisitDays ?? '',
      visitTimeFrom: '2:00',
      visitTimeTo: '4:00',
      propertyImages: propertyImages,
      propertyVideos: propertyVideos,
      deedDocument: deedDocument,
      propertyOwnerId: '3',
    );

    final result = await _addRealEstateUseCase.execute(request);
    result.fold(
      (failure) => AppSnackbar.error('فشل في إضافة العقار',
          englishMessage: 'Failed to add property'),
      (success) => AppSnackbar.success('تمت إضافة العقار بنجاح',
          englishMessage: 'Property added successfully'),
    );

    isLoading.value = false;
  }
}
