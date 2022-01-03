import 'package:easy_ads_flutter/src/easy_ad_base.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';

extension EasyAdBaseListExtension on List<EasyAdBase> {
  bool doesNotContain(AdNetwork adNetwork, AdUnitType type) =>
      indexWhere((e) => e.adNetwork == adNetwork && e.adUnitType == type) == -1;
}
