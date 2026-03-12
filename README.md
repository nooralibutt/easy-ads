# Easy Ads Flutter

[![pub package](https://img.shields.io/pub/v/easy_ads_flutter.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/easy_ads_flutter)
[![Last Commits](https://img.shields.io/github/last-commit/nooralibutt/easy-ads?logo=git&logoColor=white)](https://github.com/nooralibutt/easy-ads/commits/master)
[![Pull Requests](https://img.shields.io/github/issues-pr/nooralibutt/easy-ads?logo=github&logoColor=white)](https://github.com/nooralibutt/easy-ads/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/nooralibutt/easy-ads?logo=github&logoColor=white)](https://github.com/nooralibutt/easy-ads)
[![License](https://img.shields.io/github/license/nooralibutt/easy-ads?logo=open-source-initiative&logoColor=green)](https://github.com/nooralibutt/easy-ads/blob/master/LICENSE)
[![PayPal](https://img.shields.io/badge/Donate-PayPal-066BB7?logo=paypal)](https://paypal.me/nooralibutt)

**Show some 💙, 👍 the package & ⭐️ the repo to support the project**

A plugin to **easily integrate AdMob ads** into your Flutter app.

---

⚠ **Note**

From version **26.3.12**, this package supports **AdMob only**.

If you need **Facebook, AppLovin, or Unity ads**, you can use the alternative branches:

- **All Ad Networks (AdMob + Facebook + AppLovin + Unity)**  
  https://github.com/nooralibutt/easy-ads/tree/feature/all-ads-support

- **AdMob + Facebook Only**  
  https://github.com/nooralibutt/easy-ads/tree/feature/admob-facebook

---

## New Feature: `autoLoadAds`

We've introduced a new `autoLoadAds` field in `EasyAds` initialization:

- **Purpose:** Control whether ads are loaded automatically or not.
- **Default:** `true` (ads are loaded automatically on initialization)
- **Usage:**
  ```dart
  await EasyAds.instance.initialize(
    adIdManager,
    autoLoadAds: false, // disables automatic ad loading
  );```

If set to false, ads will not be loaded automatically.
You must manually load ads using:
```dart 
EasyAds.instance.loadAd(adUnitType: AdUnitType.interstitial);
```

---
# Features

- Google Mobile Ads (**Banner, Native, App Open, Interstitial, Rewarded**)
- **JIT (Just-in-Time)** ad loading for **Interstitial, App Open, and Rewarded** ads
- Simple API for loading and displaying ads
- Event callbacks for ad lifecycle handling

---

# AdMob Mediation

This plugin supports **AdMob Mediation**.

You can configure additional ad networks directly in your AdMob dashboard while still using this plugin.

See the official guide:  
https://developers.google.com/admob/flutter/mediation/get-started

---

# GDPR and Privacy Options Compliance

A **Consent Manager helper** is provided to support GDPR and privacy dialogs. `ConsentManager.gatherGdprConsent()` and `ConsentManager.gatherPrivacyConsent()`


## Platform Specific Setup

### iOS

#### Update your Info.plist

* The Google Mobile Ads App ID is required in your Info.plist.

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

class TestAdIdManager extends IAdIdManager {
  const TestAdIdManager();

  @override
  AppAdIds? get admobAdIds => AppAdIds(
    appId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544~3347511713'
        : 'ca-app-pub-3940256099942544~1458002511',
    appOpenId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/9257395921'
        : 'ca-app-pub-3940256099942544/5575463023',
    bannerId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/9214589741'
        : 'ca-app-pub-3940256099942544/2435281174',
    interstitialId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/1033173712'
        : 'ca-app-pub-3940256099942544/4411468910',
    rewardedId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/5224354917'
        : 'ca-app-pub-3940256099942544/1712485313',
    nativeBannerId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/2247696110'
        : 'ca-app-pub-3940256099942544/3986624511',
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
      EasyBannerAd(adSize: AdSize.largeBanner),
    ],
  );
}
```
# JIT (Just-in-Time) Ads

This package supports **JIT (Just-in-Time) ad loading** for Interstitial, App Open, and Rewarded ads.  
You can show ads **on demand**, with callbacks for success, failure, and dismissal.

### Show JIT App Open

```dart
EasyAds.instance.showJitAppOpen(
  onFailedToLoadOrShow: () => _showSnack('AppOpen failed'),
  onAdShowed: () => _showSnack('AppOpen showed'),
  onAdDismissed: () => _showSnack('AppOpen dismissed'),
);
```

### Show JIT Interstitial

```dart
EasyAds.instance.showJitInterstitial(
context,
onFailedToLoadOrShow: () => _showSnack('Interstitial failed'),
onAdShowed: () => _showSnack('Interstitial showed'),
onAdDismissed: () => _showSnack('Interstitial dismissed'),
);
```

### Show JIT Rewarded

```dart
EasyAds.instance.showJitRewarded(
context,
onEarnedReward: (ctx) => _showSnack('Reward earned!'),
);
```

### Native Ads
You can also create Native Ads and insert them into your widget tree using:

```dart
EasyAds.instance.createNativeAd();
```
Example usage in a widget tree:

```dart
@override
Widget build(BuildContext context) {
  return Column(
    children: [
      SomeWidget(),
      EasyAds.instance.createNativeAd(),
      AnotherWidget(),
    ],
  );
}
```
This ensures native ads are properly loaded and displayed within your UI.


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
