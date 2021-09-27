import 'package:collection/collection.dart';
import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/easy_admob/easy_admob_interstitial_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/easy_admob_rewarded_ad.dart';
import 'package:easy_ads_flutter/src/easy_applovin/easy_applovin_ad.dart';
import 'package:easy_ads_flutter/src/easy_unity/easy_unity_ad_base.dart';
import 'package:easy_ads_flutter/src/easy_unity/easy_unity_ad.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';
import 'package:easy_ads_flutter/src/utils/i_ad_id_manager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

class EasyAds {
  EasyAds._easyAds();
  static final EasyAds instance = EasyAds._easyAds();

  AdRequest? _adRequest;

  EasyAdNetworkInitialized? onAdNetworkInitialized;
  EasyAdCallback? onAdLoaded;
  EasyAdCallback? onAdDismissed;
  EasyAdCallback? onAdShowed;
  EasyAdFailedCallback? onAdFailedToLoad;
  EasyAdFailedCallback? onAdFailedToShow;
  EasyAdEarnedReward? onEarnedReward;

  List<EasyAdBase> get _allAds => [..._interstitialAds, ..._rewardedAds];

  /// All the interstitial ads will be stored in it
  final List<EasyAdBase> _interstitialAds = [];

  /// All the rewarded ads will be stored in it
  final List<EasyAdBase> _rewardedAds = [];

  /// Initializes the Google Mobile Ads SDK.
  ///
  /// Call this method as early as possible after the app launches
  Future<void> initialize(IAdIdManager manager, {bool testMode = false}) async {
    if (manager.admobAdIds?.appId != null) {
      final status = await MobileAds.instance.initialize();
      onAdNetworkInitialized?.call(AdNetwork.admob, true, status);

      // Initializing admob Ads
      EasyAds.instance._initAdmob(
        interstitialAdUnitId: manager.admobAdIds?.interstitialId,
        rewardedAdUnitId: manager.admobAdIds?.rewardedId,
      );
    }

    final unityGameId = manager.unityAdIds?.appId;
    if (unityGameId != null) {
      // Initializing Unity Ads
      EasyAds.instance._initUnity(
        unityGameId: unityGameId,
        testMode: testMode,
        interstitialPlacementId: manager.unityAdIds?.interstitialId,
        rewardedPlacementId: manager.unityAdIds?.rewardedId,
      );
    }

    final appLovinSdkId = manager.appLovinAdIds?.appId;
    if (appLovinSdkId != null) {
      // Initializing Unity Ads
      EasyAds.instance._initAppLovin(
        interstitialAdUnitId: manager.appLovinAdIds?.interstitialId,
        rewardedAdUnitId: manager.appLovinAdIds?.rewardedId,
      );
    }
  }

  Future<void> _initAdmob({
    String? interstitialAdUnitId,
    String? rewardedAdUnitId,
    AdRequest? adRequest,
    bool immersiveModeEnabled = true,
  }) async {
    _adRequest = adRequest;

    // init interstitial ads
    if (interstitialAdUnitId != null &&
        _interstitialAds.doesNotContain(
            AdNetwork.admob, AdUnitType.interstitial)) {
      final interstitialAd = EasyAdmobInterstitialAd(interstitialAdUnitId,
          adRequest ?? const AdRequest(), immersiveModeEnabled);
      _interstitialAds.add(interstitialAd);

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
        _rewardedAds.doesNotContain(AdNetwork.admob, AdUnitType.rewarded)) {
      final rewardedAd = EasyAdmobRewardedAd(rewardedAdUnitId,
          _adRequest ?? const AdRequest(), immersiveModeEnabled);
      _rewardedAds.add(rewardedAd);

      // overriding the callbacks
      rewardedAd.onAdLoaded = onAdLoadedMethod;
      rewardedAd.onAdFailedToLoad = onAdFailedToLoadMethod;
      rewardedAd.onAdShowed = onAdShowedMethod;
      rewardedAd.onAdFailedToShow = onAdFailedToShowMethod;
      rewardedAd.onAdDismissed = onAdDismissedMethod;
      rewardedAd.onEarnedReward = _onEarnedRewardMethod;

      await rewardedAd.load();
    }
  }

