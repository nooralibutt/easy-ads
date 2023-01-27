import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class EasyUnityBannerAd extends EasyAdBase {
  final AdSize? adSize;

  EasyUnityBannerAd(
    String adUnitId, {
    this.adSize,
  }) : super(adUnitId);

  bool _isAdLoaded = false;

  @override
  AdNetwork get adNetwork => AdNetwork.unity;

  @override
  AdUnitType get adUnitType => AdUnitType.banner;

  @override
  void dispose() => _isAdLoaded = false;

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  Future<void> load() async {}

  @override
  dynamic show() {
    final ad = UnityBannerAd(
      size: adSize == null
          ? BannerSize.standard
          : BannerSize(width: adSize!.width, height: adSize!.height),
      placementId: adUnitId,
      onLoad: onCompleteUnityBannerAd,
      onFailed: onFailedUnityBannerAd,
      onClick: onClickUnityBannerAd,
    );

    return Container(alignment: Alignment.center, child: ad);
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

  void onCompleteUnityBannerAd(args) {
    _isAdLoaded = false;
    onAdShowed?.call(adNetwork, adUnitType, args);
    onBannerAdReadyForSetState?.call(adNetwork, adUnitType, args);
  }

  void onFailedUnityBannerAd(
      String placementId, UnityAdsBannerError error, String errorMessage) {
    _isAdLoaded = false;
    onAdFailedToShow?.call(adNetwork, adUnitType, error,
        'Error occurred while loading unity banner ad');
  }

  void onClickUnityBannerAd(String placementId) {
    onAdClicked?.call(adNetwork, adUnitType, null);
  }
}
