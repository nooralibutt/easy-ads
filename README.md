# Easy Ads Flutter

[![pub package](https://img.shields.io/pub/v/easy_ads_flutter.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/easy_ads_flutter)
[![Last Commits](https://img.shields.io/github/last-commit/nooralibutt/easy-ads?logo=git&logoColor=white)](https://github.com/nooralibutt/easy-ads/commits/master)
[![Pull Requests](https://img.shields.io/github/issues-pr/nooralibutt/easy-ads?logo=github&logoColor=white)](https://github.com/nooralibutt/easy-ads/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/nooralibutt/easy-ads?logo=github&logoColor=white)](https://github.com/nooralibutt/easy-ads)
[![License](https://img.shields.io/github/license/nooralibutt/easy-ads?logo=open-source-initiative&logoColor=green)](https://github.com/nooralibutt/easy-ads/blob/master/LICENSE)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-066BB7?logo=paypal)](https://paypal.me/nooralibutt)

**Show some 💙, 👍 the package & ⭐️ the repo to support the project**

To easily integrate ads from different ad networks into your flutter app.

## Features

- Google Mobile Ads (banner, appOpen, interstitial, rewarded ad)
- Facebook Audience Network (banner, interstitial, rewarded ad)
- Unity Ads (banner, interstitial, rewarded ad)
- AppLovin Max Ads (banner, interstitial, rewarded ad)

## Admob Mediation
- This plugin supports admob mediation [See Details](https://developers.google.com/admob/flutter/mediation/get-started) to see Admob Mediation Guide.
- You just need to add the naative plaatform setting for admob mediation.

## Platform Specific Setup

### iOS

#### Update your Info.plist

* The keys for AppLovin and Google Ads **are required** in Info.plist.

Update your app's `ios/Runner/Info.plist` file to add two keys:

```xml
<key>GADApplicationIdentifier</key>
<string>YOUR_SDK_KEY</string>
```

* You have to add `SKAdNetworkItems` for all networks provided by easy-ads-flutter [info.plist](https://github.com/nooralibutt/easy-ads/blob/master/example/ios/Runner/Info.plist) you can copy paste `SKAdNetworkItems` in  your own project.

### Android

#### Update AndroidManifest.xml

```xml
<manifest>
    <application>
        <!-- Sample AdMob App ID: ca-app-pub-3940256099942544~3347511713 -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```

## Initialize Ad Ids

```dart
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
  AppAdIds? get fbAdIds => AppAdIds(
    appId: 'YOUR_APP_ID',
    interstitialId: 'VID_HD_16_9_15S_LINK#YOUR_PLACEMENT_ID',
    bannerId: 'IMG_16_9_APP_INSTALL#YOUR_PLACEMENT_ID',
    rewardedId: 'VID_HD_16_9_46S_APP_INSTALL#YOUR_PLACEMENT_ID',
  );
}
```

## Initialize the SDK

Before loading ads, have your app initialize the Mobile Ads SDK by calling `EasyAds.instance.initialize()` which initializes the SDK and returns a `Future` that finishes once initialization is complete (or after a 30-second timeout). This needs to be done only once, ideally right before running the app.

```dart
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

const IAdIdManager adIdManager = TestAdIdManager();

EasyAds.instance.initialize(
    adIdManager,
    adMobAdRequest: const AdRequest(),
    // To enable Facebook Test mode ads
    fbTestMode: true,
    admobConfiguration: RequestConfiguration(testDeviceIds: [
      '072D2F3992EF5B4493042ADC632CE39F', // Mi Phone
      '00008030-00163022226A802E',
    ]),
  );
```

## Interstitial/Rewarded Ads

### Load an ad
Ad is automatically loaded after being displayed or first time when you call initialize.
But on safe side, you can call this method. This will load both rewarded and interstitial ads.
If a particular ad is already loaded, it will not load it again.
```dart
EasyAds.instance.loadAd();
```

### Show interstitial or rewarded ad
```dart
EasyAds.instance.showAd(AdUnitType.rewarded);
```

### Show appOpen ad
```dart
EasyAds.instance.showAd(AdUnitType.appOpen)
```

## Show Banner Ads

This is how you may show banner ad in widget-tree somewhere:

```dart
@override
Widget build(BuildContext context) {
  Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SomeWidget(),
      const Spacer(),
      EasyBannerAd(
          adNetwork: AdNetwork.admob, adSize: AdSize.mediumRectangle),
    ],
  );
}
```

## Show Smart Banner Ad

Smart Banner will check one by one the priority ad networks provided by you, if any of the priority network failed to load by some reason then it will automatically jump and try to load the next one so we can prevent revenue loss. 

If you want to set the priority for Smart Banner, just pass the priorityAdNetworks in EasySmartBannerAd constructor just like below.
Other wise it will set by default as [admob, facebook, appLovin, unity] and default AdSize is AdSize.banner,

This is how you may show banner ad in widget-tree somewhere:

```dart
@override
Widget build(BuildContext context) {
  Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SomeWidget(),
      const Spacer(),
      const EasySmartBannerAd(
        priorityAdNetworks: [
          AdNetwork.facebook,
          AdNetwork.admob,
          AdNetwork.unity,
          AdNetwork.appLovin,
        ],
        adSize: AdSize.largeBanner,
      ),
    ],
  );
}
```

## Listening to the callbacks
Declare this object in the class
```dart
  StreamSubscription? _streamSubscription;
```

We are showing InterstitialAd here and also checking if ad has been shown.
If `true`, we are canceling the subscribed callbacks, if any.
Then, we are listening to the Stream and accessing the particular event we need
```dart
if (EasyAds.instance.showInterstitialAd()) {
  // Canceling the last callback subscribed
  _streamSubscription?.cancel();
  // Listening to the callback from showInterstitialAd()
  _streamSubscription =
  EasyAds.instance.onEvent.listen((event) {
    if (event.adUnitType == AdUnitType.interstitial &&
        event.type == AdEventType.adDismissed) {
      _streamSubscription?.cancel();
      goToNextScreen(countryList[index]);
    }
  });
}
```

## Authors
##### Noor Ali Butt
[![GitHub Follow](https://img.shields.io/badge/Connect--blue.svg?logo=Github&longCache=true&style=social&label=Follow)](https://github.com/nooralibutt) [![LinkedIn Link](https://img.shields.io/badge/Connect--blue.svg?logo=linkedin&longCache=true&style=social&label=Connect
)](https://www.linkedin.com/in/nooralibutt)
