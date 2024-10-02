## 2.6.0

* Applovin no longer supports isAgeRestrictedUser, read https://developers.applovin.com/en/max/flutter/overview/privacy/
* Update `applovin_max: ^4.0.0`
* Update `easy_audience_network: ^0.0.7`

## 2.5.0
* Update `applovin_max: ^3.11.0`
* Update `unity_ads_plugin: ^0.3.20`
* Update `logger: ^2.4.0`
* Remove requirement of Applovin SDK key in `Info.plist` and `AndroidManifest.xml`
* Fix `AppLovinMAX.targetingData` issue with applovin max
* Remove `AppLovinMAX.targetingData.keywords` in applovin max
* Add `segments` parameter to add segments in the initialization of applovin max sdk. For implementation, please see [here](https://developers.applovin.com/en/flutter/overview/data-and-keyword-passing/#segment-targeting)

## 2.4.4
* Update `applovin_max: ^3.10.0`
* Update `google_mobile_ads: ^5.1.0`
* Update `unity_ads_plugin: ^0.3.16`
* Update `logger: ^2.3.0`
* Update `flutter_lints: ^4.0.0`

## 2.4.3
* Updated Changelogs

## 2.4.2
* Update `applovin_max: ^3.9.2`
* Update `google_mobile_ads: ^5.0.0`
* Update `unity_ads_plugin: ^0.3.13`
* Update `logger: ^2.2.0`
* Update `flutter_lints: ^3.0.2`

## 2.4.1
* Update `applovin_max: ^3.6.0`
* Update `google_mobile_ads: ^4.0.0`
* Update `unity_ads_plugin: ^0.3.11`
* Update `collection: ^1.18.0`

## 2.4.0
* Updates loader argument names and adds assert
* Update `applovin_max: ^3.3.0`
* Update `google_mobile_ads: ^3.1.0`
* Update `unity_ads_plugin: ^0.3.10`

## 2.3.6
* Updates dependencies
* Update `applovin_max: ^3.2.0`

## 2.3.5
* Updates dependencies
* Update `applovin_max: ^3.0.1` 

## 2.3.4
* Add `isShowAppOpenOnAppStateChange` check on initialization
* Updates dependencies

## 2.3.3
* Updates dependencies
* Add logs for admob adapters

## 2.3.2
* Updates dependencies
* Adds Applovin keywords and `AdContentRating` for `isAgeRestrictedUser`

## 2.3.1
* Resolved Merge Conflicts

## 2.1.1
* Update `applovin_max: ^2.4.3`

## 2.3.0
* Adds loader before showing ad for interstitial

## 2.2.1
* Fixes large banner issue for badge

## 2.2.0
* Updates readme
* Updates plugins
* Adds ad badge for google ad mob compliance

## 2.1.0
* Add `easy_audience_network: ^0.0.6` for facebook audience network ads
* Add `TestAdIdManager()` for testing ads in test mode

## 2.0.2
* Fix Initialization Bug
* Update SKAdNetworkItems for iOS info.plist file

## 2.0.1
* Fix Banner Ad Bug 
* Update [Applovin Max](https://pub.dev/packages/applovin_max) Plugin 

## 2.0.0
* Change Facebook Ad Plugin from [facebook_audience_network](https://pub.dev/packages/facebook_audience_network) to [audience_network: ^0.0.4](https://pub.dev/packages/audience_network)

## 1.0.8
* Adds Applovin Age restricted ads parameter
* Update Dependencies
* Updated docs

## 1.0.7
* Adds Smart Banner
* Update Dependencies
* Updated docs

## 1.0.6
* Update Dependencies
* Adds Admob App Open Ad
* Adds orientation for addOpen ad on initialize easyAd
* Updated docs

## 1.0.5
* Added support for applovin_max Official plugin: 2.0.0
* Fix Facebook banner ads
* Added support for applovin banner ads
* Updated docs

## 1.0.4
* Added support for google_mobile_ads: 2.0.0
* Updated docs

## 1.0.3
* Added support for google_mobile_ads: 1.3.0
* Added support for unity_ads_plugin: 0.3.4
* Fix bugs for flutter_applovin_max: 0.3.4
* Updated docs

## 1.0.2
* Added support for google_mobile_ads: 1.1.0
* Added support for unity_ads_plugin: 0.3.3
* Updated docs

## 1.0.1
* Merged pre release
* Updated docs

## 1.0.0-facebook.0
* Implemented Pre-released Facebook ads (interstitial, rewarded and banner)
* Updated docs

## 0.5.0
* Added support for Flutter 2.8
* Added support for google_mobile_ads: 1.0.1
* Updated Docs

## 0.4.0
* Fixes unity interstitial dismiss bug
* Fixes some bugs and removes facebook
* Added EasyBannerAd for easy banner integration
* Updated docs

## 0.3.0
* Implemented Logger for EasyAds
* Updated docs

## 0.2.0
* Implemented Event Management for adLoaded, adFailed, adShowed, etc callbacks using streams
* Added methods to listen callbacks in example
* Updated docs

## 0.1.0

* Updated docs
* Adds helper method of createBanner in easy ads
* Updated initialize method to provide admob test device ids, request configuration and ad request object 

## 0.0.4

* Added Applovin ad support
* Configured project to run example project on ios
* Added Ad Id Manager for easy initialization and switch between test and actual ad ids

## 0.0.3

* Added Unity ad support
* Added On Network Initialized callback
* Updated example with unity ads

## 0.0.2

* Added Changelog
* Added how to use

## 0.0.1

* Added google mobile ads sdk
* Added easy ads singleton class to show interstitial and rewarded video ad