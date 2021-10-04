import 'package:flutter/foundation.dart';

enum AdUnitType {
  banner,
  interstitial,
  rewarded,
}

extension AdUnitTypeExtension on AdUnitType {
  String get value => describeEnum(this);
}
