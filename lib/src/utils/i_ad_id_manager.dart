abstract class IAdIdManager {
  const IAdIdManager();

  AppAdIds? get unityAdIds;
  AppAdIds? get admobAdIds;
  AppAdIds? get fbAdIds;
  AppAdIds? get appLovinAdIds;
}

class AppAdIds {
  final String appId;

  final String? interstitialId;
  final String? rewardedId;
  final String? bannerId;

  const AppAdIds({
    required this.appId,
    this.interstitialId,
    this.rewardedId,
    this.bannerId,
  });
}
