import 'package:ai_movie_app/app_section/view_model/app_section_cubit.dart';
import 'package:ai_movie_app/app_section/view_model/app_section_state.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/favorite/presentation/pages/favorite_screen.dart';

import 'package:ai_movie_app/home/home_screen.dart';
import 'package:ai_movie_app/profile/pages/profile_screen.dart';
import 'package:ai_movie_app/search/pages/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSectionScreen extends StatelessWidget {
  const AppSectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppSectionCubit(),
      child: BlocBuilder<AppSectionCubit, AppSectionState>(
        builder: (context, state) {
          final screens = <Widget>[
            HomeScreen(
              onSearchTap: () {
                context.read<AppSectionCubit>().changeIndex(1);
              },
            ),
            const SearchScreen(),
            const FavoriteScreen(),
            const ProfileScreen(),
          ];

          return Scaffold(
            backgroundColor: AppColors.primaryColor,

            body: IndexedStack(index: state.currentIndex, children: screens),

            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              child: BottomNavigationBar(
                backgroundColor: const Color(0xff1F1D2B),
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.grey,
                currentIndex: state.currentIndex,
                type: BottomNavigationBarType.fixed,

                onTap: (value) {
                  context.read<AppSectionCubit>().changeIndex(value);
                },

                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.home),
                    activeIcon: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff25283A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.home, color: Color(0xff00C9E0)),
                          SizedBox(width: 6),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Color(0xff00C9E0),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    label: '',
                  ),

                  BottomNavigationBarItem(
                    icon: const Icon(Icons.search),
                    activeIcon: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff25283A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search, color: Color(0xff00C9E0)),
                          SizedBox(width: 6),
                          Text(
                            'Search',
                            style: TextStyle(
                              color: Color(0xff00C9E0),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    label: '',
                  ),

                  BottomNavigationBarItem(
                    icon: const Icon(Icons.favorite),
                    activeIcon: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff25283A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.favorite, color: Color(0xff00C9E0)),
                          SizedBox(width: 6),
                          Text(
                            'Favorite',
                            style: TextStyle(
                              color: Color(0xff00C9E0),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    label: '',
                  ),

                  BottomNavigationBarItem(
                    icon: const Icon(Icons.person),
                    activeIcon: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff25283A),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person, color: Color(0xff00C9E0)),
                          SizedBox(width: 6),
                          Text(
                            'Profile',
                            style: TextStyle(
                              color: Color(0xff00C9E0),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    label: '',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
