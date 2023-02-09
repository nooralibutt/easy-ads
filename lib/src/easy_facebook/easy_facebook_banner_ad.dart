import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;

class EasyFacebookBannerAd extends EasyAdBase {
  final admob.AdSize? adSize;

  EasyFacebookBannerAd(
    String adUnitId, {
    this.adSize = admob.AdSize.banner,
  }) : super(adUnitId);

  bool _isAdLoaded = false;

  @override
  AdUnitType get adUnitType => AdUnitType.banner;
  @override
  AdNetwork get adNetwork => AdNetwork.facebook;

  @override
  void dispose() {
    _isAdLoaded = false;
  }

  @override
  bool get isAdLoaded => _isAdLoaded;

  @override
  Future<void> load() async {}

  @override
  dynamic show() {
    final bannerSize = adSize == null
        ? BannerSize.STANDARD
        : BannerSize(width: adSize!.width, height: adSize!.height);

    return Container(
      height: bannerSize.height.toDouble(),
      alignment: Alignment.center,
      child: BannerAd(
        placementId: adUnitId,
        bannerSize: bannerSize,
        listener: _onAdListener(),
      ),
    );
  }

  BannerAdListener? _onAdListener() {
    return BannerAdListener(
      onLoggingImpression: () {},
      onLoaded: () {
        _isAdLoaded = true;
        onAdLoaded?.call(adNetwork, adUnitType, 'Loaded');
        onBannerAdReadyForSetState?.call(adNetwork, adUnitType, 'Loaded');
      },
      onClicked: () {
        onAdClicked?.call(adNetwork, adUnitType, 'Clicked');
      },
      onError: (code, value) {
        _isAdLoaded = false;
        onAdFailedToLoad?.call(adNetwork, adUnitType, null,
            'Error occurred while loading $code $value ad');
      },
    );
  }
}
