import 'dart:async';

import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/home/presentation/cubit/today_carousel_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TodayCarousel extends StatefulWidget {
  const TodayCarousel({super.key});

  @override
  State<TodayCarousel> createState() => _TodayCarouselState();
}

class _TodayCarouselState extends State<TodayCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_pageController.hasClients) {
        final nextPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    try {
      final date = DateTime.parse(isoDate);
      return 'On ${DateFormat('MMMM d, y').format(date)}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Today',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        const SizedBox(height: 14),
        BlocBuilder<TodayCarouselCubit, TodayCarouselState>(
          builder: (context, state) {
            return switch (state) {
              TodayCarouselInitial() || TodayCarouselLoading() => const SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.activeColorIndicator,
                    ),
                  ),
                ),
              TodayCarouselError(:final message) => SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.isNotEmpty ? message : 'Could not load trending movies',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textColor,
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => context.read<TodayCarouselCubit>().fetchTrending(),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              color: AppColors.activeColorIndicator,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              TodayCarouselLoaded(:final movies) => movies.isEmpty
                  ? const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          'No trending movies today',
                          style: TextStyle(color: AppColors.textColor, fontSize: 13),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: movies.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final movie = movies[index];
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xff252836),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    // Backdrop image
                                    if (movie.backdropUrl != null)
                                      Image.network(
                                        movie.backdropUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, e, s) => Container(
                                          color: const Color(0xff252836),
                                          child: const Icon(
                                            Icons.movie,
                                            color: AppColors.textColor,
                                            size: 48,
                                          ),
                                        ),
                                      )
                                    else
                                      Container(
                                        color: const Color(0xff252836),
                                        child: const Icon(
                                          Icons.movie,
                                          color: AppColors.textColor,
                                          size: 48,
                                        ),
                                      ),
                                    // Gradient overlay
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withAlpha(200),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Title + date
                                    Positioned(
                                      left: 16,
                                      right: 16,
                                      bottom: 16,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            movie.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            _formatDate(movie.releaseDate),
                                            style: TextStyle(
                                              color: Colors.white.withAlpha(180),
                                              fontSize: 12,
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Dot page indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(movies.length, (index) {
                            final isActive = index == _currentPage;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: isActive
                                    ? AppColors.activeColorIndicator
                                    : AppColors.dotColorIndicator,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
            };
          },
        ),
      ],
    );
  }
}
