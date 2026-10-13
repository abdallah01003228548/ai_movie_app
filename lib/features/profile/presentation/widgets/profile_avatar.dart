import 'dart:typed_data';

import 'package:ai_movie_app/core/di/service_locator.dart';
import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/features/profile/data/repositories/profile_repository.dart';

import 'package:flutter/material.dart';

/// Reusable circular avatar that renders the user's profile photo.
///
/// ## Data source
/// By default, the widget opens a [StreamBuilder] on
/// [ProfileRepository.watchProfilePhoto] resolved from GetIt.  The stream uses
/// `.distinct()` so only `photoBase64` changes cause a rebuild — unrelated
/// profile writes (e.g. toggling notifications) are silently ignored.
///
/// ## Override for unsaved previews
/// Pass [overrideBytes] to show a picked-but-not-yet-saved photo on the Edit
/// Profile screen. When set, the stream is NOT opened (the caller controls the
/// bytes lifecycle).
///
/// ## Edit badge
/// Pass [onEditTap] to show a small teal pencil badge at the bottom-right of
/// the circle.
///
/// ## Size
/// [radius] defaults to 44 — callers pass an explicit value when needed (e.g.
/// Home header uses 22, Edit Profile uses 44). This is the only size token;
/// the widget contains no other hardcoded layout dimensions.
///
/// The widget contains NO base64, Firebase, or picker logic.
class ProfileAvatar extends StatelessWidget {
  /// Circle radius. Defaults to 44 (diameter 88 px).
  final double radius;

  /// When provided, this image is shown instead of the Firestore stream.
  /// Use this on Edit Profile for the unsaved local preview.
  final Uint8List? overrideBytes;

  /// When provided, a teal pencil badge is shown and tapping it calls this.
  final VoidCallback? onEditTap;

  const ProfileAvatar({
    super.key,
    this.radius = 44,
    this.overrideBytes,
    this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    // When caller provides a preview (unsaved), skip the stream entirely.
    if (overrideBytes != null) {
      return _buildStack(context, overrideBytes);
    }

    // Otherwise, listen to the live photo stream from the repository.
    return StreamBuilder<Uint8List?>(
      stream: getIt<ProfileRepository>().watchProfilePhoto(),
      builder: (context, snapshot) {
        return _buildStack(context, snapshot.data);
      },
    );
  }

  Widget _buildStack(BuildContext context, Uint8List? bytes) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildCircle(bytes),
        if (onEditTap != null) _buildBadge(context),
      ],
    );
  }

  Widget _buildCircle(Uint8List? bytes) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF252836),
        border: Border.all(
          color: AppColors.activeColorIndicator.withAlpha(100),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: bytes != null
            ? Image.memory(
                bytes,
                fit: BoxFit.cover,
                gaplessPlayback: true, // Prevents flicker on updates
                width: radius * 2,
                height: radius * 2,
              )
            : Icon(
                Icons.person,
                color: AppColors.activeColorIndicator,
                size: radius * 0.7,
              ),
      ),
    );
  }

  /// Small teal pencil badge positioned at bottom-right of the avatar.
  Widget _buildBadge(BuildContext context) {
    // Badge size scales with the avatar so it looks proportional
    final badgeSize = (radius * 0.55).clamp(20.0, 32.0);
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: onEditTap,
        child: Container(
          width: badgeSize,
          height: badgeSize,
          decoration: BoxDecoration(
            color: AppColors.activeColorIndicator,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF1F1D2B), width: 2),
          ),
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: badgeSize * 0.55,
          ),
        ),
      ),
    );
  }
}
