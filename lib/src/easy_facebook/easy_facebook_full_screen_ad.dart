import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:easy_audience_network/easy_audience_network.dart';

class EasyFacebookFullScreenAd extends EasyAdBase {
  final AdUnitType _adUnitType;
  bool _isAdLoaded = false;
  EasyFacebookFullScreenAd(String adUnitId, this._adUnitType)
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
    } else {}
  }

  InterstitialAd? interstitialAd;
  RewardedAd? rewardedAd;

  @override
  Future<void> load() async {
    if (_isAdLoaded) return;

    if (adUnitType == AdUnitType.interstitial) {
      interstitialAd = InterstitialAd(adUnitId);
      interstitialAd?.listener = _onInterstitialAdListener();
      interstitialAd?.load();
    } else {
      rewardedAd = RewardedAd(adUnitId);
      rewardedAd?.listener = _onRewardedAdListener();
      rewardedAd?.load();
    }
  }

  @override
  show() async {
    if (!_isAdLoaded) return;

    if (adUnitType == AdUnitType.interstitial) {
      if (interstitialAd == null) {
        load();
        return;
      }
      await interstitialAd?.show();
    } else {
      if (rewardedAd == null) {
        load();
        return;
      }
      await rewardedAd?.show();
    }
  }

  RewardedAdListener _onRewardedAdListener() {
    return RewardedAdListener(
      onError: (code, value) {
        _isAdLoaded = false;
        onAdFailedToLoad?.call(adNetwork, adUnitType, null,
            'Error occurred while loading $code $value ad');
      },
      onLoaded: () {
        _isAdLoaded = true;
        onAdLoaded?.call(adNetwork, adUnitType, 'Loaded');
      },
      onClicked: () {
        onAdClicked?.call(adNetwork, adUnitType, 'Clicked');
      },
      onLoggingImpression: () {},
      onVideoComplete: () {
        onEarnedReward?.call(adNetwork, adUnitType, null, null);
      },
      onVideoClosed: () {
        onAdDismissed?.call(adNetwork, adUnitType, 'Dismissed');
        _isAdLoaded = false;
        load();
      },
    );
  }

  InterstitialAdListener? _onInterstitialAdListener() {
    return InterstitialAdListener(
      onError: (code, value) {
        _isAdLoaded = false;
        onAdFailedToLoad?.call(adNetwork, adUnitType, null,
            'Error occurred while loading $code $value ad');
      },
      onLoaded: () {
        _isAdLoaded = true;
        onAdLoaded?.call(adNetwork, adUnitType, 'Loaded');
      },
      onClicked: () {
        onAdClicked?.call(adNetwork, adUnitType, 'Clicked');
      },
      onDisplayed: () {
        onAdShowed?.call(adNetwork, adUnitType, 'Displayed');
      },
      onDismissed: () {
        onAdDismissed?.call(adNetwork, adUnitType, 'Dismissed');
        _isAdLoaded = false;
        load();
      },
      onLoggingImpression: () {},
    );
  }
}
