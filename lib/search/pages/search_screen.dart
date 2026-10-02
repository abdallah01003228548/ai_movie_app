import 'dart:async';

import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/home/data/models/genre_model.dart';
import 'package:ai_movie_app/home/data/services/tmdb_service.dart';
import 'package:ai_movie_app/search/presentation/cubit/actor_credits_cubit.dart';
import 'package:ai_movie_app/search/presentation/cubit/search_multi_cubit.dart';
import 'package:ai_movie_app/search/presentation/widgets/actor_row.dart';
import 'package:ai_movie_app/search/presentation/widgets/movie_result_card.dart';
import 'package:ai_movie_app/search/presentation/widgets/search_blank_view.dart';
import 'package:ai_movie_app/search/presentation/widgets/search_idle_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SearchMultiCubit(TmdbService())),
        BlocProvider(create: (_) => ActorCreditsCubit(TmdbService())),
      ],
      child: const _SearchScreenContent(),
    );
  }
}

class _SearchScreenContent extends StatefulWidget {
  const _SearchScreenContent();

  @override
  State<_SearchScreenContent> createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<_SearchScreenContent> {
  final TmdbService _tmdbService = TmdbService();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Timer? _debounce;
  String _query = '';

  List<GenreModel> _genres = [];

  @override
  void initState() {
    super.initState();
    _loadGenres();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadGenres() async {
    try {
      final genres = await _tmdbService.genres();
      if (mounted) setState(() => _genres = genres);
    } catch (_) {
      // Best effort
    }
  }

  void _onTextChanged() {
    final text = _controller.text.trim();
    if (text == _query) return;

    _debounce?.cancel();

    if (text.isEmpty) {
      setState(() {
        _query = '';
      });
      context.read<SearchMultiCubit>().clear();
      return;
    }

    setState(() {
      _query = text;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchMultiCubit>().search(text);
    });
  }

  void _cancel() {
    _controller.clear();
    _focusNode.unfocus();
  }

  String _genreName(List<int> genreIds) {
    if (genreIds.isEmpty || _genres.isEmpty) return '';
    for (final g in _genres) {
      if (g.id == genreIds[0]) return g.name;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xff252836),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(Icons.search, color: AppColors.textColor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search movies, series, actors…',
                        hintStyle: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _focusNode.unfocus(),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                      onTap: _cancel,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(Icons.close, color: AppColors.textColor, size: 18),
                      ),
                    )
                  else
                    const SizedBox(width: 12),
                ],
              ),
            ),
          ),
          if (_query.isNotEmpty) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _cancel,
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.activeColorIndicator,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_query.isEmpty) {
      return const SearchIdleView();
    }

    return BlocBuilder<SearchMultiCubit, SearchMultiState>(
      builder: (context, state) {
        return switch (state) {
          SearchMultiInitial() || SearchMultiLoading() => const Center(
              child: CircularProgressIndicator(
                color: AppColors.activeColorIndicator,
              ),
            ),
          SearchMultiError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.read<SearchMultiCubit>().search(_query),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        color: AppColors.activeColorIndicator,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          SearchMultiLoaded(:final result) => result.movies.isEmpty && result.people.isEmpty
              ? SearchBlankView(query: _query)
              : Stack(
                  children: [
                    ListView(
                      children: [
                        const SizedBox(height: 16),
                        if (result.hasPeople) ...[
                          ActorRow(people: result.people),
                          const SizedBox(height: 16),
                          const Divider(color: Color(0xff252836), thickness: 1),
                        ],
                        if (result.hasMovies) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                            child: Text(
                              'Results for "$_query"',
                              style: const TextStyle(
                                color: AppColors.textColor,
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                          ...result.movies.map(
                            (movie) => MovieResultCard(
                              movie: movie,
                              genreName: _genreName(movie.genreIds),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ],
                ),
        };
      },
    );
  }
}