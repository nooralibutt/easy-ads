import 'package:ads/utils/enums/ad_network.dart';
import 'package:flutter/material.dart';

abstract class EasyAdBase {
  AdNetwork get adNetwork;

  Future init();
  dynamic show();
  void dispose();
  Future load();
  bool get isAdLoaded;
  VoidCallback onAdLoaded(AdNetwork adNetwork);
  VoidCallback onAdDisplayed(AdNetwork adNetwork);
  VoidCallback onAdFailedToLoad(AdNetwork adNetwork, String errorMessage);
  VoidCallback onAdDismissed(AdNetwork adNetwork);
  VoidCallback onEarnedReward(
      AdNetwork adNetwork, String rewardType, num rewardAmount);
}
