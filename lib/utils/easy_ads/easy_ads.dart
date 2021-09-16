import 'package:ads/utils/easy_ads/easy_ad_base.dart';
import 'package:ads/utils/easy_ads/easy_admob/easy_admob_rewarded_ad.dart';
import 'package:ads/utils/enums/ad_network.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:collection/collection.dart';

class EasyAds {
  EasyAds._easyAds();

  static final EasyAds instance = EasyAds._easyAds();

  AdLoaded? onAdLoaded;

  final List<EasyAdBase> bannerAds = [];
  final List<EasyAdBase> interstitialAds = [];
  final List<EasyAdBase> rewardedAds = [];

  AdRequest? adRequest;

  Future<void> initAdmob({
    String? rewardedAdUnitId,
    AdRequest? adRequest,
    bool immersiveModeEnabled = true,
  }) async {
    this.adRequest = adRequest;

    if (rewardedAdUnitId != null &&
        rewardedAds.indexWhere((e) => e.adNetwork == AdNetwork.Admob) == -1) {
      final rewardedAd = EasyAdmobRewardedAd(
          rewardedAdUnitId, adRequest ?? AdRequest(), immersiveModeEnabled);
      rewardedAds.add(rewardedAd);
      rewardedAd.onAdLoaded = onAdLoadedMethod;

      await rewardedAd.init();
      await rewardedAd.load();
    }
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

  void loadBannerAd(AdNetwork adNetwork) {}
  void isBannerAdLoaded(AdNetwork adNetwork) {}
  void showBannerAd(AdNetwork adNetwork) {}

  void loadInterstitialAd(AdNetwork adNetwork) {}
  void isInterstitialAdLoaded(AdNetwork adNetwork) {}
  void showInterstitialAd(AdNetwork adNetwork) {}

  void loadRewardedAd(AdNetwork adNetwork) {}
  void isRewardedAdLoaded(AdNetwork adNetwork) {}
  void showRewardedAd({AdNetwork adNetwork = AdNetwork.Default}) {
    final ad = rewardedAds.firstWhereOrNull((e) =>
        e.isAdLoaded &&
        (adNetwork == AdNetwork.Default || adNetwork == e.adNetwork));
    ad?.show();
  }

  void disposeRewardedAd({AdNetwork adNetwork = AdNetwork.Default}) {
    for (final r in rewardedAds) {
      if (adNetwork == AdNetwork.Default)
        r.dispose();
      else if (adNetwork == r.adNetwork) r.dispose();
    }
  }

  void onAdLoadedMethod(AdNetwork adNetwork, Object? data) =>
      onAdLoaded?.call(adNetwork, data);
}
