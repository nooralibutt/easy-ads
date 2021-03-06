import 'dart:async';

import 'package:collection/collection.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:easy_ads_flutter/src/easy_admob/easy_admob_interstitial_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/easy_admob_rewarded_ad.dart';
import 'package:easy_ads_flutter/src/easy_applovin/easy_applovin_ad.dart';
import 'package:easy_ads_flutter/src/easy_facebook/easy_facebook_banner_ad.dart';
import 'package:easy_ads_flutter/src/easy_facebook/easy_facebook_full_screen_ad.dart';
import 'package:easy_ads_flutter/src/easy_unity/easy_unity_ad.dart';
import 'package:easy_ads_flutter/src/utils/easy_event_controller.dart';
import 'package:easy_ads_flutter/src/utils/easy_logger.dart';
import 'package:easy_ads_flutter/src/utils/extensions.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class EasyAds {
  EasyAds._easyAds();
  static final EasyAds instance = EasyAds._easyAds();

  /// Google admob's ad request
  AdRequest _adRequest = const AdRequest();
  late final IAdIdManager adIdManager;

  final _eventController = EasyEventController();
  Stream<AdEvent> get onEvent => _eventController.onEvent;

  List<EasyAdBase> get _allAds => [..._interstitialAds, ..._rewardedAds];

  /// All the interstitial ads will be stored in it
  final List<EasyAdBase> _interstitialAds = [];

  /// All the rewarded ads will be stored in it
  final List<EasyAdBase> _rewardedAds = [];

  /// [_logger] is used to show Ad logs in the console
  final EasyLogger _logger = EasyLogger();

  /// Initializes the Google Mobile Ads SDK.
  ///
  /// Call this method as early as possible after the app launches
  /// [adMobAdRequest] will be used in all the admob requests. By default empty request will be used if nothing passed here.
  /// [fbTestingId] can be obtained by running the app once without the testingId.
  Future<void> initialize(
    IAdIdManager manager, {
    bool unityTestMode = false,
    AdRequest? adMobAdRequest,
    RequestConfiguration? admobConfiguration,
    bool enableLogger = true,
    String? fbTestingId,
    bool fbiOSAdvertiserTrackingEnabled = false,
  }) async {
    if (enableLogger) _logger.enable(enableLogger);
    adIdManager = manager;
    if (adMobAdRequest != null) {
      _adRequest = adMobAdRequest;
    }

    if (admobConfiguration != null) {
      MobileAds.instance.updateRequestConfiguration(admobConfiguration);
    }

    if (manager.fbAdIds?.appId != null) {
      _initFacebook(
        testingId: fbTestingId,
        iOSAdvertiserTrackingEnabled: fbiOSAdvertiserTrackingEnabled,
        interstitialPlacementId: manager.fbAdIds?.interstitialId,
        rewardedPlacementId: manager.fbAdIds?.rewardedId,
      );
    }

    if (manager.admobAdIds?.appId != null) {
      final response = await MobileAds.instance.initialize();
      final status = response.adapterStatuses.values.firstOrNull?.state;

      _eventController.fireNetworkInitializedEvent(
          AdNetwork.admob, status == AdapterInitializationState.ready);

      // Initializing admob Ads
      EasyAds.instance._initAdmob(
        interstitialAdUnitId: manager.admobAdIds?.interstitialId,
        rewardedAdUnitId: manager.admobAdIds?.rewardedId,
      );
    }

    final unityGameId = manager.unityAdIds?.appId;
    if (unityGameId != null) {
      EasyAds.instance._initUnity(
        unityGameId: unityGameId,
        testMode: unityTestMode,
        interstitialPlacementId: manager.unityAdIds?.interstitialId,
        rewardedPlacementId: manager.unityAdIds?.rewardedId,
      );
    }

    final appLovinSdkId = manager.appLovinAdIds?.appId;
    if (appLovinSdkId != null) {
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
    assert(
        adNetwork == AdNetwork.unity ||
            adNetwork == AdNetwork.admob ||
            adNetwork == AdNetwork.facebook,
        'Only admob, unity and facebook banners are available right now');

    EasyAdBase? ad;
    switch (adNetwork) {
      case AdNetwork.admob:
        final bannerId = adIdManager.admobAdIds?.bannerId;
        assert(bannerId != null,
            'You are trying to create a banner and Admob Banner id is null in ad id manager');
        if (bannerId != null) {
          ad = EasyAdmobBannerAd(bannerId,
              adSize: adSize, adRequest: _adRequest);
          _eventController.setupEvents(ad);
        }
        break;
      case AdNetwork.unity:
        final bannerId = adIdManager.unityAdIds?.bannerId;
        assert(bannerId != null,
            'You are trying to create a banner and Unity Banner id is null in ad id manager');
        if (bannerId != null) {
          ad = EasyUnityBannerAd(bannerId, adSize: adSize);
          _eventController.setupEvents(ad);
        }
        break;
      case AdNetwork.facebook:
        final bannerId = adIdManager.fbAdIds?.interstitialId;
        assert(bannerId != null,
            'You are trying to create a banner and Facebook Banner id is null in ad id manager');
        if (bannerId != null) {
          return EasyFacebookBannerAd(bannerId, adSize: adSize);
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
      final ad = EasyAdmobInterstitialAd(
          interstitialAdUnitId, _adRequest, immersiveModeEnabled);
      _interstitialAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }

    // init rewarded ads
    if (rewardedAdUnitId != null &&
        _rewardedAds.doesNotContain(AdNetwork.admob, AdUnitType.rewarded)) {
      final ad = EasyAdmobRewardedAd(
          rewardedAdUnitId, _adRequest, immersiveModeEnabled);
      _rewardedAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
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
      final ad = EasyApplovinFullScreenAd(
          interstitialAdUnitId, AdUnitType.interstitial);
      _interstitialAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.initialize();
      await ad.load();
    }

    // init rewarded ads
    if (rewardedAdUnitId != null &&
        _rewardedAds.doesNotContain(AdNetwork.appLovin, AdUnitType.rewarded)) {
      final ad =
          EasyApplovinFullScreenAd(rewardedAdUnitId, AdUnitType.rewarded);
      _rewardedAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.initialize();
      await ad.load();
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
    // placementId
    if (unityGameId != null) {
      await UnityAds.init(
        gameId: unityGameId,
        testMode: testMode,
        onComplete: () =>
            _eventController.fireNetworkInitializedEvent(AdNetwork.unity, true),
        onFailed: (UnityAdsInitializationError error, String s) =>
            _eventController.fireNetworkInitializedEvent(
                AdNetwork.unity, false),
      );
    }

    // init interstitial ads
    if (interstitialPlacementId != null &&
        _interstitialAds.doesNotContain(
            AdNetwork.unity, AdUnitType.interstitial)) {
      final ad = EasyUnityAd(interstitialPlacementId, AdUnitType.interstitial);
      _interstitialAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }

    // init rewarded ads
    if (rewardedPlacementId != null &&
        _rewardedAds.doesNotContain(AdNetwork.unity, AdUnitType.rewarded)) {
      final ad = EasyUnityAd(rewardedPlacementId, AdUnitType.rewarded);
      _rewardedAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }
  }

  Future _initFacebook({
    required bool iOSAdvertiserTrackingEnabled,
    String? testingId,
    String? interstitialPlacementId,
    String? rewardedPlacementId,
  }) async {
    final status = await FacebookAudienceNetwork.init(
        testingId: testingId,
        iOSAdvertiserTrackingEnabled: iOSAdvertiserTrackingEnabled);

    _eventController.fireNetworkInitializedEvent(
        AdNetwork.facebook, status ?? false);

    // init interstitial ads
    if (interstitialPlacementId != null &&
        _interstitialAds.doesNotContain(
            AdNetwork.facebook, AdUnitType.interstitial)) {
      final ad = EasyFacebookFullScreenAd(
          interstitialPlacementId, AdUnitType.interstitial);
      _interstitialAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }

    // init rewarded ads
    if (rewardedPlacementId != null &&
        _rewardedAds.doesNotContain(AdNetwork.facebook, AdUnitType.rewarded)) {
      final ad =
          EasyFacebookFullScreenAd(rewardedPlacementId, AdUnitType.rewarded);
      _rewardedAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }
  }

  /// Displays random ad network [adUnitType] ad.
  /// It will randomly display one network and if that network's ad is not loaded, it will try second and so on until it exhaust all the network ads.
  /// Returns bool indicating whether ad has been successfully displayed or not
  ///
  /// [adUnitType] should be mentioned here, only interstitial or rewarded should be mentioned here
  bool showRandomAd(AdUnitType adUnitType) {
    assert(
        adUnitType == AdUnitType.interstitial ||
            adUnitType == AdUnitType.rewarded,
        'Only interstitial and rewarded types should be passed to this method');

    final List<EasyAdBase> ads = (adUnitType == AdUnitType.rewarded
            ? _rewardedAds
            : _interstitialAds)
        .toList(growable: false)
      ..shuffle();

    for (final ad in ads) {
      if (ad.isAdLoaded) {
        ad.show();
        return true;
      } else {
        _logger.logInfo(
            '${ad.adNetwork} ${ad.adUnitType} was not loaded, so called loading');
        ad.load();
      }
    }

    return false;
  }

  /// Displays [adUnitType] ad from [adNetwork]. It will check if first ad it found from list is loaded,
  /// it will be displayed if [adNetwork] is not mentioned otherwise it will load the ad.
  ///
  /// Returns bool indicating whether ad has been successfully displayed or not
  ///
  /// [adUnitType] should be mentioned here, only interstitial or rewarded should be mentioned here
  /// if [adNetwork] is provided, only that network's ad would be displayed
  /// if [random] is true, any random loaded ad would be displayed
  bool showAd(AdUnitType adUnitType, {AdNetwork adNetwork = AdNetwork.any}) {
    assert(
        adUnitType == AdUnitType.interstitial ||
            adUnitType == AdUnitType.rewarded,
        'Only interstitial and rewarded types should be passed to this method');

    final List<EasyAdBase> ads =
        adUnitType == AdUnitType.rewarded ? _rewardedAds : _interstitialAds;

    for (final ad in ads) {
      if (ad.isAdLoaded) {
        if (adNetwork == AdNetwork.any || adNetwork == ad.adNetwork) {
          ad.show();
          return true;
        }
      } else {
        _logger.logInfo(
            '${ad.adNetwork} ${ad.adUnitType} was not loaded, so called loading');
        ad.load();
      }
    }

    return false;
  }

  /// This will load both rewarded and interstitial ads.
  /// If a particular ad is already loaded, it will not load it again.
  /// Also you do not have to call this method everytime. Ad is automatically loaded after being displayed.
  ///
  /// if [adNetwork] is provided, only that network's ad would be loaded
  void loadAd({AdNetwork adNetwork = AdNetwork.any}) {
    for (final e in _rewardedAds) {
      if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
        e.load();
      }
    }

    for (final e in _interstitialAds) {
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

  /// Returns bool indicating whether ad has been loaded
  ///
  /// if [adNetwork] is provided, only that network's ad would be checked
  bool isInterstitialAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = _interstitialAds.firstWhereOrNull((e) =>
        (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
        e.isAdLoaded);
    return ad?.isAdLoaded ?? false;
  }

  /// Do not call this method until unless you want to remove ads entirely from the app.
  /// Best user case for this method could be removeAds In app purchase.
  ///
  /// After this, ads would stop loading. You would have to call initialize again.
  ///
  /// if [adNetwork] is provided only that network's ads will be disposed otherwise it will be ignored
  /// if [adUnitType] is provided only that ad unit type will be disposed, otherwise it will be ignored
  void destroyAds(
      {AdNetwork adNetwork = AdNetwork.any, AdUnitType? adUnitType}) {
    for (final e in _allAds) {
      if ((adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
          (adUnitType == null || adUnitType == e.adUnitType)) {
        e.dispose();
      }
    }
  }
}
