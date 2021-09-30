import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';

enum AdEventType {
  adNetworkInitialized,
  adLoaded,
  adDismissed,
  adShowed,
  adFailedToLoad,
  adFailedToShow,
  earnedReward,
}

class AdEvent {
  final AdEventType type;
  final AdNetwork adNetwork;
  final AdUnitType adUnitType;

  /// Any custom data along with the event
  final Object? data;

  /// In case of [AdEventType.adFailedToLoad] & [AdEventType.adFailedToShow] or in any error case
  final String? error;

  AdEvent({
    required this.type,
    required this.adNetwork,
    required this.adUnitType,
    this.data,
    this.error,
  });
}
