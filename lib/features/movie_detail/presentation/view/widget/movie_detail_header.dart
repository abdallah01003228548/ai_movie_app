import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/features/favorite/presentation/view/widget/favorite_heart_icon.dart';
import 'package:ai_movie_app/features/home/data/models/movie_model.dart';
import 'package:ai_movie_app/features/movie_detail/domain/entities/movie_detail_entity.dart';
import 'package:ai_movie_app/features/movie_detail/presentation/view/widget/share_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Header widget for the Movie Detail screen.
///
/// Displays poster, title, meta-info row (year, runtime, genre, rating),
/// certification badge, action buttons (Play, Download, External Link),
/// and app bar icons (Share, Heart).
class MovieDetailHeader extends StatelessWidget {
  final MovieDetailEntity data;

  const MovieDetailHeader({super.key, required this.data});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openShare(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => ShareBottomSheet(
        title: data.title,
        id: data.id,
        mediaType: data.mediaType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final posterHeight = screenWidth * 0.75;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Poster with overlay icons ──────────────────────────────────────
        Stack(
          children: [
            // Poster image
            Container(
              width: double.infinity,
              height: posterHeight,
              color: const Color(0xff252836),
              child: data.posterUrl != null
                  ? Image.network(
                      data.posterUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => _posterPlaceholder(),
                    )
                  : _posterPlaceholder(),
            ),

            // Top gradient overlay so status bar / icons are always readable
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 100,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withAlpha(180),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // App bar icons (Back, Title, Heart + Share)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    // Back button
                    _circleButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    // Screen title
                    const Expanded(
                      child: Text(
                        'Detail Movie',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Heart icon (synced with FavoriteCubit)
                    FavoriteHeartIcon(
                      movie: MovieModel(
                        id: data.id,
                        title: data.title,
                        posterPath: data.posterPath,
                        voteAverage: data.voteAverage,
                        releaseDate: data.releaseDate,
                        genreIds: const [],
                        mediaType: data.mediaType,
                      ),
                      iconSize: 20,
                    ),
                    const SizedBox(width: 8),
                    // Share button
                    _circleButton(
                      icon: Icons.share_rounded,
                      onTap: () => _openShare(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── Content section ────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                data.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),

              // Meta row: Year • Runtime • Genre (with certification badge)
              _buildMetaRow(),

              const SizedBox(height: 10),

              // Rating row: stars + number
              _buildRatingRow(),

              const SizedBox(height: 20),

              // Action buttons row: Play, Download, External Link
              _buildActionButtons(context),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetaRow() {
    final parts = <Widget>[];

    if (data.year.isNotEmpty) {
      parts.add(_metaText(data.year));
    }

    if (data.runtimeLabel.isNotEmpty) {
      if (parts.isNotEmpty) parts.add(_metaDot());
      parts.add(_metaText(data.runtimeLabel));
    }

    if (data.genres.isNotEmpty) {
      if (parts.isNotEmpty) parts.add(_metaDot());
      parts.add(_metaText(data.genres.first));
    }

    if (data.certification != null && data.certification!.isNotEmpty) {
      if (parts.isNotEmpty) parts.add(const SizedBox(width: 8));
      parts.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.textColor.withAlpha(120)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            data.certification!,
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: parts,
    );
  }

  Widget _buildRatingRow() {
    final stars = data.stars; // 0..5
    return Row(
      children: [
        ...List.generate(5, (index) {
          final starValue = index + 1;
          if (stars >= starValue) {
            return const Icon(Icons.star_rounded, color: Color(0xFFFF8700), size: 18);
          } else if (stars >= starValue - 0.5) {
            return const Icon(Icons.star_half_rounded, color: Color(0xFFFF8700), size: 18);
          } else {
            return const Icon(Icons.star_outline_rounded, color: Color(0xFFFF8700), size: 18);
          }
        }),
        const SizedBox(width: 8),
        Text(
          data.voteAverage.toStringAsFixed(1),
          style: const TextStyle(
            color: Color(0xFFFF8700),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final hasTrailer = data.trailerKey != null;

    return Row(
      children: [
        // Play / Trailer button (Orange)
        Expanded(
          child: ElevatedButton.icon(
            onPressed: hasTrailer
                ? () => _launchUrl('https://www.youtube.com/watch?v=${data.trailerKey}')
                : null,
            icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 22),
            label: Text(
              hasTrailer ? 'Play' : 'No Trailer',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8700),
              disabledBackgroundColor: const Color(0xff252836),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // TMDB link icon button
        _circleIconButton(
          icon: Icons.open_in_new_rounded,
          color: const Color(0xff252836),
          iconColor: AppColors.activeColorIndicator,
          onTap: () => _launchUrl(data.tmdbUrl),
        ),
        const SizedBox(width: 10),

        // Download placeholder button (disabled/coming soon)
        _circleIconButton(
          icon: Icons.file_download_outlined,
          color: const Color(0xff252836),
          iconColor: AppColors.textColor,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Download feature is coming soon',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _metaText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textColor,
        fontSize: 12,
        fontFamily: 'Montserrat',
      ),
    );
  }

  Widget _metaDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '•',
        style: TextStyle(color: AppColors.textColor, fontSize: 12),
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xff252836).withAlpha(180),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }

  Widget _posterPlaceholder() {
    return const Center(
      child: Icon(
        Icons.movie_outlined,
        color: AppColors.textColor,
        size: 64,
      ),
    );
  }
}
