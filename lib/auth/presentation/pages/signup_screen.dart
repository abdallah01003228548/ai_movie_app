import 'package:ai_movie_app/auth/presentation/widgets/custom_botton.dart';
import 'package:ai_movie_app/auth/presentation/widgets/custom_text_field.dart';
import 'package:ai_movie_app/core/routes/app_routes.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/auth/presentation/cubit/auth_cubit.dart';
import 'package:ai_movie_app/auth/presentation/cubit/auth_state.dart';
import 'package:ai_movie_app/core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  void _signUp(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final fullName = fullNameController.text.trim();

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    if (valueOfCheckBox != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please agree to the Terms and Privacy Policy.')),
      );
      return;
    }

    context.read<AuthCubit>().signUp(email, password, fullName);
  }

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
      body: BlocProvider(
        create: (_) => getIt<AuthCubit>(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.appSectionScreen,
                (route) => false,
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final isLoadingState = state is AuthLoading;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Let\'s get started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 6),

                    const Text(
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

                    isLoadingState
                        ? const CircularProgressIndicator(
                            color: AppColors.activeColorIndicator,
                          )
                        : CustomButton(text: 'SignUp', onTap: () => _signUp(context)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
