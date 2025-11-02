import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/features/providers/real_estate_provider/register_to_real_estate_provider_service/presentation/pages/register_to_real_estate_provider_service_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../edit_profile_real_state_owner/presentation/pages/edit_profile_real_state_owner_screen.dart';
import '../../../register_to_real_estate_provider_service/domain/di/di.dart';
import '../controller/get_my_real_estate_my_owner_controller.dart';

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

    // ✅ الحصول على الكنترولر مرة واحدة عند الدخول
    controller = Get.find<GetRealEstateMyOwnersController>();

    // يمكنك هنا تنفيذ أي إعداد إضافي مثل:
    // controller.fetchMyOwners();
  }

  @override
  void dispose() {
    // ✅ تنظيف الكنترولر عند الخروج من الشاشة
    if (Get.isRegistered<GetRealEstateMyOwnersController>()) {
      Get.delete<GetRealEstateMyOwnersController>();
      debugPrint('🧹 GetRealEstateMyOwnersController تم حذفه بنجاح');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: "ملكياتي",
      floatingActionButton: FloatingActionButton(
        backgroundColor: ManagerColors.primaryColor,
        child: const Icon(Icons.add, color: ManagerColors.white),
        onPressed: () {
          initAddMyPropertyOwners();
          Get.to(() => const RegisterToRealEstateProviderServiceScreen());
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: getMediumTextStyle(
                fontSize: ManagerHeight.h14,
                color: ManagerColors.redStatus,
              ),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (controller.owners.isEmpty) {
          return Center(
            child: Text(
              "لا توجد ملكيات حالياً",
              style: getRegularTextStyle(
                fontSize: ManagerHeight.h14,
                color: ManagerColors.colorDescription,
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: ManagerColors.primaryColor,
          backgroundColor: ManagerColors.white,
          onRefresh: controller.fetchMyOwners,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w16,
              vertical: ManagerHeight.h8,
            ),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: controller.owners.length,
            itemBuilder: (context, index) {
              final owner = controller.owners[index];

              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(bottom: ManagerHeight.h16),
                decoration: BoxDecoration(
                  color: ManagerColors.white,
                  borderRadius: BorderRadius.circular(ManagerHeight.h16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: ManagerHeight.h10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(ManagerHeight.h16),
                  onTap: () {
                    final ownerId = owner.id ?? '';
                    Get.to(() => EditProfileRealStateOwnerScreen(
                          ownerId: ownerId,
                          owner: owner,
                        ));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(ManagerHeight.h16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🏢 صورة الشركة أو المالك
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(ManagerHeight.h12),
                          child: _buildOwnerImage(owner.companyLogo),
                        ),
                        SizedBox(width: ManagerWidth.w12),

                        /// 📋 تفاصيل المالك
                        Expanded(
                          child: _buildOwnerDetails(owner),
                        ),

                        /// ➡️ سهم الانتقال
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: ManagerColors.colorGrey,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  /// ✅ مكون عرض صورة المالك
  Widget _buildOwnerImage(String? logoUrl) {
    if (logoUrl != null && logoUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: logoUrl,
        width: ManagerWidth.w60,
        height: ManagerHeight.h60,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: ManagerWidth.w60,
          height: ManagerHeight.h60,
          alignment: Alignment.center,
          color: ManagerColors.colorCompanyDetails2,
          child: SizedBox(
            width: ManagerWidth.w22,
            height: ManagerHeight.h22,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: ManagerColors.primaryColor,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: ManagerWidth.w60,
          height: ManagerHeight.h60,
          color: ManagerColors.colorCompanyDetails2,
          child: const Icon(
            Icons.broken_image,
            size: 28,
            color: ManagerColors.primaryColor,
          ),
        ),
      );
    }

    return Container(
      width: ManagerWidth.w60,
      height: ManagerHeight.h60,
      color: ManagerColors.colorCompanyDetails2,
      child: const Icon(
        Icons.business,
        size: 30,
        color: ManagerColors.primaryColor,
      ),
    );
  }

  /// ✅ مكون عرض تفاصيل المالك
  Widget _buildOwnerDetails(dynamic owner) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          owner.ownerName ?? "",
          style: getBoldTextStyle(
            fontSize: ManagerHeight.h16,
            color: ManagerColors.primaryColor,
          ),
        ),
        SizedBox(height: ManagerHeight.h4),
        Text(
          owner.companyName ?? "",
          style: getMediumTextStyle(
            fontSize: ManagerHeight.h14,
            color: ManagerColors.colorGreySubscription,
          ),
        ),
        SizedBox(height: ManagerHeight.h4),
        Text(
          owner.companyBrief ?? "",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: getRegularTextStyle(
            fontSize: ManagerHeight.h13,
            color: ManagerColors.colorDescription,
          ),
        ),
        SizedBox(height: ManagerHeight.h8),
        Row(
          children: [
            const Icon(
              Icons.location_on,
              size: 14,
              color: ManagerColors.locationColorText,
            ),
            SizedBox(width: ManagerWidth.w4),
            Expanded(
              child: Text(
                owner.detailedAddress ?? "",
                style: getRegularTextStyle(
                  fontSize: ManagerHeight.h12,
                  color: ManagerColors.locationColorText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_styles.dart';
// import 'package:app_mobile/core/resources/manager_width.dart';
// import 'package:app_mobile/core/widgets/loading_widget.dart';
// import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
// import 'package:app_mobile/features/providers/real_estate_provider/register_to_real_estate_provider_service/presentation/pages/register_to_real_estate_provider_service_screen.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../edit_profile_real_state_owner/presentation/pages/edit_profile_real_state_owner_screen.dart';
// import '../../../register_to_real_estate_provider_service/domain/di/di.dart';
// import '../controller/get_my_real_estate_my_owner_controller.dart';
//
// class GetRealEstateMyOwnersScreen extends StatelessWidget {
//   const GetRealEstateMyOwnersScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<GetRealEstateMyOwnersController>();
//
//     return ScaffoldWithBackButton(
//       title: "ملكياتي",
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: ManagerColors.primaryColor,
//         child: Icon(
//           Icons.add,
//           color: ManagerColors.white,
//         ),
//         onPressed: () {
//           initAddMyPropertyOwners();
//           Get.to(RegisterToRealEstateProviderServiceScreen());
//         },
//       ),
//       body: Obx(
//         () {
//           // Loading state
//           if (controller.isLoading.value) {
//             return const Center(child: LoadingWidget());
//           }
//
//           // Error state
//           if (controller.errorMessage.isNotEmpty) {
//             return Center(
//               child: Text(
//                 controller.errorMessage.value,
//                 style: getMediumTextStyle(
//                   fontSize: ManagerHeight.h14,
//                   color: ManagerColors.redStatus,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             );
//           }
//
//           // No data state
//           if (controller.owners.isEmpty) {
//             return Center(
//               child: Text(
//                 "لا توجد ملكيات حالياً",
//                 style: getRegularTextStyle(
//                   fontSize: ManagerHeight.h14,
//                   color: ManagerColors.colorDescription,
//                 ),
//               ),
//             );
//           }
//
//           // Data loaded
//           return RefreshIndicator(
//             color: ManagerColors.primaryColor,
//             backgroundColor: ManagerColors.white,
//             onRefresh: () async {
//               await controller.fetchMyOwners();
//             },
//             child: ListView.builder(
//               padding: EdgeInsets.symmetric(
//                 horizontal: ManagerWidth.w16,
//                 vertical: ManagerHeight.h8,
//               ),
//               physics: const AlwaysScrollableScrollPhysics(),
//               itemCount: controller.owners.length,
//               itemBuilder: (context, index) {
//                 final owner = controller.owners[index];
//
//                 return AnimatedContainer(
//                   duration: const Duration(milliseconds: 250),
//                   curve: Curves.easeInOut,
//                   margin: EdgeInsets.only(bottom: ManagerHeight.h16),
//                   decoration: BoxDecoration(
//                     color: ManagerColors.white,
//                     borderRadius: BorderRadius.circular(ManagerHeight.h16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.06),
//                         blurRadius: ManagerHeight.h10,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(ManagerHeight.h16),
//                     onTap: () {
//                       // ✅ Navigate to Edit Screen and pass ownerId
//                       final ownerId = owner.id ?? '';
//                       Get.to(() => EditProfileRealStateOwnerScreen(
//                             ownerId: ownerId,
//                             owner: owner,
//                           ));
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.all(ManagerHeight.h16),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           /// Owner Image / Logo
//                           ClipRRect(
//                             borderRadius:
//                                 BorderRadius.circular(ManagerHeight.h12),
//                             child: owner.companyLogo != null &&
//                                     owner.companyLogo!.isNotEmpty
//                                 ? CachedNetworkImage(
//                                     imageUrl: owner.companyLogo!,
//                                     width: ManagerWidth.w60,
//                                     height: ManagerHeight.h60,
//                                     fit: BoxFit.cover,
//                                     placeholder: (context, url) => Container(
//                                       width: ManagerWidth.w60,
//                                       height: ManagerHeight.h60,
//                                       alignment: Alignment.center,
//                                       color: ManagerColors.colorCompanyDetails2,
//                                       child: SizedBox(
//                                         width: ManagerWidth.w22,
//                                         height: ManagerHeight.h22,
//                                         child: const CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           color: ManagerColors.primaryColor,
//                                         ),
//                                       ),
//                                     ),
//                                     errorWidget: (context, url, error) =>
//                                         Container(
//                                       width: ManagerWidth.w60,
//                                       height: ManagerHeight.h60,
//                                       color: ManagerColors.colorCompanyDetails2,
//                                       child: const Icon(
//                                         Icons.broken_image,
//                                         size: 28,
//                                         color: ManagerColors.primaryColor,
//                                       ),
//                                     ),
//                                   )
//                                 : Container(
//                                     width: ManagerWidth.w60,
//                                     height: ManagerHeight.h60,
//                                     color: ManagerColors.colorCompanyDetails2,
//                                     child: const Icon(
//                                       Icons.business,
//                                       size: 30,
//                                       color: ManagerColors.primaryColor,
//                                     ),
//                                   ),
//                           ),
//                           SizedBox(width: ManagerWidth.w12),
//
//                           /// Owner Details
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   owner.ownerName ?? "",
//                                   style: getBoldTextStyle(
//                                     fontSize: ManagerHeight.h16,
//                                     color: ManagerColors.primaryColor,
//                                   ),
//                                 ),
//                                 SizedBox(height: ManagerHeight.h4),
//                                 Text(
//                                   owner.companyName ?? "",
//                                   style: getMediumTextStyle(
//                                     fontSize: ManagerHeight.h14,
//                                     color: ManagerColors.colorGreySubscription,
//                                   ),
//                                 ),
//                                 SizedBox(height: ManagerHeight.h4),
//                                 Text(
//                                   owner.companyBrief ?? "",
//                                   maxLines: 2,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: getRegularTextStyle(
//                                     fontSize: ManagerHeight.h13,
//                                     color: ManagerColors.colorDescription,
//                                   ),
//                                 ),
//                                 SizedBox(height: ManagerHeight.h8),
//                                 Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.location_on,
//                                       size: 14,
//                                       color: ManagerColors.locationColorText,
//                                     ),
//                                     SizedBox(width: ManagerWidth.w4),
//                                     Expanded(
//                                       child: Text(
//                                         owner.detailedAddress ?? "",
//                                         style: getRegularTextStyle(
//                                           fontSize: ManagerHeight.h12,
//                                           color:
//                                               ManagerColors.locationColorText,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           /// Arrow icon
//                           const Icon(
//                             Icons.arrow_forward_ios,
//                             size: 16,
//                             color: ManagerColors.colorGrey,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
