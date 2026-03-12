import 'dart:async';

import 'package:collection/collection.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:easy_ads_flutter/src/easy_admob/easy_admob_interstitial_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/easy_admob_rewarded_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/jit_app_open_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/jit_interstitial_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/jit_rewarded_ad.dart';
import 'package:easy_ads_flutter/src/easy_admob/native_ad_widget.dart';
import 'package:easy_ads_flutter/src/utils/auto_hiding_loader_dialog.dart';
import 'package:easy_ads_flutter/src/utils/easy_event_controller.dart';
import 'package:easy_ads_flutter/src/utils/easy_logger.dart';
import 'package:easy_ads_flutter/src/utils/extensions.dart';
import 'package:flutter/material.dart';

class EasyAds {
  EasyAds._easyAds();
  late final bool autoLoadAds;
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
  Future<void> initialize(
    IAdIdManager manager, {
    bool isShowAppOpenOnAppStateChange = false,
    AdRequest? adMobAdRequest,
    RequestConfiguration? admobConfiguration,
    bool enableLogger = true,
    bool showAdBadge = false,
    bool autoLoadAds = true,
  }) async {
    autoLoadAds = autoLoadAds;
    _showAdBadge = showAdBadge;
    if (enableLogger) _logger.enable(enableLogger);
    adIdManager = manager;
    if (adMobAdRequest != null) {
      _adRequest = adMobAdRequest;
    }

    if (admobConfiguration != null) {
      MobileAds.instance.updateRequestConfiguration(admobConfiguration);
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
  EasyAdBase? createBanner({AdSize adSize = AdSize.banner}) {
    EasyAdBase? ad;

    final bannerId = adIdManager.admobAdIds?.bannerId;
    assert(
      bannerId != null,
      'You are trying to create a banner and Admob Banner id is null in ad id manager',
    );
    if (bannerId != null) {
      ad = EasyAdmobBannerAd(bannerId, adSize: adSize, adRequest: _adRequest);
      _eventController.setupEvents(ad);
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
    if (appOpenAdUnitId != null &&
        _appOpenAds.doesNotContain(AdUnitType.appOpen)) {
      final appOpenAdManager = EasyAdmobAppOpenAd(appOpenAdUnitId, _adRequest);
      if (isShowAppOpenOnAppStateChange) {
        _appLifecycleReactor = AppLifecycleReactor(
          appOpenAdManager: appOpenAdManager,
        );
        _appLifecycleReactor.listenToAppStateChanges();
      }
      await appOpenAdManager.load();
      _appOpenAds.add(appOpenAdManager);
      _eventController.setupEvents(appOpenAdManager);
    }
    if (autoLoadAds == false) return;
    // init interstitial ads
    if (interstitialAdUnitId != null &&
        _interstitialAds.doesNotContain(AdUnitType.interstitial)) {
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
        _rewardedAds.doesNotContain(AdUnitType.rewarded)) {
      final ad = EasyAdmobRewardedAd(
        rewardedAdUnitId,
        _adRequest,
        immersiveModeEnabled,
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
  /// if [loaderDuration] is > 0 then it will show loader before showing ad, and use [loaderDuration] in seconds. Also, you have to provide build context.
  bool showAd(
    AdUnitType adUnitType, {
    int loaderDuration = 0,
    BuildContext? context,
  }) {
    if (loaderDuration > 0) {
      assert(
        context != null,
        'Loader duration is greater than zero, context has to be provided in order to show dialog',
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

    for (final ad in ads) {
      if (ad.isAdLoaded) {
        if (ad.adUnitType == AdUnitType.interstitial &&
            loaderDuration > 0 &&
            context != null) {
          showLoaderDialog(context, loaderDuration).then((_) => ad.show());
        } else {
          ad.show();
        }
        return true;
      } else {
        _logger.logInfo('${ad.adUnitType} was not loaded, so called loading');
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
  void loadAd({AdUnitType? adUnitType}) {
    if (adUnitType == null || adUnitType == AdUnitType.rewarded) {
      for (final e in _rewardedAds) {
        e.load();
      }
    }

    if (adUnitType == null || adUnitType == AdUnitType.interstitial) {
      for (final e in _interstitialAds) {
        e.load();
      }
    }

    if (adUnitType == null || adUnitType == AdUnitType.appOpen) {
      for (final e in _appOpenAds) {
        e.load();
      }
    }
  }

  /// Returns bool indicating whether ad has been loaded
  ///
  /// if [adNetwork] is provided, only that network's ad would be checked
  bool isRewardedAdLoaded() {
    final ad = _rewardedAds.firstWhereOrNull((e) => e.isAdLoaded);
    return ad?.isAdLoaded ?? false;
  }

  /// Returns bool indicating whether ad has been loaded
  ///
  /// if [adNetwork] is provided, only that network's ad would be checked
  bool isInterstitialAdLoaded() {
    final ad = _interstitialAds.firstWhereOrNull((e) => e.isAdLoaded);
    return ad?.isAdLoaded ?? false;
  }

  /// Returns bool indicating whether ad has been loaded
  ///
  /// if [adNetwork] is provided, only that network's ad would be checked
  bool isAppOpenAdLoaded() {
    final ad = _appOpenAds.firstWhereOrNull((e) => e.isAdLoaded);
    return ad?.isAdLoaded ?? false;
  }

  /// Do not call this method until unless you want to remove ads entirely from the app.
  /// Best user case for this method could be removeAds In app purchase.
  ///
  /// After this, ads would stop loading. You would have to call initialize again.
  ///
  /// if [adNetwork] is provided only that network's ads will be disposed otherwise it will be ignored
  /// if [adUnitType] is provided only that ad unit type will be disposed, otherwise it will be ignored
  void destroyAds({AdUnitType? adUnitType}) {
    for (final e in _allAds) {
      if (adUnitType == null || adUnitType == e.adUnitType) {
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
