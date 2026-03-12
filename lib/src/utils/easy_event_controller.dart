import 'dart:async';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';

/// Easy Event controller manages events received from all type of ad units
class EasyEventController {
  Stream<AdEvent> get onEvent => _onEventController.stream;
  final _onEventController = StreamController<AdEvent>.broadcast();

  void fireNetworkInitializedEvent(bool status) {
    _onEventController.add(
      AdEvent(type: AdEventType.adNetworkInitialized, data: status),
    );
  }

  void setupEvents(EasyAdBase ad) {
    ad.onAdLoaded = _onAdLoadedMethod;
    ad.onAdFailedToLoad = _onAdFailedToLoadMethod;
    ad.onAdShowed = _onAdShowedMethod;
    ad.onAdFailedToShow = _onAdFailedToShowMethod;
    ad.onAdDismissed = _onAdDismissedMethod;
    ad.onEarnedReward = _onEarnedRewardMethod;
  }

  void _onAdLoadedMethod(AdUnitType adUnitType, Object? data) {
    _onEventController.add(
      AdEvent(type: AdEventType.adLoaded, adUnitType: adUnitType, data: data),
    );
  }

  void _onAdShowedMethod(AdUnitType adUnitType, Object? data) {
    _onEventController.add(
      AdEvent(type: AdEventType.adShowed, adUnitType: adUnitType, data: data),
    );
  }

  void _onAdFailedToLoadMethod(
    AdUnitType adUnitType,
    Object? data,
    String errorMessage,
  ) {
    _onEventController.add(
      AdEvent(
        type: AdEventType.adFailedToLoad,
        adUnitType: adUnitType,
        data: data,
        error: errorMessage,
      ),
    );
  }

  void _onAdFailedToShowMethod(
    AdUnitType adUnitType,
    Object? data,
    String errorMessage,
  ) {
    _onEventController.add(
      AdEvent(
        type: AdEventType.adFailedToShow,
        adUnitType: adUnitType,
        data: data,
        error: errorMessage,
      ),
    );
  }

  void _onAdDismissedMethod(AdUnitType adUnitType, Object? data) {
    _onEventController.add(
      AdEvent(
        type: AdEventType.adDismissed,
        adUnitType: adUnitType,
        data: data,
      ),
    );
  }

  void _onEarnedRewardMethod(
    AdUnitType adUnitType,
    String? rewardType,
    num? rewardAmount,
  ) {
    _onEventController.add(
      AdEvent(
        type: AdEventType.earnedReward,
        adUnitType: adUnitType,
        data: {'rewardType': rewardType, 'rewardAmount': rewardAmount},
      ),
    );
  }
}
