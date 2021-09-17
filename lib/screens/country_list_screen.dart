import 'package:ads/screens/country_detail_screen.dart';
import 'package:ads/models/country.dart';
import 'package:ads/utils/easy_ads/easy_ad_base.dart';
import 'package:ads/utils/easy_ads/easy_admob/easy_admob_banner_ad.dart';
import 'package:ads/utils/easy_ads/easy_ads.dart';
import 'package:ads/utils/enums/ad_network.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({Key? key}) : super(key: key);

  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  // EasyAdmobInterstitialAd? myInterstitialAds = EasyAdmobInterstitialAd();

  late final EasyAdBase _bannerAd;
  @override
  void initState() {
    super.initState();

    // myInterstitialAds?.createInterstitialAd();
    final adRequest = AdRequest();
    EasyAds.instance.initAdmob(
        rewardedAdUnitId: RewardedAd.testAdUnitId, adRequest: adRequest);

    _bannerAd =
        EasyAdmobBannerAd(BannerAd.testAdUnitId, adRequest, AdSize.banner);
    _bannerAd.load();
  }

  @override
  void dispose() {
    super.dispose();

    EasyAds.instance.disposeRewardedAd();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final countryList = Country.countryList;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Country List"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _bannerAd.show(),
          Expanded(
            child: ListView.builder(
                itemCount: countryList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // myInterstitialAds?.showInterstitialAd();
                      EasyAds.instance.showRewardedAd();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CountryDetailScreen(country: countryList[index]),
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Country.countryList[index].countryName,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
