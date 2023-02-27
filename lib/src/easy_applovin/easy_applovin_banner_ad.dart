import 'package:applovin_max/applovin_max.dart';
import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';

class EasyApplovinBannerAd extends EasyAdBase {
  EasyApplovinBannerAd(String adUnitId) : super(adUnitId);

  @override
  AdUnitType get adUnitType => AdUnitType.banner;
  @override
  AdNetwork get adNetwork => AdNetwork.appLovin;

  @override
  void dispose() {}

  @override
  bool get isAdLoaded => false;

  @override
  Future<void> load() async {}

  @override
  dynamic show() {
    return MaxAdView(
      adUnitId: adUnitId,
      adFormat: AdFormat.banner,
      customData: 'EasyApplovinBannerAd',
      listener: AdViewAdListener(
        onAdLoadedCallback: (ad) {
          onAdLoaded?.call(adNetwork, adUnitType, ad);
          onBannerAdReadyForSetState?.call(adNetwork, adUnitType, ad);
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          onAdFailedToLoad?.call(adNetwork, adUnitType, null,
              'Error occurred while loading $adNetwork ad with ${error.code.toString()} and message:  ${error.message}');
        },
        onAdClickedCallback: (_) {
          onAdClicked?.call(adNetwork, adUnitType, null);
        },
        onAdExpandedCallback: (ad) {
          onAdShowed?.call(adNetwork, adUnitType, ad);
        },
        onAdCollapsedCallback: (ad) {
          onAdDismissed?.call(adNetwork, adUnitType, ad);
        },
      ),
    );
  }
}
