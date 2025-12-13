import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/util/empty_state_widget.dart';
import 'package:app_mobile/core/widgets/custom_confirm_dialog.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/real_estate_item_model.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../add_real_estate/domain/di/di.dart';
import '../../../add_real_estate/presentation/pages/add_real_estate_screen.dart';
import '../../domain/di/di.dart';
import '../controller/delete_my_real_estate_controller.dart';
import '../controller/get_my_real_estates_controller.dart';
import '../widgets/real_estate_card_widget.dart';
import '../widgets/real_estate_shimmer_widget.dart';
import 'edit_my_real_estate_screen.dart';

class ManagerMyRealEstateProviderScreen extends StatefulWidget {
  final String id;

  const ManagerMyRealEstateProviderScreen({super.key, required this.id});

  @override
  State<ManagerMyRealEstateProviderScreen> createState() =>
      _ManagerMyRealEstateProviderScreenState();
}

class _ManagerMyRealEstateProviderScreenState
    extends State<ManagerMyRealEstateProviderScreen> {
  late GetMyRealEstatesController getController;
  late DeleteMyRealEstateController deleteController;

  @override
  void initState() {
    super.initState();
    getController = Get.find<GetMyRealEstatesController>();
    deleteController = Get.find<DeleteMyRealEstateController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getController.fetchMyRealEstates(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ManagerColors.primaryColor,
        onPressed: () {
          initAddRealEstateModule();
          Get.to(() => const AddRealEstateScreen());
        },
        icon: const Icon(Icons.add_rounded, color: ManagerColors.white),
        label: Text(
          'إضافة عقار',
          style: getMediumTextStyle(
            fontSize: 14,
            color: ManagerColors.white,
          ),
        ),
        elevation: 4,
      ),
      title: "إدارة العقارات",
      body: Obx(() {
        // Loading State with Shimmer
        if (getController.isLoading.value) {
          return _buildShimmerLoading();
        }

        // Error State
        if (getController.errorMessage.isNotEmpty &&
            getController.realEstates.isEmpty) {
          return _buildErrorState();
        }

        // Empty State
        if (getController.realEstates.isEmpty) {
          return RefreshIndicator(
            color: ManagerColors.primaryColor,
            onRefresh: () => getController.refreshEstates(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height - kToolbarHeight - 100,
                child: const Center(
                  child: EmptyStateWidget(
                    messageAr: "لا يوجد عقارات",
                    messageEn: "No properties",
                  ),
                ),
              ),
            ),
          );
        }

        // Success State with Data
        return RefreshIndicator(
          color: ManagerColors.primaryColor,
          onRefresh: () => getController.refreshEstates(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: getController.realEstates.length,
            itemBuilder: (context, index) {
              final estate = getController.realEstates[index];
              return _AnimatedRealEstateCard(
                estate: estate,
                index: index,
                onEdit: () {
                  // initEditMyRealEstate();
                  initEditMyRealEstateModule();
                  Get.to(() => EditMyRealEstateScreen(realEstate: estate));
                },
                onDelete: () => _showDeleteDialog(context, estate.id),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return const RealEstateShimmerWidget();
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
                  fontSize: ManagerFontSize.s16,
                  color: Colors.grey[800]!,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                getController.errorMessage.value,
                textAlign: TextAlign.center,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: Colors.grey[600]!,
                ),
              ),
              const SizedBox(height: 36),
              ElevatedButton.icon(
                onPressed: () => getController.fetchMyRealEstates(widget.id),
                icon: const Icon(Icons.refresh_rounded, size: 22),
                label: Text(
                  'إعادة المحاولة',
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s14,
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

  Future<void> _showDeleteDialog(BuildContext context, String id) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomConfirmDialog(
        title: "تأكيد الحذف",
        subtitle: "هل أنت متأكد أنك تريد حذف هذا العقار؟",
        confirmText: "تأكيد",
        cancelText: "إلغاء",
        onConfirm: () async {
          Get.back();
          await deleteController.deleteRealEstate(double.tryParse(id) ?? 0);
          await getController.refreshEstates();
        },
        onCancel: () => Get.back(),
      ),
    );
  }
}

// Animated Wrapper for Real Estate Card
class _AnimatedRealEstateCard extends StatefulWidget {
  final RealEstateItemModel estate;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AnimatedRealEstateCard({
    required this.estate,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_AnimatedRealEstateCard> createState() =>
      _AnimatedRealEstateCardState();
}

class _AnimatedRealEstateCardState extends State<_AnimatedRealEstateCard>
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

  // الحصول على أول صورة من قائمة الصور
  String _getFirstImage() {
    if (widget.estate.propertyImages.isEmpty) return '';
    final images = widget.estate.propertyImages.split(',');
    return images.isNotEmpty ? images.first.trim() : '';
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: RealEstateCardWidget(
          id: widget.estate.id,
          showActions: true,
          imageUrl: _getFirstImage(),
          title: widget.estate.propertySubject,
          location: widget.estate.propertyDetailedAddress,
          area: '${widget.estate.areaSqm} م²',
          rooms: '-',
          // Not Contain In Model Response
          halls: '-',
          // Not Contain In Model Response
          baths: '-',
          // Not Contain In Model Response
          direction: '-',
          // Not Contain In Model Response
          purpose: widget.estate.operationTypeLabel,
          age: '-',
          // Not Contain In Model Response
          commission: '${widget.estate.commissionPercentage}%',
          price: widget.estate.price,
          features: widget.estate.featureIds.isNotEmpty
              ? widget.estate.featureIds.split(',')
              : [],
          extraInfo: {
            'نوع العقار': widget.estate.propertyTypeLabel,
            'دور المعلن': widget.estate.advertiserRoleLabel,
            'نوع البيع': widget.estate.saleTypeLabel,
            'نوع الاستخدام': widget.estate.usageTypeLabel,
          },
          onEdit: widget.onEdit,
          onDelete: widget.onDelete,
        ),
      ),
    );
  }
}
