import 'package:flutter/foundation.dart';

enum AdUnitType {
  banner,
  interstitial,
  rewarded,
}

extension AdNetworkExtension on AdUnitType {
  String get value => describeEnum(this);
}
