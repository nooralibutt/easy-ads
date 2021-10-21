import 'dart:io';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class TestAdIdManager extends IAdIdManager {
  const TestAdIdManager();

  @override
  AppAdIds? get admobAdIds => AppAdIds(
        appId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544~3347511713'
            : 'ca-app-pub-3940256099942544~1458002511',
        bannerId: BannerAd.testAdUnitId,
        interstitialId: InterstitialAd.testAdUnitId,
        rewardedId: RewardedAd.testAdUnitId,
      );

  @override
  AppAdIds? get unityAdIds => AppAdIds(
        appId: Platform.isAndroid ? '4374881' : '4374880',
        bannerId: Platform.isAndroid ? 'Banner_Android' : 'Banner_iOS',
        interstitialId:
            Platform.isAndroid ? 'Interstitial_Android' : 'Interstitial_iOS',
        rewardedId: Platform.isAndroid ? 'Rewarded_Android' : 'Rewarded_iOS',
      );

  @override
  AppAdIds? get appLovinAdIds => AppAdIds(
        appId:
            'OeKTS4Zl758OIlAs3KQ6-3WE1IkdOo3nQNJtRubTzlyFU76TRWeQZAeaSMCr9GcZdxR4p2cnoZ1Gg7p7eSXCdA',
        interstitialId:
            Platform.isAndroid ? 'c48f54c6ce5ff297' : 'e33147110a6d12d2',
        rewardedId:
            Platform.isAndroid ? 'ffbed216d19efb09' : 'f4af3e10dd48ee4f',
      );
}
