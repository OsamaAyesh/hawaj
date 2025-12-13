import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/util/empty_state_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
import 'package:app_mobile/features/providers/real_estate_provider/register_to_real_estate_provider_service/presentation/pages/register_to_real_estate_provider_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';
import '../../../edit_profile_real_state_owner/domain/di/di.dart';
import '../../../edit_profile_real_state_owner/presentation/pages/edit_profile_real_state_owner_screen.dart';
import '../../../register_to_real_estate_provider_service/domain/di/di.dart';
import '../controller/get_my_real_estate_my_owner_controller.dart';
import '../widgets/property_owner_card_widget.dart';
import '../widgets/property_owner_shimmer_widget.dart';

class GetRealEstateMyOwnersScreen extends StatefulWidget {
  const GetRealEstateMyOwnersScreen({super.key});

  @override
  State<GetRealEstateMyOwnersScreen> createState() =>
      _GetRealEstateMyOwnersScreenState();
}

class _GetRealEstateMyOwnersScreenState
    extends State<GetRealEstateMyOwnersScreen> {
  late final GetRealEstateMyOwnersController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<GetRealEstateMyOwnersController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchMyOwners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "ملكياتي",
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ManagerColors.primaryColor,
        onPressed: () async {
          initAddMyPropertyOwners();
          await Get.to(() => const RegisterToRealEstateProviderServiceScreen());
          disposeAddMyPropertyOwners();
          await controller.refreshOwners();
        },
        icon: const Icon(Icons.add_rounded, color: ManagerColors.white),
        label: Text(
          'إضافة ملكية',
          style: getMediumTextStyle(
            fontSize: 14,
            color: ManagerColors.white,
          ),
        ),
        elevation: 4,
      ),
      body: Obx(() {
        // ===== Loading State =====
        if (controller.isLoading.value) {
          return _buildShimmerLoading();
        }

        // ===== Error State =====
        if (controller.errorMessage.isNotEmpty && controller.owners.isEmpty) {
          return _buildErrorState();
        }

        // ===== Empty State =====
        if (controller.owners.isEmpty) {
          return _buildEmptyState();
        }

        // ===== Success State =====
        return RefreshIndicator(
          color: ManagerColors.primaryColor,
          onRefresh: () => controller.refreshOwners(),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w16,
              vertical: ManagerHeight.h12,
            ),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.owners.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: ManagerHeight.h12),
            itemBuilder: (context, index) {
              final owner = controller.owners[index];
              return _AnimatedOwnerCard(
                owner: owner,
                index: index,
              );
            },
          ),
        );
      }),
    ).withHawaj(
      section: HawajSections.realEstates,
      screen: HawajScreens.myOwnerPropertys,
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w16,
        vertical: ManagerHeight.h12,
      ),
      itemCount: 3,
      separatorBuilder: (context, index) => SizedBox(height: ManagerHeight.h12),
      itemBuilder: (context, index) {
        return const PropertyOwnerShimmerWidget();
      },
    );
  }

  Widget _buildErrorState() {
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
                  backgroundColor: ManagerColors.primaryColor,
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
    return EmptyStateWidget(
      messageAr: "لا توجد ملكيات",
      messageEn: "No ownership",
    );
  }
}

// Animated Owner Card
class _AnimatedOwnerCard extends StatefulWidget {
  final dynamic owner;
  final int index;

  const _AnimatedOwnerCard({
    required this.owner,
    required this.index,
  });

  @override
  State<_AnimatedOwnerCard> createState() => _AnimatedOwnerCardState();
}

class _AnimatedOwnerCardState extends State<_AnimatedOwnerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 80)),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetRealEstateMyOwnersController>();

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: PropertyOwnerCardWidget(
          owner: widget.owner,
          onTap: () async {
            final ownerId = widget.owner.id ?? '';
            initEditProfileMyPropertyOwnerModule(ownerId);
            await Get.to(() => EditProfileRealStateOwnerScreen(
                  ownerId: ownerId,
                  owner: widget.owner,
                ));
            disposeEditProfileMyPropertyOwnerModule();
            await controller.refreshOwners();
          },
          onEdit: () async {
            final ownerId = widget.owner.id ?? '';
            initEditProfileMyPropertyOwnerModule(ownerId);
            await Get.to(() => EditProfileRealStateOwnerScreen(
                  ownerId: ownerId,
                  owner: widget.owner,
                ));
            disposeEditProfileMyPropertyOwnerModule();
            await controller.refreshOwners();
          },
        ),
      ),
    );
  }
}
