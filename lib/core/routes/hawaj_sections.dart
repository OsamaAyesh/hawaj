class HawajSections {
  // خريطة الأقسام والشاشات
  static const Map<String, Map<String, HawajScreenInfo>> sections = {
    '1': {
      // القسم الرئيسي - الصفحة الرئيسية
      '1': HawajScreenInfo(route: '/home', name: 'الرئيسية'),
      '2': HawajScreenInfo(route: '/profile', name: 'الملف الشخصي'),
      '3': HawajScreenInfo(route: '/settings', name: 'الإعدادات'),
      '4': HawajScreenInfo(route: '/notifications', name: 'الإشعارات'),
    },
    '2': {
      // قسم المنتجات
      '1': HawajScreenInfo(route: '/products', name: 'المنتجات'),
      '2':
          HawajScreenInfo(route: '/products/search', name: 'البحث في المنتجات'),
      '3':
          HawajScreenInfo(route: '/products/categories', name: 'فئات المنتجات'),
      '4': HawajScreenInfo(
          route: '/products/favorites', name: 'المنتجات المفضلة'),
    },
    '3': {
      // قسم الطلبات
      '1': HawajScreenInfo(route: '/orders', name: 'الطلبات'),
      '2': HawajScreenInfo(route: '/cart', name: 'السلة'),
      '3': HawajScreenInfo(route: '/orders/history', name: 'تاريخ الطلبات'),
      '4': HawajScreenInfo(route: '/orders/tracking', name: 'تتبع الطلبات'),
    },
    '4': {
      // قسم المحفظة والمدفوعات
      '1': HawajScreenInfo(route: '/wallet', name: 'المحفظة'),
      '2': HawajScreenInfo(route: '/wallet/transactions', name: 'المعاملات'),
      '3': HawajScreenInfo(route: '/wallet/cards', name: 'البطاقات'),
      '4': HawajScreenInfo(route: '/payments', name: 'المدفوعات'),
    },
    '5': {
      // قسم الدعم والمساعدة
      '1': HawajScreenInfo(route: '/support', name: 'الدعم'),
      '2': HawajScreenInfo(route: '/support/chat', name: 'المحادثة'),
      '3': HawajScreenInfo(route: '/support/faq', name: 'الأسئلة الشائعة'),
      '4': HawajScreenInfo(route: '/support/contact', name: 'اتصل بنا'),
    },
  };

  /// الحصول على مسار الشاشة
  static String? getRoute(String section, String screen) {
    return sections[section]?[screen]?.route;
  }

  /// الحصول على اسم الشاشة
  static String? getScreenName(String section, String screen) {
    return sections[section]?[screen]?.name;
  }

  /// الحصول على معلومات الشاشة
  static HawajScreenInfo? getScreenInfo(String section, String screen) {
    return sections[section]?[screen];
  }

  /// الحصول على جميع شاشات القسم
  static Map<String, HawajScreenInfo>? getSectionScreens(String section) {
    return sections[section];
  }

  /// الحصول على رسالة ترحيب للشاشة
  static String getWelcomeMessage(String section, String screen) {
    final screenInfo = getScreenInfo(section, screen);
    if (screenInfo != null) {
      return 'مرحباً بك في ${screenInfo.name}! كيف يمكنني مساعدتك؟';
    }
    return 'مرحباً! كيف يمكنني مساعدتك؟';
  }
}

class HawajScreenInfo {
  final String route;
  final String name;
  final String? description;

  const HawajScreenInfo({
    required this.route,
    required this.name,
    this.description,
  });
}
