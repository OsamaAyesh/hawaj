import 'package:app_mobile/core/resources/manager_colors.dart';
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
          return _buildEmptyState();
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
                  initEditMyRealEstate();
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
                  fontSize: 24,
                  color: Colors.grey[800]!,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                getController.errorMessage.value,
                textAlign: TextAlign.center,
                style: getRegularTextStyle(
                  fontSize: 16,
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
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(36),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.home_work_outlined,
                  size: 90,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'لا يوجد عقارات',
                style: getBoldTextStyle(
                  fontSize: 24,
                  color: Colors.grey[800]!,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'لم يتم إضافة أي عقارات بعد',
                textAlign: TextAlign.center,
                style: getRegularTextStyle(
                  fontSize: 16,
                  color: Colors.grey[600]!,
                ),
              ),
              const SizedBox(height: 36),
              ElevatedButton.icon(
                onPressed: () {
                  initAddRealEstateModule();
                  Get.to(() => const AddRealEstateScreen());
                },
                icon: const Icon(Icons.add_rounded, size: 22),
                label: Text(
                  'إضافة عقار جديد',
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
          // غير متوفر في الموديل
          halls: '-',
          // غير متوفر في الموديل
          baths: '-',
          // غير متوفر في الموديل
          direction: '-',
          // غير متوفر في الموديل
          purpose: widget.estate.operationTypeLabel,
          age: '-',
          // غير متوفر في الموديل
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

// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/widgets/custom_confirm_dialog.dart';
// import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
//
// import '../../../../../../core/model/real_estate_item_model.dart';
// import '../../../../../../core/resources/manager_styles.dart';
// import '../../../add_real_estate/domain/di/di.dart';
// import '../../../add_real_estate/presentation/pages/add_real_estate_screen.dart';
// import '../../domain/di/di.dart';
// import '../controller/delete_my_real_estate_controller.dart';
// import '../controller/get_my_real_estates_controller.dart';
// import 'edit_my_real_estate_screen.dart';
//
// class ManagerMyRealEstateProviderScreen extends StatefulWidget {
//   final String id;
//
//   const ManagerMyRealEstateProviderScreen({super.key, required this.id});
//
//   @override
//   State<ManagerMyRealEstateProviderScreen> createState() =>
//       _ManagerMyRealEstateProviderScreenState();
// }
//
// class _ManagerMyRealEstateProviderScreenState
//     extends State<ManagerMyRealEstateProviderScreen> {
//   late GetMyRealEstatesController getController;
//   late DeleteMyRealEstateController deleteController;
//
//   @override
//   void initState() {
//     super.initState();
//     getController = Get.find<GetMyRealEstatesController>();
//     deleteController = Get.find<DeleteMyRealEstateController>();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       getController.fetchMyRealEstates(widget.id);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldWithBackButton(
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: ManagerColors.primaryColor,
//         onPressed: () {
//           initAddRealEstateModule();
//           Get.to(() => const AddRealEstateScreen());
//         },
//         icon: const Icon(Icons.add, color: ManagerColors.white),
//         label: Text(
//           'إضافة عقار',
//           style: getMediumTextStyle(
//             fontSize: 14,
//             color: ManagerColors.white,
//           ),
//         ),
//       ),
//       title: "إدارة العقارات",
//       body: Obx(() {
//         // Loading State with Shimmer
//         if (getController.isLoading.value) {
//           return _buildShimmerLoading();
//         }
//
//         // Error State
//         if (getController.errorMessage.isNotEmpty &&
//             getController.realEstates.isEmpty) {
//           return _buildErrorState();
//         }
//
//         // Empty State
//         if (getController.realEstates.isEmpty) {
//           return _buildEmptyState();
//         }
//
//         // Success State with Data
//         return RefreshIndicator(
//           color: ManagerColors.primaryColor,
//           onRefresh: () => getController.refreshEstates(),
//           child: ListView.builder(
//             padding: const EdgeInsets.all(16),
//             physics: const AlwaysScrollableScrollPhysics(),
//             itemCount: getController.realEstates.length,
//             itemBuilder: (context, index) {
//               final estate = getController.realEstates[index];
//               return _AnimatedRealEstateCard(
//                 estate: estate,
//                 index: index,
//                 onEdit: () {
//                   initEditMyRealEstate();
//                   Get.to(() => EditMyRealEstateScreen(realEstate: estate));
//                 },
//                 onDelete: () => _showDeleteDialog(context, estate.id ?? ''),
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildShimmerLoading() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: 3,
//       itemBuilder: (context, index) {
//         return const _ShimmerRealEstateCard();
//       },
//     );
//   }
//
//   Widget _buildErrorState() {
//     return Center(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(28),
//                 decoration: BoxDecoration(
//                   color: Colors.red[50],
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.error_outline_rounded,
//                   size: 70,
//                   color: Colors.red[400],
//                 ),
//               ),
//               const SizedBox(height: 28),
//               Text(
//                 'حدث خطأ',
//                 style: getBoldTextStyle(
//                   fontSize: 24,
//                   color: Colors.grey[800]!,
//                 ),
//               ),
//               const SizedBox(height: 14),
//               Text(
//                 getController.errorMessage.value,
//                 textAlign: TextAlign.center,
//                 style: getRegularTextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[600]!,
//                 ),
//               ),
//               const SizedBox(height: 36),
//               ElevatedButton.icon(
//                 onPressed: () => getController.fetchMyRealEstates(widget.id),
//                 icon: const Icon(Icons.refresh_rounded, size: 22),
//                 label: Text(
//                   'إعادة المحاولة',
//                   style: getMediumTextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ManagerColors.primaryColor,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 48,
//                     vertical: 16,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   elevation: 2,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(36),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.home_work_outlined,
//                   size: 90,
//                   color: Colors.grey[400],
//                 ),
//               ),
//               const SizedBox(height: 28),
//               Text(
//                 'لا يوجد عقارات',
//                 style: getBoldTextStyle(
//                   fontSize: 24,
//                   color: Colors.grey[800]!,
//                 ),
//               ),
//               const SizedBox(height: 14),
//               Text(
//                 'لم يتم إضافة أي عقارات بعد',
//                 textAlign: TextAlign.center,
//                 style: getRegularTextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[600]!,
//                 ),
//               ),
//               const SizedBox(height: 36),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   initAddRealEstateModule();
//                   Get.to(() => const AddRealEstateScreen());
//                 },
//                 icon: const Icon(Icons.add_rounded, size: 22),
//                 label: Text(
//                   'إضافة عقار جديد',
//                   style: getMediumTextStyle(
//                     fontSize: 16,
//                     color: Colors.white,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: ManagerColors.primaryColor,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 48,
//                     vertical: 16,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   elevation: 2,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> _showDeleteDialog(BuildContext context, String id) async {
//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => CustomConfirmDialog(
//         title: "تأكيد الحذف",
//         subtitle: "هل أنت متأكد أنك تريد حذف هذا العقار؟",
//         confirmText: "تأكيد",
//         cancelText: "إلغاء",
//         onConfirm: () async {
//           Get.back();
//           await deleteController.deleteRealEstate(double.tryParse(id) ?? 0);
//           await getController.refreshEstates();
//         },
//         onCancel: () => Get.back(),
//       ),
//     );
//   }
// }
//
// // Animated Real Estate Card
// class _AnimatedRealEstateCard extends StatefulWidget {
//   final RealEstateItemModel estate;
//   final int index;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//
//   const _AnimatedRealEstateCard({
//     required this.estate,
//     required this.index,
//     required this.onEdit,
//     required this.onDelete,
//   });
//
//   @override
//   State<_AnimatedRealEstateCard> createState() =>
//       _AnimatedRealEstateCardState();
// }
//
// class _AnimatedRealEstateCardState extends State<_AnimatedRealEstateCard>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: Duration(milliseconds: 300 + (widget.index * 80)),
//       vsync: this,
//     );
//
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeIn,
//       ),
//     );
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.1),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _animationController,
//         curve: Curves.easeOut,
//       ),
//     );
//
//     _animationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SlideTransition(
//       position: _slideAnimation,
//       child: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.04),
//                 blurRadius: 10,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // صورة العقار مع الأزرار
//               Stack(
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(16),
//                     ),
//                     child: Image.network(
//                       widget.estate.propertyImages ?? '',
//                       width: double.infinity,
//                       height: 200,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Container(
//                           width: double.infinity,
//                           height: 200,
//                           color: Colors.grey[200],
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.broken_image_outlined,
//                                 size: 50,
//                                 color: Colors.grey[400],
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'لا توجد صورة',
//                                 style: getRegularTextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey[500]!,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Container(
//                           width: double.infinity,
//                           height: 200,
//                           color: Colors.grey[200],
//                           child: const Center(
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   // شريط الأزرار
//                   Positioned(
//                     top: 10,
//                     left: 10,
//                     child: Row(
//                       children: [
//                         _ActionButton(
//                           icon: Icons.edit_rounded,
//                           color: const Color(0xFF1976D2),
//                           onPressed: widget.onEdit,
//                         ),
//                         const SizedBox(width: 8),
//                         _ActionButton(
//                           icon: Icons.delete_rounded,
//                           color: const Color(0xFFE53935),
//                           onPressed: widget.onDelete,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               // محتوى الكارد
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // العنوان
//                     Text(
//                       widget.estate.usageTypeLabel ?? 'بدون عنوان',
//                       style: getBoldTextStyle(
//                         fontSize: 17,
//                         color: const Color(0xFF212121),
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),
//                     // الموقع
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.location_on_rounded,
//                           size: 16,
//                           color: Color(0xFFE53935),
//                         ),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             widget.estate.propertyDetailedAddress ?? 'غير محدد',
//                             style: getRegularTextStyle(
//                               fontSize: 13,
//                               color: const Color(0xFF757575),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 14),
//                     const Divider(height: 1, color: Color(0xFFE0E0E0)),
//                     const SizedBox(height: 14),
//
//                     // معلومات العقار
//                     _InfoGrid(
//                       items: [
//                         _InfoItem(
//                           label: 'المساحة',
//                           value: widget.estate.areaSqm ?? '-',
//                           icon: Icons.square_foot_rounded,
//                         ),
//                         _InfoItem(
//                           label: 'الغرف',
//                           value: widget.estate.areaSqm ?? '-',
//                           icon: Icons.bed_rounded,
//                         ),
//                         _InfoItem(
//                           label: 'الصالات',
//                           value: widget.estate.areaSqm ?? '-',
//                           icon: Icons.meeting_room_rounded,
//                         ),
//                         _InfoItem(
//                           label: 'الحمامات',
//                           value: widget.estate.areaSqm ?? '-',
//                           icon: Icons.bathroom_rounded,
//                         ),
//                       ],
//                     ),
//
//                     const SizedBox(height: 14),
//
//                     // السعر والغرض
//                     Container(
//                       padding: const EdgeInsets.all(14),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFF5F5F5),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'السعر',
//                                 style: getRegularTextStyle(
//                                   fontSize: 12,
//                                   color: const Color(0xFF9E9E9E),
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 widget.estate.price ?? '-',
//                                 style: getBoldTextStyle(
//                                   fontSize: 16,
//                                   color: const Color(0xFF1976D2),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 14,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF1976D2),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               widget.estate.areaSqm ?? 'غير محدد',
//                               style: getMediumTextStyle(
//                                 fontSize: 13,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // زر الإجراءات
// class _ActionButton extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final VoidCallback onPressed;
//
//   const _ActionButton({
//     required this.icon,
//     required this.color,
//     required this.onPressed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10),
//       elevation: 2,
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(10),
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           child: Icon(
//             icon,
//             size: 20,
//             color: color,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Grid للمعلومات
// class _InfoGrid extends StatelessWidget {
//   final List<_InfoItem> items;
//
//   const _InfoGrid({required this.items});
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 2.5,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//       ),
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         return Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: const Color(0xFFFAFAFA),
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: const Color(0xFFE0E0E0),
//               width: 1,
//             ),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 item.icon,
//                 size: 18,
//                 color: const Color(0xFF1976D2),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       item.label,
//                       style: getRegularTextStyle(
//                         fontSize: 10,
//                         color: const Color(0xFF9E9E9E),
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       item.value,
//                       style: getMediumTextStyle(
//                         fontSize: 12,
//                         color: const Color(0xFF424242),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       maxLines: 1,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
//
// class _InfoItem {
//   final String label;
//   final String value;
//   final IconData icon;
//
//   _InfoItem({
//     required this.label,
//     required this.value,
//     required this.icon,
//   });
// }
//
// // Shimmer Loading Widget
// class _ShimmerRealEstateCard extends StatelessWidget {
//   const _ShimmerRealEstateCard();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Shimmer.fromColors(
//         baseColor: Colors.grey[300]!,
//         highlightColor: Colors.grey[100]!,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image placeholder
//             Container(
//               width: double.infinity,
//               height: 200,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(
//                   top: Radius.circular(16),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Container(
//                     width: double.infinity,
//                     height: 18,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   // Location
//                   Container(
//                     width: 180,
//                     height: 14,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                   const SizedBox(height: 14),
//                   const Divider(height: 1),
//                   const SizedBox(height: 14),
//                   // Grid
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 2.5,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                     ),
//                     itemCount: 4,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(height: 14),
//                   // Price section
//                   Container(
//                     width: double.infinity,
//                     height: 70,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// // import 'package:app_mobile/core/resources/manager_colors.dart';
// // import 'package:app_mobile/core/util/empty_state_widget.dart';
// // import 'package:app_mobile/core/widgets/custom_confirm_dialog.dart';
// // import 'package:app_mobile/core/widgets/loading_widget.dart';
// // import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// //
// // import '../../../../../../core/model/real_estate_item_model.dart';
// // import '../../../add_real_estate/domain/di/di.dart';
// // import '../../../add_real_estate/presentation/pages/add_real_estate_screen.dart';
// // import '../../domain/di/di.dart';
// // import '../controller/delete_my_real_estate_controller.dart';
// // import '../controller/get_my_real_estates_controller.dart';
// // import '../widgets/real_estate_list_widget.dart';
// // import 'edit_my_real_estate_screen.dart';
// //
// // class ManagerMyRealEstateProviderScreen extends StatefulWidget {
// //   final String id;
// //
// //   const ManagerMyRealEstateProviderScreen({super.key, required this.id});
// //
// //   @override
// //   State<ManagerMyRealEstateProviderScreen> createState() =>
// //       _ManagerMyRealEstateProviderScreenState();
// // }
// //
// // class _ManagerMyRealEstateProviderScreenState
// //     extends State<ManagerMyRealEstateProviderScreen> {
// //   late GetMyRealEstatesController getController;
// //   late DeleteMyRealEstateController deleteController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     getController = Get.find<GetMyRealEstatesController>();
// //     deleteController = Get.find<DeleteMyRealEstateController>();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       getController.fetchMyRealEstates(widget.id);
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ScaffoldWithBackButton(
// //       floatingActionButton: FloatingActionButton(
// //         backgroundColor: ManagerColors.primaryColor,
// //         onPressed: () {
// //           initAddRealEstateModule();
// //           Get.to(() => const AddRealEstateScreen());
// //         },
// //         child: const Icon(
// //           Icons.add,
// //           color: ManagerColors.white,
// //         ),
// //       ),
// //       title: "عقاراتي",
// //       body: Stack(
// //         children: [
// //           Obx(() {
// //             // حالة الخطأ
// //             if (getController.errorMessage.isNotEmpty &&
// //                 getController.realEstates.isEmpty &&
// //                 !getController.isLoading.value) {
// //               return Center(
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Icon(
// //                       Icons.error_outline,
// //                       size: 60,
// //                       color: Colors.red[400],
// //                     ),
// //                     const SizedBox(height: 16),
// //                     Text(
// //                       getController.errorMessage.value,
// //                       style: const TextStyle(
// //                         color: Colors.red,
// //                         fontSize: 16,
// //                       ),
// //                       textAlign: TextAlign.center,
// //                     ),
// //                     const SizedBox(height: 24),
// //                     ElevatedButton.icon(
// //                       onPressed: () =>
// //                           getController.fetchMyRealEstates(widget.id),
// //                       icon: const Icon(Icons.refresh),
// //                       label: const Text('إعادة المحاولة'),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             }
// //
// //             // حالة فارغة
// //             if (getController.realEstates.isEmpty &&
// //                 !getController.isLoading.value) {
// //               return const Center(
// //                 child: EmptyStateWidget(
// //                   messageAr: "لا يوجد عقارات حاليا",
// //                 ),
// //               );
// //             }
// //
// //             return RefreshIndicator(
// //               color: ManagerColors.primaryColor,
// //               onRefresh: () async => await getController.refreshEstates(),
// //               child: RealEstateListWidget(
// //                 realEstates: getController.realEstates,
// //                 onEdit: (RealEstateItemModel estate) {
// //                   initEditMyRealEstate();
// //                   Get.to(() => EditMyRealEstateScreen(realEstate: estate));
// //                 },
// //                 onDelete: (id) async {
// //                   await _showDeleteDialog(context, id);
// //                 },
// //               ),
// //             );
// //           }),
// //           Obx(() {
// //             if (getController.isLoading.value ||
// //                 deleteController.isLoading.value) {
// //               return const LoadingWidget();
// //             }
// //             return const SizedBox.shrink();
// //           }),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Future<void> _showDeleteDialog(BuildContext context, String id) async {
// //     await showDialog(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (context) => CustomConfirmDialog(
// //         title: "تأكيد الحذف",
// //         subtitle: "هل أنت متأكد أنك تريد حذف هذا العقار؟",
// //         confirmText: "تأكيد",
// //         cancelText: "إلغاء",
// //         onConfirm: () async {
// //           Get.back();
// //           await deleteController.deleteRealEstate(double.tryParse(id) ?? 0);
// //           await getController.refreshEstates();
// //         },
// //         onCancel: () => Get.back(),
// //       ),
// //     );
// //   }
// // }
