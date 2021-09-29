To easily add ads into your app.

## Features

- Google Mobile Ads (banner, interstitial, rewarded ad)
- Unity Ads (banner, interstitial, rewarded ad)
- AppLovin Ads (interstitial, rewarded ad)

## Prerequisites

*   Flutter 1.22.0 or higher
*   Android
    *   Android Studio 3.2 or higher
    *   Target Android API level 19 or higher
    *   Set `compileSdkVersion` to 28 or higher
    *   Android Gradle Plugin 4.1 or higher (this is the version supported by Flutter out of the box)
*   Ios
    *   Latest version of Xcode with [enabled command-line tools](https://flutter.dev/docs/get-started/install/macos#install-xcode).
*   Recommended: [Create an AdMob account](https://support.google.com/admob/answer/2784575) and [register an Android and/or iOS app](https://support.google.com/admob/answer/2773509) (To show live ads on a published app, it is required to register that app).

## Platform Specific Setup


### iOS


#### Update your Info.plist

Update your app's `ios/Runner/Info.plist` file to add two keys:

* A `GADApplicationIdentifier` key with a string value of your AdMob app ID ([identified in the AdMob UI](https://support.google.com/admob/answer/7356431)).
* A `SKAdNetworkItems` key with Google's `SKAdNetworkIdentifier` value of `cstr6suwn9.skadnetwork` and for applovin as well

```xml
<key>AppLovinSdkKey</key>
<string>YOUR_SDK_KEY</string>
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
```

```xml
<key>SKAdNetworkItems</key>
<array>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cstr6suwn9.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>2U9PT9HC89.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>4468km3ulz.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>4FZDC2EVR5.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>7UG5ZH24HU.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>8s468mfl3y.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>9RD848Q2BZ.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>9T245VHMPL.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>av6w8kgt66.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>F38H382JLK.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>hs6bdukanm.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>KBD757YWX3.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>ludvb6z3bs.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>M8DBW4SV7C.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>mlmmfzh3r3.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>prcb7njmu6.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>t38b2kh725.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>TL55SBB4FM.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>WZMMZ9FP6W.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>YCLNXRL5PM.skadnetwork</string>
</dict>
<dict>
    <key>SKAdNetworkIdentifier</key>
    <string>ydx93a7ass.skadnetwork</string>
</dict>
</array>
```

See https://developers.google.com/admob/ios/quick-start#update\_your\_infoplist for more information about configuring `Info.plist` and setting up your App ID.


### Android


#### Update AndroidManifest.xml

The AdMob App ID must be included in the `AndroidManifest.xml`. Failure to do so will result in a crash on launch of an app.

Add the AdMob App ID ([identified in the AdMob UI](https://support.google.com/admob/answer/7356431)) to the app's `android/app/src/main/AndroidManifest.xml` file by adding a `<meta-data>` tag with name `com.google.android.gms.ads.APPLICATION_ID`, as shown below. You can find your App ID in the AdMob UI. For `android:value` insert your own AdMob App ID in quotes, as shown below.


```xml
<manifest>
    <application>
        <meta-data android:name="applovin.sdk.key"
            android:value="YOUR_SDK_KEY"/>
        <!-- Sample AdMob App ID: ca-app-pub-3940256099942544~3347511713 -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```


The same value when you initialize the plugin in your Dart code.

See https://goo.gl/fQ2neu for more information about configuring `AndroidManifest.xml` and setting up the App ID.

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

  @override
  AppAdIds? get fbAdIds => null;
}
```

## Initialize the SDK

Before loading ads, have your app initialize the Mobile Ads SDK by calling `EasyAds.instance.initialize()` which initializes the SDK and returns a `Future` that finishes once initialization is complete (or after a 30-second timeout). This needs to be done only once, ideally right before running the app.

```dart
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

const IAdIdManager adIdManager = TestAdIdManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyAds.instance.initialize(
    adIdManager,
    testMode: true,
    adMobAdRequest: const AdRequest(),
    admobConfiguration:
    RequestConfiguration(testDeviceIds: ['adakjhdjkahdahkjdahkdhk']),
  );

  runApp(MyApp());
}
```

### loading an ad

```dart
EasyAds.instance.loadRewardedAd();

OR

EasyAds.instance.loadInterstitialAd();
```

### showing Interstitial ad

```dart
EasyAds.instance.showInterstitialAd();
```

### showing Rewarded ad

```dart
EasyAds.instance.showRewardedAd();
```

### disposing an ad

```dart
EasyAds.instance.disposeAds();
```

## Banner Ads

#### Declare Banner ad

Declare banner ad instance variable and initialize it. Make sure you have specified ad ids in ad id manager

```dart
class _CountryDetailScreenState extends State<CountryDetailScreen> {
  final EasyAdBase? _bannerAd = EasyAds.instance.createBanner(adNetwork: AdNetwork.admob);
```

#### initialize and load Banner ad

Load banner ad in init state

```dart
@override
void initState() {
  super.initState();
  
  _bannerAd?.load();
}
```

#### show banner ad

Show banner ad in widget-tree somewhere 

```dart
@override
Widget build(BuildContext context) {
  Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SomeWidget(),
      const Spacer(),
      _bannerAd?.show() ?? const SizedBox(),
    ],
  );
}
```

#### dispose banner ad

```dart
@override
void dispose() {
  super.dispose();

  _bannerAd?.dispose();
}
```