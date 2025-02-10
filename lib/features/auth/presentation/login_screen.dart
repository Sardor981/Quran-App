import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quran_app/core/common/utils/app_colors.dart';
import 'package:quran_app/core/common/utils/app_images.dart';
import 'package:quran_app/features/auth/service/auth_service.dart';
import 'package:quran_app/features/home/presentation/widgets/text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLogin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF5F27EC),
                    Color(0xFF0E207F),
                  ],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextWidget(
                      text: _isLogin ? "Kirish" : "Ro'yxatdan O'tish",
                      fontSize: 30.sp,
                    ),
                  ),
                  Divider(thickness: 2, color: AppColors.main_cyan_color),
                  SizedBox(height: 60.h),
                  _buildTextField(_emailController, "Email", Icons.email),
                  SizedBox(height: 20.h),
                  _buildTextField(_passwordController, "Parol", Icons.lock,
                      isPassword: true),
                  SizedBox(height: 30.h),
                  _buildActionButton(context),
                  SizedBox(height: 20.h),
                  _buildSwitchAuthText(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Image.asset(
              AppImages.splash_bottom_img,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        suffixIcon: Icon(icon, color: AppColors.main_cyan_color),
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleAuth(context),
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColors.main_cyan_color,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: TextWidget(
            text: _isLogin ? "Kirish" : "Ro'yxatdan o'tish",
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchAuthText() {
    return RichText(
      text: TextSpan(
        text: _isLogin ? "Hisobingiz yoqmi? " : "Allaqachon hisobingiz bormi? ",
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
        children: [
          TextSpan(
            text: _isLogin ? "Royxatdan o'tish" : "Kirish",
            style: TextStyle(
              color: AppColors.main_cyan_color,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
          ),
        ],
      ),
    );
  }

  Future<void> _handleAuth(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar(context, "Iltimos, barcha maydonlarni to'ldiring!");
      return;
    }

    try {
      if (_isLogin) {
        await _authService.signIn(
            email: email, password: password, context: context);
      } else {
        await _authService.signup(
            email: email, password: password, context: context);
      }
    } catch (e) {
      _showSnackBar(context, "Xatolik: ${e.toString()}");
    }
  }

  void _showSnackBar(BuildContext context, String message,
      {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
