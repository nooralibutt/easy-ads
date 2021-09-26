import 'dart:io';

import 'package:ads/models/country.dart';
import 'package:ads/models/i_ad_id_manager.dart';
import 'package:ads/models/test_ad_id_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';

const IAdIdManager adIdManager = TestAdIdManager();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyAds.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Easy Ads Example',
      home: CountryListScreen(),
    );
  }
}

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

    // Initializing Unity Ads
    EasyAds.instance.initUnity(
      unityGameId: adIdManager.unityGameId,
      testMode: true,
      interstitialPlacementId: adIdManager.unityInterstitialId,
      rewardedPlacementId: adIdManager.unityRewardedId,
    );

    // Initializing admob Ads
    EasyAds.instance.initAdmob(
      interstitialAdUnitId: adIdManager.admobInterstitialId,
      rewardedAdUnitId: adIdManager.admobRewardedId,
    );

    // Initializing admob banner
    _bannerAd = EasyAdmobBannerAd(adIdManager.admobBannerId);
    _bannerAd.load();
  }

  @override
  void dispose() {
    super.dispose();

    EasyAds.instance.disposeAds();

    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const countryList = Country.countryList;
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
                      if (countryList[index].countryName ==
                          'Pakistan - Rewarded') {
                        EasyAds.instance.showRewardedAd();
                      } else {
                        EasyAds.instance.showInterstitialAd();
                      }
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

class CountryDetailScreen extends StatefulWidget {
  final Country country;

  const CountryDetailScreen({Key? key, required this.country})
      : super(key: key);

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  late final EasyUnityBannerAd _bannerAd;

  @override
  void initState() {
    super.initState();

    // Initializing banner and load
    _bannerAd = EasyUnityBannerAd(adIdManager.unityBannerId);
    _bannerAd.load();
  }

  @override
  void dispose() {
    super.dispose();

    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.countryName),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.country.imageUrl),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                widget.country.countryDescription,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),
            ),
          ),
          const Spacer(),
          _bannerAd.show(),
        ],
      ),
    );
  }
}
