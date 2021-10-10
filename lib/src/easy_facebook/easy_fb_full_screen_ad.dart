import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter_applovin_max/flutter_applovin_max.dart';

class EasyFbFullScreenAd extends EasyAdBase {
  final AdUnitType _adUnitType;
  bool _isAdLoaded = false;
  EasyFbFullScreenAd(String adUnitId, this._adUnitType)
      : assert(
            _adUnitType == AdUnitType.interstitial ||
                _adUnitType == AdUnitType.rewarded,
            'Ad Unit Type must be rewarded or interstitial'),
        super(adUnitId);

  @override
  AdNetwork get adNetwork => AdNetwork.facebook;

  @override
  AdUnitType get adUnitType => _adUnitType;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  void dispose() {
    _isAdLoaded = false;

    if (adUnitType == AdUnitType.interstitial) {
      FacebookInterstitialAd.destroyInterstitialAd();
    } else {
      FacebookRewardedVideoAd.destroyRewardedVideoAd();
    }
  }

  @override
  Future<void> load() async {
    if (_isAdLoaded) return;

    if (adUnitType == AdUnitType.interstitial) {
      FacebookInterstitialAd.loadInterstitialAd(
          placementId: adUnitId, listener: _onInterstitialAdListener);
    } else {
      FacebookRewardedVideoAd.loadRewardedVideoAd(
          placementId: adUnitId, listener: _onRewardedAdListener);
    }
  }

  @override
  show() async {
    if (!_isAdLoaded) return;

    if (adUnitType == AdUnitType.interstitial) {
      await FacebookInterstitialAd.showInterstitialAd();
    } else {
      await FacebookRewardedVideoAd.showRewardedVideoAd();
    }
  }

  void _onRewardedAdListener(RewardedVideoAdResult? result, dynamic value) {
    if (result == null) return;

    switch (result) {
      case RewardedVideoAdResult.ERROR:
        _isAdLoaded = false;
        onAdFailedToLoad?.call(adNetwork, adUnitType, null,
            'Error occurred while loading $value ad');
        break;
      case RewardedVideoAdResult.LOADED:
        _isAdLoaded = true;
        onAdLoaded?.call(adNetwork, adUnitType, 'Loaded: $value');
        break;
      case RewardedVideoAdResult.CLICKED:
        onAdClicked?.call(adNetwork, adUnitType, 'Clicked: $value');
        break;
      case RewardedVideoAdResult.LOGGING_IMPRESSION:
        break;
      case RewardedVideoAdResult.VIDEO_COMPLETE:
        onEarnedReward?.call(adNetwork, adUnitType, null, null);
        break;
      case RewardedVideoAdResult.VIDEO_CLOSED:
        onAdDismissed?.call(adNetwork, adUnitType, 'Dismissed: $value');
        if (value == true || value["invalidated"] == true) {
          _isAdLoaded = false;
          load();
          load();
        }
        break;
    }
  }

  void _onInterstitialAdListener(InterstitialAdResult? result, dynamic value) {
    if (result == null) return;

    switch (result) {
      case InterstitialAdResult.ERROR:
        _isAdLoaded = false;
        onAdFailedToLoad?.call(adNetwork, adUnitType, null,
            'Error occurred while loading $value ad');
        break;
      case InterstitialAdResult.LOADED:
        _isAdLoaded = true;
        onAdLoaded?.call(adNetwork, adUnitType, 'Loaded: $value');
        break;
      case InterstitialAdResult.CLICKED:
        onAdClicked?.call(adNetwork, adUnitType, 'Clicked: $value');
        break;
      case InterstitialAdResult.LOGGING_IMPRESSION:
        break;
      case InterstitialAdResult.DISPLAYED:
        onAdShowed?.call(adNetwork, adUnitType, 'Displayed: $value');
        break;
      case InterstitialAdResult.DISMISSED:
        onAdDismissed?.call(adNetwork, adUnitType, 'Dismissed: $value');
        if (value["invalidated"] == true) {
          _isAdLoaded = false;
          load();
        }
        break;
    }
  }
}
