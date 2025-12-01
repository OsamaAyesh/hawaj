import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:app_mobile/core/widgets/button_app.dart';
import 'package:app_mobile/core/widgets/scaffold_with_back_button.dart';
import 'package:app_mobile/features/common/hawaj_voice/presentation/widgets/hawaj_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../../../core/routes/hawaj_routing/hawaj_routing_and_screens.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  final ScrollController _scrollController = ScrollController();
  final List<AnimationController> _sectionControllers = [];
  final List<Animation<double>> _sectionAnimations = [];

  bool _hasAccepted = false;

  @override
  void initState() {
    super.initState();

    // Header animations
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeIn),
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );

    // Content sections animations
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Create 8 section animations with staggered delays
    for (int i = 0; i < 8; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );

      final animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );

      _sectionControllers.add(controller);
      _sectionAnimations.add(animation);
    }

    // Start animations
    _headerController.forward();
    _animateSectionsSequentially();
  }

  void _animateSectionsSequentially() async {
    for (int i = 0; i < _sectionControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 100 * i));
      if (mounted) {
        _sectionControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    for (var controller in _sectionControllers) {
      controller.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBackButton(
      title: _getLocalizedString('termsAndConditionsTitle'),
      body: Column(
        children: [
          // Animated Header
          FadeTransition(
            opacity: _headerFadeAnimation,
            child: SlideTransition(
              position: _headerSlideAnimation,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(ManagerWidth.w16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ManagerColors.primaryColor.withOpacity(0.1),
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 48,
                      color: ManagerColors.primaryColor,
                    )
                        .animate()
                        .scale(
                          duration: 800.ms,
                          curve: Curves.elasticOut,
                        )
                        .then()
                        .shimmer(duration: 1500.ms),
                    SizedBox(height: ManagerHeight.h12),
                    Text(
                      _getLocalizedString('termsWelcome'),
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s16,
                        color: ManagerColors.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: ManagerHeight.h4),
                    Text(
                      _getLocalizedString('termsLastUpdate'),
                      style: getRegularTextStyle(
                        fontSize: ManagerFontSize.s10,
                        color: ManagerColors.greyWithColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(ManagerWidth.w16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Introduction
                  _buildIntroduction(),
                  SizedBox(height: ManagerHeight.h24),

                  // Sections
                  _buildAnimatedSection(
                      0, '1', 'termsSection1Title', 'termsSection1Content'),
                  _buildAnimatedSection(
                      1, '2', 'termsSection2Title', 'termsSection2Content'),
                  _buildAnimatedSection(
                      2, '3', 'termsSection3Title', 'termsSection3Content'),
                  _buildAnimatedSection(
                      3, '4', 'termsSection4Title', 'termsSection4Content'),
                  _buildAnimatedSection(
                      4, '5', 'termsSection5Title', 'termsSection5Content'),
                  _buildAnimatedSection(
                      5, '6', 'termsSection6Title', 'termsSection6Content'),
                  _buildAnimatedSection(
                      6, '7', 'termsSection7Title', 'termsSection7Content'),
                  _buildAnimatedSection(
                      7, '8', 'termsSection8Title', 'termsSection8Content'),

                  SizedBox(height: ManagerHeight.h16),

                  // Contact Information
                  _buildContactInfo(),

                  SizedBox(height: ManagerHeight.h24),

                  // Accept Checkbox
                  _buildAcceptCheckbox(),

                  SizedBox(height: ManagerHeight.h16),

                  // Action Buttons
                  _buildActionButtons(),

                  SizedBox(height: ManagerHeight.h32),
                ],
              ),
            ),
          ),
        ],
      ),
    ).withHawaj(
      section: HawajSections.settingsSection,
      screen: HawajScreens.privacyPolicyScreen,
    );
  }

  Widget _buildIntroduction() {
    return FadeTransition(
      opacity: _headerFadeAnimation,
      child: Container(
        padding: EdgeInsets.all(ManagerWidth.w12),
        decoration: BoxDecoration(
          color: ManagerColors.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(ManagerRadius.r8),
          border: Border.all(
            color: ManagerColors.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: ManagerColors.primaryColor,
              size: 24,
            ),
            SizedBox(width: ManagerWidth.w8),
            Expanded(
              child: Text(
                _getLocalizedString('termsIntroduction'),
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s11,
                  color: ManagerColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection(
    int index,
    String number,
    String titleKey,
    String contentKey,
  ) {
    return FadeTransition(
      opacity: _sectionAnimations[index],
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(_sectionAnimations[index]),
        child: Container(
          margin: EdgeInsets.only(bottom: ManagerHeight.h16),
          padding: EdgeInsets.all(ManagerWidth.w14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ManagerRadius.r10),
            border: Border.all(
              color: ManagerColors.greyWithColor.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: ManagerColors.primaryColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: ManagerColors.primaryColor,
                      borderRadius: BorderRadius.circular(ManagerRadius.r6),
                    ),
                    child: Center(
                      child: Text(
                        number,
                        style: getBoldTextStyle(
                          fontSize: ManagerFontSize.s14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ManagerWidth.w8),
                  Expanded(
                    child: Text(
                      _getLocalizedString(titleKey),
                      style: getBoldTextStyle(
                        fontSize: ManagerFontSize.s13,
                        color: ManagerColors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ManagerHeight.h10),
              Text(
                _getLocalizedString(contentKey),
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s11,
                  color: ManagerColors.greyWithColor,
                  // height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      padding: EdgeInsets.all(ManagerWidth.w12),
      decoration: BoxDecoration(
        color: ManagerColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(ManagerRadius.r8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.support_agent,
            color: ManagerColors.primaryColor,
            size: 20,
          ),
          SizedBox(width: ManagerWidth.w8),
          Expanded(
            child: Text(
              _getLocalizedString('termsContactUs'),
              style: getRegularTextStyle(
                fontSize: ManagerFontSize.s10,
                color: ManagerColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptCheckbox() {
    return Container(
      padding: EdgeInsets.all(ManagerWidth.w10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ManagerRadius.r8),
        border: Border.all(
          color: _hasAccepted
              ? ManagerColors.primaryColor
              : ManagerColors.greyWithColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _hasAccepted = !_hasAccepted;
          });
        },
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _hasAccepted
                    ? ManagerColors.primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(ManagerRadius.r4),
                border: Border.all(
                  color: _hasAccepted
                      ? ManagerColors.primaryColor
                      : ManagerColors.greyWithColor,
                  width: 2,
                ),
              ),
              child: _hasAccepted
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            SizedBox(width: ManagerWidth.w8),
            Expanded(
              child: Text(
                _getLocalizedString('termsAcceptButton'),
                style: getRegularTextStyle(
                  fontSize: ManagerFontSize.s11,
                  color: ManagerColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: ManagerColors.greyWithColor.withOpacity(0.5),
              ),
              padding: EdgeInsets.symmetric(vertical: ManagerHeight.h12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ManagerRadius.r8),
              ),
            ),
            child: Text(
              _getLocalizedString('termsDeclineButton'),
              style: getBoldTextStyle(
                fontSize: ManagerFontSize.s12,
                color: ManagerColors.greyWithColor,
              ),
            ),
          ),
        ),
        SizedBox(width: ManagerWidth.w12),
        Expanded(
          flex: 2,
          child: ButtonApp(
            title: _getLocalizedString('termsAcceptButton'),
            onPressed: _hasAccepted
                ? () {
                    Get.back();
                    // TODO: Save acceptance in local storage
                  }
                : () {},
            paddingWidth: 0,
          ),
        ),
      ],
    );
  }

  String _getLocalizedString(String key) {
    // يمكنك استبدال هذا بنظام الترجمة الخاص بك
    final termsStrings = {
      'termsAndConditionsTitle': Get.locale?.languageCode == 'ar'
          ? 'الشروط والأحكام'
          : 'Terms & Conditions',
      'termsLastUpdate': Get.locale?.languageCode == 'ar'
          ? 'آخر تحديث: ديسمبر 2024'
          : 'Last Updated: December 2024',
      'termsWelcome': Get.locale?.languageCode == 'ar'
          ? 'مرحباً بك في حواج'
          : 'Welcome to Hawaj',
      'termsIntroduction': Get.locale?.languageCode == 'ar'
          ? 'باستخدامك لتطبيق حواج، فإنك توافق على الالتزام بالشروط والأحكام التالية. يرجى قراءتها بعناية قبل استخدام التطبيق.'
          : 'By using the Hawaj app, you agree to comply with the following terms and conditions. Please read them carefully before using the app.',
      'termsSection1Title': Get.locale?.languageCode == 'ar'
          ? '1. استخدام التطبيق'
          : '1. App Usage',
      'termsSection1Content': Get.locale?.languageCode == 'ar'
          ? '• يُسمح باستخدام التطبيق للأغراض الشخصية والتجارية المشروعة فقط\n• يجب أن يكون عمرك 18 عاماً على الأقل لاستخدام التطبيق\n• تلتزم بتقديم معلومات صحيحة ودقيقة عند التسجيل\n• أنت مسؤول عن الحفاظ على سرية بيانات حسابك'
          : '• App usage is allowed for personal and legitimate commercial purposes only\n• You must be at least 18 years old to use the app\n• You must provide accurate information during registration\n• You are responsible for maintaining the confidentiality of your account',
      'termsSection2Title': Get.locale?.languageCode == 'ar'
          ? '2. الخدمات المقدمة'
          : '2. Services Provided',
      'termsSection2Content': Get.locale?.languageCode == 'ar'
          ? '• يوفر حواج خدمات التوصيل والطلبات عبر المساعد الصوتي الذكي\n• نحتفظ بالحق في تعديل أو إيقاف أي خدمة دون إشعار مسبق\n• الأسعار قابلة للتغيير وفقاً لسياسة التسعير الخاصة بنا\n• نبذل قصارى جهدنا لضمان دقة المعلومات المعروضة'
          : '• Hawaj provides delivery services through an intelligent voice assistant\n• We reserve the right to modify or discontinue any service without prior notice\n• Prices are subject to change according to our pricing policy\n• We do our best to ensure the accuracy of displayed information',
      'termsSection3Title': Get.locale?.languageCode == 'ar'
          ? '3. الخصوصية والبيانات'
          : '3. Privacy & Data',
      'termsSection3Content': Get.locale?.languageCode == 'ar'
          ? '• نحترم خصوصيتك ونحمي بياناتك الشخصية\n• نستخدم البيانات لتحسين جودة الخدمة المقدمة\n• لن نشارك معلوماتك مع أطراف ثالثة دون موافقتك\n• راجع سياسة الخصوصية للمزيد من التفاصيل'
          : '• We respect your privacy and protect your personal data\n• We use data to improve service quality\n• We will not share your information with third parties without your consent\n• Review the privacy policy for more details',
      'termsSection4Title': Get.locale?.languageCode == 'ar'
          ? '4. المدفوعات والمعاملات'
          : '4. Payments & Transactions',
      'termsSection4Content': Get.locale?.languageCode == 'ar'
          ? '• جميع المدفوعات تتم عبر بوابات دفع آمنة\n• أنت مسؤول عن دفع جميع الرسوم والضرائب المطبقة\n• في حالة الإلغاء، تطبق سياسة الاسترجاع الخاصة بنا\n• نحتفظ بحق رفض أي طلب أو معاملة مشبوهة'
          : '• All payments are made through secure gateways\n• You are responsible for paying all applicable fees and taxes\n• In case of cancellation, our refund policy applies\n• We reserve the right to refuse any suspicious transaction',
      'termsSection5Title': Get.locale?.languageCode == 'ar'
          ? '5. المسؤولية والضمانات'
          : '5. Liability & Warranties',
      'termsSection5Content': Get.locale?.languageCode == 'ar'
          ? '• التطبيق مقدم \'كما هو\' دون ضمانات صريحة أو ضمنية\n• لا نتحمل مسؤولية أي أضرار ناتجة عن استخدام التطبيق\n• نحن غير مسؤولين عن جودة المنتجات من مقدمي الخدمة\n• مسؤوليتنا محدودة بالحد الأقصى الذي يسمح به القانون'
          : '• The app is provided \'as is\' without express or implied warranties\n• We are not liable for any damages resulting from app usage\n• We are not responsible for product quality from service providers\n• Our liability is limited to the maximum extent permitted by law',
      'termsSection6Title': Get.locale?.languageCode == 'ar'
          ? '6. الملكية الفكرية'
          : '6. Intellectual Property',
      'termsSection6Content': Get.locale?.languageCode == 'ar'
          ? '• جميع حقوق الملكية الفكرية للتطبيق محفوظة لحواج\n• يُمنع نسخ أو توزيع أو تعديل محتوى التطبيق دون إذن\n• الشعارات والعلامات التجارية مملوكة لأصحابها\n• أي انتهاك سيتم اتخاذ إجراءات قانونية بشأنه'
          : '• All intellectual property rights are reserved to Hawaj\n• Copying, distributing or modifying app content without permission is prohibited\n• Logos and trademarks are owned by their respective owners\n• Any violation will result in legal action',
      'termsSection7Title': Get.locale?.languageCode == 'ar'
          ? '7. إنهاء الخدمة'
          : '7. Service Termination',
      'termsSection7Content': Get.locale?.languageCode == 'ar'
          ? '• يحق لنا إنهاء أو تعليق حسابك في حالة انتهاك الشروط\n• يمكنك إلغاء حسابك في أي وقت من إعدادات التطبيق\n• عند الإنهاء، تفقد الوصول إلى جميع البيانات والخدمات\n• بعض الأحكام تظل سارية حتى بعد إنهاء الخدمة'
          : '• We may terminate or suspend your account for terms violation\n• You can delete your account anytime from app settings\n• Upon termination, you lose access to all data and services\n• Some provisions remain effective after termination',
      'termsSection8Title': Get.locale?.languageCode == 'ar'
          ? '8. تعديل الشروط'
          : '8. Terms Modification',
      'termsSection8Content': Get.locale?.languageCode == 'ar'
          ? '• نحتفظ بالحق في تعديل هذه الشروط في أي وقت\n• سيتم إخطارك بأي تغييرات جوهرية عبر التطبيق\n• استمرارك في استخدام التطبيق يعني قبولك للشروط المحدثة\n• راجع هذه الصفحة بانتظام للاطلاع على التحديثات'
          : '• We reserve the right to modify these terms at any time\n• You will be notified of any material changes via the app\n• Continued use means acceptance of updated terms\n• Review this page regularly for updates',
      'termsContactUs': Get.locale?.languageCode == 'ar'
          ? 'للاستفسارات حول الشروط والأحكام، يرجى التواصل معنا عبر صفحة الدعم الفني.'
          : 'For inquiries about the terms and conditions, please contact us through the support page.',
      'termsAcceptButton': Get.locale?.languageCode == 'ar'
          ? 'أوافق على الشروط والأحكام'
          : 'I Accept Terms & Conditions',
      'termsDeclineButton':
          Get.locale?.languageCode == 'ar' ? 'رفض' : 'Decline',
    };

    return termsStrings[key] ?? key;
  }
}
