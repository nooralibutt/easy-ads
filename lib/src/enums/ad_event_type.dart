import 'package:flutter/foundation.dart';

enum AdEventType {
  adNetworkInitialized,
  adLoaded,
  adDismissed,
  adShowed,
  adFailedToLoad,
  adFailedToShow,
  earnedReward,
}

extension AdEventTypeExtension on AdEventType {
  String get value => describeEnum(this);
}
