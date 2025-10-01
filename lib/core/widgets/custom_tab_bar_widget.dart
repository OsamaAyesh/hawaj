import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';

class CustomTabBarWidget extends StatefulWidget {
  final List<String> tabs; // النصوص اللي هتظهر
  final List<Widget> views; // الشاشات اللي تقابل كل Tab
  final EdgeInsetsGeometry? padding; // لو حابب تعدل البادنج
  final double? height; // ارتفاع التاب بار
  final Color? backgroundColor; // لون خلفية التاب بار
  final Color? indicatorColor; // لون المؤشر

  const CustomTabBarWidget({
    super.key,
    required this.tabs,
    required this.views,
    this.padding,
    this.height,
    this.backgroundColor,
    this.indicatorColor,
  });

  @override
  State<CustomTabBarWidget> createState() => _CustomTabBarWidgetState();
}

class _CustomTabBarWidgetState extends State<CustomTabBarWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: widget.padding ??
              EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
          child: Container(
            height: widget.height ?? ManagerHeight.h44,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? ManagerColors.backGroundColorTab,
              borderRadius: BorderRadius.circular(ManagerRadius.r8),
            ),
            child: Padding(
              padding: EdgeInsets.all(ManagerRadius.r4),
              child: TabBar(
                controller: _tabController,
                indicatorPadding: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                indicator: BoxDecoration(
                  color: widget.indicatorColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(ManagerRadius.r8),
                ),
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black.withOpacity(0.5),
                labelStyle: getBoldTextStyle(
                  fontSize: ManagerFontSize.s11,
                  color: ManagerColors.black,
                ),
                unselectedLabelStyle: getRegularTextStyle(
                  fontSize: ManagerFontSize.s12,
                  color: ManagerColors.black,
                ),
                tabs: widget.tabs.map((e) => Tab(child: Text(e))).toList(),
              ),
            ),
          ),
        ),
        SizedBox(height: ManagerHeight.h12),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.views,
          ),
        )
      ],
    );
  }
}
