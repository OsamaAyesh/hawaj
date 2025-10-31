import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/features/providers/job_provider_app/add_company_jobs_provider/presentation/pages/add_company_jobs_provider_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../add_company_jobs_provider/domain/di/di.dart';

class ListCompanyJobsScreen extends StatelessWidget {
  const ListCompanyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Temporary mock data until API integration
    final List<Map<String, dynamic>> companies = [
      {
        "company_name": "Innovative Tech",
        "industry": "Information Technology",
        "mobile_number": "+966501234567",
        "detailed_address": "King Fahd Road, Riyadh, Saudi Arabia",
        "company_description":
            "We are a cutting-edge technology company focusing on innovative solutions for businesses across the MENA region.",
        "company_short_description": "Building smart digital solutions.",
        "company_logo":
            "https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg",
        "contact_person_name": "Mohamed Ayesh",
        "contact_person_email": "ahmed@innovativetech.sa",
      },
      {
        "company_name": "Green Future",
        "industry": "Renewable Energy",
        "mobile_number": "+966509876543",
        "detailed_address": "Olaya District, Riyadh, Saudi Arabia",
        "company_description":
            "Focused on building sustainable energy solutions for a better tomorrow.",
        "company_short_description": "Sustainability through innovation.",
        "company_logo":
            "https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg",
        "contact_person_name": "Sarah Al Qahtani",
        "contact_person_email": "sarah@greenfuture.sa",
      },
    ];

    return ScaffoldWithBackButton(
      title: "شركاتي",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: companies.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final company = companies[index];
            return _CompanyCard(company: company);
          },
        ),
      ),

      /// === Floating Action Button ===
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          initAddCompanyJobs();
          Get.to(() => const AddCompanyJobsProviderScreen());
        },
        backgroundColor: ManagerColors.primaryColor,
        icon: const Icon(Icons.add_business_rounded, color: Colors.white),
        label: Text(
          "إضافة شركة",
          style: getMediumTextStyle(
            fontSize: ManagerFontSize.s14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final Map<String, dynamic> company;

  const _CompanyCard({required this.company});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ManagerColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ManagerColors.greyWithColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: ManagerColors.greyWithColor.withOpacity(0.3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === Top Row (Logo + Info) ===
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Logo
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  company["company_logo"],
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),

              // Company Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      company["company_name"],
                      style: getMediumTextStyle(
                        fontSize: ManagerFontSize.s18,
                        color: ManagerColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      company["industry"],
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s14,
                        color: ManagerColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      company["company_short_description"],
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s13,
                        color: ManagerColors.greyWithColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 10),

          // === Contact Info ===
          Row(
            children: [
              Icon(
                Icons.person,
                color: ManagerColors.greyWithColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  company["contact_person_name"],
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s13,
                    color: ManagerColors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                color: ManagerColors.greyWithColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  company["contact_person_email"],
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s13,
                    color: ManagerColors.greyWithColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // === Action Buttons (Edit / View Details) ===
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // View Details Button
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: ManagerColors.primaryColor,
                ),
                onPressed: () {
                  // TODO: Navigate to details screen
                },
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: Text(
                  "View Details",
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: ManagerColors.primaryColor,
                  ),
                ),
              ),

              // Edit Button
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: ManagerColors.secondColor,
                ),
                onPressed: () {
                  // TODO: Navigate to edit company screen
                },
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: Text(
                  "Edit",
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: ManagerColors.secondColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
