import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'api_service.dart';
import 'auth_storage.dart';
import 'add_chore_screen.dart';

void main() {
  runApp(const ChoreApp());
}

enum ChoreFilter { all, pending, done }

class AppStrings {
  final Locale locale;

  const AppStrings(this.locale);

  bool get isArabic => locale.languageCode == 'ar';

  static const supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  static AppStrings of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return AppStrings(locale);
  }

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  String get appTitle => isArabic ? 'مهامي' : 'My Chores';
  String get appBrand => isArabic ? 'تشور فلو' : 'ChoreFlow';
  String get welcomeTitle =>
      isArabic ? 'مرحباً بك في تشور فلو' : 'Welcome to ChoreFlow';
  String get welcomeSubtitle => isArabic
      ? 'تابع المهام المنزلية، أنجزها قبل انتهاء الوقت، وابقَ منظماً بتجربة جميلة وعصرية.'
      : 'Track chores, finish them before expiry, and stay organized with a clean, modern experience.';
  String get login => isArabic ? 'تسجيل الدخول' : 'Login';
  String get register => isArabic ? 'إنشاء حساب' : 'Create Account';
  String get welcomeBack => isArabic ? 'مرحباً بعودتك' : 'Welcome back';
  String get loginSubtitle => isArabic
      ? 'سجّل الدخول لمتابعة إدارة مهامك.'
      : 'Login to continue managing your chores.';
  String get email => isArabic ? 'البريد الإلكتروني' : 'Email';
  String get password => isArabic ? 'كلمة المرور' : 'Password';
  String get fullName => isArabic ? 'الاسم الكامل' : 'Full name';
  String get confirmPassword =>
      isArabic ? 'تأكيد كلمة المرور' : 'Confirm password';
  String get createAccount =>
      isArabic ? 'إنشاء حسابك' : 'Create your account';
  String get registerSubtitle => isArabic
      ? 'ابدأ بتنظيم مهامك بطريقة أذكى.'
      : 'Start organizing your chores in a smarter way.';
  String get alreadyHaveAccount => isArabic
      ? 'لديك حساب بالفعل؟ سجّل الدخول'
      : 'Already have an account? Login';
  String get noAccount =>
      isArabic ? 'ليس لديك حساب؟ أنشئ حساباً' : "Don't have an account? Register";
  String get invalidEmail => isArabic
      ? 'يرجى إدخال بريد إلكتروني صحيح'
      : 'Please enter a valid email';
  String get shortPassword => isArabic
      ? 'يجب أن تكون كلمة المرور 6 أحرف على الأقل'
      : 'Password must be at least 6 characters';
  String get enterName =>
      isArabic ? 'يرجى إدخال اسمك' : 'Please enter your name';
  String get passwordsMismatch =>
      isArabic ? 'كلمتا المرور غير متطابقتين' : 'Passwords do not match';
  String get logout => isArabic ? 'تسجيل الخروج' : 'Logout';
  String get logoutQuestion => isArabic ? 'تسجيل الخروج؟' : 'Logout?';
  String get logoutConfirmText => isArabic
      ? 'هل تريد تسجيل الخروج من التطبيق؟'
      : 'Do you want to logout from the app?';
  String get cancel => isArabic ? 'إلغاء' : 'Cancel';
  String get delete => isArabic ? 'حذف' : 'Delete';
  String get deleteQuestion => isArabic ? 'حذف المهمة؟' : 'Delete chore?';
  String deleteConfirm(String title) => isArabic
      ? 'هل أنت متأكد أنك تريد حذف "$title"؟'
      : 'Are you sure you want to delete "$title"?';
  String get stayOrganized =>
      isArabic ? 'ابقَ منظماً اليوم' : 'Stay organized today';
  String get homeSubtitle => isArabic
      ? 'ابحث، صفِّ، عدّل، وأنجز المهام قبل انتهاء وقتها.'
      : 'Search, filter, edit, and finish chores before they expire.';
  String get pending => isArabic ? 'قيد الانتظار' : 'Pending';
  String get done => isArabic ? 'تم' : 'Done';
  String get todayChores => isArabic ? 'مهام اليوم' : "Today's chores";
  String get searchHint =>
      isArabic ? 'ابحث في المهام...' : 'Search chores...';
  String get all => isArabic ? 'الكل' : 'All';
  String get add => isArabic ? 'إضافة' : 'Add';
  String get addChore => isArabic ? 'إضافة مهمة' : 'Add Chore';
  String get editChore => isArabic ? 'تعديل المهمة' : 'Edit Chore';
  String get createNewChore =>
      isArabic ? 'إنشاء مهمة جديدة' : 'Create a new chore';
  String get updateYourChore =>
      isArabic ? 'حدّث المهمة' : 'Update your chore';
  String get choreFormSubtitle => isArabic
      ? 'حدّد العنوان والوصف ووقت الانتهاء.'
      : 'Set the title, description, and expiry time.';
  String get choreTitle => isArabic ? 'عنوان المهمة' : 'Chore title';
  String get choreTitleHint =>
      isArabic ? 'مثال: غسل الصحون' : 'Example: Wash dishes';
  String get description => isArabic ? 'الوصف' : 'Description';
  String get optionalDetails =>
      isArabic ? 'تفاصيل اختيارية' : 'Optional details';
  String get chooseExpiry =>
      isArabic ? 'اختر تاريخ ووقت الانتهاء' : 'Choose expiry date & time';
  String get saveChanges => isArabic ? 'حفظ التعديلات' : 'Save Changes';
  String get noDescription =>
      isArabic ? 'لا يوجد وصف' : 'No description';
  String get enterChoreTitle => isArabic
      ? 'يرجى إدخال عنوان المهمة'
      : 'Please enter a chore title';
  String get chooseExpiryError => isArabic
      ? 'يرجى اختيار تاريخ ووقت الانتهاء'
      : 'Please choose an expiry date and time';
  String get expiryFutureError => isArabic
      ? 'يجب أن يكون وقت الانتهاء في المستقبل'
      : 'Expiry time must be in the future';
  String expiresOn(String date) =>
      isArabic ? 'ينتهي في $date' : 'Expires on $date';
  String expiresLabel(String date) =>
      isArabic ? 'ينتهي: $date' : 'Expires: $date';
  String get noChoresYet =>
      isArabic ? 'لا توجد مهام بعد' : 'No chores yet';
  String get noPending =>
      isArabic ? 'لا توجد مهام قيد الانتظار' : 'No pending chores';
  String get noCompleted =>
      isArabic ? 'لا توجد مهام مكتملة' : 'No completed chores';
  String get noMatching =>
      isArabic ? 'لا توجد مهام مطابقة' : 'No matching chores';
  String get addFirstChore => isArabic
      ? 'أضف مهمتك الأولى وابدأ بتتبعها قبل انتهاء الوقت.'
      : 'Add your first chore and start tracking it before it expires.';
  String get noPendingSubtitle => isArabic
      ? 'لا توجد لديك مهام معلقة الآن.'
      : 'You have nothing pending right now.';
  String get noCompletedSubtitle => isArabic
      ? 'ستظهر المهام المكتملة هنا.'
      : 'Completed chores will appear here.';
  String get noMatchingSubtitle => isArabic
      ? 'جرّب كلمة مختلفة أو امسح البحث.'
      : 'Try a different keyword or clear the search.';
  String addedSuccess(String title) => isArabic
      ? 'تمت إضافة "$title" بنجاح'
      : '"$title" added successfully';
  String updatedSuccess(String title) => isArabic
      ? 'تم تحديث "$title" بنجاح'
      : '"$title" updated successfully';
  String deletedSuccess(String title) => isArabic
      ? 'تم حذف "$title"'
      : '"$title" deleted';
  String markedDone(String title) => isArabic
      ? 'تم إنجاز "$title"'
      : '"$title" marked as done';
  String expiredRemovedOne(String title) => isArabic
      ? 'انتهى وقت "$title" وتمت إزالته'
      : '"$title" expired and was removed';
  String expiredRemovedMany(int count) => isArabic
      ? 'انتهى وقت $count مهام وتمت إزالتها'
      : '$count chores expired and were removed';
  String get language => isArabic ? 'اللغة' : 'Language';
  String get switchToLight =>
      isArabic ? 'التبديل إلى الوضع الفاتح' : 'Switch to light mode';
  String get switchToDark =>
      isArabic ? 'التبديل إلى الوضع الداكن' : 'Switch to dark mode';
  String get languageChangedArabic =>
      isArabic ? 'تم تغيير اللغة إلى العربية' : 'Language changed to Arabic';
  String get languageChangedEnglish =>
      isArabic ? 'Language changed to English' : 'تم تغيير اللغة إلى الإنجليزية';
  String get loading => isArabic ? 'جارٍ التحميل...' : 'Loading...';

  String formatTimeLeft(DateTime expiresAt) {
    final now = DateTime.now();
    final difference = expiresAt.difference(now);

    if (difference.isNegative || difference.inSeconds <= 0) {
      return isArabic ? 'منتهية' : 'Expired';
    }

    if (difference.inMinutes < 1) {
      return isArabic
          ? 'متبقي ${difference.inSeconds} ث'
          : '${difference.inSeconds}s left';
    }

    if (difference.inHours < 1) {
      return isArabic
          ? 'متبقي ${difference.inMinutes} د'
          : '${difference.inMinutes}m left';
    }

    if (difference.inDays < 1) {
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;

      if (minutes == 0) {
        return isArabic ? 'متبقي $hours س' : '${hours}h left';
      }

      return isArabic
          ? 'متبقي $hours س $minutes د'
          : '${hours}h ${minutes}m left';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    return isArabic
        ? 'متبقي $days ي $hours س'
        : '${days}d ${hours}h left';
  }

  String formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');

    return '$day/$month/${dateTime.year} $hour:$minute';
  }
}

