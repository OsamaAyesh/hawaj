import 'package:get/get.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/domain/model/offer_item_model.dart';
import 'package:app_mobile/features/providers/offers_provider/manage_list_offer/domain/use_case/get_my_offer_use_case.dart';

class GetMyOfferController extends GetxController {
  final GetMyOfferUseCase _getMyOfferUseCase;

  GetMyOfferController(this._getMyOfferUseCase);

  /// ====== Reactive Variables ======
  var isLoading = false.obs;
  var offers = <OfferItemModel>[].obs;
  var errorMessage = "".obs;

  /// ====== Load Offers ======
  Future<void> loadOffers() async {
    isLoading.value = true;
    errorMessage.value = "";

    final result = await _getMyOfferUseCase.execute();

    result.fold(
          (failure) {
        errorMessage.value = failure.message;
      },
          (offerModel) {
        offers.value = offerModel.data.data;
      },
    );

    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    loadOffers();
  }
}
