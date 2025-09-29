// import 'package:app_mobile/core/error_handler/failure.dart';
// import 'package:app_mobile/core/util/snack_bar.dart';
// import 'package:app_mobile/features/users/offer_user/list_offers/domain/model/offer_user_item_model.dart';
// import 'package:app_mobile/features/users/offer_user/list_offers/domain/model/offer_user_model.dart';
// import 'package:get/get.dart';
//
// import '../../domain/use_case/get_offer_use_case.dart';
//
// class OffersController extends GetxController {
//   final GetOfferUseCase _getOfferUseCase;
//
//   OffersController(this._getOfferUseCase);
//
//   /// الحالة ال
//   final isLoading = false.obs;
//   final errorMessage = ''.obs;
//
//   /// البيانات
//   final offers = <OfferUserItemModel>[].obs;
//
//   Future<void> fetchOffers() async {
//     isLoading.value = true;
//     errorMessage.value = '';
//
//     final result = await _getOfferUseCase.execute();
//
//     result.fold(
//       (Failure f) {
//         errorMessage.value = f.message ?? "حدث خطأ أثناء تحميل البيانات";
//         AppSnackbar.error(errorMessage.value);
//       },
//       (OfferUserModel model) {
//         if (model.error) {
//           errorMessage.value = model.message;
//           AppSnackbar.error(model.message);
//         } else {
//           offers.assignAll(model.data.data);
//         }
//       },
//     );
//
//     isLoading.value = false;
//   }
//
//   /// تحديث البيانات (لـ pull-to-refresh)
//   Future<void> refreshOffers() => fetchOffers();
// }