class ChoreApp extends StatefulWidget {
  const ChoreApp({super.key});

  @override
  State<ChoreApp> createState() => _ChoreAppState();
}

class _ChoreAppState extends State<ChoreApp> {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoggedIn = false;
  Locale _locale = const Locale('en');
  bool _isCheckingSession = true;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final token = await AuthStorage.getToken();

    if (token != null) {
      try {
        await ApiService.getUser(token);

        if (mounted) {
          setState(() {
            _isLoggedIn = true;
          });
        }
      } catch (_) {
        await AuthStorage.clearToken();
      }
    }

    if (!mounted) return;
    setState(() {
      _isCheckingSession = false;
    });
  }

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _login() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  Future<void> _logout() async {
    final token = await AuthStorage.getToken();

    try {
      if (token != null) {
        await ApiService.logout(token);
      }
    } catch (_) {}

    await AuthStorage.clearToken();

    if (!mounted) return;

    setState(() {
      _isLoggedIn = false;
    });
  }

  void _toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'en'
          ? const Locale('ar')
          : const Locale('en');
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(_locale);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: strings.appTitle,
      locale: _locale,
      supportedLocales: AppStrings.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: strings.textDirection,
          child: child!,
        );
      },
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F7FB),
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F1117),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F1117),
          elevation: 0,
        ),
      ),
      home: _isCheckingSession
          ? const _StartupLoader()
          : _isLoggedIn
              ? HomeScreen(
                  isDarkMode: _themeMode == ThemeMode.dark,
                  onToggleTheme: _toggleTheme,
                  onToggleLanguage: _toggleLanguage,
                  onLogout: _logout,
                )
              : WelcomeScreen(
                  isDarkMode: _themeMode == ThemeMode.dark,
                  onToggleTheme: _toggleTheme,
                  onToggleLanguage: _toggleLanguage,
                  onLoginSuccess: _login,
                ),
    );
  }
}

