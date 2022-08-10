import 'package:applovin_max/applovin_max.dart';
import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:flutter/material.dart';

class EasyApplovinBannerAd extends EasyAdBase {
  final AdViewPosition _position;
  EasyApplovinBannerAd(String adUnitId, this._position) : super(adUnitId);

  bool _isAdLoaded = false;

  @override
  AdUnitType get adUnitType => AdUnitType.banner;
  @override
  AdNetwork get adNetwork => AdNetwork.appLovin;

  @override
  void dispose() {
    _isAdLoaded = false;
    AppLovinMAX.destroyBanner(adUnitId);
  }

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  Future<void> load() async {
    if (_isAdLoaded) return;
    if (adUnitType == AdUnitType.banner) {
      AppLovinMAX.createBanner(adUnitId, _position);
    }
    _isAdLoaded = true;
  }

  @override
  dynamic show() {
    if (!_isAdLoaded) {
      return const SizedBox();
    }

    AppLovinMAX.showBanner(adUnitId);
    _isAdLoaded = false;

    return MaxAdView(
      adUnitId: adUnitId,
      adFormat: AdFormat.banner,
      listener: AdViewAdListener(
        onAdLoadedCallback: (_) {
          _isAdLoaded = true;
          onAdLoaded?.call(adNetwork, adUnitType, null);
        },
        onAdLoadFailedCallback: (_, __) {
          _isAdLoaded = false;
          onAdFailedToLoad?.call(adNetwork, adUnitType, null,
              'Error occurred while loading $adNetwork ad');
        },
        onAdClickedCallback: (_) {
          onAdClicked?.call(adNetwork, adUnitType, null);
        },
        onAdExpandedCallback: (_) {},
        onAdCollapsedCallback: (_) {},
      ),
    );
  }
}
