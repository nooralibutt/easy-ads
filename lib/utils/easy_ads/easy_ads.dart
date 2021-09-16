import 'package:ads/utils/easy_ads/easy_ad_base.dart';
import 'package:ads/utils/enums/ad_network.dart';

class EasyAds {
  EasyAds._easyAds();

  static final EasyAds instance = EasyAds._easyAds();

  List<EasyAdBase>? interstitialAds;
  List<EasyAdBase>? bannerAds;
  List<EasyAdBase>? rewardedAds;

  Future initAdmob() {
    return Future(() => null);
  }

  Future initFacebook() {
    return Future(() => null);
  }

  Future initAppLovin() {
    return Future(() => null);
  }

  Future initUnity() {
    return Future(() => null);
  }

  void loadInterstitial(AdNetwork adNetwork) {}
  void showInterstitial(AdNetwork adNetwork) {}
  void isInterstitialAdLoaded(AdNetwork adNetwork) {}
  void loadBannerAd(AdNetwork adNetwork) {}
  void showBannerAd(AdNetwork adNetwork) {}
  void isBannerAdLoaded(AdNetwork adNetwork) {}
}
