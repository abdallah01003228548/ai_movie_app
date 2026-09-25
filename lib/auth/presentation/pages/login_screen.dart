import 'package:ai_movie_app/auth/presentation/widgets/custom_botton.dart';
import 'package:ai_movie_app/auth/presentation/widgets/custom_text_field.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),

        title: const Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              Text(
                'Hi, Tiffany',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 6),

              Text(
                'Welcome back! Please enter \nyour details.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ),

              const SizedBox(height: 28),

              CustomTextField(
                label: 'Email Address',

                controller: emailController,
              ),

              const SizedBox(height: 16),

              CustomTextField(
                label: 'Password',

                controller: passwordController,
                suffixIcon: Icons.visibility_off,
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.activeColorIndicator,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              
              CustomButton(
                text: 'Login',
                onTap: () {
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
