import 'dart:async';

import 'package:collection/collection.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:easy_ads_flutter/src/easy_admob/easy_admob_interstitial_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/easy_admob_rewarded_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/jit_app_open_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/jit_interstitial_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/jit_rewarded_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/native_ad_widget.dart';
import 'package:easy_ads_flutter/src/easy_facebook/easy_facebook_full_screen_ad.dart';
import 'package:easy_ads_flutter/src/utils/auto_hiding_loader_dialog.dart';
import 'package:easy_ads_flutter/src/utils/easy_event_controller.dart';
import 'package:easy_ads_flutter/src/utils/easy_logger.dart';
import 'package:easy_ads_flutter/src/utils/extensions.dart';
import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:flutter/material.dart';

class EasyAds {
  EasyAds._easyAds();

  static final EasyAds instance = EasyAds._easyAds();

  /// Google admob's ad request
  AdRequest _adRequest = const AdRequest();
  late final IAdIdManager adIdManager;
  late AppLifecycleReactor _appLifecycleReactor;

  final _eventController = EasyEventController();

  Stream<AdEvent> get onEvent => _eventController.onEvent;

  List<EasyAdBase> get _allAds => [..._interstitialAds, ..._rewardedAds];

  /// All the interstitial ads will be stored in it
  final List<EasyAdBase> _appOpenAds = [];

  /// All the interstitial ads will be stored in it
  final List<EasyAdBase> _interstitialAds = [];

  /// All the rewarded ads will be stored in it
  final List<EasyAdBase> _rewardedAds = [];

  /// [_logger] is used to show Ad logs in the console
  final EasyLogger _logger = EasyLogger();

  /// On banner, ad badge will appear
  bool get showAdBadge => _showAdBadge;
  bool _showAdBadge = false;

  /// Initializes the Google Mobile Ads SDK.
  ///
  /// Call this method as early as possible after the app launches
  /// [adMobAdRequest] will be used in all the admob requests. By default empty request will be used if nothing passed here.
  /// [fbTestingId] can be obtained by running the app once without the testingId.
  Future<void> initialize(
    IAdIdManager manager, {
    bool fbTestMode = false,
    bool isShowAppOpenOnAppStateChange = false,
    AdRequest? adMobAdRequest,
    RequestConfiguration? admobConfiguration,
    bool enableLogger = true,
    String? fbTestingId,
    bool fbiOSAdvertiserTrackingEnabled = false,
    bool showAdBadge = false,
  }) async {
    _showAdBadge = showAdBadge;
    if (enableLogger) _logger.enable(enableLogger);
    adIdManager = manager;
    if (adMobAdRequest != null) {
      _adRequest = adMobAdRequest;
    }

    if (admobConfiguration != null) {
      MobileAds.instance.updateRequestConfiguration(admobConfiguration);
    }

    final fbAdId = manager.fbAdIds?.appId;
    if (fbAdId != null && fbAdId.isNotEmpty) {
      _initFacebook(
        testingId: fbTestingId,
        testMode: fbTestMode,
        iOSAdvertiserTrackingEnabled: fbiOSAdvertiserTrackingEnabled,
        interstitialPlacementId: manager.fbAdIds?.interstitialId,
        rewardedPlacementId: manager.fbAdIds?.rewardedId,
      );
    }

    final admobAdId = manager.admobAdIds?.appId;
    if (admobAdId != null && admobAdId.isNotEmpty) {
      final response = await MobileAds.instance.initialize();
      final status = response.adapterStatuses.values.firstOrNull?.state;

      response.adapterStatuses.forEach((key, value) {
        _logger.logInfo(
          'Google-mobile-ads Adapter status for $key: ${value.description}',
        );
      });

      _eventController.fireNetworkInitializedEvent(
        AdNetwork.admob,
        status == AdapterInitializationState.ready,
      );

      // Initializing admob Ads
      await EasyAds.instance._initAdmob(
        appOpenAdUnitId: manager.admobAdIds?.appOpenId,
        interstitialAdUnitId: manager.admobAdIds?.interstitialId,
        rewardedAdUnitId: manager.admobAdIds?.rewardedId,
        isShowAppOpenOnAppStateChange: isShowAppOpenOnAppStateChange,
      );
    }
  }

