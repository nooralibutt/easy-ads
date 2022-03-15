import 'package:easy_ads_flutter/src/easy_unity/easy_unity_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

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

    await UnityAds.load(
      placementId: adUnitId,
      onComplete: (_) => _isAdLoaded = true,
      onFailed: (s, e, em) => _isAdLoaded = false,
    );
  }

  @override
  dynamic show() {
    final ad = UnityBannerAd(
      size: BannerSize(width: adSize.width, height: adSize.height),
      placementId: adUnitId,
      onLoad: onCompleteUnityAd,
      onFailed: _onFailedUnityBannerAd,
      onClick: _onClickUnityBannerAd,
    );

    return Container(
      alignment: Alignment.center,
      child: ad,
      height: adSize.height.toDouble(),
      width: adSize.width.toDouble(),
    );
  }

  @override
  void onCompleteUnityAd(args) {
    _isAdLoaded = true;
    onAdLoaded?.call(adNetwork, adUnitType, null);
  }

  @override
  void onFailedUnityAd(
      UnityAdsInitializationError error, String errorMessage) {}

  void _onFailedUnityBannerAd(
      String placementId, UnityAdsBannerError error, String errorMessage) {
    _isAdLoaded = false;
    onAdFailedToLoad?.call(adNetwork, adUnitType, error,
        'Error occurred while loading unity banner ad');
  }

  void _onClickUnityBannerAd(String placementId) {
    onAdClicked?.call(adNetwork, adUnitType, null);
  }
}
