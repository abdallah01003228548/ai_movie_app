import 'package:ai_movie_app/auth/presentation/widgets/custom_botton.dart';
import 'package:ai_movie_app/auth/presentation/widgets/custom_text_field.dart';
import 'package:ai_movie_app/core/routes/app_routes.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/auth/presentation/cubit/auth_cubit.dart';
import 'package:ai_movie_app/auth/presentation/cubit/auth_state.dart';
import 'package:ai_movie_app/core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password.')),
      );
      return;
    }

    context.read<AuthCubit>().login(email, password);
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
                      'Hi, Tiffany',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    const SizedBox(height: 6),

                    const Text(
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
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.resetPasswordScreen);
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: const Text(
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

                    isLoadingState
                        ? const CircularProgressIndicator(
                            color: AppColors.activeColorIndicator,
                          )
                        : CustomButton(
                            text: 'Login',
                            onTap: () => _login(context),
                          ),
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
