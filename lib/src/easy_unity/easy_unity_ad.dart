import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class EasyUnityAd extends EasyAdBase {
  final AdUnitType _adUnitType;
  bool _isAdLoaded = false;
  EasyUnityAd(String adUnitId, this._adUnitType) : super(adUnitId);

  @override
  AdUnitType get adUnitType => _adUnitType;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  AdNetwork get adNetwork => AdNetwork.unity;

  @override
  void dispose() {
    _isAdLoaded = false;
  }

  @override
  Future<void> load() async {
    if (_isAdLoaded) return;

    UnityAds.load(
      placementId: adUnitId,
      onComplete: onCompleteLoadUnityAd,
      onFailed: onFailedToLoadUnityAd,
    );
  }

  @override
  show() {
    UnityAds.showVideoAd(
      placementId: adUnitId,
      onStart: onStartUnityAd,
      onClick: onClickUnityAd,
      onSkipped: onSkipUnityAd,
      onComplete: onCompleteUnityAd,
      onFailed: onFailedToShowUnityAd,
    );

    _isAdLoaded = false;
    load();
  }

  void onCompleteLoadUnityAd(String s) {
    _isAdLoaded = true;
    onAdLoaded?.call(adNetwork, adUnitType, null);
  }

  void onFailedToLoadUnityAd(
      String placementId, UnityAdsLoadError error, String errorMessage) {
    _isAdLoaded = false;
    onAdFailedToLoad?.call(
        adNetwork, adUnitType, error, 'Error occurred while loading unity ad');
  }

  void onStartUnityAd(String s) {
    _isAdLoaded = false;
    onAdShowed?.call(adNetwork, adUnitType, null);
  }

  void onClickUnityAd(String s) {
    onAdClicked?.call(adNetwork, adUnitType, null);
  }

  void onSkipUnityAd(String s) {
    onAdDismissed?.call(adNetwork, adUnitType, null);
  }

  void onCompleteUnityAd(String s) {
    _isAdLoaded = false;
    if (adUnitType == AdUnitType.rewarded) {
      onEarnedReward?.call(adNetwork, adUnitType, null, null);
    } else {
      onAdDismissed?.call(adNetwork, adUnitType, null);
    }
  }

  void onFailedToShowUnityAd(
      String placementId, UnityAdsShowError error, String errorMessage) {
    _isAdLoaded = false;
    onAdFailedToShow?.call(
        adNetwork, adUnitType, error, 'Error occurred while loading unity ad');
  }
}
