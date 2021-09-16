import 'package:ads/screens/country_detail_screen.dart';
import 'package:ads/models/country.dart';
import 'package:ads/utils/easy_ads/easy_admob/easy_admob_banner_ad.dart';
import 'package:ads/utils/easy_ads/easy_admob/easy_admob_interstitial_ad.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({Key? key}) : super(key: key);

  @override
  _CountryListScreenState createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  BannerAd? bannerAds;
  EasyAdmobInterstitialAd? myInterstitialAds = EasyAdmobInterstitialAd();

  @override
  void initState() {
    super.initState();
    bannerAds = EasyAdmobBannerAd.bannerCreate();
    bannerAds?.load();
    myInterstitialAds?.createInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAds?.dispose();
    bannerAds = null;
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
          if (bannerAds != null)
            SizedBox(
              child: AdWidget(ad: bannerAds!),
              height: 50,
              width: double.infinity,
            ),
          Expanded(
            child: ListView.builder(
                itemCount: countryList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      myInterstitialAds?.showInterstitialAd();
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