  /// Returns [EasyAdBase] if ad is created successfully. It assumes that you have already assigned banner id in Ad Id Manager
  ///
  /// if [adNetwork] is provided, only that network's ad would be created. For now, only unity and admob banner is supported
  /// [adSize] is used to provide ad banner size
  EasyAdBase? createBanner({
    required AdNetwork adNetwork,
    AdSize adSize = AdSize.banner,
  }) {
    EasyAdBase? ad;

    switch (adNetwork) {
      case AdNetwork.admob:
        final bannerId = adIdManager.admobAdIds?.bannerId;
        assert(
          bannerId != null,
          'You are trying to create a banner and Admob Banner id is null in ad id manager',
        );
        if (bannerId != null) {
          ad = EasyAdmobBannerAd(
            bannerId,
            adSize: adSize,
            adRequest: _adRequest,
          );
          _eventController.setupEvents(ad);
        }
        break;
      default:
        ad = null;
    }
    return ad;
  }

  Future<void> _initAdmob({
    String? appOpenAdUnitId,
    String? interstitialAdUnitId,
    String? rewardedAdUnitId,
    bool immersiveModeEnabled = true,
    bool isShowAppOpenOnAppStateChange = true,
  }) async {
    // init interstitial ads
    if (interstitialAdUnitId != null &&
        _interstitialAds.doesNotContain(
          AdNetwork.admob,
          AdUnitType.interstitial,
        )) {
      final ad = EasyAdmobInterstitialAd(
        interstitialAdUnitId,
        _adRequest,
        immersiveModeEnabled,
      );
      _interstitialAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }

    // init rewarded ads
    if (rewardedAdUnitId != null &&
        _rewardedAds.doesNotContain(AdNetwork.admob, AdUnitType.rewarded)) {
      final ad = EasyAdmobRewardedAd(
        rewardedAdUnitId,
        _adRequest,
        immersiveModeEnabled,
      );
      _rewardedAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }

    if (appOpenAdUnitId != null &&
        _appOpenAds.doesNotContain(AdNetwork.admob, AdUnitType.appOpen)) {
      final appOpenAdManager = EasyAdmobAppOpenAd(appOpenAdUnitId, _adRequest);
      await appOpenAdManager.load();
      if (isShowAppOpenOnAppStateChange) {
        _appLifecycleReactor = AppLifecycleReactor(
          appOpenAdManager: appOpenAdManager,
        );
        _appLifecycleReactor.listenToAppStateChanges();
      }
      _appOpenAds.add(appOpenAdManager);
      _eventController.setupEvents(appOpenAdManager);
    }
  }

  Future _initFacebook({
    required bool iOSAdvertiserTrackingEnabled,
    required bool testMode,
    String? testingId,
    String? interstitialPlacementId,
    String? rewardedPlacementId,
  }) async {
    final status = await EasyAudienceNetwork.init(
      testingId: testingId,
      testMode: testMode,
      iOSAdvertiserTrackingEnabled: iOSAdvertiserTrackingEnabled,
    );

    _eventController.fireNetworkInitializedEvent(
      AdNetwork.facebook,
      status ?? false,
    );

    // init interstitial ads
    if (interstitialPlacementId != null &&
        _interstitialAds.doesNotContain(
          AdNetwork.facebook,
          AdUnitType.interstitial,
        )) {
      final ad = EasyFacebookFullScreenAd(
        interstitialPlacementId,
        AdUnitType.interstitial,
      );
      _interstitialAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }

    // init rewarded ads
    if (rewardedPlacementId != null &&
        _rewardedAds.doesNotContain(AdNetwork.facebook, AdUnitType.rewarded)) {
      final ad = EasyFacebookFullScreenAd(
        rewardedPlacementId,
        AdUnitType.rewarded,
      );
      _rewardedAds.add(ad);
      _eventController.setupEvents(ad);

      await ad.load();
    }
  }

