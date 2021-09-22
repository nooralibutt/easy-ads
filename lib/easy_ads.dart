library easy_ads;

import 'package:collection/collection.dart';
import 'package:easy_ads/src/easy_ad_base.dart';
import 'package:easy_ads/src/easy_admob/easy_admob_interstitial_ad.dart';
import 'package:easy_ads/src/easy_admob/easy_admob_rewarded_ad.dart';
export 'package:easy_ads/src/enums/ad_network.dart';
export 'package:easy_ads/src/easy_admob/easy_admob_banner_ad.dart';
import 'package:easy_ads/src/enums/ad_network.dart';
import 'package:easy_ads/src/enums/ad_unit_type.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class EasyAds {
  EasyAds._easyAds();
  static final EasyAds instance = EasyAds._easyAds();

  AdLoaded? onAdLoaded;
  AdRequest? _adRequest;
  AdShowed? onAdShowed;
  AdFailedToLoad? onAdFailedToLoad;
  AdFailedToShow? onAdFailedToShow;
  AdDismissed? onAdDismissed;
  EarnedReward? onEarnedReward;

  final List<EasyAdBase> interstitialAds = [];
  final List<EasyAdBase> rewardedAds = [];

  /// Initializes the Google Mobile Ads SDK.
  ///
  /// Call this method as early as possible after the app launches
  Future<void> initialize() async {
    MobileAds.instance.initialize();
  }

  Future<void> initAdmob({
    String? interstitialAdUnitId,
    String? rewardedAdUnitId,
    AdRequest? adRequest,
    bool immersiveModeEnabled = true,
  }) async {
    _adRequest = adRequest;

    // init interstitial ads
    if (interstitialAdUnitId != null &&
        interstitialAds.indexWhere((e) => e.adNetwork == AdNetwork.admob) ==
            -1) {
      final interstitialAd = EasyAdmobInterstitialAd(interstitialAdUnitId,
          adRequest ?? const AdRequest(), immersiveModeEnabled);
      interstitialAds.add(interstitialAd);

      // overriding the callbacks
      interstitialAd.onAdLoaded = onAdLoadedMethod;
      interstitialAd.onAdFailedToLoad = onAdFailedToLoadMethod;
      interstitialAd.onAdShowed = onAdShowedMethod;
      interstitialAd.onAdFailedToShow = onAdFailedToShowMethod;
      interstitialAd.onAdDismissed = onAdDismissedMethod;

      await interstitialAd.load();
    }

    // init rewarded ads
    if (rewardedAdUnitId != null &&
        rewardedAds.indexWhere((e) => e.adNetwork == AdNetwork.admob) == -1) {
      final rewardedAd = EasyAdmobRewardedAd(rewardedAdUnitId,
          _adRequest ?? const AdRequest(), immersiveModeEnabled);
      rewardedAds.add(rewardedAd);

      // overriding the callbacks
      rewardedAd.onAdLoaded = onAdLoadedMethod;
      rewardedAd.onAdFailedToLoad = onAdFailedToLoadMethod;
      rewardedAd.onAdShowed = onAdShowedMethod;
      rewardedAd.onAdFailedToShow = onAdFailedToShowMethod;
      rewardedAd.onAdDismissed = onAdDismissedMethod;
      rewardedAd.onEarnedReward = onEarnedRewardMethod;

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

  void loadInterstitialAd({AdNetwork adNetwork = AdNetwork.any}) {
    for (final e in interstitialAds) {
      if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
        e.load();
      }
    }
  }

  bool isInterstitialAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = interstitialAds.firstWhereOrNull((e) =>
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
        e.isAdLoaded);
    return ad?.isAdLoaded ?? false;
  }

  void showInterstitialAd({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = interstitialAds.firstWhereOrNull((e) =>
        e.isAdLoaded &&
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork));
    ad?.show();
  }

  void disposeInterstitialAd({AdNetwork adNetwork = AdNetwork.any}) {
    for (final e in interstitialAds) {
      if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
        e.dispose();
      }
    }
  }

  void loadRewardedAd({AdNetwork adNetwork = AdNetwork.any}) {
    for (final e in rewardedAds) {
      if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
        e.load();
      }
    }
  }

  bool isRewardedAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = rewardedAds.firstWhereOrNull((e) =>
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
        e.isAdLoaded);
    return ad?.isAdLoaded ?? false;
  }

  void showRewardedAd({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = rewardedAds.firstWhereOrNull((e) =>
        e.isAdLoaded &&
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork));
    ad?.show();
  }

  void disposeRewardedAd({AdNetwork adNetwork = AdNetwork.any}) {
    for (final e in rewardedAds) {
      if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
        e.dispose();
      }
    }
  }

  void onAdLoadedMethod(
          AdNetwork adNetwork, AdUnitType adUnitType, Object? data) =>
      onAdLoaded?.call(adNetwork, adUnitType, data);
  void onAdShowedMethod(
          AdNetwork adNetwork, AdUnitType adUnitType, Object? data) =>
      onAdShowed?.call(adNetwork, adUnitType, data);
  void onAdFailedToLoadMethod(
          AdNetwork adNetwork, AdUnitType adUnitType, String errorMessage) =>
      onAdFailedToLoad?.call(adNetwork, adUnitType, errorMessage);
  void onAdFailedToShowMethod(AdNetwork adNetwork, AdUnitType adUnitType,
          String errorMessage, Object? data) =>
      onAdFailedToShow?.call(adNetwork, adUnitType, errorMessage, data);
  void onAdDismissedMethod(
          AdNetwork adNetwork, AdUnitType adUnitType, Object? data) =>
      onAdDismissed?.call(adNetwork, adUnitType, data);
  void onEarnedRewardMethod(AdNetwork adNetwork, AdUnitType adUnitType,
          String rewardType, num rewardAmount) =>
      onEarnedReward?.call(adNetwork, adUnitType, rewardType, rewardAmount);
}
