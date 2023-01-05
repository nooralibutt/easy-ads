import 'dart:async';

import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

class EasySmartBannerAd extends StatefulWidget {
  const EasySmartBannerAd({Key? key}) : super(key: key);

  @override
  State<EasySmartBannerAd> createState() => _EasySmartBannerAdState();
}

class _EasySmartBannerAdState extends State<EasySmartBannerAd> {
  final adNetworks = [
    AdNetwork.admob,
    AdNetwork.facebook,
    AdNetwork.appLovin,
    AdNetwork.unity,
  ];
  int index = 0;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    isAdAvailable();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isBannerIdAvailable(adNetworks[index]);
  }

  void isAdAvailable() {
    _streamSubscription?.cancel();
    _streamSubscription = EasyAds.instance.onEvent.listen((event) {
      if (event.adUnitType == AdUnitType.banner &&
          event.type == AdEventType.adFailedToLoad) {
        _streamSubscription?.cancel();
        if (index >= 4) index = 0;
        index++;
        setState(() {});
      }
    });
  }

  Widget isBannerIdAvailable(AdNetwork adNetwork) {
    final adIdManager = EasyAds.instance.adIdManager;
    if (adNetwork == AdNetwork.admob &&
        adIdManager.admobAdIds?.bannerId != null) {
      index = 0;
      return const EasyBannerAd(adNetwork: AdNetwork.admob);
    } else if (adNetwork == AdNetwork.facebook &&
        adIdManager.fbAdIds?.bannerId != null) {
      index = 1;
      return const EasyBannerAd(adNetwork: AdNetwork.facebook);
    } else if (adNetwork == AdNetwork.appLovin &&
        adIdManager.appLovinAdIds?.bannerId != null) {
      index = 2;
      return const EasyBannerAd(adNetwork: AdNetwork.appLovin);
    } else if (adNetwork == AdNetwork.unity &&
        adIdManager.unityAdIds?.bannerId != null) {
      index = 3;
      return const EasyBannerAd(adNetwork: AdNetwork.unity);
    } else {
      if (index >= 4) index = 0;
      index++;
      Timer(const Duration(seconds: 2), () => setState(() {}));
      return const SizedBox();
    }
  }
}
