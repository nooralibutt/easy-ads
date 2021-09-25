import 'package:easy_ads_flutter/src/easy_unity/easy_unity_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

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

    final status = await UnityAds.isReady(placementId: adUnitId);
    _isAdLoaded = status ?? false;
  }

  @override
  show() async {
    await UnityAds.showVideoAd(placementId: adUnitId);

    _isAdLoaded = false;
    load();
  }

  @override
  void onUnityAdListener(UnityAdState state, args) {
    final arguments = args as Map<dynamic, dynamic>?;
    if (arguments != null && arguments['placementId'] == adUnitId) {
      if (state == UnityAdState.error) {
        _isAdLoaded = false;
        onAdFailedToLoad?.call(adNetwork, adUnitType, args,
            'Error occurred while loading unity ad');
      } else if (state == UnityAdState.ready) {
        _isAdLoaded = true;
        onAdLoaded?.call(adNetwork, adUnitType, null);
      } else if (state == UnityAdState.started) {
        _isAdLoaded = false;
        onAdShowed?.call(adNetwork, adUnitType, null);
      } else if (state == UnityAdState.skipped) {
        onAdDismissed?.call(adNetwork, adUnitType, null);
      } else if (adUnitType == AdUnitType.rewarded &&
          state == UnityAdState.complete) {
        onEarnedReward?.call(adNetwork, adUnitType, null, null);
      }
    }
  }
}
