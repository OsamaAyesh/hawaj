import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: ManagerColors.white,
        borderRadius: BorderRadius.circular(ManagerRadius.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة العقار مع الأزرار
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(ManagerRadius.r16),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: ManagerHeight.h210,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: ManagerHeight.h210,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: ManagerColors.primaryColor,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: ManagerHeight.h210,
                    color: Colors.grey.shade200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          size: 50,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'لا توجد صورة',
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // الأزرار العائمة
              if (showActions)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Row(
                    children: [
                      _ActionButton(
                        icon: Icons.edit_rounded,
                        color: ManagerColors.primaryColor,
                        onPressed: onEdit ?? () {},
                        tooltip: "تعديل",
                      ),
                      SizedBox(width: ManagerWidth.w8),
                      _ActionButton(
                        icon: Icons.delete_rounded,
                        color: Colors.red,
                        onPressed: onDelete ?? () {},
                        tooltip: "حذف",
                      ),
                    ],
                  ),
                ),
              // باج الغرض
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ManagerWidth.w12,
                    vertical: ManagerHeight.h6,
                  ),
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor,
                    borderRadius: BorderRadius.circular(ManagerRadius.r20),
                    boxShadow: [
                      BoxShadow(
                        color: ManagerColors.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    purpose,
                    style: getMediumTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: ManagerColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // محتوى الكارد
          Padding(
            padding: EdgeInsets.all(ManagerWidth.w14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان
                Text(
                  title,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.primaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: ManagerHeight.h6),
                // الموقع
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: Colors.red,
                    ),
                    SizedBox(width: ManagerWidth.w4),
                    Expanded(
                      child: Text(
                        location,
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s12,
                          color: ManagerColors.greyWithColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ManagerHeight.h12),
                const Divider(height: 1, color: Color(0xFFE0E0E0)),
                SizedBox(height: ManagerHeight.h12),

                // معلومات العقار
                _buildInfoRow("المساحة", area, Icons.square_foot_rounded),
                _buildInfoRow("عدد الغرف", rooms, Icons.bed_rounded),
                _buildInfoRow("عدد الصالات", halls, Icons.meeting_room_rounded),
                _buildInfoRow("عدد الحمامات", baths, Icons.bathroom_rounded),
                _buildInfoRow("العمولة", commission, Icons.percent_rounded),

                SizedBox(height: ManagerHeight.h12),

                // السعر
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(ManagerWidth.w12),
                  decoration: BoxDecoration(
                    color: ManagerColors.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(ManagerRadius.r10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'السعر',
                        style: getRegularTextStyle(
                          fontSize: ManagerFontSize.s13,
                          color: ManagerColors.greyWithColor,
                        ),
                      ),
                      Text(
                        price,
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s16,
                          color: ManagerColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // معلومات إضافية
                if (extraInfo.isNotEmpty) ...[
                  SizedBox(height: ManagerHeight.h12),
                  _buildExtraInfoBox(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: ManagerHeight.h8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: ManagerColors.primaryColor.withOpacity(0.7),
          ),
          SizedBox(width: ManagerWidth.w8),
          Expanded(
            child: Text(
              label,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.greyWithColor,
              ),
            ),
          ),
          Text(
            value,
            style: getMediumTextStyle(
              fontSize: ManagerFontSize.s13,
              color: ManagerColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtraInfoBox() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ManagerRadius.r10),
        border: Border.all(
          color: ManagerColors.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(ManagerWidth.w10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: extraInfo.entries.map((e) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: ManagerHeight.h4),
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

// زر الإجراءات
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String tooltip;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 3,
      shadowColor: color.withOpacity(0.3),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Tooltip(
          message: tooltip,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              size: 20,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
// import 'package:app_mobile/core/resources/manager_colors.dart';
// import 'package:app_mobile/core/resources/manager_height.dart';
// import 'package:app_mobile/core/resources/manager_radius.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../../../core/resources/manager_font_size.dart';
// import '../../../../../../core/resources/manager_styles.dart';
// import '../../../../../../core/resources/manager_width.dart';
//
// class RealEstateCardWidget extends StatelessWidget {
//   final String id;
//   final bool showActions;
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
//   final Map<String, String> extraInfo;
//   final VoidCallback? onEdit;
//   final VoidCallback? onDelete;
//
//   const RealEstateCardWidget({
//     super.key,
//     required this.id,
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
//     this.onEdit,
//     this.onDelete,
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
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(
//                   top: Radius.circular(10),
//                 ),
//                 child: CachedNetworkImage(
//                   imageUrl: imageUrl,
//                   width: double.infinity,
//                   height: ManagerHeight.h210,
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Container(
//                     height: ManagerHeight.h210,
//                     color: Colors.grey.shade200,
//                     child: const Center(
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                   ),
//                   errorWidget: (context, url, error) => Container(
//                     height: ManagerHeight.h210,
//                     color: Colors.grey.shade300,
//                     child: const Center(
//                       child: Icon(
//                         Icons.broken_image_outlined,
//                         size: 40,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               if (showActions)
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: onEdit,
//                         icon: const Icon(Icons.edit,
//                             color: ManagerColors.primaryColor),
//                         tooltip: "تعديل",
//                       ),
//                       IconButton(
//                         onPressed: onDelete,
//                         icon:
//                             const Icon(Icons.delete_outline, color: Colors.red),
//                         tooltip: "حذف",
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//           Padding(
//             padding: EdgeInsets.all(ManagerWidth.w14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: getBoldTextStyle(
//                     fontSize: ManagerFontSize.s14,
//                     color: ManagerColors.primaryColor,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on_outlined,
//                         size: 16, color: ManagerColors.greyWithColor),
//                     const SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         location,
//                         style: getRegularTextStyle(
//                           fontSize: ManagerFontSize.s12,
//                           color: ManagerColors.greyWithColor,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 _buildInfoRow("المساحة", area),
//                 _buildInfoRow("الغرض", purpose),
//                 _buildInfoRow("عدد الغرف", rooms),
//                 _buildInfoRow("عدد الصالات", halls),
//                 _buildInfoRow("العمولة", commission),
//                 _buildInfoRow("السعر", price),
//                 const SizedBox(height: 12),
//                 _buildDottedBox(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: getRegularTextStyle(
//               fontSize: ManagerFontSize.s12,
//               color: ManagerColors.greyWithColor,
//             ),
//           ),
//           Text(
//             value,
//             style: getBoldTextStyle(
//               fontSize: ManagerFontSize.s12,
//               color: ManagerColors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDottedBox() {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: ManagerColors.primaryColor.withOpacity(0.2),
//           style: BorderStyle.solid,
//         ),
//       ),
//       padding: const EdgeInsets.all(8),
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
// }
