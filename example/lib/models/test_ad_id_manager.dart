import 'dart:io';

import 'package:ads/models/i_ad_id_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class TestAdIdManager extends IAdIdManager {
  const TestAdIdManager();

  @override
  String get unityGameId => Platform.isAndroid ? '4374881' : '4374880';

  @override
  String get unityInterstitialId =>
      Platform.isAndroid ? 'Interstitial_Android' : 'Interstitial_iOS';

  @override
  String get unityRewardedId =>
      Platform.isAndroid ? 'Rewarded_Android' : 'Rewarded_iOS';

  @override
  String get unityBannerId =>
      Platform.isAndroid ? 'Banner_Android' : 'Banner_iOS';

  @override
  String get admobBannerId => BannerAd.testAdUnitId;

  @override
  String get admobInterstitialId => InterstitialAd.testAdUnitId;

  @override
  String get admobRewardedId => RewardedAd.testAdUnitId;

  @override
  // TODO: implement appLovinBannerId
  String get appLovinBannerId => throw UnimplementedError();

  @override
  // TODO: implement appLovinInterstitialId
  String get appLovinInterstitialId => throw UnimplementedError();

  @override
  // TODO: implement appLovinRewardedId
  String get appLovinRewardedId => throw UnimplementedError();

  @override
  // TODO: implement fbBannerId
  String get fbBannerId => throw UnimplementedError();

  @override
  // TODO: implement fbInterstitialId
  String get fbInterstitialId => throw UnimplementedError();

  @override
  // TODO: implement fbRewardedId
  String get fbRewardedId => throw UnimplementedError();
}
