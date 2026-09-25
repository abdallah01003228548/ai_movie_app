import 'package:ai_movie_app/auth/presentation/widgets/custom_botton.dart';
import 'package:ai_movie_app/auth/presentation/widgets/otp_input_field.dart';

import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class VerifyYorAccountScreen extends StatefulWidget {
  const VerifyYorAccountScreen({super.key});

  @override
  State<VerifyYorAccountScreen> createState() => _VerifyYorAccountScreenState();
}

class _VerifyYorAccountScreenState extends State<VerifyYorAccountScreen> {
  final TextEditingController emailController = TextEditingController();

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
                'Verifying Your Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    height: 1.6,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'We have just sent you 4 digit code via your email ',
                    ),
                    TextSpan(
                      text: 'example@gmail.com',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              OtpInputField(),
              const SizedBox(height: 40),

              CustomButton(text: 'continue', onTap: () {}),
              const SizedBox(height: 40),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontFamily: 'Montserrat',
                  ),
                  children: [
                    TextSpan(text: "Didn't receive code? "),
                    TextSpan(
                      text: 'Resend',
                      style: TextStyle(
                        color: Color(0xFF12CDD9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