  Future _initFacebook() {
    return Future(() => null);
  }

  Future<void> _initAppLovin({
    String? interstitialAdUnitId,
    String? rewardedAdUnitId,
  }) async {
    // init interstitial ads
    if (interstitialAdUnitId != null &&
        _interstitialAds.doesNotContain(
            AdNetwork.appLovin, AdUnitType.interstitial)) {
      final interstitialAd = EasyApplovinFullScreenAd(
          interstitialAdUnitId, AdUnitType.interstitial);
      _interstitialAds.add(interstitialAd);

      // overriding the callbacks
      interstitialAd.onAdLoaded = onAdLoadedMethod;
      interstitialAd.onAdFailedToLoad = onAdFailedToLoadMethod;
      interstitialAd.onAdShowed = onAdShowedMethod;
      interstitialAd.onAdFailedToShow = onAdFailedToShowMethod;
      interstitialAd.onAdDismissed = onAdDismissedMethod;

      await interstitialAd.initialize();
      await interstitialAd.load();
    }

    // init rewarded ads
    if (rewardedAdUnitId != null &&
        _rewardedAds.doesNotContain(AdNetwork.appLovin, AdUnitType.rewarded)) {
      final rewardedAd =
          EasyApplovinFullScreenAd(rewardedAdUnitId, AdUnitType.rewarded);
      _rewardedAds.add(rewardedAd);

      // overriding the callbacks
      rewardedAd.onAdLoaded = onAdLoadedMethod;
      rewardedAd.onAdFailedToLoad = onAdFailedToLoadMethod;
      rewardedAd.onAdShowed = onAdShowedMethod;
      rewardedAd.onAdFailedToShow = onAdFailedToShowMethod;
      rewardedAd.onAdDismissed = onAdDismissedMethod;
      rewardedAd.onEarnedReward = _onEarnedRewardMethod;

      await rewardedAd.initialize();
      await rewardedAd.load();
    }
  }

  /// * [unityGameId] - identifier from Project Settings in Unity Dashboard.
  /// * [testMode] - if true, then test ads are shown.
  Future _initUnity({
    String? unityGameId,
    bool testMode = false,
    String? interstitialPlacementId,
    String? rewardedPlacementId,
  }) async {
    // init interstitial ads
    if (interstitialPlacementId != null &&
        _interstitialAds.doesNotContain(
            AdNetwork.unity, AdUnitType.interstitial)) {
      final interstitialAd =
          EasyUnityAd(interstitialPlacementId, AdUnitType.interstitial);
      _interstitialAds.add(interstitialAd);

      // overriding the callbacks
      interstitialAd.onAdLoaded = onAdLoadedMethod;
      interstitialAd.onAdFailedToLoad = onAdFailedToLoadMethod;
      interstitialAd.onAdShowed = onAdShowedMethod;
      interstitialAd.onAdFailedToShow = onAdFailedToShowMethod;
      interstitialAd.onAdDismissed = onAdDismissedMethod;

      await interstitialAd.load();
    }

    // init interstitial ads
    if (rewardedPlacementId != null &&
        _rewardedAds.doesNotContain(AdNetwork.unity, AdUnitType.rewarded)) {
      final rewardedAd = EasyUnityAd(rewardedPlacementId, AdUnitType.rewarded);
      _rewardedAds.add(rewardedAd);

      // overriding the callbacks
      rewardedAd.onAdLoaded = onAdLoadedMethod;
      rewardedAd.onAdFailedToLoad = onAdFailedToLoadMethod;
      rewardedAd.onAdShowed = onAdShowedMethod;
      rewardedAd.onAdFailedToShow = onAdFailedToShowMethod;
      rewardedAd.onAdDismissed = onAdDismissedMethod;

      await rewardedAd.load();
    }

    // placementId
    if (unityGameId != null) {
      final status = await UnityAds.init(
        gameId: unityGameId,
        testMode: testMode,
        listener: _onUnityAdListener,
      );
      onAdNetworkInitialized?.call(AdNetwork.unity, status == true, status);
    }
  }

