import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/model/real_estate_item_model.dart';
import 'real_estate_card_widget.dart';

class RealEstateListWidget extends StatelessWidget {
  final List<RealEstateItemModel> realEstates;
  final Function(RealEstateItemModel estate) onEdit;
  final Function(String id) onDelete;

  const RealEstateListWidget({
    super.key,
    required this.realEstates,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
      itemCount: realEstates.length,
      separatorBuilder: (_, __) => SizedBox(height: ManagerHeight.h16),
      itemBuilder: (context, index) {
        final estate = realEstates[index];

        return RealEstateCardWidget(
          id: estate.id,
          showActions: true,
          imageUrl: estate.propertyImages,
          title: estate.propertySubject,
          location: estate.propertyDetailedAddress,
          area: "${estate.areaSqm} م²",
          rooms: estate.featureIds.isNotEmpty
              ? estate.featureIds.split(',').length.toString()
              : "--",
          halls: estate.facilityIds.isNotEmpty
              ? estate.facilityIds.split(',').length.toString()
              : "--",
          baths: "--",
          direction: "--",
          purpose: estate.usageTypeLabel,
          age: "--",
          commission: "${estate.commissionPercentage}%",
          price: "${estate.price} دولار",
          features: [
            "النوع: ${estate.propertyTypeLabel}",
            "العملية: ${estate.operationTypeLabel}",
            "البيع: ${estate.saleTypeLabel}",
          ],
          extraInfo: {
            "المالك": estate.propertyOwnerIdLabel,
            "الإحداثيات": "(${estate.lat}, ${estate.lng})",
          },
          onEdit: () => onEdit(estate),
          // ✅ إرسال الموديل الكامل
          onDelete: () => onDelete(estate.id),
        );
      },
    );
  }
}

// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_width.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../../../core/model/real_estate_item_model.dart';
// import 'real_estate_card_widget.dart';
//
// class RealEstateListWidget extends StatelessWidget {
//   final List<RealEstateItemModel> realEstates;
//   final Function(String id) onEdit;
//   final Function(String id) onDelete;
//
//   const RealEstateListWidget({
//     super.key,
//     required this.realEstates,
//     required this.onEdit,
//     required this.onDelete,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.separated(
//       padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
//       itemCount: realEstates.length,
//       separatorBuilder: (_, __) => SizedBox(height: ManagerHeight.h16),
//       itemBuilder: (context, index) {
//         final estate = realEstates[index];
//
//         return RealEstateCardWidget(
//           id: estate.id,
//           showActions: true,
//           imageUrl: estate.propertyImages,
//           title: estate.propertySubject,
//           location: estate.propertyDetailedAddress,
//           area: "${estate.areaSqm} م²",
//           rooms: estate.featureIds.isNotEmpty
//               ? estate.featureIds.split(',').length.toString()
//               : "--",
//           halls: estate.facilityIds.isNotEmpty
//               ? estate.facilityIds.split(',').length.toString()
//               : "--",
//           baths: "--",
//           direction: "--",
//           purpose: estate.usageTypeLabel,
//           age: "--",
//           commission: "${estate.commissionPercentage}%",
//           price: "${estate.price} دولار",
//           features: [
//             "النوع: ${estate.propertyTypeLabel}",
//             "العملية: ${estate.operationTypeLabel}",
//             "البيع: ${estate.saleTypeLabel}",
//           ],
//           extraInfo: {
//             "المالك": estate.propertyOwnerIdLabel,
//             "الإحداثيات": "(${estate.lat}, ${estate.lng})",
//           },
//           onEdit: () => onEdit(estate.id.toString()),
//           onDelete: () => onDelete(estate.id),
//         );
//       },
//     );
//   }
// }
// // class RealEstateListWidget extends StatelessWidget {
// //   final bool isAvailable;
// //   final List<RealEstateItemModel> realEstates;
// //
// //   const RealEstateListWidget({
// //     super.key,
// //     required this.isAvailable,
// //     required this.realEstates,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.separated(
// //       padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
// //       itemCount: realEstates.length,
// //       separatorBuilder: (_, __) => SizedBox(height: ManagerHeight.h16),
// //       itemBuilder: (context, index) {
// //         final estate = realEstates[index];
// //
// //         return RealEstateCardWidget(
// //           // 🔹 Show actions only if property is not available (for future use)
// //           showActions: !isAvailable,
// //
// //           // 🔹 Use real API data
// //           imageUrl: estate.propertyImages,
// //           title: estate.propertySubject,
// //           location: estate.propertyDetailedAddress,
// //           area: "${estate.areaSqm} م²",
// //           rooms: estate.featureIds.isNotEmpty
// //               ? estate.featureIds.split(',').length.toString()
// //               : "--",
// //           halls: estate.facilityIds.isNotEmpty
// //               ? estate.facilityIds.split(',').length.toString()
// //               : "--",
// //           age: "--",
// //           // API currently doesn't provide property age
// //           baths: "--",
// //           // API currently doesn't provide baths count
// //           direction: "--",
// //           // API currently doesn't provide direction info
// //           purpose: estate.usageTypeLabel,
// //           commission: "${estate.commissionPercentage}%",
// //           price: "${estate.price} دولار أمريكي",
// //
// //           // 🔹 You can later map these from featureIds/facilityIds if the backend provides labels
// //           features: [
// //             "النوع: ${estate.propertyTypeLabel}",
// //             "نوع العملية: ${estate.operationTypeLabel}",
// //             "نوع البيع: ${estate.saleTypeLabel}",
// //             "الدور: ${estate.advertiserRoleLabel}",
// //             "الاستخدام: ${estate.usageTypeLabel}",
// //           ],
// //
// //           // 🔹 Extra information (you can enhance this with real fields if available)
// //           extraInfo: {
// //             "المالك": estate.propertyOwnerIdLabel,
// //             "الإحداثيات": "(${estate.lat}, ${estate.lng})",
// //             "وقت الزيارة": "${estate.visitTimeFrom} - ${estate.visitTimeTo}",
// //             "أيام الزيارة": estate.visitDays,
// //           },
// //         );
// //       },
// //     );
// //   }
// // }
