import 'package:easy_ads_flutter/src/enums/ad_event_type.dart';
import 'package:easy_ads_flutter/src/enums/ad_network.dart';
import 'package:easy_ads_flutter/src/enums/ad_unit_type.dart';

class AdEvent {
  final AdEventType type;
  final AdNetwork adNetwork;
  final AdUnitType? adUnitType;

  /// Any custom data along with the event
  final Object? data;

  /// In case of [AdEventType.adFailedToLoad] & [AdEventType.adFailedToShow] or in any error case
  final String? error;

  AdEvent({
    required this.type,
    required this.adNetwork,
    this.adUnitType,
    this.data,
    this.error,
  });
}
