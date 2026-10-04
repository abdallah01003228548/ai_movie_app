import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/movie_detail/data/models/movie_detail_model.dart';
import 'package:flutter/material.dart';

/// Cast and Crew horizontal scrolling list for the Movie Detail screen.
class CastCrewList extends StatelessWidget {
  final List<CastMember> cast;

  const CastCrewList({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Cast & Crew',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: cast.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final member = cast[index];
              return _CastCard(member: member);
            },
          ),
        ),
      ],
    );
  }
}

class _CastCard extends StatelessWidget {
  final CastMember member;

  const _CastCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xff252836),
            backgroundImage:
                member.profileUrl != null ? NetworkImage(member.profileUrl!) : null,
            child: member.profileUrl == null
                ? const Icon(Icons.person, color: AppColors.textColor, size: 28)
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            member.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
