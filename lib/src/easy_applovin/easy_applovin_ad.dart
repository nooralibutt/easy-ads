import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:flutter_applovin_max/flutter_applovin_max.dart';

class EasyApplovinFullScreenAd extends EasyAdBase {
  final AdUnitType _adUnitType;
  bool _isAdLoaded = false;
  EasyApplovinFullScreenAd(String adUnitId, this._adUnitType)
      : assert(
            _adUnitType == AdUnitType.interstitial ||
                _adUnitType == AdUnitType.rewarded,
            'Ad Unit Type must be rewarded or interstitial'),
        super(adUnitId);

  @override
  AdNetwork get adNetwork => AdNetwork.appLovin;

  @override
  AdUnitType get adUnitType => _adUnitType;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  void dispose() {
    _isAdLoaded = false;
  }

  Future<void> initialize() async {
    if (adUnitType == AdUnitType.interstitial) {
      await FlutterApplovinMax.initInterstitialAd(adUnitId);
    } else {
      await FlutterApplovinMax.initRewardAd(adUnitId);
    }
  }

  @override
  Future<void> load() async {
    if (_isAdLoaded) return;

    if (adUnitType == AdUnitType.interstitial) {
      _isAdLoaded =
          await FlutterApplovinMax.isInterstitialLoaded(onAppLovinAdListener) ??
              false;
    } else {
      _isAdLoaded =
          await FlutterApplovinMax.isRewardLoaded(onAppLovinAdListener) ??
              false;
    }
  }

  @override
  show() async {
    if (adUnitType == AdUnitType.interstitial) {
      await FlutterApplovinMax.showInterstitialVideo(onAppLovinAdListener);
    } else {
      await FlutterApplovinMax.showRewardVideo(onAppLovinAdListener);
    }
  }

  void onAppLovinAdListener(AppLovinAdListener? event) {
    if (event == null) return;

    switch (event) {
      case AppLovinAdListener.adLoaded:
        _isAdLoaded = true;
        onAdLoaded?.call(adNetwork, adUnitType, null);
        break;
      case AppLovinAdListener.adLoadFailed:
        _isAdLoaded = false;
        onAdFailedToLoad?.call(adNetwork, adUnitType, null,
            'Error occurred while loading $adNetwork ad');
        break;
      case AppLovinAdListener.adDisplayed:
        onAdShowed?.call(adNetwork, adUnitType, null);
        break;
      case AppLovinAdListener.adHidden:
        onAdDismissed?.call(adNetwork, adUnitType, null);
        break;
      case AppLovinAdListener.adClicked:
        onAdClicked?.call(adNetwork, adUnitType, null);
        break;
      case AppLovinAdListener.onAdDisplayFailed:
        onAdFailedToShow?.call(adNetwork, adUnitType, null,
            'Error occurred while showing $adNetwork ad');
        break;
      case AppLovinAdListener.onRewardedVideoStarted:
      case AppLovinAdListener.onRewardedVideoCompleted:
        break;
      case AppLovinAdListener.onUserRewarded:
        onEarnedReward?.call(adNetwork, adUnitType, null, null);
        break;
    }
  }
}
