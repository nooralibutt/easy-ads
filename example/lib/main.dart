import 'dart:io';

import 'package:ads/models/country.dart';
import 'package:flutter/material.dart';
import 'package:easy_ads_flutter/easy_ads_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

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
  static final _unityGameId = Platform.isAndroid ? '4374881' : '4374880';
  static final _unityInterstitialPlacementId =
      Platform.isAndroid ? 'Interstitial_Android' : 'Interstitial_iOS';
  static final _unityRewardedPlacementId =
      Platform.isAndroid ? 'Rewarded_Android' : 'Rewarded_iOS';

  late final EasyAdmobBannerAd _bannerAd;
  @override
  void initState() {
    super.initState();

    // Initializing Unity Ads
    EasyAds.instance.initUnity(
      unityGameId: _unityGameId,
      testMode: true,
      interstitialPlacementId: _unityInterstitialPlacementId,
      rewardedPlacementId: _unityRewardedPlacementId,
    );

    // Initializing admob Ads
    EasyAds.instance.initAdmob(
      interstitialAdUnitId: InterstitialAd.testAdUnitId,
      rewardedAdUnitId: RewardedAd.testAdUnitId,
    );

    // Initializing admob banner
    _bannerAd = EasyAdmobBannerAd(BannerAd.testAdUnitId, const AdRequest());
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
  static final _unityBannerPlacementId =
      Platform.isAndroid ? 'Banner_Android' : 'Banner_iOS';

  late final EasyUnityBannerAd _bannerAd;

  @override
  void initState() {
    super.initState();

    // Initializing banner and load
    _bannerAd = EasyUnityBannerAd(_unityBannerPlacementId);
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
