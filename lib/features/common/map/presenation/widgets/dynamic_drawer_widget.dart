// lib/features/common/drawer_menu/presentation/widgets/dynamic_drawer_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';

import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_font_size.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_styles.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../map/presenation/widgets/verfied_widget.dart';
import '../../domain/models/drawer_menu_model.dart';
import '../controller/drawer_menu_controller.dart';

class DynamicDrawerWidget extends StatelessWidget {
  final GlobalKey<SliderDrawerState> sliderKey;
  final String userName;
  final String role;
  final String phone;
  final String avatar;

  const DynamicDrawerWidget({
    Key? key,
    required this.sliderKey,
    required this.userName,
    required this.role,
    required this.phone,
    required this.avatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DrawerMenuController>();

    return Container(
      color: ManagerColors.white,
      child: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildShimmerLoadingState();
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return _buildErrorState(controller);
                }

                if (controller.menuItems.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: controller.refreshMenu,
                  color: ManagerColors.primaryColor,
                  child: _buildMenuList(controller),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ManagerWidth.w16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ManagerColors.primaryColor,
            ManagerColors.primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => sliderKey.currentState?.closeSlider(),
            ),
          ),
          VerifiedAvatar(
            imageUrl:
                avatar.isNotEmpty ? avatar : 'https://via.placeholder.com/150',
            size: 80,
            isVerified: true,
          ),
          SizedBox(height: ManagerHeight.h12),
          Text(
            userName,
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ManagerHeight.h4),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: ManagerWidth.w12,
              vertical: ManagerHeight.h4,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user, size: 14, color: Colors.white),
                SizedBox(width: ManagerWidth.w4),
                Text(
                  role,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ManagerHeight.h8),
          if (phone.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone, size: 16, color: Colors.white70),
                SizedBox(width: ManagerWidth.w4),
                Text(
                  phone,
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMenuList(DrawerMenuController controller) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w16,
        vertical: ManagerHeight.h12,
      ),
      itemCount: controller.menuItems.length,
      itemBuilder: (context, index) {
        final item = controller.menuItems[index];
        return _buildMenuItem(item, controller);
      },
    );
  }

  Widget _buildMenuItem(DrawerItemModel item, DrawerMenuController controller) {
    // H1 - Header
    if (item.isHeader) {
      return Padding(
        padding:
            EdgeInsets.fromLTRB(0, ManagerHeight.h20, 0, ManagerHeight.h12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: ManagerColors.primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: ManagerWidth.w8),
            Text(
              item.title,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.black,
              ),
            ),
          ],
        ),
      );
    }

    // HR - Divider
    if (item.isDivider) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
        child: Divider(
          color: Colors.grey.shade300,
          thickness: 1,
          height: 1,
        ),
      );
    }

    // Item - Regular
    if (item.actionName == null) return const SizedBox.shrink();

    final iconPath = controller.getIcon(item.actionName!);
    if (iconPath == null) return const SizedBox.shrink();

    final isActive = item.isActive;

    return InkWell(
      onTap: isActive
          ? () {
              sliderKey.currentState?.closeSlider();
              Future.delayed(const Duration(milliseconds: 300), () {
                controller.handleItemTap(item);
              });
            }
          : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ManagerWidth.w12,
          vertical: ManagerHeight.h8,
        ),
        margin: EdgeInsets.only(bottom: ManagerHeight.h4),
        decoration: BoxDecoration(
          color: isActive ? Colors.transparent : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: ManagerWidth.w24,
              height: ManagerHeight.h24,
              color: isActive ? null : Colors.grey,
            ),
            SizedBox(width: ManagerWidth.w12),
            Expanded(
              child: Text(
                item.title,
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s13,
                  color: isActive ? ManagerColors.black : Colors.grey,
                ),
              ),
            ),
            if (isActive)
              Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400)
            else
              Icon(Icons.lock_outline, size: 17, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════════
  /// ✨ SHIMMER LOADING STATE - احترافي ومميز
  /// ═══════════════════════════════════════════════════════════
  Widget _buildShimmerLoadingState() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w16,
        vertical: ManagerHeight.h12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ═══ Section 1 Header ═══
          _buildShimmerSectionHeader(),
          SizedBox(height: ManagerHeight.h8),

          // ═══ Section 1 Items (3 items) ═══
          ..._buildShimmerMenuItems(3),

          SizedBox(height: ManagerHeight.h12),

          // ═══ Divider ═══
          _buildShimmerDivider(),

          SizedBox(height: ManagerHeight.h12),

          // ═══ Section 2 Header ═══
          _buildShimmerSectionHeader(),
          SizedBox(height: ManagerHeight.h8),

          // ═══ Section 2 Items (4 items) ═══
          ..._buildShimmerMenuItems(4),

          SizedBox(height: ManagerHeight.h20),

          // ═══ Logout Button Shimmer ═══
          _buildShimmerLogoutButton(),
        ],
      ),
    );
  }

  /// بناء Shimmer للـ Section Header
  Widget _buildShimmerSectionHeader() {
    return Row(
      children: [
        _ShimmerBox(
          width: 4,
          height: 18,
          borderRadius: BorderRadius.circular(2),
        ),
        SizedBox(width: ManagerWidth.w8),
        _ShimmerBox(
          width: ManagerWidth.w120,
          height: 16,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  /// بناء قائمة من Shimmer Menu Items
  List<Widget> _buildShimmerMenuItems(int count) {
    return List.generate(
      count,
      (index) => Padding(
        padding: EdgeInsets.only(bottom: ManagerHeight.h4),
        child: _buildShimmerMenuItem(index),
      ),
    );
  }

  /// بناء Shimmer لـ Menu Item واحد
  Widget _buildShimmerMenuItem(int index) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w12,
        vertical: ManagerHeight.h12,
      ),
      child: Row(
        children: [
          // Icon Shimmer
          _ShimmerBox(
            width: ManagerWidth.w24,
            height: ManagerHeight.h24,
            borderRadius: BorderRadius.circular(6),
            delay: Duration(milliseconds: index * 100),
          ),
          SizedBox(width: ManagerWidth.w12),

          // Text Shimmer - عرض متغير للواقعية
          Expanded(
            child: _ShimmerBox(
              width: double.infinity,
              height: 14,
              borderRadius: BorderRadius.circular(4),
              delay: Duration(milliseconds: index * 100 + 50),
            ),
          ),
          SizedBox(width: ManagerWidth.w12),

          // Arrow Shimmer
          _ShimmerBox(
            width: 16,
            height: 16,
            borderRadius: BorderRadius.circular(4),
            delay: Duration(milliseconds: index * 100 + 100),
          ),
        ],
      ),
    );
  }

  /// بناء Shimmer للـ Divider
  Widget _buildShimmerDivider() {
    return _ShimmerBox(
      width: double.infinity,
      height: 1,
      borderRadius: BorderRadius.zero,
    );
  }

  /// بناء Shimmer لزر تسجيل الخروج
  Widget _buildShimmerLogoutButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ManagerWidth.w16,
        vertical: ManagerHeight.h14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ShimmerBox(
            width: 20,
            height: 20,
            borderRadius: BorderRadius.circular(4),
          ),
          SizedBox(width: ManagerWidth.w8),
          _ShimmerBox(
            width: ManagerWidth.w100,
            height: 14,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════════
  /// 🚨 ERROR STATE
  /// ═══════════════════════════════════════════════════════════
  Widget _buildErrorState(DrawerMenuController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ManagerWidth.w20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة خطأ متحركة
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: EdgeInsets.all(ManagerWidth.w16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red[400],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: ManagerHeight.h20),

            Text(
              'حدث خطأ في تحميل القائمة',
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s15,
                color: Colors.grey[800]!,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: ManagerHeight.h8),

            Text(
              controller.errorMessage.value,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s12,
                color: Colors.grey[600]!,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: ManagerHeight.h20),

            ElevatedButton.icon(
              onPressed: controller.refreshMenu,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ManagerColors.primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: ManagerWidth.w24,
                  vertical: ManagerHeight.h12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ═══════════════════════════════════════════════════════════
  /// 📭 EMPTY STATE
  /// ═══════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Container(
                  padding: EdgeInsets.all(ManagerWidth.w20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_open,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: ManagerHeight.h16),
          Text(
            'لا توجد عناصر في القائمة',
            style: getRegularTextStyle(
              fontSize: ManagerFontSize.s14,
              color: Colors.grey[600]!,
            ),
          ),
        ],
      ),
    );
  }
}

