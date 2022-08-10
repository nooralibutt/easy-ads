import 'package:applovin_max/applovin_max.dart';
import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';

class EasyApplovinRewardedAd extends EasyAdBase {
  EasyApplovinRewardedAd(
    String adUnitId,
  ) : super(adUnitId);

  bool _isAdLoaded = false;

  @override
  AdNetwork get adNetwork => AdNetwork.appLovin;

  @override
  AdUnitType get adUnitType => AdUnitType.rewarded;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  void dispose() => _isAdLoaded = false;

  @override
  Future<void> load() async {
    if (_isAdLoaded) return;

    if (adUnitType == AdUnitType.rewarded) {
      AppLovinMAX.loadRewardedAd(adUnitId);
      _isAdLoaded = await AppLovinMAX.isRewardedAdReady(adUnitId) ?? false;
    }
    _onAppLovinAdListener();
  }

  @override
  show() {
    if (!_isAdLoaded) return;

    if (adUnitType == AdUnitType.rewarded) {
      AppLovinMAX.showRewardedAd(adUnitId);
    }
    _isAdLoaded = false;
  }

  void _onAppLovinAdListener() {
    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (_) {
          _isAdLoaded = true;
          onAdLoaded?.call(adNetwork, adUnitType, null);
        },
        onAdLoadFailedCallback: (_, __) {
          _isAdLoaded = false;
          onAdFailedToLoad?.call(adNetwork, adUnitType, null,
              'Error occurred while loading $adNetwork ad');
        },
        onAdDisplayedCallback: (_) {
          onAdShowed?.call(adNetwork, adUnitType, null);
        },
        onAdDisplayFailedCallback: (_, __) {
          onAdFailedToShow?.call(adNetwork, adUnitType, null,
              'Error occurred while showing $adNetwork ad');
        },
        onAdClickedCallback: (_) {
          onAdClicked?.call(adNetwork, adUnitType, null);
        },
        onAdHiddenCallback: (_) {
          onAdDismissed?.call(adNetwork, adUnitType, null);
        },
        onAdReceivedRewardCallback: (_, __) {
          onEarnedReward?.call(adNetwork, adUnitType, null, null);
        },
      ),
    );
  }
}
