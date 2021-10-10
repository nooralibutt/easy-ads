abstract class IAdIdManager {
  const IAdIdManager();

  /// pass null if you wish to not to implementing unity ads
  ///
  /// AppAdIds? get unityAdIds => null;
  AppAdIds? get unityAdIds;

  /// pass null if you wish to not to implementing admob ads
  ///
  /// AppAdIds? get admobAdIds => null;
  AppAdIds? get admobAdIds;

  /// pass null if you wish to not to implementing facebook ads
  ///
  /// AppAdIds? get fbAdIds => null;
  AppAdIds? get fbAdIds;

  /// pass null if you wish to not to implementing appLovin ads
  ///
  /// AppAdIds? get appLovinAdIds => null;
  AppAdIds? get appLovinAdIds;
}

class AppAdIds {
  /// App Id should never be null, if there is no app id for a particular ad network, leave it empty
  final String appId;

  /// if id is null then it will not be implemented
  final String? interstitialId;

  /// if id is null then it will not be implemented
  final String? rewardedId;

  /// if id is null then it will not be implemented
  final String? bannerId;

  const AppAdIds({
    required this.appId,
    this.interstitialId,
    this.rewardedId,
    this.bannerId,
  });
}
