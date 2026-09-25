import 'package:ai_movie_app/auth/presentation/widgets/custom_botton.dart';
import 'package:ai_movie_app/auth/presentation/widgets/custom_text_field.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  bool? valueOfCheckBox = false;

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
          'Sign Up',
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
                'Let\'s get started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 6),

              Text(
                'The latest movies and series\nare here.',
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
                label: 'Full Name',

                controller: fullNameController,
              ),

              const SizedBox(height: 20),
              CustomTextField(
                label: 'Email Address',

                controller: emailController,
              ),

              const SizedBox(height: 20),

              CustomTextField(
                label: 'Password',

                controller: passwordController,
                suffixIcon: Icons.visibility_off,
              ),

              const SizedBox(height: 14),
              Row(
                children: [
                  Checkbox(
                    value: valueOfCheckBox,
                    activeColor: Colors.cyan,
                    checkColor: Colors.black,
                    onChanged: (value) {
                      setState(() {
                        valueOfCheckBox = value;
                      });
                    },
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontFamily: 'Montserrat',
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms and Services',
                          style: TextStyle(
                            color: Color(0xFF12CDD9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: '\nand '),
                        TextSpan(
                          text: 'Privacy Policy',
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

              const SizedBox(height: 28),

              CustomButton(text: 'SignUp', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
