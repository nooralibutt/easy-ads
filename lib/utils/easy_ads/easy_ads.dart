import 'package:ads/utils/easy_ads/easy_ad_base.dart';
import 'package:ads/utils/easy_ads/easy_admob/easy_admob_rewarded_ad.dart';
import 'package:ads/utils/enums/ad_network.dart';
import 'package:ads/utils/enums/ad_unit_type.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:collection/collection.dart';

class EasyAds {
  EasyAds._easyAds();

  static final EasyAds instance = EasyAds._easyAds();

  AdLoaded? onAdLoaded;
  AdShowed? onAdShowed;
  AdFailedToLoad? onAdFailedToLoad;
  AdFailedToShow? onAdFailedToShow;
  AdDismissed? onAdDismissed;
  EarnedReward? onEarnedReward;

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

      // overriding the callbacks
      rewardedAd.onAdLoaded = onAdLoadedMethod;
      rewardedAd.onAdFailedToLoad = onAdFailedToLoadMethod;
      rewardedAd.onAdShowed = onAdShowedMethod;
      rewardedAd.onAdFailedToShow = onAdFailedToShowMethod;
      rewardedAd.onAdDismissed = onAdDismissedMethod;
      rewardedAd.onEarnedReward = onEarnedRewardMethod;

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

  void loadRewardedAd({AdNetwork adNetwork = AdNetwork.any}) {
    rewardedAds.forEach((e) {
      if (e.isAdLoaded == false &&
          (adNetwork == AdNetwork.any || adNetwork == e.adNetwork)) {
        e.load();
      }
    });
  }

  bool isRewardedAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = rewardedAds.firstWhereOrNull((e) =>
        e.isAdLoaded &&
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork));
    return ad?.isAdLoaded ?? false;
  }

  void showRewardedAd({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = rewardedAds.firstWhereOrNull((e) =>
        e.isAdLoaded &&
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork));
    ad?.show();
  }

  void disposeRewardedAd({AdNetwork adNetwork = AdNetwork.any}) {
    for (final r in rewardedAds) {
      if (adNetwork == AdNetwork.any)
        r.dispose();
      else if (adNetwork == r.adNetwork) r.dispose();
    }
  }

  void onAdLoadedMethod(AdNetwork adNetwork, Object? data) =>
      onAdLoaded?.call(adNetwork, data);
  void onAdShowedMethod(AdNetwork adNetwork, Object? data) =>
      onAdShowed?.call(adNetwork, data);
  void onAdFailedToLoadMethod(AdNetwork adNetwork, String errorMessage) =>
      onAdFailedToLoad?.call(adNetwork, errorMessage);
  void onAdFailedToShowMethod(
          AdNetwork adNetwork, String errorMessage, Object? data) =>
      onAdFailedToShow?.call(adNetwork, errorMessage, data);
  void onAdDismissedMethod(AdNetwork adNetwork, Object? data) =>
      onAdDismissed?.call(adNetwork, data);
  void onEarnedRewardMethod(
          AdNetwork adNetwork, String rewardType, num rewardAmount) =>
      onEarnedReward?.call(adNetwork, rewardType, rewardAmount);
}
