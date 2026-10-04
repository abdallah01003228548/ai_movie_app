import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// A helper class that builds the shareable text/link and calls share_plus.
///
/// Kept here (not in a widget's onTap) to keep UI and logic separated per
/// ARCHITECTURE.md §4.
class ShareHelper {
  static String buildShareText(String title, int id, String mediaType) {
    final link = 'https://www.themoviedb.org/$mediaType/$id';
    return 'Check out $title on ai_movie_app: $link';
  }

  static Future<void> share(String title, int id, String mediaType) async {
    final text = buildShareText(title, id, mediaType);
    await Share.share(text);
  }
}

/// Modal bottom sheet matching the Share Figma frame.
///
/// Show via:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   builder: (_) => ShareBottomSheet(title: ..., id: ..., mediaType: ...),
/// );
/// ```
class ShareBottomSheet extends StatelessWidget {
  final String title;
  final int id;
  final String mediaType;

  const ShareBottomSheet({
    super.key,
    required this.title,
    required this.id,
    required this.mediaType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff252836),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textColor.withAlpha(100),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Title row with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Share to',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xff1F1D2B),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Icon buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ShareIconButton(
                icon: Icons.facebook_rounded,
                label: 'Facebook',
                color: const Color(0xFF1877F2),
                onTap: () => ShareHelper.share(title, id, mediaType),
              ),
              _ShareIconButton(
                icon: Icons.camera_alt_rounded,
                label: 'Instagram',
                color: const Color(0xFFE4405F),
                onTap: () => ShareHelper.share(title, id, mediaType),
              ),
              _ShareIconButton(
                icon: Icons.message_rounded,
                label: 'Message',
                color: const Color(0xFF34B7F1),
                onTap: () => ShareHelper.share(title, id, mediaType),
              ),
              _ShareIconButton(
                icon: Icons.send_rounded,
                label: 'Telegram',
                color: const Color(0xFF2CA5E0),
                onTap: () => ShareHelper.share(title, id, mediaType),
              ),
            ],
          ),
          const SizedBox(height: 28),
          // Bottom share button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => ShareHelper.share(title, id, mediaType),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.activeColorIndicator,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: const Text(
                'Share Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ShareIconButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: color.withAlpha(80), width: 1),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 11,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
