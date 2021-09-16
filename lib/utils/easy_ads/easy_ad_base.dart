import 'package:ads/utils/enums/ad_network.dart';
import 'package:ads/utils/enums/ad_unit_type.dart';

abstract class EasyAdBase {
  final String adUnitId;

  /// This will be called for initialization when we don't have to wait for the initialization
  EasyAdBase(this.adUnitId);

  AdNetwork get adNetwork;
  AdUnitType get adUnitType;
  bool get isAdLoaded;

  /// This will be called for initialization when we have to wait for the initialization
  Future<void> init();
  void dispose();

  /// This will load ad, It will only load the ad if isAdLoaded is false
  Future<void> load();
  dynamic show();

  AdLoaded? onAdLoaded;
  AdShowed? onAdShowed;
  AdFailedToLoad? onAdFailedToLoad;
  AdFailedToShow? onAdFailedToShow;
  AdDismissed? onAdDismissed;
  EarnedReward? onEarnedReward;
}

typedef AdLoaded = void Function(AdNetwork adNetwork, Object? data);
typedef AdShowed = void Function(AdNetwork adNetwork, Object? data);
typedef AdFailedToLoad = void Function(
    AdNetwork adNetwork, String errorMessage);
typedef AdFailedToShow = void Function(
    AdNetwork adNetwork, String errorMessage, Object? data);
typedef AdDismissed = void Function(AdNetwork adNetwork, Object? data);
typedef EarnedReward = void Function(
    AdNetwork adNetwork, String rewardType, num rewardAmount);
