import 'package:flutter/foundation.dart';

enum AdNetwork {
  any,
  admob,
  facebook,
  appLovin,
  unity,
}

extension AdNetworkExtension on AdNetwork {
  String get value => describeEnum(this);
}
