import 'package:easy_ads/src/easy_ad_base.dart';
import 'package:easy_ads/src/enums/ad_network.dart';
import 'package:easy_ads/src/enums/ad_unit_type.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EasyAdmobBannerAd extends EasyAdBase {
  final AdRequest _adRequest;
  final AdSize _adSize;

  EasyAdmobBannerAd(
    String adUnitId,
    this._adRequest,
    this._adSize,
  ) : super(adUnitId);

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
    _bannerAd = BannerAd(
      size: _adSize,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _bannerAd = ad as BannerAd?;
          print('Banner Ad Loaded  >>>>>>>>>>>>>>>>>>>>>>>>>>');
          _isAdLoaded = true;
          onAdLoaded?.call(adNetwork, adUnitType, ad);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _bannerAd = null;
          _isAdLoaded = false;
          onAdFailedToLoad?.call(adNetwork, adUnitType, error.toString());
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => print('Ad closed.'),
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
      request: _adRequest,
    );
    _bannerAd?.load();
  }

  @override
  dynamic show() {
    final ad = _bannerAd;
    if (ad == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return const SizedBox();
    }

    return SizedBox(
      child: AdWidget(ad: ad),
      height: 50,
      width: double.infinity,
    );
  }
}
