import 'dart:async';

import 'package:ai_movie_app/core/constant/assets_constant.dart';
import 'package:flutter/material.dart';

class MovieCarousel extends StatefulWidget {
  const MovieCarousel({super.key});

  @override
  State<MovieCarousel> createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
  final List<String> _images = [
    AssetsConstant.onboarding1,
    AssetsConstant.carousel,
    AssetsConstant.carousel1,
  ];

  late final PageController _controller;
  Timer? _timer;

  final int _initialPage = 1000;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = _initialPage;
    _controller = PageController(
      initialPage: _initialPage,
      viewportFraction: 0.65,
    );
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _currentPage++;
      if (_controller.hasClients) {
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: PageView.builder(
        controller: _controller,
        onPageChanged: (index) => _currentPage = index,
        itemBuilder: (context, index) {
          final imageIndex = index % _images.length;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double scale = 1.0;
              double opacity = 1.0;

              if (_controller.position.haveDimensions) {
                final page = _controller.page ?? _initialPage.toDouble();
                final diff = (page - index).abs();
                scale = (1 - (diff * 0.25)).clamp(0.75, 1.0);
                opacity = (1 - (diff * 0.5)).clamp(0.5, 1.0);
              }

              return Center(
                child: Opacity(
                  opacity: opacity,
                  child: Transform.scale(scale: scale, child: child),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24), // حواف بسيطة بدل الدائرة الكاملة
                child: Image.asset(
                  _images[imageIndex],
                  fit: BoxFit.cover,
                  height: 400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}