import 'package:audience_network/audience_network.dart';
import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as admob;

class EasyFacebookBannerAd extends EasyAdBase {
  final admob.AdSize adSize;

  EasyFacebookBannerAd(
    String adUnitId, {
    this.adSize = admob.AdSize.banner,
  }) : super(adUnitId);

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  AdUnitType get adUnitType => AdUnitType.banner;
  @override
  AdNetwork get adNetwork => AdNetwork.facebook;

  @override
  void dispose() {
    _isAdLoaded = false;
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
    return BannerAd(
      placementId: adUnitId,
      bannerSize: BannerSize(width: adSize.width, height: adSize.height),
      listener: _onAdListener(),
    );
  }

  BannerAdListener? _onAdListener() {
    return BannerAdListener(
      onLoggingImpression: () {},
      onLoaded: () {
        _isAdLoaded = true;
        onAdLoaded?.call(adNetwork, adUnitType, 'Loaded');
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
