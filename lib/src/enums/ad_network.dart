enum AdNetwork { any, admob, facebook }

extension AdNetworkExtension on AdNetwork {
  String get value => name;
}
