import 'package:ai_movie_app/core/constant/assets_constant.dart';

class OnboardingData {
  final String image;
  final String title;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<OnboardingData> onboardingData() {
  return [
    OnboardingData(
      image: AssetsConstant.onboarding,
      title: 'Lorem ipsum dolor sit amet consecteur esplicit',
      description:
          'Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient.',
    ),
    OnboardingData(
      image: AssetsConstant.onboarding1,
      title: 'Lorem ipsum dolor sit amet consecteur esplicit',
      description:
          'Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient.',
    ),
    OnboardingData(
      image: AssetsConstant.onboarding2,
      title: 'Lorem ipsum dolor sit amet consecteur esplicit',
      description:
          'Semper in cursus magna et eu varius nunc adipiscing. Elementum justo, laoreet id sem semper parturient.',
    ),
  ];
}
