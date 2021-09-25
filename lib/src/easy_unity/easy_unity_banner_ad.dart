import 'package:easy_ads_flutter/src/easy_unity/easy_unity_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

class EasyUnityBannerAd extends EasyUnityAdBase {
  final AdSize adSize;

  EasyUnityBannerAd(
    String adUnitId, {
    this.adSize = AdSize.largeBanner,
  }) : super(adUnitId);

  bool _isAdLoaded = false;

  @override
  AdUnitType get adUnitType => AdUnitType.banner;

  @override
  void dispose() => _isAdLoaded = false;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  Future<void> load() async {
    if (_isAdLoaded) return;

    final status = await UnityAds.isReady(placementId: adUnitId);
    _isAdLoaded = status ?? false;
  }

  @override
  dynamic show() {
    final ad = UnityBannerAd(
      size: BannerSize(width: adSize.width, height: adSize.height),
      placementId: adUnitId,
      listener: _onUnityBannerAdListener,
    );

    return Container(
      alignment: Alignment.center,
      child: ad,
      height: adSize.height.toDouble(),
      width: adSize.width.toDouble(),
    );
  }

  @override
  void onUnityAdListener(UnityAdState state, args) {}

  void _onUnityBannerAdListener(BannerAdState state, args) {
    print('Banner Listener: $state => $args');

    if (state == BannerAdState.error) {
      _isAdLoaded = false;
      onAdFailedToLoad?.call(adNetwork, adUnitType, args,
          'Error occurred while loading unity banner ad');
    } else if (state == BannerAdState.loaded) {
      _isAdLoaded = true;
      onAdLoaded?.call(adNetwork, adUnitType, null);
    } else if (state == BannerAdState.clicked) {
      onAdClicked?.call(adNetwork, adUnitType, null);
    }
  }
}
