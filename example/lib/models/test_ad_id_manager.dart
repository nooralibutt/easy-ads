import 'dart:io';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';

class TestAdIdManager extends IAdIdManager {
  const TestAdIdManager();

  @override
  AppAdIds? get admobAdIds => AppAdIds(
        appId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544~3347511713'
            : 'ca-app-pub-3940256099942544~1458002511',
        appOpenId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/3419835294'
            : 'ca-app-pub-3940256099942544/5662855259',
        bannerId: 'ca-app-pub-3940256099942544/6300978111',
        interstitialId: 'ca-app-pub-3940256099942544/1033173712',
        rewardedId: 'ca-app-pub-3940256099942544/5224354917',
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
        bannerId: Platform.isAndroid ? 'b2c4f43d3986bcfb' : '80c269494c0e45c2',
        interstitialId:
            Platform.isAndroid ? 'c48f54c6ce5ff297' : 'e33147110a6d12d2',
        rewardedId:
            Platform.isAndroid ? 'ffbed216d19efb09' : 'f4af3e10dd48ee4f',
      );

  @override
  AppAdIds? get fbAdIds => const AppAdIds(
        appId: '1579706379118402',
        interstitialId: 'VID_HD_16_9_15S_LINK#YOUR_PLACEMENT_ID',
        bannerId: 'IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID',
        rewardedId: 'VID_HD_16_9_46S_APP_INSTALL#YOUR_PLACEMENT_ID',
      );
}
