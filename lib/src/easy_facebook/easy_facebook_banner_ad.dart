import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EasyFacebookBannerAd extends EasyAdBase {
  final AdSize adSize;

  EasyFacebookBannerAd(
    String adUnitId, {
    AdRequest? adRequest,
    this.adSize = AdSize.banner,
  }) : super(adUnitId);

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  AdUnitType get adUnitType => AdUnitType.banner;
  @override
  AdNetwork get adNetwork => AdNetwork.admob;

  @override
  void dispose() {
    _isAdLoaded = false;
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  Future<void> load() async {
    if (_isAdLoaded) return;
  }

  @override
  dynamic show() {
    return FacebookBannerAd(
      placementId: adUnitId,
      bannerSize: BannerSize(width: adSize.width, height: adSize.height),
      listener: _onAdListener,
    );
  }

  void _onAdListener(BannerAdResult result, dynamic value) {
    switch (result) {
      case BannerAdResult.ERROR:
        _isAdLoaded = false;
        onAdFailedToLoad?.call(adNetwork, adUnitType, null,
            'Error occurred while loading $value ad');
        break;
      case BannerAdResult.LOADED:
        _isAdLoaded = true;
        onAdLoaded?.call(adNetwork, adUnitType, 'Loaded: $value');
        break;
      case BannerAdResult.CLICKED:
        onAdClicked?.call(adNetwork, adUnitType, 'Clicked: $value');
        break;
      case BannerAdResult.LOGGING_IMPRESSION:
        break;
    }
  }
}