  /// Displays [adUnitType] ad from [adNetwork]. It will check if first ad it found from list is loaded,
  /// it will be displayed if [adNetwork] is not mentioned otherwise it will load the ad.
  ///
  /// Returns bool indicating whether ad has been successfully displayed or not
  ///
  /// [adUnitType] should be mentioned here, only interstitial or rewarded should be mentioned here
  /// if [adNetwork] is provided, only that network's ad would be displayed
  /// if [loaderDuration] is > 0 then it will show loader before showing ad, and use [loaderDuration] in seconds. Also, you have to provide build context.
  bool showAd(
    AdUnitType adUnitType, {
    AdNetwork adNetwork = AdNetwork.any,
    int loaderDuration = 0,
    BuildContext? context,
  }) {
    if (loaderDuration > 0) {
      assert(
        context != null,
        "Loader duration is greater than zero, context has to be provided in order to show dialog",
      );
    }

    List<EasyAdBase> ads = [];
    if (adUnitType == AdUnitType.rewarded) {
      ads = _rewardedAds;
    } else if (adUnitType == AdUnitType.interstitial) {
      ads = _interstitialAds;
    } else if (adUnitType == AdUnitType.appOpen) {
      ads = _appOpenAds;
    }

    if (adNetwork != AdNetwork.any) {
      final ad = ads.firstWhereOrNull((e) => adNetwork == e.adNetwork);
      if (ad?.isAdLoaded == true) {
        if (ad?.adUnitType == AdUnitType.interstitial &&
            loaderDuration > 0 &&
            context != null) {
          showLoaderDialog(context, loaderDuration).then((_) => ad?.show());
        } else {
          ad?.show();
        }
        return true;
      } else {
        _logger.logInfo(
          '${ad?.adNetwork} ${ad?.adUnitType} was not loaded, so called loading',
        );
        ad?.load();
        return false;
      }
    }

    for (final ad in ads) {
      if (ad.isAdLoaded) {
        if (adNetwork == AdNetwork.any || adNetwork == ad.adNetwork) {
          if (ad.adUnitType == AdUnitType.interstitial &&
              loaderDuration > 0 &&
              context != null) {
            showLoaderDialog(context, loaderDuration).then((_) => ad.show());
          } else {
            ad.show();
          }
          return true;
        }
      } else {
        _logger.logInfo(
          '${ad.adNetwork} ${ad.adUnitType} was not loaded, so called loading',
        );
        ad.load();
      }
    }

    return false;
  }

  /// This will load both rewarded and interstitial ads.
  /// If a particular ad is already loaded, it will not load it again.
  /// Also you do not have to call this method everytime. Ad is automatically loaded after being displayed.
  ///
  /// if [adNetwork] is provided, only that network's ad will be loaded
  /// if [adUnitType] is provided, only that unit type will be loaded, otherwise all unit types will be loaded
  void loadAd({AdNetwork adNetwork = AdNetwork.any, AdUnitType? adUnitType}) {
    if (adUnitType == null || adUnitType == AdUnitType.rewarded) {
      for (final e in _rewardedAds) {
        if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
          e.load();
        }
      }
    }

