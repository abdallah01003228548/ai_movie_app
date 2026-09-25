import 'package:ai_movie_app/auth/presentation/widgets/custom_botton.dart';
import 'package:ai_movie_app/auth/presentation/widgets/custom_text_field.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
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
                'Reset Password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 6),

              Text(
                'Recover your account password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ),

              const SizedBox(height: 28),

              CustomTextField(
                label: 'Password',

                controller: passwordController,
              ),
              SizedBox(height: 20),
              CustomTextField(
                label: 'Confirm Password',

                controller: confirmPasswordController,
              ),

              const SizedBox(height: 40),

              CustomButton(text: 'Rest', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
