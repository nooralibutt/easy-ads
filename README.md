To easily add ads into your app.

## Features

- Google Mobile Ads (banner, interstitial, rewarded ad)
- Unity Ads (banner, interstitial, rewarded ad)

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
* A `SKAdNetworkItems` key with Google's `SKAdNetworkIdentifier` value of `cstr6suwn9.skadnetwork`.

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
<key>SKAdNetworkItems</key>
  <array>
    <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>cstr6suwn9.skadnetwork</string>
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
        <!-- Sample AdMob App ID: ca-app-pub-3940256099942544~3347511713 -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
    </application>
</manifest>
```


The same value when you initialize the plugin in your Dart code.

See https://goo.gl/fQ2neu for more information about configuring `AndroidManifest.xml` and setting up the App ID.


## Initialize the SDK

Before loading ads, have your app initialize the Mobile Ads SDK by calling `EasyAds.instance.initialize()` which initializes the SDK and returns a `Future` that finishes once initialization is complete (or after a 30-second timeout). This needs to be done only once, ideally right before running the app.


```dart
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyAds.instance.initialize();

  runApp(MyApp());
}
```

### Initialize the admob plugin

```dart
EasyAds.instance.initAdmob(
        interstitialAdUnitId: InterstitialAd.testAdUnitId,
        rewardedAdUnitId: RewardedAd.testAdUnitId);
```

### Initialize the unity plugin

```dart
EasyAds.instance.initUnity(
        unityGameId: 'unityGameId',
        testMode: true,
        interstitialPlacementId: 'Interstitial_Android',
        rewardedPlacementId: 'Rewarded_Android');
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

Declare banner ad instance variable and banner ad placement ids

```dart
class _CountryDetailScreenState extends State<CountryDetailScreen> {
  static final _unityBannerPlacementId =
          Platform.isAndroid ? 'Banner_Android' : 'Banner_iOS';

  late final EasyUnityBannerAd _bannerAd;
```

#### initialize and load Banner ad

Initialize and Load banner ad in init state

```dart
@override
void initState() {
  super.initState();

  // Initializing banner and load ad
  _bannerAd = EasyUnityBannerAd(_unityBannerPlacementId);
  _bannerAd.load();
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
      _bannerAd.show(),
    ],
  );
}
```

#### dispose banner ad

```dart
@override
void dispose() {
  super.dispose();

  _bannerAd.dispose();
}
```