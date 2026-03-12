enum AdEventType {
  /// When ad network is initialized and ready to load ad units this will be triggered
  /// In case of [adNetworkInitialized], [AdEvent.data] will have a boolean value indicating status of initialization
  adNetworkInitialized,

  /// When ad unit is loaded, this will be triggered
  adLoaded,

  /// When user clicks cross button and close the ad, this will be triggered
  adDismissed,
  adShowed,
  adFailedToLoad,
  adFailedToShow,
  earnedReward,
}

extension AdEventTypeExtension on AdEventType {
  String get value => name;
}
