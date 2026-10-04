import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/movie_detail/data/models/movie_detail_model.dart';
import 'package:ai_movie_app/movie_detail/presentation/widgets/share_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Header widget for the Movie Detail screen.
///
/// Displays poster, title, meta-info row (year, runtime, genre, rating),
/// certification badge, action buttons (Play, Download, External Link),
/// and app bar icons (Share, Heart).
class MovieDetailHeader extends StatelessWidget {
  final MovieDetailModel data;

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
            // Gradient overlay (bottom fade)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.55, 1.0],
                    colors: [
                      Colors.transparent,
                      AppColors.primaryColor,
                    ],
                  ),
                ),
              ),
            ),
            // Back button (top-left)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(120),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                ),
              ),
            ),
            // Share + Heart (top-right)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              right: 16,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _openShare(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(120),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.share_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(120),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.favorite, color: Color(0xFFFF4D6D), size: 18),
                  ),
                ],
              ),
            ),
          ],
        ),

        // ── Title ────────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              fontFamily: 'Montserrat',
            ),
          ),
        ),

        const SizedBox(height: 10),

        // ── Meta row: year | runtime | genre | rating ────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              if (data.year.isNotEmpty) _MetaChip(icon: Icons.calendar_today_outlined, label: data.year),
              if (data.runtimeLabel.isNotEmpty) _MetaChip(icon: Icons.access_time, label: data.runtimeLabel),
              if (data.genres.isNotEmpty) _MetaChip(icon: Icons.local_movies_outlined, label: data.genres[0].name),
              _MetaChip(
                icon: Icons.star_rounded,
                label: data.stars.toStringAsFixed(1),
                iconColor: const Color(0xffFFC107),
              ),
              if (data.certification != null && data.certification!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.textColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    data.certification!,
                    style: const TextStyle(
                      color: AppColors.textColor,
                      fontSize: 11,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // ── Action buttons: Play | Download | External link ──────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // Play button — real: opens YouTube trailer
              if (data.trailerKey != null) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _launchUrl(
                      'https://www.youtube.com/watch?v=${data.trailerKey}',
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                    label: const Text(
                      'Play',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.activeColorIndicator,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              // Download icon — UI only
              _CircleActionButton(
                icon: Icons.download_rounded,
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Download coming soon')),
                ),
              ),
              const SizedBox(width: 10),
              // External link — opens TMDB page
              _CircleActionButton(
                icon: Icons.open_in_new_rounded,
                onTap: () => _launchUrl(data.tmdbUrl),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _posterPlaceholder() {
    return Container(
      color: const Color(0xff252836),
      child: const Center(
        child: Icon(Icons.movie_creation_outlined, color: AppColors.textColor, size: 64),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _MetaChip({required this.icon, required this.label, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor ?? AppColors.textColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textColor,
            fontSize: 12,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xff252836),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
