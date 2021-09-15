import 'package:ads/utils/enums/ad_network.dart';

abstract class EasyAdBase {
  AdNetwork get adNetwork;

  Future init();
  dynamic show();
  void dispose();
  Future load();
  bool get isAdLoaded;
  AdLoaded? onAdLoaded;
  AdDisplayed? onAdDisplayed;
  AdFailedToLoad? onAdFailedToLoad;
  AdDismissed? onAdDismissed;
  EarnedReward? onEarnedReward;
}

typedef AdLoaded = void Function(AdNetwork adNetwork);
typedef AdDisplayed = void Function(AdNetwork adNetwork);
typedef AdFailedToLoad = void Function(
    AdNetwork adNetwork, String errorMessage);
typedef AdDismissed = void Function(AdNetwork adNetwork);
typedef EarnedReward = void Function(
    AdNetwork adNetwork, String rewardType, num rewardAmount);
