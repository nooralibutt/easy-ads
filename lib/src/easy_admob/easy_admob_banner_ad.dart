import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EasyAdmobBannerAd extends EasyAdBase {
  final AdRequest _adRequest;
  final AdSize adSize;

  EasyAdmobBannerAd(
    super.adUnitId, {
    AdRequest? adRequest,
    this.adSize = AdSize.banner,
  }) : _adRequest = adRequest ?? const AdRequest();

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  AdUnitType get adUnitType => AdUnitType.banner;

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
    await _bannerAd?.dispose();
    _bannerAd = null;
    _isAdLoaded = false;

    _bannerAd = BannerAd(
      size: adSize,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _bannerAd = ad as BannerAd?;
          _isAdLoaded = true;
          onAdLoaded?.call(adUnitType, ad);
          onBannerAdReadyForSetState?.call(adUnitType, ad);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _bannerAd = null;
          _isAdLoaded = false;
          onAdFailedToLoad?.call(adUnitType, ad, error.toString());
          ad.dispose();
        },
        onAdOpened: (Ad ad) => onAdClicked?.call(adUnitType, ad),
        onAdClosed: (Ad ad) => onAdDismissed?.call(adUnitType, ad),
        onAdImpression: (Ad ad) => onAdShowed?.call(adUnitType, ad),
      ),
      request: _adRequest,
    );
    _bannerAd?.load();
  }

  @override
  dynamic show() {
    if (_bannerAd == null || _isAdLoaded == false) {
      load();
      return SizedBox(
        height: adSize.height.toDouble(),
        width: adSize.width.toDouble(),
      );
    }

    return Container(
      alignment: Alignment.center,
      height: adSize.height.toDouble(),
      width: adSize.width.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
