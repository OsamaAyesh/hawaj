import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/util/empty_state_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/get_my_property_owner_controller.dart';
import '../widgets/my_property_owner_item_widget.dart';
import '../widgets/shimmer_property_card_widget.dart';

class MyPropertyOwnerScreen extends StatefulWidget {
  const MyPropertyOwnerScreen({super.key});

  @override
  State<MyPropertyOwnerScreen> createState() => _MyPropertyOwnerScreenState();
}

class _MyPropertyOwnerScreenState extends State<MyPropertyOwnerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<GetMyPropertyOwnerController>();
      controller.fetchMyOwners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetMyPropertyOwnerController>();

    return ScaffoldWithBackButton(
      title: 'إدارة الملكيات العقارية',
      body: Obx(() {
        // Loading State with Shimmer
        if (controller.isLoading.value) {
          return _buildShimmerLoading();
        }

        // Error State
        if (controller.errorMessage.isNotEmpty && controller.owners.isEmpty) {
          return _buildErrorState(controller);
        }

        // Empty State
        if (controller.owners.isEmpty) {
          return _buildEmptyState();
        }

        // Success State with Data
        return RefreshIndicator(
          onRefresh: () => controller.fetchMyOwners(),
          color: Theme.of(context).primaryColor,
          child: ListView.builder(
            padding: EdgeInsets.only(
                left: ManagerWidth.w16,
                right: ManagerWidth.w16,
                top: ManagerHeight.h16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.owners.length,
            itemBuilder: (context, index) {
              final owner = controller.owners[index];
              return PropertyOwnerCard(
                owner: owner,
                index: index,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w16, vertical: ManagerHeight.h16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return const ShimmerPropertyCard();
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: ManagerHeight.h12);
      },
    );
  }

  Widget _buildErrorState(GetMyPropertyOwnerController controller) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 70,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'حدث خطأ',
                style: getBoldTextStyle(
                  fontSize: 24,
                  color: Colors.grey[800]!,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: getRegularTextStyle(
                  fontSize: 16,
                  color: Colors.grey[600]!,
                ),
              ),
              const SizedBox(height: 36),
              ElevatedButton.icon(
                onPressed: () => controller.fetchMyOwners(),
                icon: const Icon(Icons.refresh_rounded, size: 22),
                label: Text(
                  'إعادة المحاولة',
                  style: getMediumTextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: SingleChildScrollView(
        child: EmptyStateWidget(
          messageAr: "لا توجد ملكيات مسجلة",
          messageEn: "No registered properties owners",
        ),
      ),
    );
  }
}
