import 'package:easy_ads_flutter/src/easy_unity/easy_unity_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class EasyUnityAd extends EasyUnityAdBase {
  final AdUnitType _adUnitType;
  bool _isAdLoaded = false;
  EasyUnityAd(String adUnitId, this._adUnitType) : super(adUnitId);

  @override
  AdUnitType get adUnitType => _adUnitType;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  void dispose() {
    _isAdLoaded = false;
  }

  @override
  Future<void> load() async {
    if (_isAdLoaded) return;

    await UnityAds.load(
      placementId: adUnitId,
      onComplete: onCompleteUnityAd,
      onFailed: _onFailedUnityAd,
    );
  }

  @override
  show() async {
    await UnityAds.showVideoAd(placementId: adUnitId);

    _isAdLoaded = false;
    load();
  }

  @override
  void onCompleteUnityAd(args) {
    _isAdLoaded = true;
    if (adUnitType == AdUnitType.rewarded) {
      onEarnedReward?.call(adNetwork, adUnitType, null, null);
    } else {
      onAdDismissed?.call(adNetwork, adUnitType, null);
    }
  }

  @override
  void onFailedUnityAd(
      UnityAdsInitializationError error, String errorMessage) {}

  void _onFailedUnityAd(
      String placementId, UnityAdsLoadError error, String errorMessage) {
    _isAdLoaded = false;
    onAdFailedToLoad?.call(
        adNetwork, adUnitType, error, 'Error occurred while loading unity ad');
  }
}
