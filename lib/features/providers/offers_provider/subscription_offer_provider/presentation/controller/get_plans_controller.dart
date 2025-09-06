import 'package:get/get.dart';
import 'package:app_mobile/core/error_handler/failure.dart';
import 'package:app_mobile/features/providers/offers_provider/subscription_offer_provider/domain/model/plan_item_model.dart';
import '../../domain/use_case/get_plans_use_case.dart';

class PlansController extends GetxController {
  final GetPlansUseCase _getPlansUseCase;
  PlansController(this._getPlansUseCase);

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var plans = <PlanItemModel>[].obs;

  /// الخطة المختارة
  Rxn<PlanItemModel> selectedPlan = Rxn<PlanItemModel>();

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

        /// نختار أول خطة كـ default
        if (plans.isNotEmpty) {
          selectedPlan.value = plans.first;
        }
      },
    );
  }

  void selectPlanByDays(double days) {
    final plan = plans.firstWhereOrNull((p) => p.days == days);
    if (plan != null) {
      selectedPlan.value = plan;
    }
  }
}
