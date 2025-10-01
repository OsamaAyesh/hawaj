import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/resources/manager_strings.dart';

class MyServiceGridCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String price;
  final bool isActive;
  final VoidCallback? onToggle;

  const MyServiceGridCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    this.isActive = true,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.black12.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ======= صورة + بادج =======
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                PositionedDirectional(
                  top: 10,
                  start: 10,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: ManagerColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.edit, // أيقونة القلم حسب الصورة
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ======= المحتوى =======
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w12,
              vertical: ManagerHeight.h10,
            ),
            child: Column(
              children: [
                // السعر — صغير وخافت ومحاذاة البداية
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    "\$$price   ${ManagerStrings.servicePrice}",
                    // "السعر يبدأ من"
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s10,
                      color: ManagerColors.blackWithOpcity,
                    ),
                  ),
                ),
                SizedBox(height: ManagerHeight.h6),

                // العنوان — Bold ومركزي
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(height: ManagerHeight.h6),

                // الوصف — مركزي وخافت
                Text(
                  description,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.blackWithOpcity,
                  ),
                ),
              ],
            ),
          ),

          // ======= زر أسفل الكارد =======
          Padding(
            padding: EdgeInsets.fromLTRB(
              ManagerWidth.w12,
              0,
              ManagerWidth.w12,
              ManagerHeight.h12,
            ),
            child: SizedBox(
              height: ManagerHeight.h34,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFFFECEC) // وردي فاتح
                      : const Color(0xFFEFF9EF),
                  // أخضر فاتح عند المعطّل (لـ "تفعيل")
                  borderRadius: BorderRadius.circular(ManagerRadius.r8),
                ),
                child: TextButton(
                  onPressed: onToggle,
                  style: TextButton.styleFrom(
                    foregroundColor: isActive
                        ? const Color(0xFFD23B3B)
                        : const Color(0xFF2E7D32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ManagerRadius.r8),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    isActive
                        ? ManagerStrings.disableService
                        : ManagerStrings.enableService,
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: isActive
                          ? const Color(0xFFD23B3B)
                          : const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
