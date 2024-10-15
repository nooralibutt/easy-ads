import 'dart:io';

import 'i_ad_id_manager.dart';

class TestAdIdManager extends IAdIdManager {
  const TestAdIdManager();

  @override
  AppAdIds? get admobAdIds => AppAdIds(
        appId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544~3347511713'
            : 'ca-app-pub-3940256099942544~1458002511',
        appOpenId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/3419835294'
            : 'ca-app-pub-3940256099942544/5575463023',
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
        appId: 'YOUR_SDK_KEY',
        bannerId: Platform.isAndroid
            ? 'ANDROID_BANNER_AD_UNIT_ID'
            : 'IOS_BANNER_AD_UNIT_ID',
        interstitialId: Platform.isAndroid
            ? 'ANDROID_INTER_AD_UNIT_ID'
            : 'IOS_INTER_AD_UNIT_ID',
        rewardedId: Platform.isAndroid
            ? 'ANDROID_REWARDED_AD_UNIT_ID'
            : 'IOS_REWARDED_AD_UNIT_ID',
      );

  @override
  AppAdIds? get fbAdIds => const AppAdIds(
        appId: '1579706379118402',
        interstitialId: 'VID_HD_16_9_15S_LINK#YOUR_PLACEMENT_ID',
        bannerId: 'IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID',
        rewardedId: 'VID_HD_16_9_46S_APP_INSTALL#YOUR_PLACEMENT_ID',
      );
}
