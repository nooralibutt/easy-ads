import 'package:ads/screens/country_detail_screen.dart';
import 'package:ads/models/country.dart';
import 'package:easy_ads/easy_ads.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({Key? key}) : super(key: key);

  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  late final EasyAdmobBannerAd _bannerAd;
  @override
  void initState() {
    super.initState();

    final adRequest = AdRequest();

    _bannerAd =
        EasyAdmobBannerAd(BannerAd.testAdUnitId, adRequest, AdSize.banner);
    _bannerAd.load();

    EasyAds.instance.initAdmob(
        interstitialAdUnitId: InterstitialAd.testAdUnitId,
        rewardedAdUnitId: RewardedAd.testAdUnitId);
  }

  @override
  void dispose() {
    super.dispose();

    EasyAds.instance.disposeInterstitialAd();
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
                      EasyAds.instance.showInterstitialAd();
                      // EasyAds.instance.showRewardedAd();
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
