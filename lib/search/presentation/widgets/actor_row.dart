import 'package:ai_movie_app/core/theme/app_colors.dart';
import 'package:ai_movie_app/home/data/models/person_model.dart';
import 'package:ai_movie_app/search/presentation/cubit/actor_credits_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

/// Part 4 — Actors row that appears above search results when [people] is
/// non-empty. Tapping an actor avatar fetches and shows their filmography
/// in a horizontal "Movie Related" list below.
class ActorRow extends StatefulWidget {
  final List<PersonModel> people;

  const ActorRow({super.key, required this.people});

  @override
  State<ActorRow> createState() => _ActorRowState();
}

class _ActorRowState extends State<ActorRow> {
  PersonModel? _selectedPerson;

  void _onActorTap(PersonModel person) {
    if (_selectedPerson?.id == person.id) {
      // Tap same actor again → collapse
      setState(() {
        _selectedPerson = null;
      });
      context.read<ActorCreditsCubit>().clear();
      return;
    }
    setState(() {
      _selectedPerson = person;
    });
    context.read<ActorCreditsCubit>().fetchCredits(person.id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── "Actors" header ──
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Actors',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        const SizedBox(height: 12),
        // ── Horizontal avatar list ──
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: widget.people.length,
            separatorBuilder: (context, i) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final person = widget.people[index];
              final isSelected = _selectedPerson?.id == person.id;
              return GestureDetector(
                onTap: () => _onActorTap(person),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.activeColorIndicator
                              : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xff252836),
                        child: ClipOval(
                          child: person.profileUrl != null
                              ? Image.network(
                                  person.profileUrl!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, e, s) =>
                                      _avatarPlaceholder(),
                                )
                              : _avatarPlaceholder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 64,
                      child: Text(
                        person.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 11,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // ── "Movie Related" section (shown when an actor is selected) ──
        if (_selectedPerson != null) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Movie Related · ${_selectedPerson?.name ?? ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to a "See All" screen (not yet implemented)
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: AppColors.activeColorIndicator,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          BlocBuilder<ActorCreditsCubit, ActorCreditsState>(
            builder: (context, state) {
              return switch (state) {
                ActorCreditsInitial() || ActorCreditsLoading() => const SizedBox(
                    height: 140,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.activeColorIndicator,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ActorCreditsError() => const SizedBox(
                    height: 60,
                    child: Center(
                      child: Text(
                        'Could not load filmography',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ActorCreditsLoaded(:final credits) => credits.isEmpty
                    ? const SizedBox(
                        height: 60,
                        child: Center(
                          child: Text(
                            'No credits found',
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: credits.length,
                          separatorBuilder: (context, i) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final credit = credits[index];
                            return SizedBox(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: credit.posterUrl != null
                                          ? Image.network(
                                              credit.posterUrl!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorBuilder: (_, e, s) =>
                                                  _creditPlaceholder(),
                                            )
                                          : _creditPlaceholder(),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    credit.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              };
            },
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: const Color(0xff252836),
      child: const Icon(Icons.person, color: AppColors.textColor, size: 28),
    );
  }

  Widget _creditPlaceholder() {
    return Container(
      color: const Color(0xff252836),
      child: const Center(
        child: Icon(Icons.movie_creation_outlined, color: AppColors.textColor, size: 28),
      ),
    );
  }
}
