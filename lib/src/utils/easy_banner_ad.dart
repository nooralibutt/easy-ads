import 'package:flutter/material.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';

class EasyBannerAd extends StatefulWidget {
  final AdNetwork adNetwork;
  final AdSize adSize;
  const EasyBannerAd({
    this.adNetwork = AdNetwork.admob,
    this.adSize = AdSize.banner,
    Key? key,
  })  : assert(adNetwork != AdNetwork.appLovin,
            "Applovin banner is not supported yet"),
        super(key: key);

  @override
  _EasyBannerAdState createState() => _EasyBannerAdState();
}

class _EasyBannerAdState extends State<EasyBannerAd> {
  late final EasyAdBase? _bannerAd = EasyAds.instance
      .createBanner(adNetwork: widget.adNetwork, adSize: widget.adSize);

  @override
  Widget build(BuildContext context) => _bannerAd?.show() ?? const SizedBox();

  @override
  void initState() {
    _bannerAd?.load();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }
}
