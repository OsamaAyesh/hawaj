import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/resources/manager_width.dart';

class RealEstateCardWidget extends StatelessWidget {
  final String id;
  final bool showActions;
  final String imageUrl;
  final String title;
  final String location;
  final String area;
  final String rooms;
  final String halls;
  final String baths;
  final String direction;
  final String purpose;
  final String age;
  final String commission;
  final String price;
  final List<String> features;
  final Map<String, String> extraInfo;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RealEstateCardWidget({
    super.key,
    required this.id,
    required this.showActions,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.area,
    required this.rooms,
    required this.halls,
    required this.baths,
    required this.direction,
    required this.purpose,
    required this.age,
    required this.commission,
    required this.price,
    required this.features,
    required this.extraInfo,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ManagerColors.white,
        borderRadius: BorderRadius.circular(ManagerRadius.r10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 الصورة + أزرار الإجراءات (تعديل / حذف)
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 210,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 210,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image_outlined, size: 40),
                    ),
                  ),
                ),
              ),
              if (showActions)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit,
                            color: ManagerColors.primaryColor),
                        tooltip: "تعديل",
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon:
                            const Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: "حذف",
                      ),
                    ],
                  ),
                ),
            ],
          ),

          /// 🔹 التفاصيل الداخلية
          Padding(
            padding: EdgeInsets.all(ManagerWidth.w14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: ManagerColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: ManagerColors.greyWithColor),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.greyWithColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildInfoRow("المساحة", area),
                _buildInfoRow("الغرض", purpose),
                _buildInfoRow("عدد الغرف", rooms),
                _buildInfoRow("عدد الصالات", halls),
                _buildInfoRow("العمولة", commission),
                _buildInfoRow("السعر", price),
                const SizedBox(height: 12),
                _buildDottedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s12,
              color: ManagerColors.greyWithColor,
            ),
          ),
          Text(
            value,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s12,
              color: ManagerColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ManagerColors.primaryColor.withOpacity(0.2),
          style: BorderStyle.solid,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: extraInfo.entries.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  e.key,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.greyWithColor,
                  ),
                ),
                Text(
                  e.value,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.primaryColor,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
// class RealEstateCardWidget extends StatelessWidget {
//   final bool showActions; // إذا نعرض أيقونات الإعداد والحذف
//   final String imageUrl;
//   final String title;
//   final String location;
//   final String area;
//   final String rooms;
//   final String halls;
//   final String baths;
//   final String direction;
//   final String purpose;
//   final String age;
//   final String commission;
//   final String price;
//   final List<String> features;
//   final Map<String, String> extraInfo; // مثل تاريخ الإضافة، رقم الترخيص، إلخ
//
//   const RealEstateCardWidget({
//     super.key,
//     required this.showActions,
//     required this.imageUrl,
//     required this.title,
//     required this.location,
//     required this.area,
//     required this.rooms,
//     required this.halls,
//     required this.baths,
//     required this.direction,
//     required this.purpose,
//     required this.age,
//     required this.commission,
//     required this.price,
//     required this.features,
//     required this.extraInfo,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ManagerColors.white,
//         borderRadius: BorderRadius.circular(ManagerRadius.r10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.08),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// ===== الصورة مع الأيقونات =====
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius:
//                     const BorderRadius.vertical(top: Radius.circular(10)),
//                 child: Image.network(
//                   imageUrl,
//                   width: double.infinity,
//                   height: 210,
//                   fit: BoxFit.cover,
//                   // 🔹 Display a loading indicator while the image is loading
//                   loadingBuilder: (context, child, loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Container(
//                       width: double.infinity,
//                       height: 210,
//                       color: Colors.grey.shade200,
//                       alignment: Alignment.center,
//                       child: const CircularProgressIndicator(strokeWidth: 2),
//                     );
//                   },
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       width: double.infinity,
//                       height: 210,
//                       color: Colors.grey.shade300,
//                       alignment: Alignment.center,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.broken_image_outlined,
//                             color: Colors.grey,
//                             size: 40,
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             "فشل في عرض الصورة",
//                             style: getRegularTextStyle(
//                                 fontSize: ManagerFontSize.s12,
//                                 color: ManagerColors.greyWithColor),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//
//           /// ===== المحتوى الداخلي =====
//           Padding(
//             padding: EdgeInsets.all(ManagerWidth.w14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// ===== العنوان والموقع =====
//                 Row(
//                   children: [
//                     Text(
//                       title,
//                       style: getBoldTextStyle(
//                         fontSize: ManagerFontSize.s14,
//                         color: ManagerColors.primaryColor,
//                       ),
//                     ),
//                     const SizedBox(width: 4),
//                     const Icon(
//                       Icons.location_on_outlined,
//                       color: ManagerColors.greyWithColor,
//                       size: 16,
//                     ),
//                     Expanded(
//                       child: Text(
//                         location,
//                         style: getRegularTextStyle(
//                           fontSize: ManagerFontSize.s12,
//                           color: ManagerColors.greyWithColor,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: ManagerHeight.h12),
//
//                 /// ===== التفاصيل =====
//                 _buildDetailsGrid(),
//
//                 SizedBox(height: ManagerHeight.h16),
//
//                 /// ===== مميزات العقار =====
//                 Text(
//                   "مميزات العقار",
//                   style: getBoldTextStyle(
//                     fontSize: ManagerFontSize.s14,
//                     color: ManagerColors.black,
//                   ),
//                 ),
//                 SizedBox(height: ManagerHeight.h10),
//
//                 _buildFeatures(),
//
//                 SizedBox(height: ManagerHeight.h12),
//
//                 /// ===== المعلومات الإضافية داخل مربع منقط =====
//                 _buildDottedBox(),
//
//                 SizedBox(height: ManagerHeight.h12),
//
//                 /// ===== الأزرار السفلية =====
//                 _buildBottomButtons(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// ✅ أسهم التنقل في الصور
//   Widget _buildArrow(IconData icon) {
//     return Container(
//       width: 30,
//       height: 30,
//       decoration: const BoxDecoration(
//         color: ManagerColors.primaryColor,
//         shape: BoxShape.circle,
//       ),
//       child: Icon(icon, color: Colors.white, size: 16),
//     );
//   }
//
//   /// ✅ الشبكة العلوية للتفاصيل
//   Widget _buildDetailsGrid() {
//     final details = {
//       "المساحة": area,
//       "الواجهة": direction,
//       "عدد غرف النوم": rooms,
//       "الغرض": purpose,
//       "عدد الصالات": halls,
//       "عرض الشارع": "651 م²",
//       "عمر العقار": age,
//       "سعر البيع": commission,
//     };
//
//     return Wrap(
//       alignment: WrapAlignment.spaceBetween,
//       runSpacing: 8,
//       children: details.entries.map((entry) {
//         return SizedBox(
//           width: 140,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 entry.key,
//                 style: getRegularTextStyle(
//                   fontSize: ManagerFontSize.s12,
//                   color: ManagerColors.greyWithColor,
//                 ),
//               ),
//               Text(
//                 entry.value,
//                 style: getBoldTextStyle(
//                   fontSize: ManagerFontSize.s12,
//                   color: ManagerColors.black,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   /// ✅ قائمة المميزات
//   Widget _buildFeatures() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(child: _buildFeatureColumn(features.sublist(0, 2))),
//         Expanded(child: _buildFeatureColumn(features.sublist(2, 4))),
//       ],
//     );
//   }
//
//   Widget _buildFeatureColumn(List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: items
//           .map(
//             (item) => Padding(
//               padding: const EdgeInsets.only(bottom: 4),
//               child: Row(
//                 children: [
//                   const Icon(
//                     Icons.check_circle,
//                     size: 16,
//                     color: ManagerColors.primaryColor,
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     item,
//                     style: getRegularTextStyle(
//                       fontSize: ManagerFontSize.s12,
//                       color: ManagerColors.greyWithColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }
//
//   /// ✅ المربع المنقط
//   Widget _buildDottedBox() {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: ManagerColors.primaryColor.withOpacity(0.2),
//           style: BorderStyle.solid,
//           width: 1,
//         ),
//       ),
//       padding: const EdgeInsets.all(12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: extraInfo.entries.map((e) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 2),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   e.key,
//                   style: getRegularTextStyle(
//                     fontSize: ManagerFontSize.s12,
//                     color: ManagerColors.greyWithColor,
//                   ),
//                 ),
//                 Text(
//                   e.value,
//                   style: getBoldTextStyle(
//                     fontSize: ManagerFontSize.s12,
//                     color: ManagerColors.primaryColor,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
//
//   /// ✅ الأزرار السفلية
//   Widget _buildBottomButtons() {
//     return Row(
//       children: [
//         Expanded(
//           flex: 2,
//           child: Container(
//             height: 42,
//             decoration: BoxDecoration(
//               color: ManagerColors.primaryColor,
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Center(
//               child: Text(
//                 price,
//                 style: getBoldTextStyle(
//                   fontSize: ManagerFontSize.s13,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(width: ManagerWidth.w8),
//         Expanded(
//           flex: 3,
//           child: Container(
//             height: 42,
//             decoration: BoxDecoration(
//               color: ManagerColors.greyWithColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(6),
//             ),
//             child: Center(
//               child: Text(
//                 "تم بيع العقار - اضغط لإخفائه من عرض الزائرين",
//                 style: getBoldTextStyle(
//                   fontSize: ManagerFontSize.s11,
//                   color: ManagerColors.greyWithColor,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
