import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/components/custom_text_field.dart';
import 'package:mobile_app/components/snackbars.dart';
import 'package:mobile_app/getX/auth/auth_controller.dart';
import 'package:mobile_app/pages/auth/register_page.dart';
import 'package:mobile_app/pages/home/home_screen.dart';
import 'package:mobile_app/shared/theme/app_color.dart';
import 'package:mobile_app/shared/utils/constants/asset_paths.dart';

import 'components/bottom_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  final AuthController controller = Get.find<AuthController>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await controller.login(
        _emailController.text,
        _passwordController.text,
      );
      if (success) {
        Get.offAll(() => HomeScreen());
        snackbar.getSuccessSnackBar("Login Successful!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        return Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(loginVector),
                      const SizedBox(height: 40),
                      CustomTextFormField(
                        controller: _emailController,
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppColors.textOnPrimary,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: !_showPassword,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.textOnPrimary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textOnPrimary,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                        validator:
                            (value) =>
                                value == null || value.length < 6
                                    ? 'Password must be at least 6 characters'
                                    : null,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      BottomText(
                        text: "Don't have an Account? ",
                        buttonText: "Register",
                        onPress: () => Get.to(() => RegisterPage()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (controller.loading.value)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
          ],
        );
      }),
    );
  }
}
