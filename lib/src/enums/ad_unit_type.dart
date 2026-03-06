enum AdUnitType { appOpen, banner, interstitial, rewarded }

extension AdUnitTypeExtension on AdUnitType {
  String get value => name;
}
