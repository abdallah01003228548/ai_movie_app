import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Story line text with expandable "More" / "Less" toggle.
///
/// Expansion is a purely local UI state — no cubit involved.
class StoryLineText extends StatefulWidget {
  final String text;

  const StoryLineText({super.key, required this.text});

  @override
  State<StoryLineText> createState() => _StoryLineTextState();
}

class _StoryLineTextState extends State<StoryLineText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Story Line',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.text,
            maxLines: _expanded ? null : 4,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 13,
              fontFamily: 'Montserrat',
              height: 1.6,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Less' : 'More',
              style: const TextStyle(
                color: AppColors.activeColorIndicator,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