  void loadInterstitialAd({AdNetwork adNetwork = AdNetwork.any}) {
    for (final e in _interstitialAds) {
      if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
        e.load();
      }
    }
  }

  bool isInterstitialAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = _interstitialAds.firstWhereOrNull((e) =>
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
        e.isAdLoaded);
    return ad?.isAdLoaded ?? false;
  }

  void showInterstitialAd({AdNetwork adNetwork = AdNetwork.any}) {
    _interstitialAds.shuffle();

    final ad = _interstitialAds.firstWhereOrNull((e) =>
        e.isAdLoaded &&
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork));
    ad?.show();
  }

  void loadRewardedAd({AdNetwork adNetwork = AdNetwork.any}) {
    for (final e in _rewardedAds) {
      if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
        e.load();
      }
    }
  }

  bool isRewardedAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = _rewardedAds.firstWhereOrNull((e) =>
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
        e.isAdLoaded);
    return ad?.isAdLoaded ?? false;
  }

  void showRewardedAd({AdNetwork adNetwork = AdNetwork.any}) {
    _rewardedAds.shuffle();

    final ad = _rewardedAds.firstWhereOrNull((e) =>
        e.isAdLoaded &&
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork));
    ad?.show();
  }

  /// if [adNetwork] is provided only that network's ads will be disposed otherwise it will be ignored
  /// if [adUnitType] is provided only that ad unit type will be disposed, otherwise it will be ignored
  void disposeAds(
      {AdNetwork adNetwork = AdNetwork.any, AdUnitType? adUnitType}) {
    for (final e in _allAds) {
      if ((adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
          (adUnitType == null || adUnitType == e.adUnitType)) {
        e.dispose();
      }
    }
  }

  /// A single listener for unity ad state which will be called
  /// every time unity ad is completed, failed or loaded
  void _onUnityAdListener(UnityAdState state, dynamic args) {
    for (final ad in _allAds) {
      if (ad is EasyUnityAdBase) ad.onUnityAdListener(state, args);
    }
  }

  void onAdLoadedMethod(
      AdNetwork adNetwork, AdUnitType adUnitType, Object? data) {
    print(
        'EasyAds AdLoaded: Network: $adNetwork, AdUnitType: $adUnitType, Custom Data: $data');
    onAdLoaded?.call(adNetwork, adUnitType, data);
  }

  void onAdShowedMethod(
          AdNetwork adNetwork, AdUnitType adUnitType, Object? data) =>
      onAdShowed?.call(adNetwork, adUnitType, data);
  void onAdFailedToLoadMethod(AdNetwork adNetwork, AdUnitType adUnitType,
      Object? data, String errorMessage) {
    print(
        'EasyAds AdFailedToLoad: Network: $adNetwork, AdUnitType: $adUnitType, Custom Data: $data');

    onAdFailedToLoad?.call(adNetwork, adUnitType, data, errorMessage);
  }

  void onAdFailedToShowMethod(AdNetwork adNetwork, AdUnitType adUnitType,
          Object? data, String errorMessage) =>
      onAdFailedToShow?.call(adNetwork, adUnitType, data, errorMessage);
  void onAdDismissedMethod(
          AdNetwork adNetwork, AdUnitType adUnitType, Object? data) =>
      onAdDismissed?.call(adNetwork, adUnitType, data);
  void _onEarnedRewardMethod(AdNetwork adNetwork, AdUnitType adUnitType,
          String? rewardType, num? rewardAmount) =>
      onEarnedReward?.call(adNetwork, adUnitType, rewardType, rewardAmount);
}
