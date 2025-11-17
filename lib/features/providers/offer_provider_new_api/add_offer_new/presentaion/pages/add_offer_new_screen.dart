import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/labeled_text_field.dart';
import 'package:app_mobile/core/widgets/lable_drop_down_button.dart';
import 'package:app_mobile/core/widgets/loading_widget.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/core/widgets/sized_box_between_feilads_widgets.dart';
import 'package:app_mobile/core/widgets/upload_media_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/common_widgets/form_screen_widgets/sub_title_form_screen_widget.dart';
import '../../../../../common/common_widgets/form_screen_widgets/title_form_screen_widget.dart';
import '../../domain/di/di.dart';
import '../controller/add_offer_new_controller.dart';

class AddOfferNewScreen extends StatefulWidget {
  const AddOfferNewScreen({super.key});

  @override
  State<AddOfferNewScreen> createState() => _AddOfferNewScreenState();
}

class _AddOfferNewScreenState extends State<AddOfferNewScreen>
    with SingleTickerProviderStateMixin {
  late final AddOfferNewController controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // add_offer_new_screen.dart

  @override
  void initState() {
    super.initState();

    controller = Get.find<AddOfferNewController>();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // ✅ Fetch companies after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

// ✅ Add fetch method
  Future<void> _fetchData() async {
    await controller.fetchCompanies();
    if (mounted && controller.companies.isNotEmpty) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    disposeAddOfferNew();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: ManagerStrings.addOfferTitle,
      body: Obx(() {
        // Show loading while fetching
        if (controller.isLoading.value) {
          return const Center(child: LoadingWidget());
        }

        // ✅ Show empty state only if fetch was attempted and no companies
        if (controller.hasAttemptedFetch.value &&
            controller.companies.isEmpty) {
          return _buildEmptyState();
        }

        return Stack(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildForm(context),
              ),
            ),
            if (controller.isSubmitting.value)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ManagerWidth.w32,
                      vertical: ManagerHeight.h24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LoadingWidget(),
                        SizedBox(height: ManagerHeight.h16),
                        Text(
                          ManagerStrings.submittingOfferLoading,
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s15,
                            color: ManagerColors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  // ==================== Empty State ====================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ManagerWidth.w24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 600),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.elasticOut,
              builder: (_, double value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: ManagerColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.business_outlined,
                  size: 80,
                  color: ManagerColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: ManagerHeight.h24),
            Text(
              ManagerStrings.noCompaniesAvailable,
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s18,
                color: ManagerColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ManagerHeight.h12),
            Text(
              ManagerStrings.registerCompanyFirst,
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.greyWithColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ManagerHeight.h32),
            ButtonApp(
              title: ManagerStrings.retryButton,
              onPressed: controller.retryFetchCompanies,
              paddingWidth: ManagerWidth.w48,
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Main Form ====================
  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + ManagerHeight.h20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ManagerHeight.h20),
            _buildHeader(),
            SizedBox(height: ManagerHeight.h20),
            _buildOrganizationDropdown(),
            const SizedBoxBetweenFieldWidgets(),
            _buildProductNameField(),
            const SizedBoxBetweenFieldWidgets(),
            _buildProductDescriptionField(),
            const SizedBoxBetweenFieldWidgets(),
            _buildProductImageField(),
            const SizedBoxBetweenFieldWidgets(),
            _buildProductPriceField(),
            const SizedBoxBetweenFieldWidgets(),
            _buildOfferTypeDropdown(),
            const SizedBoxBetweenFieldWidgets(),
            _buildConditionalDiscountFields(),
            _buildOfferStatusDropdown(),
            SizedBox(height: ManagerHeight.h32),
            _buildSubmitButton(),
            SizedBox(height: ManagerHeight.h20),
          ],
        ),
      ),
    );
  }

  // ==================== Header Section ====================
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleFormScreenWidget(title: ManagerStrings.addOfferDetailsTitle),
        SubTitleFormScreenWidget(
          subTitle: ManagerStrings.addOfferDetailsSubtitle,
        ),
      ],
    );
  }

  // ==================== Dropdown - Company ====================
  Widget _buildOrganizationDropdown() {
    return Obx(() {
      return LabeledDropdownField(
        label: ManagerStrings.selectCompanyLabel,
        hint: ManagerStrings.selectCompanyHint,
        value: controller.selectedCompany.value,
        items: controller.companies.map((company) {
          return DropdownMenuItem(
            value: company,
            child: Text(
              company.organizationName,
              style: getMediumTextStyle(
                fontSize: ManagerFontSize.s14,
                color: ManagerColors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) => controller.selectedCompany.value = value,
      );
    });
  }

  // ==================== Product Name ====================
  Widget _buildProductNameField() {
    return LabeledTextField(
      widthButton: ManagerWidth.w130,
      label: ManagerStrings.productNameLabel,
      hintText: ManagerStrings.productNameHint,
      controller: controller.productNameController,
      textInputAction: TextInputAction.next,
    );
  }

  // ==================== Product Description ====================
  Widget _buildProductDescriptionField() {
    return LabeledTextField(
      widthButton: ManagerWidth.w130,
      label: ManagerStrings.productDescriptionLabel,
      hintText: ManagerStrings.productDescriptionHint,
      controller: controller.productDescriptionController,
      minLines: 3,
      maxLines: 5,
      textInputAction: TextInputAction.next,
    );
  }

  // ==================== Product Image ====================
  Widget _buildProductImageField() {
    return UploadMediaField(
      label: ManagerStrings.productImageLabel,
      hint: ManagerStrings.productImageHint,
      note: ManagerStrings.productImageNote,
      file: controller.pickedImage,
    );
  }

  // ==================== Product Price ====================
  Widget _buildProductPriceField() {
    return LabeledTextField(
      widthButton: ManagerWidth.w80,
      label: ManagerStrings.productPriceLabel,
      hintText: ManagerStrings.productPriceHint,
      controller: controller.productPriceController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
    );
  }

  // ==================== Offer Type ====================
  Widget _buildOfferTypeDropdown() {
    return Obx(() => LabeledDropdownField<String>(
          label: ManagerStrings.offerTypeLabel,
          hint: ManagerStrings.offerTypeHint,
          value: controller.offerType.value,
          items: [
            DropdownMenuItem(
                value: "2", child: Text(ManagerStrings.offerTypeNormal)),
            DropdownMenuItem(
                value: "1", child: Text(ManagerStrings.offerTypeDiscount)),
          ],
          onChanged: (v) => controller.offerType.value = v ?? "2",
        ));
  }

  // ==================== Conditional Discount Fields ====================
  Widget _buildConditionalDiscountFields() {
    return Obx(() {
      if (controller.offerType.value == "1") {
        return Column(
          children: [
            LabeledTextField(
              widthButton: ManagerWidth.w80,
              label: ManagerStrings.discountPercentageLabel,
              hintText: ManagerStrings.discountPercentageHint,
              controller: controller.offerPriceController,
              keyboardType: TextInputType.number,
            ),
            const SizedBoxBetweenFieldWidgets(),

            // Dates
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: ManagerStrings.startDateLabel,
                    hint: ManagerStrings.startDateHint,
                    controller: controller.offerStartDateController,
                  ),
                ),
                SizedBox(width: ManagerWidth.w16),
                Expanded(
                  child: _buildDateField(
                    label: ManagerStrings.endDateLabel,
                    hint: ManagerStrings.endDateHint,
                    controller: controller.offerEndDateController,
                  ),
                ),
              ],
            ),

            const SizedBoxBetweenFieldWidgets(),

            LabeledTextField(
              widthButton: ManagerWidth.w130,
              label: ManagerStrings.offerDescriptionLabel,
              hintText: ManagerStrings.offerDescriptionHint,
              controller: controller.offerDescriptionController,
              minLines: 3,
              maxLines: 5,
            ),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }

  // ==================== Date Picker Field ====================
  Widget _buildDateField({
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    return GestureDetector(
      onTap: () => _openDatePicker(controller),
      child: AbsorbPointer(
        child: LabeledTextField(
          label: label,
          hintText: hint,
          controller: controller,
          widthButton: 130,
          prefixIcon: Icon(
            Icons.calendar_today,
            color: ManagerColors.primaryColor,
            size: 18,
          ),
        ),
      ),
    );
  }

  Future<void> _openDatePicker(TextEditingController controller) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      cancelText: ManagerStrings.cancel,
      confirmText: ManagerStrings.confirm,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ManagerColors.primaryColor,
              onPrimary: Colors.white,
              onSurface: ManagerColors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      controller.text =
          "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
    }
  }

  // ==================== Offer Status ====================
  Widget _buildOfferStatusDropdown() {
    return Obx(() => LabeledDropdownField<String>(
          label: ManagerStrings.offerStatusLabel,
          hint: ManagerStrings.offerStatusHint,
          value: controller.offerStatus.value,
          items: [
            DropdownMenuItem(
                value: "5", child: Text(ManagerStrings.offerStatusReview)),
            DropdownMenuItem(
                value: "1", child: Text(ManagerStrings.offerStatusPublished)),
            DropdownMenuItem(
                value: "2", child: Text(ManagerStrings.offerStatusUnpublished)),
            DropdownMenuItem(
                value: "3", child: Text(ManagerStrings.offerStatusExpired)),
            DropdownMenuItem(
                value: "4", child: Text(ManagerStrings.offerStatusCanceled)),
          ],
          onChanged: (v) => controller.offerStatus.value = v ?? "5",
        ));
  }

  // ==================== Submit Button ====================
  Widget _buildSubmitButton() {
    return ButtonApp(
      title: ManagerStrings.submitOffer,
      onPressed: controller.submitOffer,
      paddingWidth: 0,
    );
  }
}
