abstract class IAdIdManager {
  const IAdIdManager();

  String get unityGameId;
  String get unityInterstitialId;
  String get unityRewardedId;
  String get unityBannerId;

  String get admobInterstitialId;
  String get admobRewardedId;
  String get admobBannerId;

  String get appLovinInterstitialId;
  String get appLovinRewardedId;
  String get appLovinBannerId;

  String get fbInterstitialId;
  String get fbRewardedId;
  String get fbBannerId;
}
