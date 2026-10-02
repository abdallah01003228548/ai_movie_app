import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/home/data/models/genre_model.dart';
import 'package:ai_movie_app/home/presentation/cubit/category_chips_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Part 4 — "Categories" horizontal chip row.
///
/// Fetches genres ONCE via [CategoryChipsCubit] and prepends a synthetic
/// "All" chip (id: -1). Selecting a chip calls [onGenreSelected] which
/// triggers Part 5's data reload. This section never refetches on chip tap.
class CategoryChips extends StatefulWidget {
  /// Called when a genre chip is tapped.
  /// Passes `null` for "All", otherwise the selected genre's id.
  final ValueChanged<int?> onGenreSelected;

  const CategoryChips({super.key, required this.onGenreSelected});

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  int _selectedId = -1; // -1 means "All"

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Categories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<CategoryChipsCubit, CategoryChipsState>(
          builder: (context, state) {
            return switch (state) {
              CategoryChipsInitial() || CategoryChipsLoading() => const SizedBox(
                  height: 40,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.activeColorIndicator,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              CategoryChipsError() => SizedBox(
                  height: 40,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Could not load categories',
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => context.read<CategoryChipsCubit>().fetchGenres(),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              color: AppColors.activeColorIndicator,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              CategoryChipsLoaded(:final genres) => () {
                  final allGenres = [
                    const GenreModel(id: -1, name: 'All'),
                    ...genres,
                  ];

                  return SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: allGenres.length,
                      separatorBuilder: (context, i) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final genre = allGenres[index];
                        final isSelected = genre.id == _selectedId;

                        return GestureDetector(
                          onTap: () {
                            if (genre.id == _selectedId) return;
                            setState(() {
                              _selectedId = genre.id;
                            });
                            widget.onGenreSelected(
                              genre.id == -1 ? null : genre.id,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.activeColorIndicator
                                  : const Color(0xff252836),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                genre.name,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.textColor,
                                  fontSize: 13,
                                  fontWeight:
                                      isSelected ? FontWeight.w600 : FontWeight.w400,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }(),
            };
          },
        ),
      ],
    );
  }
}