/// ═══════════════════════════════════════════════════════════
/// ✨ SHIMMER BOX - مكون قابل لإعادة الاستخدام
/// ═══════════════════════════════════════════════════════════
class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Duration delay;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    this.delay = Duration.zero,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // تأخير بدء الـ Animation
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                Colors.grey.shade200,
                Colors.grey.shade100,
                Colors.grey.shade200,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}
// // lib/features/common/drawer_menu/presentation/widgets/dynamic_drawer_widget.dart
//
// import 'package:flutter/material.dart';
// import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
// import 'package:get/get.dart';
//
// import '../../../../../core/resources/manager_colors.dart';
// import '../../../../../core/resources/manager_font_size.dart';
// import '../../../../../core/resources/manager_height.dart';
// import '../../../../../core/resources/manager_styles.dart';
// import '../../../../../core/resources/manager_width.dart';
// import '../../../map/presenation/widgets/verfied_widget.dart';
// import '../../domain/models/drawer_menu_model.dart';
// import '../controller/drawer_menu_controller.dart';
//
// class DynamicDrawerWidget extends StatelessWidget {
//   final GlobalKey<SliderDrawerState> sliderKey;
//   final String userName;
//   final String role;
//   final String phone;
//   final String avatar;
//
//   const DynamicDrawerWidget({
//     Key? key,
//     required this.sliderKey,
//     required this.userName,
//     required this.role,
//     required this.phone,
//     required this.avatar,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<DrawerMenuController>();
//
//     return Container(
//       color: ManagerColors.white,
//       child: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(context),
//             Expanded(
//               child: Obx(() {
//                 if (controller.isLoading.value) {
//                   return _buildLoadingState();
//                 }
//
//                 if (controller.errorMessage.value.isNotEmpty) {
//                   return _buildErrorState(controller);
//                 }
//
//                 if (controller.menuItems.isEmpty) {
//                   return _buildEmptyState();
//                 }
//
//                 return RefreshIndicator(
//                   onRefresh: controller.refreshMenu,
//                   color: ManagerColors.primaryColor,
//                   child: _buildMenuList(controller),
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(ManagerWidth.w16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             ManagerColors.primaryColor,
//             ManagerColors.primaryColor.withOpacity(0.8),
//           ],
//         ),
//       ),
//       child: Column(
//         children: [
//           Align(
//             alignment: Alignment.topLeft,
//             child: IconButton(
//               icon: const Icon(Icons.close, color: Colors.white),
//               onPressed: () => sliderKey.currentState?.closeSlider(),
//             ),
//           ),
//           VerifiedAvatar(
//             imageUrl:
//                 avatar.isNotEmpty ? avatar : 'https://via.placeholder.com/150',
//             size: 80,
//             isVerified: true,
//           ),
//           SizedBox(height: ManagerHeight.h12),
//           Text(
//             userName,
//             style: getBoldTextStyle(
//               fontSize: ManagerFontSize.s16,
//               color: Colors.white,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: ManagerHeight.h4),
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: ManagerWidth.w12,
//               vertical: ManagerHeight.h4,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.verified_user, size: 14, color: Colors.white),
//                 SizedBox(width: ManagerWidth.w4),
//                 Text(
//                   role,
//                   style: getRegularTextStyle(
//                     fontSize: ManagerFontSize.s12,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: ManagerHeight.h8),
//           if (phone.isNotEmpty)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.phone, size: 16, color: Colors.white70),
//                 SizedBox(width: ManagerWidth.w4),
//                 Text(
//                   phone,
//                   style: getRegularTextStyle(
//                     fontSize: ManagerFontSize.s12,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMenuList(DrawerMenuController controller) {
//     return ListView.builder(
//       padding: EdgeInsets.symmetric(
//         horizontal: ManagerWidth.w16,
//         vertical: ManagerHeight.h12,
//       ),
//       itemCount: controller.menuItems.length,
//       itemBuilder: (context, index) {
//         final item = controller.menuItems[index];
//         return _buildMenuItem(item, controller);
//       },
//     );
//   }
//
//   Widget _buildMenuItem(DrawerItemModel item, DrawerMenuController controller) {
//     // H1 - Header
//     if (item.isHeader) {
//       return Padding(
//         padding:
//             EdgeInsets.fromLTRB(0, ManagerHeight.h20, 0, ManagerHeight.h12),
//         child: Row(
//           children: [
//             Container(
//               width: 4,
//               height: 18,
//               decoration: BoxDecoration(
//                 color: ManagerColors.primaryColor,
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             SizedBox(width: ManagerWidth.w8),
//             Text(
//               item.title,
//               style: getBoldTextStyle(
//                 fontSize: ManagerFontSize.s14,
//                 color: ManagerColors.black,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     // HR - Divider
//     if (item.isDivider) {
//       return Padding(
//         padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
//         child: Divider(
//           color: Colors.grey.shade300,
//           thickness: 1,
//           height: 1,
//         ),
//       );
//     }
//
//     // Item - Regular
//     if (item.actionName == null) return const SizedBox.shrink();
//
//     final iconPath = controller.getIcon(item.actionName!);
//     if (iconPath == null) return const SizedBox.shrink();
//
//     final isActive = item.isActive;
//
//     return InkWell(
//       onTap: isActive
//           ? () {
//               sliderKey.currentState?.closeSlider();
//               Future.delayed(const Duration(milliseconds: 300), () {
//                 controller.handleItemTap(item);
//               });
//             }
//           : null,
//       borderRadius: BorderRadius.circular(8),
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: ManagerWidth.w12,
//           vertical: ManagerHeight.h8,
//         ),
//         margin: EdgeInsets.only(bottom: ManagerHeight.h4),
//         decoration: BoxDecoration(
//           color: isActive ? Colors.transparent : Colors.grey.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Image.asset(
//               iconPath,
//               width: ManagerWidth.w24,
//               height: ManagerHeight.h24,
//               color: isActive ? null : Colors.grey,
//             ),
//             SizedBox(width: ManagerWidth.w12),
//             Expanded(
//               child: Text(
//                 item.title,
//                 style: getRegularTextStyle(
//                   fontSize: ManagerFontSize.s13,
//                   color: isActive ? ManagerColors.black : Colors.grey,
//                 ),
//               ),
//             ),
//             if (isActive)
//               Icon(Icons.chevron_right, size: 20, color: Colors.grey.shade400)
//             else
//               Icon(Icons.lock_outline, size: 17, color: Colors.grey.shade400),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoadingState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor:
//                 AlwaysStoppedAnimation<Color>(ManagerColors.primaryColor),
//           ),
//           SizedBox(height: ManagerHeight.h16),
//           Text(
//             'جارٍ تحميل القائمة...',
//             style: getRegularTextStyle(
//               fontSize: ManagerFontSize.s14,
//               color: Colors.grey[600]!,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorState(DrawerMenuController controller) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(ManagerWidth.w20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 50, color: Colors.red[400]),
//             SizedBox(height: ManagerHeight.h20),
//             Text(
//               'حدث خطأ في تحميل القائمة',
//               style: getBoldTextStyle(
//                 fontSize: ManagerFontSize.s15,
//                 color: Colors.grey[800]!,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: ManagerHeight.h20),
//             ElevatedButton.icon(
//               onPressed: controller.refreshMenu,
//               icon: const Icon(Icons.refresh),
//               label: const Text('إعادة المحاولة'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ManagerColors.primaryColor,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.menu_open, size: 60, color: Colors.grey[400]),
//           SizedBox(height: ManagerHeight.h16),
//           Text(
//             'لا توجد عناصر في القائمة',
//             style: getRegularTextStyle(
//               fontSize: ManagerFontSize.s14,
//               color: Colors.grey[600]!,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
