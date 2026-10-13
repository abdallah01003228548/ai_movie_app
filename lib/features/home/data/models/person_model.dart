/// Represents a person (actor/director) entry from the TMDB search/multi
/// or combined_credits API responses.
class PersonModel {
  final int id;
  final String name;
  final String? profilePath;

  const PersonModel({
    required this.id,
    required this.name,
    this.profilePath,
  });

  /// Full URL for the profile/avatar image, or null if not available.
  String? get profileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w500$profilePath' : null;

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? '',
      profilePath: json['profile_path'] as String?,
    );
  }
}