    if (adUnitType == null || adUnitType == AdUnitType.interstitial) {
      for (final e in _interstitialAds) {
        if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
          e.load();
        }
      }
    }

    if (adUnitType == null || adUnitType == AdUnitType.appOpen) {
      for (final e in _appOpenAds) {
        if (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) {
          e.load();
        }
      }
    }
  }

  /// Returns bool indicating whether ad has been loaded
  ///
  /// if [adNetwork] is provided, only that network's ad would be checked
  bool isRewardedAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = _rewardedAds.firstWhereOrNull(
      (e) =>
          (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
          e.isAdLoaded,
    );
    return ad?.isAdLoaded ?? false;
  }

  /// Returns bool indicating whether ad has been loaded
  ///
  /// if [adNetwork] is provided, only that network's ad would be checked
  bool isInterstitialAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = _interstitialAds.firstWhereOrNull(
      (e) =>
          (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
          e.isAdLoaded,
    );
    return ad?.isAdLoaded ?? false;
  }

  /// Returns bool indicating whether ad has been loaded
  ///
  /// if [adNetwork] is provided, only that network's ad would be checked
  bool isAppOpenAdLoaded({AdNetwork adNetwork = AdNetwork.any}) {
    final ad = _appOpenAds.firstWhereOrNull(
      (e) =>
          (adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
          e.isAdLoaded,
    );
    return ad?.isAdLoaded ?? false;
  }

  /// Do not call this method until unless you want to remove ads entirely from the app.
  /// Best user case for this method could be removeAds In app purchase.
  ///
  /// After this, ads would stop loading. You would have to call initialize again.
  ///
  /// if [adNetwork] is provided only that network's ads will be disposed otherwise it will be ignored
  /// if [adUnitType] is provided only that ad unit type will be disposed, otherwise it will be ignored
  void destroyAds({
    AdNetwork adNetwork = AdNetwork.any,
    AdUnitType? adUnitType,
  }) {
    for (final e in _allAds) {
      if ((adNetwork == AdNetwork.any || adNetwork == e.adNetwork) &&
          (adUnitType == null || adUnitType == e.adUnitType)) {
        e.dispose();
      }
    }
  }

  /// Loads and immediately shows a Just-In-Time (JIT) AdMob App Open ad.
  /// Call this when you want to display an app open ad on-demand (no preloading).
  ///
  /// [onFailedToLoadOrShow] — fired if the ad fails to load or show.
  /// [onAdShowed] — fired when the ad is displayed.
  /// [onAdDismissed] — fired when the ad is closed.
  Future<void> showJitAppOpen({
    VoidCallback? onFailedToLoadOrShow,
    VoidCallback? onAdShowed,
    VoidCallback? onAdDismissed,
  }) async {
    final appOpenId = adIdManager.admobAdIds?.appOpenId;
    assert(
      appOpenId != null && appOpenId.isNotEmpty,
      'App Open Ad ID is null or empty. Set it in your Ad ID manager before showing ads.',
    );
    if (appOpenId == null || appOpenId.isEmpty) {
      _logger.logInfo('App Open Ad ID is null, skipping ad show.');
      onFailedToLoadOrShow?.call();
      return;
    }
    JitAppOpenAd(
      appOpenId,
      _adRequest,
      onFailedToLoadOrShow: onFailedToLoadOrShow,
      onAdShowed: onAdShowed,
      onAdDismissed: onAdDismissed,
    ).loadAndShow();
  }

  /// Loads and immediately shows a Just-In-Time (JIT) AdMob Interstitial ad.
  /// Call this when you want to display an interstitial ad on-demand (no preloading).
  ///
  /// [onFailedToLoadOrShow] — fired if the ad fails to load or show.
  /// [onAdShowed] — fired when the ad is displayed.
  /// [onAdDismissed] — fired when the ad is closed.
  Future<void> showJitInterstitial(
    BuildContext context, {
    VoidCallback? onFailedToLoadOrShow,
    VoidCallback? onAdShowed,
    VoidCallback? onAdDismissed,
  }) async {
    final interstitialId = adIdManager.admobAdIds?.interstitialId;
    assert(
      interstitialId != null && interstitialId.isNotEmpty,
      'Interstitial Ad ID is null or empty. Set it in your Ad ID manager before showing ads.',
    );
    if (interstitialId == null || interstitialId.isEmpty) {
      _logger.logInfo('Interstitial Ad ID is null, skipping ad show.');
      onFailedToLoadOrShow?.call();
      return;
    }
    JitInterstitialAd(
      interstitialId,
      _adRequest,
      onFailedToLoadOrShow: onFailedToLoadOrShow,
      onAdShowed: onAdShowed,
      onAdDismissed: onAdDismissed,
    ).loadAndShow(context);
  }

  /// Loads and immediately shows a Just-In-Time (JIT) AdMob Rewarded ad with optional user prompt.
  /// Handles showing loading overlay and success/error dialogs.
  ///
  /// [onEarnedReward] — called when the user earns the reward.
  Future<void> showJitRewarded(
    BuildContext context, {
    required void Function(BuildContext context) onEarnedReward,
  }) async {
    final rewardedAdId = adIdManager.admobAdIds?.rewardedId ?? '';
    assert(
      rewardedAdId.isNotEmpty,
      'Rewarded Ad ID is null or empty. Set it in your Ad ID manager before showing ads.',
    );
    if (rewardedAdId.isEmpty) {
      _logger.logInfo('Rewarded Ad ID is null or empty, skipping ad show.');
      return;
    }
    final viewModel = RewardedAdViewModel(
      rewardedAdId,
      _adRequest,
      onEarnedReward: onEarnedReward,
      context: context,
    );

    final jitAd = JitRewardedAd();
    jitAd.loadAndShowAd(context, viewModel);
  }

  /// Creates a Native Ad Widget for display.
  /// Returns a [NativeAdWidget] if the ID is valid, otherwise a placeholder widget.
  Widget createNativeAd() {
    final nativeId = adIdManager.admobAdIds?.nativeBannerId;
    assert(
      nativeId != null && nativeId.isNotEmpty,
      'Native Ad ID is null or empty. Set it in your Ad ID manager before creating native ads.',
    );
    if (nativeId == null || nativeId.isEmpty) {
      _logger.logInfo('Native Ad ID is null, returning placeholder widget.');
      return const SizedBox(
        height: 100,
        child: Center(child: Text('Native Ad Placeholder')),
      );
    }
    return NativeAdWidget(nativeId, _adRequest);
  }
}
