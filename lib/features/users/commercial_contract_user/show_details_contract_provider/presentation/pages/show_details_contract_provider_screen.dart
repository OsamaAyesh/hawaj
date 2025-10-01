import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/resources/manager_colors.dart';
import '../../../../../../core/resources/manager_font_size.dart';
import '../../../../../../core/resources/manager_height.dart';
import '../../../../../../core/resources/manager_radius.dart';
import '../../../../../../core/resources/manager_styles.dart';
import '../../../../../../core/resources/manager_width.dart';

class ShowDetailsContractProviderScreen extends StatelessWidget {
  const ShowDetailsContractProviderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        "title": "تصميم UI/UX",
        "description": "تصميم واجهات استخدام جمالية وسهلة الاستخدام لمنتجاتك.",
        "price": "699",
        "image":
            "https://media.istockphoto.com/id/1329328971/photo/discussing-business-opportunities.jpg?s=612x612&w=0&k=20&c=pF7XH_KSpB6J2YLnuLtZ3JEAFAwdMcBc3zOdPnnNkpM="
        // صورة تجريبية
      },
      {
        "title": "تحليل البيانات",
        "description":
            "استخراج قيمة من بياناتك باستخدام تقنيات التحليل والتعلم الآلي.",
        "price": "699",
        "image":
            "https://cdn-dynmedia-1.microsoft.com/is/image/microsoftcorp/Cloud-for-financial-services-Hero-image-640x480?resMode=sharp2&op_usm=1.5,0.65,15,0&wid=640&hei=480&qlt=100&fmt=png-alpha&fit=constrain"
        // صورة تجريبية
      },
      {
        "title": "تطوير البرمجيات",
        "description":
            "تصميم وتطوير برمجيات مخصصة لتلبية احتياجاتك باستخدام أحدث التقنيات.",
        "price": "129",
        "image":
            "https://www.bitrebels.com/wp-content/uploads/2019/01/10-vital-it-support-article-image-optimized.png"
        // صورة تجريبية
      },
    ];
    return ScaffoldWithBackButton(
      title: "تفاصيل مقدم الخدمة",
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ManagerHeight.h48,
            ),
            _buildCompanyHeader(),
            SizedBox(
              height: ManagerHeight.h14,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w12),
              child: Row(
                children: [
                  _infoCard("2023-05", "عضو منذ"),
                  _infoCard(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF3E206D),
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            "\$",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: ManagerWidth.w4),
                        Text(
                          "200",
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    "متوسط السعر",
                  ),
                  _infoCard("+10", "سنوات الخبرة"),
                ],
              ),
            ),
            SizedBox(
              height: ManagerHeight.h12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Text(
                "نبذة عن الخدمة",
                style: getBoldTextStyle(
                  color: ManagerColors.primaryColor,
                  fontSize: ManagerFontSize.s14,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Text(
                "شركة متخصصة في تقديم الحلول والاستشارات التقنية للمؤسسات والأفراد، تركز على تمكين التحول الرقمي وتقديم الدعم في مجالات تطوير الأنظمة، تحسين البنية التحتية التكنولوجية، وتحليل الاحتياجات الرقمية.  تضم نخبة من المهندسين والخبراء في مجالات البرمجة، الأمن السيبراني، وإدارة المشاريع التقنية، وتلتزم بتقديم حلول مبتكرة وفعّالة تعزز من كفاءة الأعمال وجودة الأداء.",
                style: getRegularTextStyle(
                  color: Colors.grey,
                  fontSize: ManagerFontSize.s12,
                ),
                maxLines: 8,
              ),
            ),
            SizedBox(
              height: ManagerHeight.h8,
            ),
            // داخل body بعد "الخدمات التي يقدمها"
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
              child: Text(
                "الخدمات التي يقدمها",
                style: getBoldTextStyle(
                  color: ManagerColors.primaryColor,
                  fontSize: ManagerFontSize.s14,
                ),
              ),
            ),

            SizedBox(height: ManagerHeight.h12),

            SizedBox(
              height: ManagerHeight.h200,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w16),
                itemCount: services.length,
                separatorBuilder: (_, __) => SizedBox(width: ManagerWidth.w12),
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Container(
                    width: ManagerWidth.w180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ManagerRadius.r10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: ManagerColors.black.withOpacity(0.08),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(ManagerRadius.r10),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: service["image"]!,
                            height: ManagerHeight.h100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.error, size: 40),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service["title"]!,
                                style: getBoldTextStyle(
                                  fontSize: ManagerFontSize.s10,
                                  color: ManagerColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: ManagerHeight.h4),
                              Text(
                                service["description"]!,
                                style: getRegularTextStyle(
                                  fontSize: ManagerFontSize.s8,
                                  color: Colors.grey,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: ManagerHeight.h6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "السعر يبدأ من ",
                                          style: getBoldTextStyle(
                                            fontSize: ManagerFontSize.s6,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "\$${service["price"]}",
                                          style: getBoldTextStyle(
                                            fontSize: ManagerFontSize.s13,
                                            color: ManagerColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl:
                      "https://marketplace.canva.com/EAFzGa8kk30/3/0/1600w/canva-blue-and-black-modern-gradient-software-development-technology-logo-lU0JB64VYys.jpg",
                  width: ManagerHeight.h90,
                  height: ManagerHeight.h90,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const CircularProgressIndicator(
                    color: ManagerColors.primaryColor,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: ManagerHeight.h90,
                    height: ManagerHeight.h90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF1E293B),
                    ),
                    child: const Icon(
                      Icons.business,
                      size: 40,
                      color: ManagerColors.white,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(
                  Icons.verified,
                  color: ManagerColors.primaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: ManagerHeight.h12),
          Text(
            "شركة الإستشارات التقنية",
            style: getBoldTextStyle(
              fontSize: ManagerFontSize.s14,
              color: ManagerColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ManagerHeight.h4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w24),
            child: Text(
              "شركة تقنية مميزة تقدم خدمات تقنية مميزة وفريدة",
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s11,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(Object value, String label) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ManagerWidth.w4),
        child: DottedBorder(
          color: ManagerColors.primaryColor,
          borderType: BorderType.RRect,
          radius: Radius.circular(ManagerRadius.r6),
          dashPattern: const [6, 3],
          strokeWidth: 1.2,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
            child: Column(
              children: [
                SizedBox(height: ManagerHeight.h8),
                Center(
                  child: value is String
                      ? Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: ManagerColors.primaryColor,
                          ),
                        )
                      : (value as Widget),
                ),
                SizedBox(height: ManagerHeight.h4),
                Center(
                  child: Text(
                    label,
                    style: getRegularTextStyle(
                      fontSize: ManagerFontSize.s11,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
