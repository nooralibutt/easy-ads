enum AdNetwork { any, admob }

extension AdNetworkExtension on AdNetwork {
  String get value => name;
}
