import 'package:flutter/foundation.dart';

enum AdNetwork {
  Default,
  Admob,
  Facebook,
  AppLovin,
  Unity,
}

extension AdNetworkExtension on AdNetwork {
  String get value => describeEnum(this);
}