class _StartupLoader extends StatelessWidget {
  const _StartupLoader();

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(s.loading),
          ],
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLanguage;
  final VoidCallback onLoginSuccess;

  const WelcomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onToggleLanguage,
    required this.onLoginSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: s.language,
            onPressed: onToggleLanguage,
            icon: const Icon(Icons.language_rounded),
          ),
          IconButton(
            tooltip: isDarkMode ? s.switchToLight : s.switchToDark,
            onPressed: onToggleTheme,
            icon: Icon(
              isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.indigo.withOpacity(0.12),
                  ),
                  child: const Icon(
                    Icons.checklist_rounded,
                    size: 52,
                    color: Colors.indigo,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Center(
                child: Text(
                  s.welcomeTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  s.welcomeSubtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.68),
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(
                          onLoginSuccess: onLoginSuccess,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    s.login,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterScreen(
                          onRegisterSuccess: onLoginSuccess,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    side: BorderSide(
                      color: theme.colorScheme.onSurface.withOpacity(0.15),
                    ),
                  ),
                  child: Text(
                    s.register,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final s = AppStrings.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.invalidEmail)),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.shortPassword)),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await ApiService.login(
        email: email,
        password: password,
      );

      final token = response['token']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception('Token was not returned from server');
      }

      await AuthStorage.saveToken(token);
      widget.onLoginSuccess();

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.login),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.welcomeBack,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                s.loginSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.65),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: s.isArabic ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  labelText: s.email,
                  hintText: 'you@example.com',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textAlign: s.isArabic ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  labelText: s.password,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          s.login,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RegisterScreen(
                          onRegisterSuccess: widget.onLoginSuccess,
                        ),
                      ),
                    );
                  },
                  child: Text(s.noAccount),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  final VoidCallback onRegisterSuccess;

  const RegisterScreen({
    super.key,
    required this.onRegisterSuccess,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final s = AppStrings.of(context);
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.enterName)),
      );
      return;
    }

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.invalidEmail)),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.shortPassword)),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.passwordsMismatch)),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await ApiService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
      );

      final token = response['token']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception('Token was not returned from server');
      }

      await AuthStorage.saveToken(token);
      widget.onRegisterSuccess();

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.register),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.createAccount,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                s.registerSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.65),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                textAlign: s.isArabic ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  labelText: s.fullName,
                  hintText: 'Ali Mashlah',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textAlign: s.isArabic ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  labelText: s.email,
                  hintText: 'you@example.com',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textAlign: s.isArabic ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  labelText: s.password,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                textAlign: s.isArabic ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  labelText: s.confirmPassword,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          s.register,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(
                          onLoginSuccess: widget.onRegisterSuccess,
                        ),
                      ),
                    );
                  },
                  child: Text(s.alreadyHaveAccount),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLanguage;
  final Future<void> Function() onLogout;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onToggleLanguage,
    required this.onLogout,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  ChoreFilter _selectedFilter = ChoreFilter.all;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Chore> _chores = [];
  bool _isLoadingChores = true;
  bool _isProcessingExpiry = false;

  @override
  void initState() {
    super.initState();
    _loadChores();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _processExpiredChores();

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadChores() async {
    try {
      final token = await AuthStorage.getToken();
      if (token == null) {
        if (!mounted) return;
        setState(() {
          _isLoadingChores = false;
        });
        return;
      }

      final data = await ApiService.getChores(token);
      final chores = data
          .map((item) => Chore.fromJson(Map<String, dynamic>.from(item)))
          .toList();

      if (!mounted) return;

      setState(() {
        _chores = chores;
        _isLoadingChores = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingChores = false;
      });

      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  bool _isExpired(Chore chore) {
    return DateTime.now().isAfter(chore.expiresAt);
  }

  void _showMessage(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _processExpiredChores() async {
    if (_isProcessingExpiry || _chores.isEmpty) return;

    final expiredPending = _chores
        .where((chore) => !chore.isDone && _isExpired(chore) && chore.id != null)
        .toList();

    if (expiredPending.isEmpty) return;

    _isProcessingExpiry = true;
    final s = AppStrings.of(context);

    try {
      final token = await AuthStorage.getToken();
      if (token == null) return;

      for (final chore in expiredPending) {
        try {
          await ApiService.deleteChore(
            token: token,
            choreId: chore.id!,
          );
        } catch (_) {}
      }

      if (!mounted) return;

      setState(() {
        _chores.removeWhere(
          (chore) =>
              !chore.isDone &&
              _isExpired(chore) &&
              chore.id != null &&
              expiredPending.any((item) => item.id == chore.id),
        );
      });

      if (expiredPending.length == 1) {
        _showMessage(s.expiredRemovedOne(expiredPending.first.title));
      } else if (expiredPending.isNotEmpty) {
        _showMessage(s.expiredRemovedMany(expiredPending.length));
      }
    } finally {
      _isProcessingExpiry = false;
    }
  }

  Future<void> _markChoreAsDone(Chore chore) async {
    final s = AppStrings.of(context);
    final index = _chores.indexOf(chore);
    if (index == -1) return;
    if (_chores[index].isDone) return;
    if (_isExpired(_chores[index])) return;
    if (_chores[index].id == null) return;

    try {
      final token = await AuthStorage.getToken();
      if (token == null) return;

      final response = await ApiService.markChoreDone(
        token: token,
        choreId: _chores[index].id!,
      );

      final updated = Chore.fromJson(
        Map<String, dynamic>.from(response['chore']),
      );

      if (!mounted) return;

      setState(() {
        _chores[index] = updated;
      });

      _showMessage(s.markedDone(updated.title));
    } catch (e) {
      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    }
  }

 Future<void> _openAddChoreScreen() async {
  final s = AppStrings.of(context);

  final Chore? newChore = await Navigator.push<Chore>(
    context,
    MaterialPageRoute<Chore>(
      builder: (_) => const ChoreFormScreen(),
    ),
  );

  if (newChore == null) return;

  try {
    final String? token = await AuthStorage.getToken();
    if (token == null) return;

    final Map<String, dynamic> response = await ApiService.createChore(
      token: token,
      title: newChore.title,
      description: newChore.description,
      expiresAt: newChore.expiresAt,
    );

    final Chore created = Chore.fromJson(
      Map<String, dynamic>.from(response['chore'] as Map),
    );

    if (!mounted) return;

    setState(() {
      _chores.insert(0, created);
    });

    _showMessage(s.addedSuccess(created.title));
  } catch (e) {
    _showMessage(e.toString().replaceFirst('Exception: ', ''));
  }
}

Future<void> _openEditChoreScreen(Chore chore) async {
  final s = AppStrings.of(context);
  final int index = _chores.indexOf(chore);

  if (index == -1) return;

  final Chore currentChore = _chores[index];
  if (currentChore.id == null) return;

  final Chore? updatedChore = await Navigator.push<Chore>(
    context,
    MaterialPageRoute<Chore>(
      builder: (_) => ChoreFormScreen(
        existingChore: currentChore,
      ),
    ),
  );

  if (updatedChore == null) return;

  try {
    final String? token = await AuthStorage.getToken();
    if (token == null) return;

    final Map<String, dynamic> response = await ApiService.updateChore(
      token: token,
      choreId: currentChore.id!,
      title: updatedChore.title,
      description: updatedChore.description,
      expiresAt: updatedChore.expiresAt,
      isDone: updatedChore.isDone,
    );

    final Chore saved = Chore.fromJson(
      Map<String, dynamic>.from(response['chore'] as Map),
    );

    if (!mounted) return;

    setState(() {
      _chores[index] = saved;
    });

    _showMessage(s.updatedSuccess(saved.title));
  } catch (e) {
    _showMessage(e.toString().replaceFirst('Exception: ', ''));
  }
}

  Future<void> _confirmDeleteChore(Chore chore) async {
    final s = AppStrings.of(context);
    final index = _chores.indexOf(chore);
    if (index == -1) return;
    if (_chores[index].id == null) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(s.deleteQuestion),
          content: Text(s.deleteConfirm(chore.title)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(s.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(s.delete),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        final token = await AuthStorage.getToken();
        if (token == null) return;

        await ApiService.deleteChore(
          token: token,
          choreId: _chores[index].id!,
        );

        if (!mounted) return;

        setState(() {
          _chores.removeAt(index);
        });

        _showMessage(s.deletedSuccess(chore.title));
      } catch (e) {
        _showMessage(e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  Future<void> _confirmLogout() async {
    final s = AppStrings.of(context);

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(s.logoutQuestion),
          content: Text(s.logoutConfirmText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(s.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(s.logout),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await widget.onLogout();
    }
  }

  List<Chore> _filteredChores() {
    List<Chore> filtered = List.from(_chores);

    switch (_selectedFilter) {
      case ChoreFilter.all:
        break;
      case ChoreFilter.pending:
        filtered = filtered.where((chore) => !chore.isDone).toList();
        break;
      case ChoreFilter.done:
        filtered = filtered.where((chore) => chore.isDone).toList();
        break;
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((chore) {
        return chore.title.toLowerCase().contains(query) ||
            chore.description.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  String _emptyTitle() {
    final s = AppStrings.of(context);

    if (_searchQuery.isNotEmpty) return s.noMatching;

    switch (_selectedFilter) {
      case ChoreFilter.all:
        return s.noChoresYet;
      case ChoreFilter.pending:
        return s.noPending;
      case ChoreFilter.done:
        return s.noCompleted;
    }
  }

  String _emptySubtitle() {
    final s = AppStrings.of(context);

    if (_searchQuery.isNotEmpty) return s.noMatchingSubtitle;

    switch (_selectedFilter) {
      case ChoreFilter.all:
        return s.addFirstChore;
      case ChoreFilter.pending:
        return s.noPendingSubtitle;
      case ChoreFilter.done:
        return s.noCompletedSubtitle;
    }
  }

  String _filterLabel(ChoreFilter filter) {
    final s = AppStrings.of(context);

    switch (filter) {
      case ChoreFilter.all:
        return s.all;
      case ChoreFilter.pending:
        return s.pending;
      case ChoreFilter.done:
        return s.done;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final doneCount = _chores.where((chore) => chore.isDone).length;
    final pendingCount = _chores.where((chore) => !chore.isDone).length;
    final theme = Theme.of(context);
    final isDark = widget.isDarkMode;
    final visibleChores = _filteredChores();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          s.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: s.language,
            onPressed: () {
              widget.onToggleLanguage();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                final updated = AppStrings.of(context);
                _showMessage(
                  updated.isArabic
                      ? updated.languageChangedArabic
                      : updated.languageChangedEnglish,
                );
              });
            },
            icon: const Icon(Icons.language_rounded),
          ),
          IconButton(
            tooltip: isDark ? s.switchToLight : s.switchToDark,
            onPressed: widget.onToggleTheme,
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
          ),
          IconButton(
            tooltip: s.logout,
            onPressed: _confirmLogout,
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddChoreScreen,
        icon: const Icon(Icons.add),
        label: Text(s.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.stayOrganized,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                s.homeSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.65),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: s.pending,
                      value: pendingCount.toString(),
                      icon: Icons.access_time_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: s.done,
                      value: doneCount.toString(),
                      icon: Icons.check_circle_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim();
                  });
                },
                textAlign: s.isArabic ? TextAlign.right : TextAlign.left,
                decoration: InputDecoration(
                  hintText: s.searchHint,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchQuery.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ChoreFilter.values.map((filter) {
                    final isSelected = _selectedFilter == filter;

                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(_filterLabel(filter)),
                        onSelected: (_) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        selectedColor: Colors.indigo.withOpacity(0.18),
                        checkmarkColor: Colors.indigo,
                        side: BorderSide(
                          color: isSelected
                              ? Colors.indigo.withOpacity(0.30)
                              : theme.colorScheme.onSurface.withOpacity(0.10),
                        ),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.indigo
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                s.todayChores,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _isLoadingChores
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : visibleChores.isEmpty
                        ? EmptyStateCard(
                            title: _emptyTitle(),
                            subtitle: _emptySubtitle(),
                            onAddPressed: _openAddChoreScreen,
                            showAddButton: _selectedFilter == ChoreFilter.all &&
                                _searchQuery.isEmpty,
                          )
                        : ListView.separated(
                            itemCount: visibleChores.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final chore = visibleChores[index];
                              final isExpired = _isExpired(chore);

                              return GestureDetector(
                                onTap: () => _openEditChoreScreen(chore),
                                onLongPress: () => _confirmDeleteChore(chore),
                                child: ChoreCard(
                                  chore: chore,
                                  timeLabel: chore.isDone
                                      ? s.done
                                      : s.formatTimeLeft(chore.expiresAt),
                                  expiryLabel: s.expiresLabel(
                                    s.formatDateTime(chore.expiresAt),
                                  ),
                                  isExpired: isExpired,
                                  onToggleDone: () => _markChoreAsDone(chore),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.colorScheme.surface;
    final shadowColor = theme.brightness == Brightness.dark
        ? Colors.black.withOpacity(0.18)
        : Colors.black.withOpacity(0.05);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.indigo.withOpacity(0.10),
            child: Icon(icon, color: Colors.indigo),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.65),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChoreCard extends StatelessWidget {
  final Chore chore;
  final String timeLabel;
  final String expiryLabel;
  final bool isExpired;
  final VoidCallback onToggleDone;

  const ChoreCard({
    super.key,
    required this.chore,
    required this.timeLabel,
    required this.expiryLabel,
    required this.isExpired,
    required this.onToggleDone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final s = AppStrings.of(context);

    final baseCardColor = chore.isDone
        ? Colors.green.withOpacity(isDark ? 0.16 : 0.08)
        : theme.colorScheme.surface;

    final borderColor = chore.isDone
        ? Colors.green.withOpacity(0.20)
        : isExpired
            ? Colors.red.withOpacity(0.20)
            : theme.colorScheme.onSurface.withOpacity(0.08);

    final shadowColor = isDark
        ? Colors.black.withOpacity(0.18)
        : Colors.black.withOpacity(0.05);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: baseCardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: chore.isDone
                  ? Colors.green.withOpacity(0.15)
                  : isExpired
                      ? Colors.red.withOpacity(0.12)
                      : Colors.indigo.withOpacity(0.10),
            ),
            child: Icon(
              chore.isDone
                  ? Icons.check
                  : isExpired
                      ? Icons.timer_off_rounded
                      : Icons.schedule,
              color: chore.isDone
                  ? Colors.green
                  : isExpired
                      ? Colors.red
                      : Colors.indigo,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chore.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    decoration:
                        chore.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  chore.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.68),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  expiryLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.55),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: chore.isDone
                        ? Colors.green.withOpacity(0.12)
                        : isExpired
                            ? Colors.red.withOpacity(0.12)
                            : Colors.orange.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    timeLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: chore.isDone
                          ? Colors.green
                          : isExpired
                              ? Colors.red
                              : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: chore.isDone || isExpired ? null : onToggleDone,
            tooltip: s.done,
            style: IconButton.styleFrom(
              backgroundColor: chore.isDone
                  ? Colors.green.withOpacity(0.14)
                  : isExpired
                      ? Colors.grey.withOpacity(0.14)
                      : Colors.indigo.withOpacity(0.10),
            ),
            icon: Icon(
              chore.isDone
                  ? Icons.check_circle
                  : isExpired
                      ? Icons.block_rounded
                      : Icons.radio_button_unchecked,
              color: chore.isDone
                  ? Colors.green
                  : isExpired
                      ? Colors.grey
                      : Colors.indigo,
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onAddPressed;
  final bool showAddButton;

  const EmptyStateCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onAddPressed,
    required this.showAddButton,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);
    final shadowColor = theme.brightness == Brightness.dark
        ? Colors.black.withOpacity(0.18)
        : Colors.black.withOpacity(0.05);

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.indigo.withOpacity(0.10),
              child: const Icon(
                Icons.task_alt_rounded,
                color: Colors.indigo,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.65),
                height: 1.4,
              ),
            ),
            if (showAddButton) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onAddPressed,
                icon: const Icon(Icons.add),
                label: Text(s.addChore),
              ),
            ],
          ],
        ),
      ),
    );
  }
}