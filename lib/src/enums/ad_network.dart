enum AdNetwork { any, admob, appLovin, facebook }

extension AdNetworkExtension on AdNetwork {
  String get value => name;
}
