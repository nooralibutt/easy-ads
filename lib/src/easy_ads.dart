import 'dart:async';

import 'package:collection/collection.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/easy_admob/easy_admob_interstitial_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/easy_admob_rewarded_ad.dart';
import 'package:easy_ads_flutter/src/ad_event.dart';
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

  /// Google admob's ad request
  AdRequest _adRequest = const AdRequest();
  late final IAdIdManager adIdManager;

  EasyAdNetworkInitialized? onAdNetworkInitialized;
  EasyAdCallback? onAdLoaded;
  EasyAdCallback? onAdDismissed;
  EasyAdCallback? onAdShowed;
  EasyAdFailedCallback? onAdFailedToLoad;
  EasyAdFailedCallback? onAdFailedToShow;
  EasyAdEarnedReward? onEarnedReward;

  final _onEventController = StreamController<AdEvent>.broadcast();
  Stream<AdEvent> get onEvent => _onEventController.stream;

  List<EasyAdBase> get _allAds => [..._interstitialAds, ..._rewardedAds];

  /// All the interstitial ads will be stored in it
  final List<EasyAdBase> _interstitialAds = [];

  /// All the rewarded ads will be stored in it
  final List<EasyAdBase> _rewardedAds = [];

  /// Initializes the Google Mobile Ads SDK.
  ///
  /// Call this method as early as possible after the app launches
  Future<void> initialize(IAdIdManager manager,
      {bool testMode = false,
      AdRequest? adMobAdRequest,
      RequestConfiguration? admobConfiguration}) async {
    adIdManager = manager;
    if (adMobAdRequest != null) {
      _adRequest = adMobAdRequest;
    }

    if (admobConfiguration != null) {
      MobileAds.instance.updateRequestConfiguration(admobConfiguration);
    }

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

  /// Returns [EasyAdBase] if ad is created successfully. It assumes that you have already assigned banner id in Ad Id Manager
  ///
  /// if [adNetwork] is provided, only that network's ad would be created. For now, only unity and admob banner is supported
  /// [adSize] is used to provide ad banner size
  EasyAdBase? createBanner(
      {required AdNetwork adNetwork, AdSize adSize = AdSize.banner}) {
    assert(adNetwork == AdNetwork.unity || adNetwork == AdNetwork.admob,
        'Only admob and unity banners are available right now');

    EasyAdBase? ad;
    switch (adNetwork) {
      case AdNetwork.admob:
        final bannerId = adIdManager.admobAdIds?.bannerId;
        assert(bannerId != null,
            'You are trying to create a banner and Admob Banner id is null in ad id manager');
        if (bannerId != null) {
          return EasyAdmobBannerAd(bannerId,
              adSize: adSize, adRequest: _adRequest);
        }
        break;
      case AdNetwork.unity:
        final bannerId = adIdManager.unityAdIds?.bannerId;
        assert(bannerId != null,
            'You are trying to create a banner and Unity Banner id is null in ad id manager');
        if (bannerId != null) {
          return EasyUnityBannerAd(bannerId, adSize: adSize);
        }
        break;
      default:
        ad = null;
    }
    return ad;
  }

  Future<void> _initAdmob({
    String? interstitialAdUnitId,
    String? rewardedAdUnitId,
    bool immersiveModeEnabled = true,
  }) async {
    // init interstitial ads
    if (interstitialAdUnitId != null &&
        _interstitialAds.doesNotContain(
            AdNetwork.admob, AdUnitType.interstitial)) {
      final interstitialAd = EasyAdmobInterstitialAd(
          interstitialAdUnitId, _adRequest, immersiveModeEnabled);
      _interstitialAds.add(interstitialAd);

      // overriding the callbacks
      interstitialAd.onAdLoaded = _onAdLoadedMethod;
      interstitialAd.onAdFailedToLoad = _onAdFailedToLoadMethod;
      interstitialAd.onAdShowed = _onAdShowedMethod;
      interstitialAd.onAdFailedToShow = _onAdFailedToShowMethod;
      interstitialAd.onAdDismissed = _onAdDismissedMethod;

      await interstitialAd.load();
    }

    // init rewarded ads
    if (rewardedAdUnitId != null &&
        _rewardedAds.doesNotContain(AdNetwork.admob, AdUnitType.rewarded)) {
      final rewardedAd = EasyAdmobRewardedAd(
          rewardedAdUnitId, _adRequest, immersiveModeEnabled);
      _rewardedAds.add(rewardedAd);

      // overriding the callbacks
      rewardedAd.onAdLoaded = _onAdLoadedMethod;
      rewardedAd.onAdFailedToLoad = _onAdFailedToLoadMethod;
      rewardedAd.onAdShowed = _onAdShowedMethod;
      rewardedAd.onAdFailedToShow = _onAdFailedToShowMethod;
      rewardedAd.onAdDismissed = _onAdDismissedMethod;
      rewardedAd.onEarnedReward = _onEarnedRewardMethod;

      await rewardedAd.load();
    }
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
      interstitialAd.onAdLoaded = _onAdLoadedMethod;
      interstitialAd.onAdFailedToLoad = _onAdFailedToLoadMethod;
      interstitialAd.onAdShowed = _onAdShowedMethod;
      interstitialAd.onAdFailedToShow = _onAdFailedToShowMethod;
      interstitialAd.onAdDismissed = _onAdDismissedMethod;

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
      rewardedAd.onAdLoaded = _onAdLoadedMethod;
      rewardedAd.onAdFailedToLoad = _onAdFailedToLoadMethod;
      rewardedAd.onAdShowed = _onAdShowedMethod;
      rewardedAd.onAdFailedToShow = _onAdFailedToShowMethod;
      rewardedAd.onAdDismissed = _onAdDismissedMethod;
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
      interstitialAd.onAdLoaded = _onAdLoadedMethod;
      interstitialAd.onAdFailedToLoad = _onAdFailedToLoadMethod;
      interstitialAd.onAdShowed = _onAdShowedMethod;
      interstitialAd.onAdFailedToShow = _onAdFailedToShowMethod;
      interstitialAd.onAdDismissed = _onAdDismissedMethod;

      await interstitialAd.load();
    }

    // init interstitial ads
    if (rewardedPlacementId != null &&
        _rewardedAds.doesNotContain(AdNetwork.unity, AdUnitType.rewarded)) {
      final rewardedAd = EasyUnityAd(rewardedPlacementId, AdUnitType.rewarded);
      _rewardedAds.add(rewardedAd);

      // overriding the callbacks
      rewardedAd.onAdLoaded = _onAdLoadedMethod;
      rewardedAd.onAdFailedToLoad = _onAdFailedToLoadMethod;
      rewardedAd.onAdShowed = _onAdShowedMethod;
      rewardedAd.onAdFailedToShow = _onAdFailedToShowMethod;
      rewardedAd.onAdDismissed = _onAdDismissedMethod;

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

  /// if [adNetwork] is provided, only that network's ad would be loaded
  void loadInterstitialAd({AdNetwork adNetwork = AdNetwork.any}) {
    for (final e in _interstitialAds) {
      if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
        e.load();
      }
    }
  }

  /// Returns bool indicating whether ad has been loaded
  ///
  /// if [adNetwork] is provided, only that network's ad would be checked
  bool isInterstitialAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = _interstitialAds.firstWhereOrNull((e) =>
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
        e.isAdLoaded);
    return ad?.isAdLoaded ?? false;
  }

  /// Returns bool indicating whether ad has been displayed successfully or not
  ///
  /// if [adNetwork] is provided, only that network's ad would be displayed
  /// if [random] is true, any random loaded ad would be displayed
  bool showInterstitialAd(
      {AdNetwork adNetwork = AdNetwork.any, bool random = false}) {
    final List<EasyAdBase> ads;
    if (random) {
      ads = _interstitialAds.toList()..shuffle();
    } else {
      ads = _interstitialAds;
    }

    final ad = ads.firstWhereOrNull((e) =>
        e.isAdLoaded &&
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork));
    ad?.show();

    return ad != null;
  }

  /// if [adNetwork] is provided, only that network's ad would be loaded
  void loadRewardedAd({AdNetwork adNetwork = AdNetwork.any}) {
    for (final e in _rewardedAds) {
      if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
        e.load();
      }
    }
  }

  /// Returns bool indicating whether ad has been loaded
  ///
  /// if [adNetwork] is provided, only that network's ad would be checked
  bool isRewardedAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = _rewardedAds.firstWhereOrNull((e) =>
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
        e.isAdLoaded);
    return ad?.isAdLoaded ?? false;
  }

  /// Returns bool indicating whether ad has been displayed successfully or not
  ///
  /// if [adNetwork] is provided, only that network's ad would be showed
  bool showRewardedAd({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = _rewardedAds.firstWhereOrNull((e) =>
        e.isAdLoaded &&
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork));
    ad?.show();

    return ad != null;
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

  void _onAdLoadedMethod(
      AdNetwork adNetwork, AdUnitType adUnitType, Object? data) {
    print(
        'EasyAds AdLoaded: Network: $adNetwork, AdUnitType: $adUnitType, Custom Data: $data');

    _onEventController.add(AdEvent(
      type: AdEventType.adLoaded,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: data,
    ));

    onAdLoaded?.call(adNetwork, adUnitType, data);
  }

  void _onAdShowedMethod(
      AdNetwork adNetwork, AdUnitType adUnitType, Object? data) {
    _onEventController.add(AdEvent(
      type: AdEventType.adShowed,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: data,
    ));

    onAdShowed?.call(adNetwork, adUnitType, data);
  }

  void _onAdFailedToLoadMethod(AdNetwork adNetwork, AdUnitType adUnitType,
      Object? data, String errorMessage) {
    print(
        'EasyAds AdFailedToLoad: Network: $adNetwork, AdUnitType: $adUnitType, Custom Data: $data');

    _onEventController.add(AdEvent(
      type: AdEventType.adFailedToLoad,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: data,
      error: errorMessage,
    ));

    onAdFailedToLoad?.call(adNetwork, adUnitType, data, errorMessage);
  }

  void _onAdFailedToShowMethod(AdNetwork adNetwork, AdUnitType adUnitType,
      Object? data, String errorMessage) {
    _onEventController.add(AdEvent(
      type: AdEventType.adFailedToShow,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: data,
      error: errorMessage,
    ));

    onAdFailedToShow?.call(adNetwork, adUnitType, data, errorMessage);
  }

  void _onAdDismissedMethod(
      AdNetwork adNetwork, AdUnitType adUnitType, Object? data) {
    _onEventController.add(AdEvent(
      type: AdEventType.adDismissed,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: data,
    ));

    onAdDismissed?.call(adNetwork, adUnitType, data);
  }

  void _onEarnedRewardMethod(AdNetwork adNetwork, AdUnitType adUnitType,
      String? rewardType, num? rewardAmount) {
    _onEventController.add(AdEvent(
      type: AdEventType.earnedReward,
      adNetwork: adNetwork,
      adUnitType: adUnitType,
      data: {'rewardType': rewardType, 'rewardAmount': rewardAmount},
    ));

    onEarnedReward?.call(adNetwork, adUnitType, rewardType, rewardAmount);
  }
}
