import 'package:app_mobile/core/util/snack_bar.dart';
import 'package:get/get.dart';
import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/core/model/with_out_data_model.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/plan_item_model.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/get_my_organization_offer_provider_model.dart';

import '../../../../../../core/model/orgnization_company_daily_offer_item_model.dart';
import '../../domain/use_case/get_plans_use_case.dart';
import '../../domain/use_case/get_my_organization_offer_provider_use_case.dart';
import '../../domain/use_case/set_subscription_offer_provider_use_case.dart';
import '../../data/request/set_subscription_offer_provider_request.dart';
import '../pages/success_subscription_offer_provider_screen.dart';

class PlansController extends GetxController {
  final GetPlansUseCase _getPlansUseCase;
  final GetMyOrganizationOfferProviderUseCase _getMyOrganizationsUseCase;
  final SetSubscriptionOfferProviderUseCase _setSubscriptionUseCase;

  PlansController(
      this._getPlansUseCase,
      this._getMyOrganizationsUseCase,
      this._setSubscriptionUseCase,
      );

  /// Loading & Error
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// Plans
  var plans = <PlanItemModel>[].obs;
  Rxn<PlanItemModel> selectedPlan = Rxn<PlanItemModel>();

  /// Organizations
  var organizations = <OrganizationCompanyDailyOfferItemModel>[].obs;
  Rxn<OrganizationCompanyDailyOfferItemModel> selectedOrganization =
  Rxn<OrganizationCompanyDailyOfferItemModel>();

  /// -------- Fetch Plans --------
  Future<void> fetchPlans() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getPlansUseCase.execute();

    result.fold(
          (Failure failure) {
        isLoading.value = false;
        errorMessage.value = failure.message;
      },
          (planModel) {
        isLoading.value = false;
        plans.value = planModel.data.data;
        if (plans.isNotEmpty) {
          selectedPlan.value = plans.first; // الافتراضي
        }
      },
    );
  }

  /// -------- Fetch Organizations --------
  Future<void> fetchOrganizations() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await _getMyOrganizationsUseCase.execute();

    result.fold(
          (Failure failure) {
        isLoading.value = false;
        errorMessage.value = failure.message;
      },
          (organizationModel) {
        isLoading.value = false;
        organizations.value = organizationModel.data.data;
        if (organizations.isNotEmpty) {
          selectedOrganization.value = organizations.first; // ناخد أول وحدة
        }
      },
    );
  }

  /// -------- Select Plan By Days --------
  void selectPlanByDays(double days) {
    final plan = plans.firstWhereOrNull((p) => p.days == days);
    if (plan != null) {
      selectedPlan.value = plan;
    }
  }

  /// -------- Set Subscription --------
  Future<void> subscribe() async {
    if (selectedOrganization.value == null || selectedPlan.value == null) {
      errorMessage.value = "لم يتم اختيار المؤسسة أو الخطة";
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    final request = SetSubscriptionOfferProviderRequest(
      organizationsId: selectedOrganization.value!.id,
      plansId: selectedPlan.value!.id,
    );

    final result = await _setSubscriptionUseCase.execute(request);

    result.fold(
          (Failure failure) {
        isLoading.value = false;
        errorMessage.value = failure.message;
      },
          (WithOutDataModel response) {
        isLoading.value = false;
        AppSnackbar.success("تم الأشتراك بنجاح في هذه الخطة لمؤسستك",
          englishMessage: "Successfully subscribed to this plan for your organization."
        );
        Get.offAll(const SuccessSubscriptionOfferProviderScreen());
      },
    );
  }

  /// -------- Initialize Data --------
  Future<void> initData() async {
    await fetchPlans();
    await fetchOrganizations();
  }
}
