import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/model/job_company_item_model.dart';

class CompanyJobsProviderDetailsScreen extends StatelessWidget {
  final JobCompanyItemModel company;

  const CompanyJobsProviderDetailsScreen({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: ManagerHeight.h276,
                child: Stack(
                  children: [
                    Image.asset(
                      ManagerImages.backRemove,
                      width: double.infinity,
                      height: ManagerHeight.h276,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: ManagerHeight.h51,
                        left: ManagerWidth.w16,
                        right: ManagerWidth.w16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: ManagerHeight.h28,
                            width: ManagerWidth.w28,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ManagerColors.white),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: ManagerColors.black,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            height: ManagerHeight.h28,
                            width: ManagerWidth.w28,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ManagerColors.white),
                            child: const Center(
                              child: Icon(
                                Icons.share_outlined,
                                color: ManagerColors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: ManagerWidth.w16,
                  right: ManagerWidth.w16,
                  top: ManagerHeight.h217,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ManagerRadius.r8),
                  child: CachedNetworkImage(
                    imageUrl: company.companyLogo,
                    height: ManagerHeight.h98,
                    width: ManagerWidth.w98,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: ManagerHeight.h98,
                      width: ManagerWidth.w98,
                      decoration: BoxDecoration(
                        color: ManagerColors.greyWithColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(ManagerRadius.r8),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ManagerColors.primaryColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      ManagerImages.backRemove,
                      height: ManagerHeight.h98,
                      width: ManagerWidth.w98,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company.companyName,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(height: ManagerHeight.h4),
                Text(
                  company.detailedAddress.isNotEmpty
                      ? company.detailedAddress
                      : 'لا يوجد عنوان محدد',
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(height: ManagerHeight.h16),

                // رقم الهاتف
                Row(
                  children: [
                    Container(
                      height: ManagerHeight.h28,
                      width: ManagerWidth.w28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ManagerColors.primaryColor.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.phone,
                        color: ManagerColors.primaryColor,
                        size: ManagerHeight.h16,
                      ),
                    ),
                    SizedBox(width: ManagerWidth.w8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'رقم الهاتف',
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.greyWithColor,
                          ),
                        ),
                        Text(
                          company.mobileNumber.isNotEmpty
                              ? company.mobileNumber
                              : 'غير متوفر',
                          style: getMediumTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: ManagerHeight.h16),

                // البريد الإلكتروني
                Row(
                  children: [
                    Container(
                      height: ManagerHeight.h28,
                      width: ManagerWidth.w28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ManagerColors.primaryColor.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.email_outlined,
                        color: ManagerColors.primaryColor,
                        size: ManagerHeight.h16,
                      ),
                    ),
                    SizedBox(width: ManagerWidth.w8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'البريد الإلكتروني',
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s12,
                            color: ManagerColors.greyWithColor,
                          ),
                        ),
                        Text(
                          company.contactPersonEmail.isNotEmpty
                              ? company.contactPersonEmail
                              : 'غير متوفر',
                          style: getMediumTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: ManagerHeight.h16),

                // نبذة عن الشركة
                Text(
                  'نبذة عن الشركة',
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: ManagerColors.black,
                  ),
                ),
                SizedBox(height: ManagerHeight.h8),
                Text(
                  company.companyDescription.isNotEmpty
                      ? company.companyDescription
                      : 'لم يتم إدخال نبذة عن الشركة بعد.',
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: ManagerColors.greyWithColor,
                    overflow: TextOverflow.visible,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: ManagerHeight.h24),

                // Container(
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     color: ManagerColors.primaryColor,
                //     borderRadius: BorderRadius.circular(ManagerRadius.r8),
                //   ),
                //   padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
                //   child: Center(
                //     child: Text(
                //       "يوفر لدى الشركة وظائف: عدد 3",
                //       style: getMediumTextStyle(
                //         fontSize: ManagerFontSize.s14,
                //         color: ManagerColors.white,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
