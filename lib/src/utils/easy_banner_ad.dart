import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:flutter/material.dart';

class EasyBannerAd extends StatefulWidget {
  final AdNetwork adNetwork;
  final AdSize adSize;
  const EasyBannerAd({
    this.adNetwork = AdNetwork.admob,
    this.adSize = AdSize.banner,
    Key? key,
  }) : super(key: key);

  @override
  _EasyBannerAdState createState() => _EasyBannerAdState();
}

class _EasyBannerAdState extends State<EasyBannerAd> {
  EasyAdBase? _bannerAd;

  @override
  Widget build(BuildContext context) => _bannerAd?.show() ?? const SizedBox();

  @override
  void didUpdateWidget(covariant EasyBannerAd oldWidget) {
    super.didUpdateWidget(oldWidget);

    createBanner();
    _bannerAd?.onBannerAdReadyForSetState = onBannerAdReadyForSetState;
  }

  void createBanner() {
    _bannerAd = EasyAds.instance
        .createBanner(adNetwork: widget.adNetwork, adSize: widget.adSize);
    _bannerAd?.load();
  }

  @override
  void initState() {
    super.initState();

    createBanner();

    _bannerAd?.onAdLoaded = onBannerAdReadyForSetState;
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  void onBannerAdReadyForSetState(
      AdNetwork adNetwork, AdUnitType adUnitType, Object? data) {
    setState(() {});
  }
}
